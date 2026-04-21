/// Shared typed models returned by all DeviceClient implementations.
/// Protocol-specific parsing (TCP raw strings, REST JSON, MQTT protobuf)
/// all converge into these common types.

// ---------------------------------------------------------------------------
// Device Info
// ---------------------------------------------------------------------------

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
  final DateTime? systemTime;

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
    this.systemTime,
  });
}

// ---------------------------------------------------------------------------
// Network Interfaces
// ---------------------------------------------------------------------------

/// Unified view of all network interfaces on a device.
class NetworkInterfaces {
  final EthernetConfig? ethernet;
  final WiFiConfig? wifi;
  final LoRaConfig? lora;

  const NetworkInterfaces({this.ethernet, this.wifi, this.lora});
}

class EthernetConfig {
  final bool dhcpEnabled;
  final String? staticIP;
  final String? subnetMask;
  final String? gateway;
  final String? dns;
  final bool isDefaultInterface;

  const EthernetConfig({
    this.dhcpEnabled = true,
    this.staticIP,
    this.subnetMask,
    this.gateway,
    this.dns,
    this.isDefaultInterface = true,
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

enum WiFiMode { station, accessPoint }

class WiFiConfig {
  final bool enabled;
  final WiFiMode mode;
  final String? ssid;
  final String? password;
  final bool dhcpEnabled;
  final String? staticIP;
  final String? subnetMask;
  final String? gateway;
  final String? dns;

  const WiFiConfig({
    this.enabled = false,
    this.mode = WiFiMode.station,
    this.ssid,
    this.password,
    this.dhcpEnabled = true,
    this.staticIP,
    this.subnetMask,
    this.gateway,
    this.dns,
  });
}

class WiFiStatus {
  final WiFiMode mode;
  final String? macAddress;
  final String? ssid;
  final String? status;
  final String? ipAddress;
  final String? subnetMask;
  final String? gateway;
  final String? dns;

  const WiFiStatus({
    this.mode = WiFiMode.station,
    this.macAddress,
    this.ssid,
    this.status,
    this.ipAddress,
    this.subnetMask,
    this.gateway,
    this.dns,
  });
}

class LoRaConfig {
  final bool enabled;
  final String? uniqueAddress;
  final String? bridgeAddress;
  final List<int>? aesKey;

  const LoRaConfig({
    this.enabled = false,
    this.uniqueAddress,
    this.bridgeAddress,
    this.aesKey,
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

// ---------------------------------------------------------------------------
// Time
// ---------------------------------------------------------------------------

class DeviceTime {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final String? raw;

  const DeviceTime({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    this.raw,
  });

  DateTime toDateTime() => DateTime(year, month, day, hour, minute, second);
}

// ---------------------------------------------------------------------------
// RIOT Engine
// ---------------------------------------------------------------------------

enum RiotStatusCode { notStarted, idle, running }

class RiotStatus {
  final RiotStatusCode code;
  final String message;

  const RiotStatus({required this.code, required this.message});
}

class RiotPackage {
  final int id;
  final String? name;
  final String? version;

  const RiotPackage({required this.id, this.name, this.version});
}

// ---------------------------------------------------------------------------
// RS485
// ---------------------------------------------------------------------------

enum RS485Protocol { none, modbusMaster, modbusSlave, bacnet }

class RS485Config {
  final RS485Protocol port1;
  final RS485Protocol port2;

  const RS485Config({
    this.port1 = RS485Protocol.none,
    this.port2 = RS485Protocol.none,
  });
}

class RS485Settings {
  final int baudRate;
  final int dataBits;
  final String parity; // "N", "E", "O"
  final int stopBits;

  const RS485Settings({
    this.baudRate = 115200,
    this.dataBits = 8,
    this.parity = 'N',
    this.stopBits = 1,
  });

  @override
  String toString() => '$baudRate-$dataBits-$parity-$stopBits';
}

// ---------------------------------------------------------------------------
// BACnet
// ---------------------------------------------------------------------------

class BACnetConfig {
  final int? deviceId;
  final String? deviceName;
  final String? deviceDescription;
  final int? bipPort;
  final int? mstpAddress;
  final int? bipNetworkNumber;
  final int? mstpNetworkNumber;
  final String? bipDatalinkInterface;

  const BACnetConfig({
    this.deviceId,
    this.deviceName,
    this.deviceDescription,
    this.bipPort,
    this.mstpAddress,
    this.bipNetworkNumber,
    this.mstpNetworkNumber,
    this.bipDatalinkInterface,
  });
}

// ---------------------------------------------------------------------------
// Modbus / BACnet Point Values
// ---------------------------------------------------------------------------

class PointValue {
  final double value;
  final String? raw;

  const PointValue({required this.value, this.raw});
}

// ---------------------------------------------------------------------------
// Command listing
// ---------------------------------------------------------------------------

class CommandInfo {
  final String name;
  final String description;

  const CommandInfo({required this.name, required this.description});
}
