import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:usb_serial/usb_serial.dart';

import '../logging/app_logger.dart';
import 'serial_models.dart';

export 'serial_models.dart';

/// Cross-platform serial port session.
///
/// Manages the connection lifecycle, reading, and writing for a serial port.
/// Works with USB-to-serial devices like ESP32, Arduino, etc.
///
/// Usage:
/// ```dart
/// final session = SerialSession(portName: '/dev/ttyUSB0');
/// await session.open();
///
/// // Listen for incoming data
/// session.dataStream.listen((data) {
///   print('Received: ${data.text}');
/// });
///
/// // Send data
/// session.writeLine('AT');
///
/// // Send a command and wait for response
/// final response = await session.sendCommand('AT\r\n');
/// print('Response: $response');
///
/// await session.close();
/// ```
class SerialSession {
  /// Port name or device path (e.g. "/dev/ttyUSB0", "COM3").
  final String portName;

  /// Serial configuration.
  final SerialConfig config;

  /// For Android: optional UsbDevice reference for USB serial.
  final UsbDeviceRef? usbDevice;

  // Desktop backend
  SerialPort? _desktopPort;
  SerialPortReader? _desktopReader;
  StreamSubscription<Uint8List>? _desktopReaderSub;

  // Android backend
  UsbPort? _androidPort;
  StreamSubscription? _androidInputSub;

  // State
  SerialSessionState _state = SerialSessionState.closed;
  final _stateController = StreamController<SerialSessionState>.broadcast();
  final _dataController = StreamController<SerialData>.broadcast();
  final _lineController = StreamController<String>.broadcast();
  String _lineBuffer = '';

  // Stats
  int _bytesSent = 0;
  int _bytesReceived = 0;

  SerialSession({
    required this.portName,
    this.config = const SerialConfig(),
    this.usbDevice,
  });

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  SerialSessionState get state => _state;
  Stream<SerialSessionState> get stateStream => _stateController.stream;
  bool get isOpen => _state == SerialSessionState.open;
  int get bytesSent => _bytesSent;
  int get bytesReceived => _bytesReceived;

  // ---------------------------------------------------------------------------
  // Data streams
  // ---------------------------------------------------------------------------

  /// Raw byte stream from the serial port.
  Stream<SerialData> get dataStream => _dataController.stream;

  /// Line-delimited stream. Splits on `\n` (strips `\r`).
  Stream<String> get lineStream => _lineController.stream;

  // ---------------------------------------------------------------------------
  // Open / Close
  // ---------------------------------------------------------------------------

  /// Opens the serial port with the configured parameters.
  Future<void> open() async {
    if (_state == SerialSessionState.open) return;
    _setState(SerialSessionState.opening);
    AppLogger.log('SerialSession', 'opening $portName');

    try {
      if (Platform.isAndroid) {
        await _openAndroid();
      } else {
        _openDesktop();
      }
      _setState(SerialSessionState.open);
      AppLogger.log('SerialSession', 'opened $portName');
    } catch (e) {
      AppLogger.error('SerialSession', 'open failed $portName', e);
      _setState(SerialSessionState.error);
      rethrow;
    }
  }

  /// Closes the serial port and releases resources.
  Future<void> close() async {
    if (_state == SerialSessionState.closed) {
      AppLogger.log('SerialSession', 'close skipped — already closed');
      return;
    }
    AppLogger.log('SerialSession', 'closing $portName');

    // Mark closed FIRST to prevent re-entrant close from onDone callbacks.
    _setState(SerialSessionState.closed);

    try {
      if (Platform.isAndroid) {
        await _closeAndroid();
      } else {
        await _closeDesktop();
      }
    } catch (e) {
      AppLogger.error('SerialSession', 'close error', e);
    }
  }

  /// Closes and disposes all streams. Call when done with the session.
  Future<void> dispose() async {
    AppLogger.log('SerialSession', 'dispose $portName');
    await close();
    if (!_stateController.isClosed) await _stateController.close();
    if (!_dataController.isClosed) await _dataController.close();
    if (!_lineController.isClosed) await _lineController.close();
  }

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Writes raw bytes to the serial port.
  Future<void> writeBytes(Uint8List data) async {
    _assertOpen();

    if (Platform.isAndroid) {
      await _androidPort!.write(data);
    } else {
      _desktopPort!.write(data);
    }
    _bytesSent += data.length;
  }

