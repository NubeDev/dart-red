import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../common/connection_state.dart';
import '../transport.dart';

/// Configuration for the TCP transport, mirrors Go `rtcp.Config`.
class TcpConfig {
  final String host;
  final int port;
  final Duration commandTimeout;
  final Duration connectTimeout;
  final Duration keepAlivePeriod;
  final bool autoReconnect;
  final int maxRetries;
  final Duration retryDelay;
  final String? username;
  final String? password;
  final bool autoLogin;

  const TcpConfig({
    required this.host,
    this.port = 56789,
    this.commandTimeout = const Duration(seconds: 10),
    this.connectTimeout = const Duration(seconds: 5),
    this.keepAlivePeriod = const Duration(seconds: 30),
    this.autoReconnect = true,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.username,
    this.password,
    this.autoLogin = false,
  });
}

/// Raw TCP socket transport for ACBM/Riot devices.
///
/// Port of Go `rtcp/client.go`. Telnet-style line protocol:
/// send `"command\n"`, read lines until empty line or timeout.
///
/// The socket stream is consumed once into a persistent line buffer.
/// Commands are serialized via a lock — one command at a time.
class AcbmTcpTransport implements AcbmTransport {
  final TcpConfig config;

  Socket? _socket;
  StreamSubscription<List<int>>? _socketSub;

  // Line buffering — socket data arrives in chunks, we accumulate and split.
  String _rxBuffer = '';
  final _lineController = StreamController<String>.broadcast();

  // Command lock — only one command in flight at a time (matches Go mutex).
  Completer<void>? _cmdLock;

  // Status
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _status = const ConnectionStatus();
  @override
  ConnectionStatus get status => _status;
  @override
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  bool _disposed = false;

  AcbmTcpTransport(this.config);

  /// Shorthand constructor matching Go `rtcp.NewClient(host, port)`.
  factory AcbmTcpTransport.simple(String host, [int port = 56789]) {
    return AcbmTcpTransport(TcpConfig(host: host, port: port));
  }

  // ---------------------------------------------------------------------------
  // Connection lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<void> connect() async {
    if (_socket != null) return;
    await _connectInternal();

