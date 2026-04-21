import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../common/connection_state.dart';
import '../../../serial/serial_session.dart';
import '../transport.dart';
import '../tcp/acbm_tcp_transport.dart' show AuthenticationError;

/// Configuration for the serial transport.
class SerialTransportConfig {
  final String portName;
  final int baudRate;
  final Duration commandTimeout;
  final String? username;
  final String? password;
  final bool autoLogin;

  const SerialTransportConfig({
    required this.portName,
    this.baudRate = 115200,
    this.commandTimeout = const Duration(seconds: 10),
    this.username,
    this.password,
    this.autoLogin = false,
  });
}

/// Serial transport for ACBM/Riot devices.
///
/// Same line-based protocol as TCP: send `"command\n"`, read lines until
/// empty line or timeout. Wraps [SerialSession] for cross-platform serial I/O.
class AcbmSerialTransport implements AcbmTransport {
  final SerialTransportConfig config;

  late final SerialSession _session;
  StreamSubscription<String>? _lineSub;

  // Line buffering — relay from SerialSession's lineStream.
  final _lineController = StreamController<String>.broadcast();

  // Command lock — one command at a time.
  Completer<void>? _cmdLock;

  // Status
  final _statusController = StreamController<ConnectionStatus>.broadcast();
  ConnectionStatus _status = const ConnectionStatus();

  AcbmSerialTransport(this.config) {
    _session = SerialSession(
      portName: config.portName,
      config: SerialConfig(baudRate: config.baudRate),
    );
  }

  @override
  ConnectionStatus get status => _status;

  @override
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  @override
  bool get isConnected => _session.isOpen;

  // ---------------------------------------------------------------------------
  // Connection lifecycle
  // ---------------------------------------------------------------------------

  @override
  Future<void> connect() async {
    if (_session.isOpen) return;
    _updateStatus(state: DeviceConnectionState.connecting);

    try {
      await _session.open();

      // Forward lines from the serial session into our line controller.
      _lineSub = _session.lineStream.listen(
        (line) {
          if (!_lineController.isClosed) _lineController.add(line);
        },
        onError: (e) {
          debugPrint('AcbmSerialTransport: read error — $e');
          _updateStatus(
            state: DeviceConnectionState.error,
            lastError: () => e.toString(),
            errorCount: _status.errorCount + 1,
          );
        },
        onDone: () {
          debugPrint('AcbmSerialTransport: port closed');
          _updateStatus(
            state: DeviceConnectionState.disconnected,
            authState: DeviceAuthState.unauthenticated,
            authenticatedUser: () => null,
          );
        },
      );

      _updateStatus(
        state: DeviceConnectionState.connected,
        connectedAt: DateTime.now(),
      );

      // Auto-login if configured.
      if (config.autoLogin &&
          config.username != null &&
          config.password != null) {
        await login(config.username!, config.password!);
      }
    } catch (e) {
      _updateStatus(
        state: DeviceConnectionState.error,
        lastError: () => e.toString(),
      );
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_session.isOpen) return;

    // Logout first if authenticated.
    if (_status.authState == DeviceAuthState.authenticated) {
      try {
        await _session.writeString('logout\n');
      } catch (_) {}
    }

    await _lineSub?.cancel();
    _lineSub = null;
    await _session.close();
    _updateStatus(
      state: DeviceConnectionState.disconnected,
      authState: DeviceAuthState.unauthenticated,
      authenticatedUser: () => null,
    );
  }

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  @override
  Future<void> login(String username, String password) async {
    final lines = await execute('login $username $password');

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

  // ---------------------------------------------------------------------------
  // Command execution
  // ---------------------------------------------------------------------------

  @override
  Future<List<String>> execute(String command) async {
    if (!_session.isOpen) throw StateError('Serial port not open');

    // Acquire command lock.
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
    // Send command — use writeString with \n (not writeLine which adds \r\n).
    // ACBM protocol uses bare \n as line terminator, matching TCP transport.
    final payload = '$command\n';
    await _session.writeString(payload);
    _updateStatus(bytesSent: _status.bytesSent + payload.length);

    // Collect response lines until empty line or timeout.
    final lines = <String>[];
    final completer = Completer<List<String>>();

    late StreamSubscription<String> lineSub;
    final timer = Timer(config.commandTimeout, () {
      if (!completer.isCompleted) {
        lineSub.cancel();
        completer.complete(lines);
      }
    });

    lineSub = _lineController.stream.listen((line) {
      // Skip echo of our own command.
      if (line.trim() == command.trim()) return;

      if (line.isEmpty) {
        // Empty line = end of response.
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

  @override
  Future<void> executeNoResponse(String command) async {
    if (!_session.isOpen) throw StateError('Serial port not open');
    await _session.writeString('$command\n');
    _updateStatus(bytesSent: _status.bytesSent + command.length + 1);
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
    await _lineSub?.cancel();
    _lineSub = null;
    await _session.dispose();
    await _lineController.close();
    await _statusController.close();
  }
}