  /// Writes a string (UTF-8 encoded) to the serial port.
  Future<void> writeString(String text) async {
    await writeBytes(Uint8List.fromList(utf8.encode(text)));
  }

  /// Writes a string followed by `\r\n` (standard serial line ending).
  Future<void> writeLine(String line) async {
    await writeString('$line\r\n');
  }

  /// Sends a command and waits for a response line (or timeout).
  ///
  /// Writes the command with `\r\n`, then collects response lines until
  /// [timeout] expires. Returns all received lines joined.
  Future<String> sendCommand(
    String command, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final lines = <String>[];
    final completer = Completer<String>();

    late StreamSubscription<String> sub;
    final timer = Timer(timeout, () {
      sub.cancel();
      if (!completer.isCompleted) {
        completer.complete(lines.join('\n'));
      }
    });

    sub = lineStream.listen((line) {
      // Skip echo of our own command
      if (line.trim() == command.trim()) return;
      lines.add(line);
    });

    await writeLine(command);

    final result = await completer.future;
    timer.cancel();
    await sub.cancel();
    return result;
  }

  // ---------------------------------------------------------------------------
  // Desktop implementation
  // ---------------------------------------------------------------------------

  void _openDesktop() {
    _desktopPort = SerialPort(portName);

    if (!_desktopPort!.openReadWrite()) {
      final err = SerialPort.lastError?.message ?? 'Unknown error';
      throw SerialSessionException('Failed to open $portName: $err');
    }

    // Apply config
    final cfg = SerialPortConfig();
    cfg.baudRate = config.baudRate;
    cfg.bits = config.dataBits;
    cfg.stopBits = _stopBitsToDesktop(config.stopBits);
    cfg.parity = _parityToDesktop(config.parity);
    cfg.setFlowControl(_flowControlToDesktop(config.flowControl));
    _desktopPort!.config = cfg;
    cfg.dispose();

    // Start reading
    _desktopReader = SerialPortReader(_desktopPort!);
    _desktopReaderSub = _desktopReader!.stream.listen(
      (data) => _onData(data),
      onError: (e) {
        AppLogger.error('SerialSession', 'read error on $portName', e);
        if (_state == SerialSessionState.open) {
          close();
        }
      },
      onDone: () {
        AppLogger.log('SerialSession', 'reader stream done on $portName (state=$_state)');
        if (_state == SerialSessionState.open) {
          close();
        }
      },
    );
  }

  Future<void> _closeDesktop() async {
    final sub = _desktopReaderSub;
    final reader = _desktopReader;
    final port = _desktopPort;
    _desktopReaderSub = null;
    _desktopReader = null;
    _desktopPort = null;

    // 1. Cancel the subscription FIRST — this triggers onCancel inside the
    //    reader, which kills the background read-isolate and closes the
    //    ReceivePort. The isolate does blocking sp_wait with a 500 ms
    //    timeout, so it may still be alive briefly.
    try {
      await sub?.cancel();
    } catch (e) {
      AppLogger.error('SerialSession', 'subscription cancel error', e);
    }

    // 2. Close the reader's StreamController.
    try {
      reader?.close();
    } catch (e) {
      AppLogger.error('SerialSession', 'reader close error', e);
    }

    // 3. Close the native port — sp_close releases the fd.
    //    The isolate may still be running (stuck in sp_wait), so close
    //    will unblock it by invalidating the fd.
    try {
      port?.close();
    } catch (e) {
      AppLogger.error('SerialSession', 'port close error', e);
    }

    // 4. Free native memory.
    try {
      port?.dispose();
    } catch (e) {
      AppLogger.error('SerialSession', 'port dispose error', e);
    }

    AppLogger.log('SerialSession', 'closeDesktop complete for $portName');
  }

  int _stopBitsToDesktop(SerialStopBits sb) {
    switch (sb) {
      case SerialStopBits.one:
        return 1;
      case SerialStopBits.onePointFive:
        return 3;
      case SerialStopBits.two:
        return 2;
    }
  }

  int _parityToDesktop(SerialParity p) {
    switch (p) {
      case SerialParity.none:
        return SerialPortParity.none;
      case SerialParity.odd:
        return SerialPortParity.odd;
      case SerialParity.even:
        return SerialPortParity.even;
      case SerialParity.mark:
        return SerialPortParity.mark;
      case SerialParity.space:
        return SerialPortParity.space;
    }
  }

