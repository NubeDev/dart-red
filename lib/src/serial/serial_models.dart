import 'dart:typed_data';

/// Parity modes for serial communication.
enum SerialParity {
  none,
  odd,
  even,
  mark,
  space,
}

/// Stop bit configurations.
enum SerialStopBits {
  one,
  onePointFive,
  two,
}

/// Flow control modes.
enum SerialFlowControl {
  none,
  rtsCts,
  dsrDtr,
  xonXoff,
}

/// Configuration for a serial port connection.
class SerialConfig {
  final int baudRate;
  final int dataBits;
  final SerialStopBits stopBits;
  final SerialParity parity;
  final SerialFlowControl flowControl;

  const SerialConfig({
    this.baudRate = 115200,
    this.dataBits = 8,
    this.stopBits = SerialStopBits.one,
    this.parity = SerialParity.none,
    this.flowControl = SerialFlowControl.none,
  });

  /// Common presets for ESP32 defaults.
  static const esp32 = SerialConfig(baudRate: 115200);
  static const esp32Monitor = SerialConfig(baudRate: 115200);

  /// Slower baud rates for certain devices.
  static const baud9600 = SerialConfig(baudRate: 9600);
  static const baud19200 = SerialConfig(baudRate: 19200);
  static const baud38400 = SerialConfig(baudRate: 38400);

  SerialConfig copyWith({
    int? baudRate,
    int? dataBits,
    SerialStopBits? stopBits,
    SerialParity? parity,
    SerialFlowControl? flowControl,
  }) {
    return SerialConfig(
      baudRate: baudRate ?? this.baudRate,
      dataBits: dataBits ?? this.dataBits,
      stopBits: stopBits ?? this.stopBits,
      parity: parity ?? this.parity,
      flowControl: flowControl ?? this.flowControl,
    );
  }

  @override
  String toString() =>
      'SerialConfig($baudRate, $dataBits${stopBits.name[0].toUpperCase()}'
      '${parity == SerialParity.none ? "N" : parity.name[0].toUpperCase()})';
}

/// A serial port discovered on the system.
class SerialPortInfo {
  /// System name (e.g. "/dev/ttyUSB0", "COM3").
  final String portName;

  /// Human-readable description.
  final String? description;

  /// USB vendor ID (null for non-USB ports).
  final int? vendorId;

  /// USB product ID (null for non-USB ports).
  final int? productId;

  /// Manufacturer name.
  final String? manufacturer;

  /// Product name (e.g. "CP2102 USB to UART Bridge").
  final String? productName;

  /// USB serial number.
  final String? serialNumber;

  const SerialPortInfo({
    required this.portName,
    this.description,
    this.vendorId,
    this.productId,
    this.manufacturer,
    this.productName,
    this.serialNumber,
  });

  /// Whether this looks like a USB-to-serial adapter (ESP32, Arduino, etc).
  bool get isUsbSerial => vendorId != null && productId != null;

  /// Display name for UI.
  String get displayName {
    if (productName != null && productName!.isNotEmpty) {
      return '$productName ($portName)';
    }
    if (description != null && description!.isNotEmpty) {
      return '$description ($portName)';
    }
    return portName;
  }

  /// VID:PID string if available.
  String? get vidPid {
    if (vendorId == null || productId == null) return null;
    return '${vendorId!.toRadixString(16).padLeft(4, '0')}:'
        '${productId!.toRadixString(16).padLeft(4, '0')}';
  }

  @override
  String toString() => 'SerialPortInfo($displayName)';
}

/// Events from the serial session.
enum SerialSessionState {
  closed,
  opening,
  open,
  error,
}

/// A chunk of data received from the serial port.
class SerialData {
  final Uint8List bytes;
  final DateTime receivedAt;

  SerialData(this.bytes, {DateTime? receivedAt})
      : receivedAt = receivedAt ?? DateTime.now();

  /// Decode as UTF-8 string, replacing invalid bytes.
  String get text => String.fromCharCodes(bytes);

  int get length => bytes.length;

  @override
  String toString() => 'SerialData(${bytes.length} bytes)';
}
