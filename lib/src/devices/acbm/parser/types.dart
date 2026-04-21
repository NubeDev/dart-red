import 'dart:typed_data';

/// Parsed types from ACBM TCP responses — mirrors Go `parser/types.go`.

class DeviceInfo {
  final String? deviceNote;
  final String? hwVersion;
  final String? fwVersion;
  final String? fwReleaseTime;
  final int? modbusAddress;
  final String? bacnetIPDatalink;
  final EthernetStatus? ethernet;
  final WiFiStatus? wifi;
  final LoRaStatus? lora;
  final List<String> raw;

  const DeviceInfo({
    this.deviceNote,
    this.hwVersion,
    this.fwVersion,
    this.fwReleaseTime,
    this.modbusAddress,
    this.bacnetIPDatalink,
    this.ethernet,
    this.wifi,
    this.lora,
    this.raw = const [],
  });
}

class EthernetStatus {
  final String? macAddress;
  final String? ipAddress;
  final String? subnetMask;
  final String? gateway;
  final String? dns;

  const EthernetStatus({
    this.macAddress,
    this.ipAddress,
    this.subnetMask,
    this.gateway,
    this.dns,
  });
}

class WiFiStatus {
  final String? mode;
  final String? macAddress;
  final String? ssid;
  final String? status;
  final String? ipAddress;
  final String? subnetMask;
  final String? gateway;
  final String? dns;

  const WiFiStatus({
    this.mode,
    this.macAddress,
    this.ssid,
    this.status,
    this.ipAddress,
    this.subnetMask,
    this.gateway,
    this.dns,
  });
}

class LoRaStatus {
  final bool detected;
  final String? uniqueAddress;
  final String? bridgeAddress;

  const LoRaStatus({
    this.detected = false,
    this.uniqueAddress,
    this.bridgeAddress,
  });
}

class ParamValue {
  final String puc;
  final String alias;
  final String dataType;
  final String access;
  final String value;
  final int size;
  final String raw;

  const ParamValue({
    this.puc = '',
    this.alias = '',
    this.dataType = '',
    this.access = '',
    this.value = '',
    this.size = 0,
    this.raw = '',
  });

  String asString() => value;
  int? asInt() => int.tryParse(value);

  bool? asBool() {
    switch (value) {
      case '0': return false;
      case '1': return true;
      default: return null;
    }
  }

  Uint8List? asBlob() {
    try {
      var hex = value.replaceAll('-', '');
      if (hex.endsWith('...')) hex = hex.substring(0, hex.length - 3);
      if (hex.isEmpty || hex.length.isOdd) return null;
      final bytes = Uint8List(hex.length ~/ 2);
      for (var i = 0; i < hex.length; i += 2) {
        bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
      }
      return bytes;
    } catch (_) {
      return null;
    }
  }

  String? asIP() {
    final bytes = asBlob();
    if (bytes == null || bytes.length != 4) return null;
    return '${bytes[0]}.${bytes[1]}.${bytes[2]}.${bytes[3]}';
  }

  @override
  String toString() => '$alias ($puc) = $value [$dataType]';
}

class RTCTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final String raw;
  final String friendly;

  const RTCTime({
    this.year = 0, this.month = 0, this.day = 0,
    this.hour = 0, this.minute = 0, this.second = 0,
    this.raw = '', this.friendly = '',
  });

  DateTime toDateTime() {
    final fullYear = year < 100 ? 2000 + year : year;
    return DateTime(fullYear, month, day, hour, minute, second);
  }
}

enum RiotStatusCode { notStarted, idle, running, unknown }

class RiotStatus {
  final String message;
  final int code;
  final List<String> raw;

  const RiotStatus({this.message = '', this.code = -1, this.raw = const []});

  RiotStatusCode get statusCode => switch (code) {
    0 => RiotStatusCode.notStarted,
    1 => RiotStatusCode.idle,
    2 => RiotStatusCode.running,
    _ => RiotStatusCode.unknown,
  };

  bool get isRunning => code == 2;
  bool get isIdle => code == 1;
  bool get isNotStarted => code == 0;
}

class CommandInfo {
  final String name;
  final String description;
  const CommandInfo({required this.name, required this.description});
}

class RiotPackageEntry {
  final String name;
  final int id;
  final String version;
  const RiotPackageEntry({required this.name, required this.id, required this.version});
}

class RiotNodeEntry {
  final int nodeId;
  final Map<int, double> outputs;
  const RiotNodeEntry({required this.nodeId, required this.outputs});
}

class RS485SettingsParsed {
  final int baudRate;
  final int dataBits;
  final String parity;
  final int stopBits;

  const RS485SettingsParsed({
    required this.baudRate, required this.dataBits,
    required this.parity, required this.stopBits,
  });

  String format() => '$baudRate-$dataBits-$parity-$stopBits';
}