    // Auto-login if configured
    if (config.autoLogin &&
        config.username != null &&
        config.password != null) {
      await login(config.username!, config.password!);
    }
  }

  Future<void> _connectInternal() async {
    _updateStatus(state: DeviceConnectionState.connecting);
    _rxBuffer = '';

    try {
      _socket = await Socket.connect(
        config.host,
        config.port,
        timeout: config.connectTimeout,
      );

      // TCP keepalive
      _socket!.setOption(SocketOption.tcpNoDelay, true);

      // Listen to socket stream — feed into line buffer
      _socketSub = _socket!.listen(
        _onData,
        onError: _onSocketError,
        onDone: _onSocketDone,
      );

      _updateStatus(
        state: DeviceConnectionState.connected,
        connectedAt: DateTime.now(),
      );
    } catch (e) {
      _socket = null;
      _updateStatus(
        state: DeviceConnectionState.error,
        lastError: () => e.toString(),
      );
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    final socket = _socket;
    if (socket == null) return;

    // Logout first if authenticated (matches Go: Close → Logout → socket.Close)
    if (_status.authState == DeviceAuthState.authenticated) {
      try {
        await _sendRaw('logout');
      } catch (_) {}
    }

    await _teardown();
    _updateStatus(
      state: DeviceConnectionState.disconnected,
      authState: DeviceAuthState.unauthenticated,
      authenticatedUser: () => null,
    );
  }

  Future<void> _teardown() async {
    await _socketSub?.cancel();
    _socketSub = null;
    try {
      _socket?.destroy();
    } catch (_) {}
    _socket = null;
    _rxBuffer = '';
  }

  @override
  bool get isConnected =>
      _socket != null && _status.state == DeviceConnectionState.connected;

  // ---------------------------------------------------------------------------
  // Authentication — mirrors Go login/logout
  // ---------------------------------------------------------------------------

  @override
  Future<void> login(String username, String password) async {
    final lines = await execute('login $username $password');

    // Riot responds with empty or a success line on good login,
    // or an error line on bad credentials.
    final response = lines.join(' ').toLowerCase();
    if (response.contains('error') || response.contains('fail')) {
      _updateStatus(authState: DeviceAuthState.unauthenticated);
      throw AuthenticationError('Login failed: ${lines.join(', ')}');
    }

    _updateStatus(
      authState: DeviceAuthState.authenticated,
      authenticatedUser: () => username,
    );
  }

  Future<void> logout() async {
    await execute('logout');
    _updateStatus(
      authState: DeviceAuthState.unauthenticated,
      authenticatedUser: () => null,
    );
  }

  // ---------------------------------------------------------------------------
  // Command execution — the core of the transport
  // ---------------------------------------------------------------------------

  /// Send a command and collect response lines until empty line or timeout.
  ///
  /// Commands are serialized — only one in flight at a time, matching the
  /// Go implementation's sync.RWMutex behavior.
  @override
  Future<List<String>> execute(String command) async {
    if (_socket == null) {
      if (config.autoReconnect) {
        await _reconnect();
      } else {
        throw StateError('Not connected');
      }
    }

    // Acquire command lock
    while (_cmdLock != null) {
      await _cmdLock!.future;
    }
    _cmdLock = Completer<void>();

    try {
      return await _executeInternal(command);
    } finally {
      final lock = _cmdLock;
      _cmdLock = null;
      lock?.complete();
    }
  }

  Future<List<String>> _executeInternal(String command) async {
    final socket = _socket;
    if (socket == null) throw StateError('Not connected');

    // Send
    final bytes = utf8.encode('$command\n');
    socket.add(bytes);
    await socket.flush();
    _updateStatus(bytesSent: _status.bytesSent + bytes.length);

    // Collect response lines until empty line or timeout
    final lines = <String>[];
    final completer = Completer<List<String>>();

    late StreamSubscription<String> lineSub;
    final timer = Timer(config.commandTimeout, () {
      if (!completer.isCompleted) {
        lineSub.cancel();
        completer.complete(lines); // Return partial on timeout
      }
    });

    lineSub = _lineController.stream.listen((line) {
      if (line.isEmpty) {
        // Empty line = end of response
        timer.cancel();
        lineSub.cancel();
        if (!completer.isCompleted) completer.complete(lines);
      } else {
        lines.add(line);
      }
    });

    try {
      final result = await completer.future;
      _updateStatus(
        lastCommandAt: DateTime.now(),
        commandCount: _status.commandCount + 1,
      );
      return result;
    } catch (e) {
      _updateStatus(
        errorCount: _status.errorCount + 1,
        lastError: () => e.toString(),
      );
      rethrow;
    }
  }

  /// Fire-and-forget for commands that cause reboot (restart, reset).
  /// Matches Go `ExecuteCommandNoResponse`.
  @override
  Future<void> executeNoResponse(String command) async {
    final socket = _socket;
    if (socket == null) throw StateError('Not connected');
    final bytes = utf8.encode('$command\n');
    socket.add(bytes);
    await socket.flush();
    _updateStatus(bytesSent: _status.bytesSent + bytes.length);
    await _teardown();
    _updateStatus(
      state: DeviceConnectionState.disconnected,
      authState: DeviceAuthState.unauthenticated,
      authenticatedUser: () => null,
    );
  }

  /// Send without acquiring the lock — used internally by disconnect/logout.
  Future<void> _sendRaw(String command) async {
    final socket = _socket;
    if (socket == null) return;
    socket.add(utf8.encode('$command\n'));
    await socket.flush();
  }

  // ---------------------------------------------------------------------------
  // Socket stream handling — persistent listener, feeds line buffer
  // ---------------------------------------------------------------------------

  void _onData(List<int> data) {
    _updateStatus(bytesReceived: _status.bytesReceived + data.length);
    _rxBuffer += utf8.decode(data, allowMalformed: true);

    // Split buffer into complete lines
    while (_rxBuffer.contains('\n')) {
      final idx = _rxBuffer.indexOf('\n');
      final line = _rxBuffer.substring(0, idx).trimRight();
      _rxBuffer = _rxBuffer.substring(idx + 1);
      _lineController.add(line); // Empty lines pass through — they signal end-of-response
    }
  }

  void _onSocketError(Object error) {
    debugPrint('AcbmTcpTransport: socket error — $error');
    _updateStatus(
      state: DeviceConnectionState.error,
      lastError: () => error.toString(),
      errorCount: _status.errorCount + 1,
    );
    _socket = null;
    if (config.autoReconnect && !_disposed) {
      _reconnect();
    }
  }

  void _onSocketDone() {
    debugPrint('AcbmTcpTransport: socket closed by remote');
    _socket = null;
    _socketSub = null;
    _updateStatus(
      state: DeviceConnectionState.disconnected,
      authState: DeviceAuthState.unauthenticated,
      authenticatedUser: () => null,
    );
    if (config.autoReconnect && !_disposed) {
      _reconnect();
    }
  }

  // ---------------------------------------------------------------------------
  // Auto-reconnect — matches Go maxRetries + retryDelay
  // ---------------------------------------------------------------------------

  Future<void> _reconnect() async {
    if (_disposed) return;
    _updateStatus(state: DeviceConnectionState.reconnecting);

    for (var attempt = 1; attempt <= config.maxRetries; attempt++) {
      try {
        debugPrint(
            'AcbmTcpTransport: reconnect attempt $attempt/${config.maxRetries}');
        await _teardown();
        await Future.delayed(config.retryDelay);
        await _connectInternal();
        _updateStatus(reconnectCount: _status.reconnectCount + 1);

        // Re-login if we had credentials
        if (config.autoLogin &&
            config.username != null &&
            config.password != null) {
          await login(config.username!, config.password!);
        }

        return; // Success
      } catch (e) {
        debugPrint('AcbmTcpTransport: reconnect attempt $attempt failed — $e');
        if (attempt == config.maxRetries) {
          _updateStatus(
            state: DeviceConnectionState.error,
            lastError: () => 'Reconnect failed after ${config.maxRetries} attempts: $e',
          );
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  void _updateStatus({
    DeviceConnectionState? state,
    DeviceAuthState? authState,
    String? Function()? authenticatedUser,
    DateTime? connectedAt,
    DateTime? lastCommandAt,
    int? commandCount,
    int? errorCount,
    int? bytesSent,
    int? bytesReceived,
    int? reconnectCount,
    String? Function()? lastError,
  }) {
    _status = _status.copyWith(
      state: state,
      authState: authState,
      authenticatedUser: authenticatedUser,
      connectedAt: connectedAt,
      lastCommandAt: lastCommandAt,
      commandCount: commandCount,
      errorCount: errorCount,
      bytesSent: bytesSent,
      bytesReceived: bytesReceived,
      reconnectCount: reconnectCount,
      lastError: lastError,
    );
    if (!_statusController.isClosed) {
      _statusController.add(_status);
    }
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  @override
  Future<void> dispose() async {
    _disposed = true;
    await _teardown();
    await _lineController.close();
    await _statusController.close();
  }
}

// ---------------------------------------------------------------------------
// Errors
// ---------------------------------------------------------------------------

class AuthenticationError implements Exception {
  final String message;
  AuthenticationError(this.message);

  @override
  String toString() => 'AuthenticationError: $message';
}
