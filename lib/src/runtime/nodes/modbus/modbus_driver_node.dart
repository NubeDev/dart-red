import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import '../../../serial/serial_session.dart';
import '../../node.dart';
import '../../port.dart';
import '../../driver_poller.dart';
import 'modbus_codec.dart';

/// Modbus poll-point context — carried per registered point.
typedef ModbusPollCtx = ({
  String host,
  int port,
  int unitId,
  String registerType,
  int address,
  int count,
  String dataType,
  String byteOrder,
  double scale,
  double offset,
});

/// Source node that manages a Modbus network and poll loop.
///
/// Supports both TCP (connection pool) and RTU (serial port) transports.
/// Child `modbus.device` nodes provide per-device addressing:
///   - TCP: each device has its own host:port + unit ID
///   - RTU: all devices share the serial bus, each has a unit ID
///
/// Uses [DriverPoller] for the poll loop (shared with BACnet driver).
///
/// Containment: modbus.driver → modbus.device → modbus.point
class ModbusDriverNode extends SourceNode {
  @override
  String get typeName => 'modbus.driver';

  @override
  String get description => 'Modbus driver (TCP or RTU)';

  @override
  String get iconName => 'cpu';

  @override
  List<String> get allowedChildTypes => const ['modbus.device'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final transport = settings['transport'] as String? ?? 'tcp';
    if (transport == 'rtu') {
      final serial = settings['serialPort'] as String?;
      if (serial != null && serial.isNotEmpty) return 'RTU · $serial';
      return 'RTU';
    }
    final iface = settings['interface'] as String?;
    if (iface != null && iface.isNotEmpty) return 'TCP · $iface';
    return 'TCP';
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'transport': {
            'type': 'string',
            'title': 'Transport',
            'enum': ['tcp', 'rtu'],
            'x-enum-labels': ['Modbus TCP', 'Modbus RTU (Serial)'],
            'default': 'tcp',
          },
          'pollIntervalSecs': {
            'type': 'integer',
            'title': 'Poll Interval (seconds)',
            'default': 10,
            'minimum': 1,
            'maximum': 300,
          },
          'timeout': {
            'type': 'integer',
            'title': 'Request Timeout (seconds)',
            'default': 5,
            'minimum': 1,
            'maximum': 30,
          },
        },
        'allOf': [
          {
            'if': {
              'properties': {
                'transport': {'const': 'tcp'},
              },
            },
            'then': {
              'properties': {
                'interface': {
                  'type': 'string',
                  'title': 'Network Interface',
                  'x-widget': 'interface-picker',
                },
              },
            },
          },
          {
            'if': {
              'properties': {
                'transport': {'const': 'rtu'},
              },
            },
            'then': {
              'properties': {
                'serialPort': {
                  'type': 'string',
                  'title': 'Serial Port',
                  'x-widget': 'serial-port-picker',
                },
                'baudRate': {
                  'type': 'integer',
                  'title': 'Baud Rate',
                  'enum': [9600, 19200, 38400, 57600, 115200],
                  'default': 9600,
                },
                'parity': {
                  'type': 'string',
                  'title': 'Parity',
                  'enum': ['none', 'even', 'odd'],
                  'x-enum-labels': ['None', 'Even', 'Odd'],
                  'default': 'none',
                },
                'stopBits': {
                  'type': 'integer',
                  'title': 'Stop Bits',
                  'enum': [1, 2],
                  'default': 1,
                },
              },
            },
          },
        ],
      };

  // ---------------------------------------------------------------------------
  // Shared registries — device / point / write nodes look up state here
  // ---------------------------------------------------------------------------

  /// driverNodeId → transport type ('tcp' | 'rtu')
  static final transports = <String, String>{};

  /// driverNodeId → { "host:port" → Socket } — TCP connection pool
  static final connectionPools = <String, Map<String, Socket>>{};

  /// driverNodeId → SerialSession — RTU serial connection
  static final serialSessions = <String, SerialSession>{};

  /// driverNodeId → timeout duration
  static final timeouts = <String, Duration>{};

  /// driverNodeId → DriverPoller (so point nodes can register)
  static final pollers = <String, DriverPoller<ModbusPollCtx>>{};

  /// Transaction ID counter (wraps at 0xFFFF)
  static int _transactionId = 0;
  static int get nextTransactionId =>
      (_transactionId = (_transactionId + 1) & 0xFFFF);

  // Per-instance state
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _generation = <String, int>{};

  /// Get or create a TCP connection for the given host:port.
  static Future<Socket?> getOrConnect(
    String driverId,
    String host,
    int port,
  ) async {
    final pool = connectionPools[driverId];
    if (pool == null) return null;

    final key = '$host:$port';
    final existing = pool[key];
    if (existing != null) return existing;

    final timeout = timeouts[driverId] ?? const Duration(seconds: 5);
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      pool[key] = socket;
      print('modbus.driver[$driverId]: connected to $key');
      return socket;
    } catch (e) {
      print('modbus.driver[$driverId]: connect to $key failed: $e');
      return null;
    }
  }

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final transport = settings['transport'] as String? ?? 'tcp';
    final timeoutSecs = settings['timeout'] as int? ?? 5;
    final pollSecs = settings['pollIntervalSecs'] as int? ?? 10;

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    onOutput({'status': 'starting'});

    transports[nodeId] = transport;
    timeouts[nodeId] = Duration(seconds: timeoutSecs);

    if (transport == 'rtu') {
      // --- RTU: open serial port ---
      final serialPort = settings['serialPort'] as String? ?? '';
      if (serialPort.isEmpty) {
        print('modbus.driver[$nodeId]: no serial port configured');
        onOutput({'status': 'error'});
        return;
      }

      final baudRate = settings['baudRate'] as int? ?? 9600;
      final parityStr = settings['parity'] as String? ?? 'none';
      final stopBits = settings['stopBits'] as int? ?? 1;

      final parity = switch (parityStr) {
        'even' => SerialParity.even,
        'odd' => SerialParity.odd,
        _ => SerialParity.none,
      };

      final session = SerialSession(
        portName: serialPort,
        config: SerialConfig(
          baudRate: baudRate,
          dataBits: 8,
          stopBits:
              stopBits == 2 ? SerialStopBits.two : SerialStopBits.one,
          parity: parity,
        ),
      );

      try {
        await session.open();
      } catch (e) {
        print('modbus.driver[$nodeId]: serial open failed: $e');
        onOutput({'status': 'error'});
        return;
      }

      if (_generation[nodeId] != gen) {
        await session.dispose();
        return;
      }

      serialSessions[nodeId] = session;
      onOutput({'status': 'online'});
      print('modbus.driver[$nodeId]: RTU started on $serialPort @ $baudRate');
    } else {
      // --- TCP: set up connection pool ---
      connectionPools[nodeId] = {};
      onOutput({'status': 'online'});
      print('modbus.driver[$nodeId]: TCP started (connection pool ready)');
    }

    // Create and start the common poller
    final poller = DriverPoller<ModbusPollCtx>(
      driverId: nodeId,
      interval: Duration(seconds: pollSecs),
      reader: (ctx) => _readPoint(nodeId, ctx),
      tag: 'modbus.driver',
    );
    pollers[nodeId] = poller;
    poller.start();
  }

  // ---------------------------------------------------------------------------
  // Read — dispatches to TCP or RTU
  // ---------------------------------------------------------------------------

  Future<PollResult> _readPoint(String nodeId, ModbusPollCtx ctx) async {
    final transport = transports[nodeId] ?? 'tcp';
    if (transport == 'rtu') {
      return _readPointRtu(nodeId, ctx);
    }
    return _readPointTcp(nodeId, ctx);
  }

  /// TCP read — sends MBAP-framed request over a pooled TCP socket.
  Future<PollResult> _readPointTcp(String nodeId, ModbusPollCtx ctx) async {
    final socket = await getOrConnect(nodeId, ctx.host, ctx.port);
    if (socket == null) {
      return PollResult.error('Cannot connect to ${ctx.host}:${ctx.port}');
    }
    final timeout = timeouts[nodeId] ?? const Duration(seconds: 5);
    final label = '${ctx.registerType}[${ctx.address}]@unit${ctx.unitId}';

    try {
      final fc = ModbusCodec.functionCodeForRead(ctx.registerType);
      final txId = nextTransactionId;
      final request = ModbusCodec.buildReadRequest(
        transactionId: txId,
        unitId: ctx.unitId,
        functionCode: fc,
        startAddress: ctx.address,
        count: ctx.count,
      );

      socket.add(request);

      final response = await socket.first.timeout(timeout);
      final bytes = Uint8List.fromList(response);

      if (bytes.length < 9) {
        return PollResult.error('Response too short (${bytes.length} bytes)');
      }

      if (bytes[7] & 0x80 != 0) {
        final exCode = bytes.length > 8 ? bytes[8] : 0;
        final msg = modbusExceptionCodes[exCode] ??
            'Unknown exception (code $exCode)';
        print('modbus.driver[$nodeId]: $label exception — $msg');
        return PollResult.error(msg);
      }

      final byteCount = bytes[8];
      if (bytes.length < 9 + byteCount) {
        return PollResult.error('Truncated response');
      }
      final data = bytes.sublist(9, 9 + byteCount);

      return _decodeAndScale(nodeId, label, data, ctx);
    } on TimeoutException {
      print('modbus.driver[$nodeId]: $label timeout');
      return PollResult.stale('Unit ${ctx.unitId} not responding');
    } catch (e) {
      print('modbus.driver[$nodeId]: $label error — $e');
      return PollResult.error(e.toString());
    }
  }

  /// RTU read — sends CRC-framed request over serial, waits for response.
  Future<PollResult> _readPointRtu(String nodeId, ModbusPollCtx ctx) async {
    final session = serialSessions[nodeId];
    if (session == null || !session.isOpen) {
      return const PollResult.error('Serial port not open');
    }
    final timeout = timeouts[nodeId] ?? const Duration(seconds: 5);
    final label = '${ctx.registerType}[${ctx.address}]@unit${ctx.unitId}';

    try {
      final fc = ModbusCodec.functionCodeForRead(ctx.registerType);
      final request = ModbusCodec.buildRtuReadRequest(
        unitId: ctx.unitId,
        functionCode: fc,
        startAddress: ctx.address,
        count: ctx.count,
      );

      final response = await _rtuTransact(session, request, timeout);

      final payload = ModbusCodec.validateRtuResponse(response);
      if (payload == null) {
        return const PollResult.error('CRC error in response');
      }

      // payload: unitId(1) + FC(1) + byteCount(1) + data(N)
      if (payload.length < 3) {
        return PollResult.error(
            'Response too short (${payload.length} bytes)');
      }

      // Check for exception response
      if (payload[1] & 0x80 != 0) {
        final exCode = payload.length > 2 ? payload[2] : 0;
        final msg = modbusExceptionCodes[exCode] ??
            'Unknown exception (code $exCode)';
        print('modbus.driver[$nodeId]: $label exception — $msg');
        return PollResult.error(msg);
      }

      final byteCount = payload[2];
      if (payload.length < 3 + byteCount) {
        return const PollResult.error('Truncated response');
      }
      final data = payload.sublist(3, 3 + byteCount);

      return _decodeAndScale(nodeId, label, data, ctx);
    } on TimeoutException {
      print('modbus.driver[$nodeId]: $label timeout');
      return PollResult.stale('Unit ${ctx.unitId} not responding');
    } catch (e) {
      print('modbus.driver[$nodeId]: $label error — $e');
      return PollResult.error(e.toString());
    }
  }

  /// Shared decode + scale logic for both TCP and RTU.
  PollResult _decodeAndScale(
    String nodeId,
    String label,
    Uint8List data,
    ModbusPollCtx ctx,
  ) {
    final value = ModbusCodec.decodeValue(
      data: data,
      dataType: ctx.dataType,
      byteOrder: ctx.byteOrder,
      registerType: ctx.registerType,
    );
    final scaled = (value is num) ? value * ctx.scale + ctx.offset : value;
    print('modbus.driver[$nodeId]: $label = $scaled');
    return PollResult.ok(scaled);
  }

  // ---------------------------------------------------------------------------
  // RTU serial transaction
  // ---------------------------------------------------------------------------

  /// Send an RTU frame and collect the response using silence-based framing.
  ///
  /// Modbus RTU uses 3.5 character times of silence to delimit frames.
  /// We use a short timer (50 ms) after the last received byte as the
  /// frame delimiter — conservative enough for all standard baud rates.
  static Future<Uint8List> _rtuTransact(
    SerialSession session,
    Uint8List request,
    Duration timeout,
  ) async {
    final buffer = <int>[];
    final completer = Completer<Uint8List>();
    Timer? frameTimer;

    final sub = session.dataStream.listen((data) {
      buffer.addAll(data.bytes);
      // Reset the silence timer on each chunk
      frameTimer?.cancel();
      frameTimer = Timer(const Duration(milliseconds: 50), () {
        if (!completer.isCompleted) {
          completer.complete(Uint8List.fromList(buffer));
        }
      });
    });

    // Overall timeout guard
    final overallTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
            TimeoutException('RTU response timeout', timeout));
      }
    });

    try {
      await session.writeBytes(request);
      return await completer.future;
    } finally {
      frameTimer?.cancel();
      overallTimer.cancel();
      await sub.cancel();
    }
  }

  // ---------------------------------------------------------------------------
  // Write — dispatches to TCP or RTU
  // ---------------------------------------------------------------------------

  /// Send a write request and return the result. Used by [ModbusWriteNode].
  static Future<PollResult> writeRegisters({
    required String driverId,
    required String host,
    required int port,
    required int unitId,
    required String registerType,
    required int address,
    required String dataType,
    required String byteOrder,
    required dynamic value,
  }) async {
    final transport = transports[driverId] ?? 'tcp';
    if (transport == 'rtu') {
      return _writeRegistersRtu(
        driverId: driverId,
        unitId: unitId,
        registerType: registerType,
        address: address,
        dataType: dataType,
        byteOrder: byteOrder,
        value: value,
      );
    }
    return _writeRegistersTcp(
      driverId: driverId,
      host: host,
      port: port,
      unitId: unitId,
      registerType: registerType,
      address: address,
      dataType: dataType,
      byteOrder: byteOrder,
      value: value,
    );
  }

  static Future<PollResult> _writeRegistersTcp({
    required String driverId,
    required String host,
    required int port,
    required int unitId,
    required String registerType,
    required int address,
    required String dataType,
    required String byteOrder,
    required dynamic value,
  }) async {
    final socket = await getOrConnect(driverId, host, port);
    if (socket == null) {
      return PollResult.error('Cannot connect to $host:$port');
    }
    final timeout = timeouts[driverId] ?? const Duration(seconds: 5);

    try {
      final request = ModbusCodec.buildWriteRequest(
        transactionId: nextTransactionId,
        unitId: unitId,
        registerType: registerType,
        address: address,
        dataType: dataType,
        byteOrder: byteOrder,
        value: value,
      );

      socket.add(request);
      final response = await socket.first.timeout(timeout);
      final bytes = Uint8List.fromList(response);

      if (bytes.length < 9) {
        return const PollResult.error('Response too short');
      }

      if (bytes[7] & 0x80 != 0) {
        final exCode = bytes.length > 8 ? bytes[8] : 0;
        final msg = modbusExceptionCodes[exCode] ??
            'Unknown exception (code $exCode)';
        return PollResult.error(msg);
      }

      return PollResult.ok(value);
    } on TimeoutException {
      return PollResult.stale('Unit $unitId not responding');
    } catch (e) {
      return PollResult.error(e.toString());
    }
  }

  static Future<PollResult> _writeRegistersRtu({
    required String driverId,
    required int unitId,
    required String registerType,
    required int address,
    required String dataType,
    required String byteOrder,
    required dynamic value,
  }) async {
    final session = serialSessions[driverId];
    if (session == null || !session.isOpen) {
      return const PollResult.error('Serial port not open');
    }
    final timeout = timeouts[driverId] ?? const Duration(seconds: 5);

    try {
      final request = ModbusCodec.buildRtuWriteRequest(
        unitId: unitId,
        registerType: registerType,
        address: address,
        dataType: dataType,
        byteOrder: byteOrder,
        value: value,
      );

      final response = await _rtuTransact(session, request, timeout);

      final payload = ModbusCodec.validateRtuResponse(response);
      if (payload == null) {
        return const PollResult.error('CRC error in response');
      }

      if (payload.length >= 2 && payload[1] & 0x80 != 0) {
        final exCode = payload.length > 2 ? payload[2] : 0;
        final msg = modbusExceptionCodes[exCode] ??
            'Unknown exception (code $exCode)';
        return PollResult.error(msg);
      }

      return PollResult.ok(value);
    } on TimeoutException {
      return PollResult.stale('Unit $unitId not responding');
    } catch (e) {
      return PollResult.error(e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Stop
  // ---------------------------------------------------------------------------

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    pollers[nodeId]?.stop();
    pollers.remove(nodeId);

    // Clean up TCP pool
    final pool = connectionPools.remove(nodeId);
    if (pool != null) {
      for (final socket in pool.values) {
        socket.destroy();
      }
    }

    // Clean up RTU serial
    final session = serialSessions.remove(nodeId);
    if (session != null) {
      await session.dispose();
    }

    transports.remove(nodeId);
    timeouts.remove(nodeId);
    _callbacks.remove(nodeId);
  }
}

/// Human-readable Modbus exception codes.
const Map<int, String> modbusExceptionCodes = {
  1: 'Illegal Function — the function code is not supported',
  2: 'Illegal Data Address — the register address does not exist',
  3: 'Illegal Data Value — the value is out of range',
  4: 'Server Device Failure — internal error on the device',
  5: 'Acknowledge — request accepted, processing',
  6: 'Server Device Busy — retry later',
  8: 'Memory Parity Error — device memory corruption',
  10: 'Gateway Path Unavailable — gateway misconfigured',
  11: 'Gateway Target Failed to Respond — target device not reachable',
};
