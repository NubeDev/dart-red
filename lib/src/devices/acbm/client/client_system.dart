import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import 'client_base.dart';

/// System commands: ping, device info, list commands, restart.
mixin ClientSystemMixin on AcbmClientBase {
  Future<bool> ping() async {
    try {
      await transport.execute('list');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<models.DeviceInfo> getDeviceInfo() async {
    final lines = await transport.execute('dev_info');
    final parsed = parseDeviceInfo(lines);
    return models.DeviceInfo(
      deviceNote: parsed.deviceNote,
      hwVersion: parsed.hwVersion,
      fwVersion: parsed.fwVersion,
      fwReleaseTime: parsed.fwReleaseTime,
      modbusAddress: parsed.modbusAddress,
      bacnetIPDatalink: parsed.bacnetIPDatalink,
      ethernet: parsed.ethernet != null
          ? models.EthernetStatus(
              macAddress: parsed.ethernet!.macAddress,
              ipAddress: parsed.ethernet!.ipAddress,
              subnetMask: parsed.ethernet!.subnetMask,
              gateway: parsed.ethernet!.gateway,
              dns: parsed.ethernet!.dns,
            )
          : null,
      wifi: parsed.wifi != null
          ? models.WiFiStatus(
              mode: parsed.wifi!.mode?.toLowerCase() == 'access point'
                  ? models.WiFiMode.accessPoint
                  : models.WiFiMode.station,
              macAddress: parsed.wifi!.macAddress,
              ssid: parsed.wifi!.ssid,
              status: parsed.wifi!.status,
              ipAddress: parsed.wifi!.ipAddress,
              subnetMask: parsed.wifi!.subnetMask,
              gateway: parsed.wifi!.gateway,
              dns: parsed.wifi!.dns,
            )
          : null,
      lora: parsed.lora != null
          ? models.LoRaStatus(
              detected: parsed.lora!.detected,
              uniqueAddress: parsed.lora!.uniqueAddress,
              bridgeAddress: parsed.lora!.bridgeAddress,
            )
          : null,
    );
  }

  Future<List<models.CommandInfo>> listCommands() async {
    final lines = await transport.execute('list');
    final parsed = parseCommandList(lines);
    return parsed.map((c) => models.CommandInfo(name: c.name, description: c.description)).toList();
  }

  Future<void> restart() async {
    await transport.executeNoResponse('restart');
  }
}