  int _flowControlToDesktop(SerialFlowControl fc) {
    switch (fc) {
      case SerialFlowControl.none:
        return SerialPortFlowControl.none;
      case SerialFlowControl.rtsCts:
        return SerialPortFlowControl.rtsCts;
      case SerialFlowControl.dsrDtr:
        return SerialPortFlowControl.dtrDsr;
      case SerialFlowControl.xonXoff:
        return SerialPortFlowControl.xonXoff;
    }
  }

  // ---------------------------------------------------------------------------
  // Android implementation
  // ---------------------------------------------------------------------------

  Future<void> _openAndroid() async {
    // If we have a UsbDeviceRef, use its device ID
    if (usbDevice != null) {
      _androidPort =
          await UsbSerial.createFromDeviceId(usbDevice!.deviceId);
    } else {
      // Find the device by port name
      final devices = await UsbSerial.listDevices();
      final device = devices.where((d) => d.deviceName == portName).firstOrNull;
      if (device == null) {
        throw SerialSessionException('Device not found: $portName');
      }
      _androidPort = await device.create();
    }

    if (_androidPort == null) {
      throw SerialSessionException('Failed to create port for $portName');
    }

    final opened = await _androidPort!.open();
    if (!opened) {
      throw SerialSessionException('Failed to open $portName');
    }

    await _androidPort!.setPortParameters(
      config.baudRate,
      config.dataBits,
      _stopBitsToAndroid(config.stopBits),
      _parityToAndroid(config.parity),
    );
    await _androidPort!.setFlowControl(
      _flowControlToAndroid(config.flowControl),
    );

    // Start reading
    _androidInputSub = _androidPort!.inputStream?.listen(
      (data) => _onData(data),
      onError: (e) {
        debugPrint('SerialSession: android read error — $e');
        _setState(SerialSessionState.error);
      },
    );
  }

  Future<void> _closeAndroid() async {
    await _androidInputSub?.cancel();
    _androidInputSub = null;
    await _androidPort?.close();
    _androidPort = null;
  }

  int _stopBitsToAndroid(SerialStopBits sb) {
    switch (sb) {
      case SerialStopBits.one:
        return UsbPort.STOPBITS_1;
      case SerialStopBits.onePointFive:
        return UsbPort.STOPBITS_1_5;
      case SerialStopBits.two:
        return UsbPort.STOPBITS_2;
    }
  }

  int _parityToAndroid(SerialParity p) {
    switch (p) {
      case SerialParity.none:
        return UsbPort.PARITY_NONE;
      case SerialParity.odd:
        return UsbPort.PARITY_ODD;
      case SerialParity.even:
        return UsbPort.PARITY_EVEN;
      case SerialParity.mark:
        return UsbPort.PARITY_MARK;
      case SerialParity.space:
        return UsbPort.PARITY_SPACE;
    }
  }

  int _flowControlToAndroid(SerialFlowControl fc) {
    switch (fc) {
      case SerialFlowControl.none:
        return UsbPort.FLOW_CONTROL_OFF;
      case SerialFlowControl.rtsCts:
        return UsbPort.FLOW_CONTROL_RTS_CTS;
      case SerialFlowControl.dsrDtr:
        return UsbPort.FLOW_CONTROL_DSR_DTR;
      case SerialFlowControl.xonXoff:
        return UsbPort.FLOW_CONTROL_XON_XOFF;
    }
  }

  // ---------------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------------

  void _onData(Uint8List data) {
    _bytesReceived += data.length;
    _dataController.add(SerialData(data));

    // Line buffering
    _lineBuffer += utf8.decode(data, allowMalformed: true);
    while (_lineBuffer.contains('\n')) {
      final idx = _lineBuffer.indexOf('\n');
      final line = _lineBuffer.substring(0, idx).replaceAll('\r', '');
      _lineBuffer = _lineBuffer.substring(idx + 1);
      _lineController.add(line);
    }
  }

  void _setState(SerialSessionState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  void _assertOpen() {
    if (_state != SerialSessionState.open) {
      throw StateError('Serial port is not open (state: $_state)');
    }
  }
}

/// Lightweight reference to a USB device (Android).
/// Used to pass device identity without coupling to the `usb_serial` types.
class UsbDeviceRef {
  final int? deviceId;
  final String deviceName;
  final int? vid;
  final int? pid;

  const UsbDeviceRef({
    this.deviceId,
    required this.deviceName,
    this.vid,
    this.pid,
  });
}

class SerialSessionException implements Exception {
  final String message;
  SerialSessionException(this.message);

  @override
  String toString() => 'SerialSessionException: $message';
}
