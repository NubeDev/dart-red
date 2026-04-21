import 'connection_state.dart';
import 'device_models.dart';

/// Common interface for all device types and protocols.
///
/// Each device+protocol combination implements this:
///   - ACBM over TCP  → [AcbmClient]
///   - ACBM over REST → (future)
///   - ACBL over REST → (future)
///
/// Callers interact only with [DeviceClient]. The implementation handles
/// transport (socket/HTTP/MQTT), serialization (raw string parsing, JSON,
/// protobuf), and protocol quirks internally.
///
/// Not every device supports every method — unsupported operations throw
/// [UnsupportedError]. Use the capability flags to check before calling.
abstract class DeviceClient {
  // ---------------------------------------------------------------------------
  // Connection lifecycle
  // ---------------------------------------------------------------------------

  Future<void> connect();
  Future<void> disconnect();
  Future<void> login(String username, String password);
  ConnectionStatus get status;
  Stream<ConnectionStatus> get statusStream;

  // ---------------------------------------------------------------------------
  // Capabilities — what this device+protocol supports
  // ---------------------------------------------------------------------------

  /// Check what this client can do. Lets UI hide unsupported controls.
  DeviceCapabilities get capabilities;

  // ---------------------------------------------------------------------------
  // System
  // ---------------------------------------------------------------------------

  Future<bool> ping();
  Future<DeviceInfo> getDeviceInfo();
  Future<List<CommandInfo>> listCommands();
  Future<void> restart();

  // ---------------------------------------------------------------------------
  // Network interfaces — the common surface
  // ---------------------------------------------------------------------------

  Future<NetworkInterfaces> getInterfaces();

  // Ethernet
  Future<EthernetConfig> getEthernetConfig();
  Future<EthernetStatus> getEthernetStatus();
  Future<void> setEthernetStatic({
    required String ip,
    required String subnetMask,
    required String gateway,
    String? dns,
  });
  Future<void> setEthernetDHCP();

  // WiFi
  Future<WiFiConfig> getWiFiConfig();
  Future<WiFiStatus> getWiFiStatus();
  Future<void> setWiFiStation({
    required String ssid,
    required String password,
    bool dhcp = true,
    String? staticIP,
    String? subnetMask,
    String? gateway,
    String? dns,
  });
  Future<void> enableWiFi();
  Future<void> disableWiFi();

  // LoRa
  Future<LoRaConfig> getLoRaConfig();
  Future<void> enableLoRa();
  Future<void> disableLoRa();

  // ---------------------------------------------------------------------------
  // RS485
  // ---------------------------------------------------------------------------

  Future<RS485Config> getRS485Config();
  Future<void> setRS485Config(RS485Config config);

  // ---------------------------------------------------------------------------
  // BACnet
  // ---------------------------------------------------------------------------

  Future<BACnetConfig> getBACnetConfig();
  Future<void> setBACnetConfig(BACnetConfig config);

  // ---------------------------------------------------------------------------
  // Modbus points
  // ---------------------------------------------------------------------------

  Future<PointValue> modbusReadAI(int slaveId, int register);
  Future<PointValue> modbusReadAO(int slaveId, int register);
  Future<void> modbusWriteAO(int slaveId, int register, int value);
  Future<PointValue> modbusReadDI(int slaveId, int address);
  Future<PointValue> modbusReadDO(int slaveId, int address);
  Future<void> modbusWriteDO(int slaveId, int address, bool value);

  // ---------------------------------------------------------------------------
  // BACnet points
  // ---------------------------------------------------------------------------

  Future<PointValue> bacnetReadAI(int deviceId, int objectId);
  Future<PointValue> bacnetReadAO(int deviceId, int objectId);
  Future<void> bacnetWriteAO(int deviceId, int objectId, double value);
  Future<PointValue> bacnetReadAV(int deviceId, int objectId);
  Future<void> bacnetWriteAV(int deviceId, int objectId, double value);
  Future<PointValue> bacnetReadBI(int deviceId, int objectId);
  Future<PointValue> bacnetReadBO(int deviceId, int objectId);
  Future<void> bacnetWriteBO(int deviceId, int objectId, bool value);

  // ---------------------------------------------------------------------------
  // RIOT engine
  // ---------------------------------------------------------------------------

  Future<RiotStatus> getRiotStatus();
  Future<List<RiotPackage>> getRiotPackages();

  // ---------------------------------------------------------------------------
  // Time
  // ---------------------------------------------------------------------------

  Future<DeviceTime> getTime();
  Future<void> setTime(DateTime time);

  // ---------------------------------------------------------------------------
  // Raw / escape hatch
  // ---------------------------------------------------------------------------

  /// Send a raw command string. Protocol-specific — returns raw response lines.
  /// Use for debugging or commands not yet in the typed API.
  Future<List<String>> rawCommand(String command);
}

/// Declares what a device+protocol combination supports.
/// UI can check these to show/hide controls.
class DeviceCapabilities {
  final bool ethernet;
  final bool wifi;
  final bool lora;
  final bool rs485;
  final bool bacnet;
  final bool modbus;
  final bool riot;
  final bool mqtt;
  final bool authentication; // TCP requires login, REST may use token

  const DeviceCapabilities({
    this.ethernet = false,
    this.wifi = false,
    this.lora = false,
    this.rs485 = false,
    this.bacnet = false,
    this.modbus = false,
    this.riot = false,
    this.mqtt = false,
    this.authentication = false,
  });

  /// ACBM has everything.
  static const acbm = DeviceCapabilities(
    ethernet: true,
    wifi: true,
    lora: true,
    rs485: true,
    bacnet: true,
    modbus: true,
    riot: true,
    mqtt: true,
    authentication: true,
  );
}
