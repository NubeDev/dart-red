import 'parse_utils.dart';
import 'types.dart';

/// Port of Go `parseBasicDeviceInfo` + `ParseEthernetStatus/WiFi/LoRa`.
DeviceInfo parseDeviceInfo(List<String> lines) {
  final clean = cleanLines(lines);

  String? deviceNote, hwVersion, fwVersion, fwReleaseTime, bacnetIPDatalink;
  int? modbusAddress;

  for (final line in clean) {
    if (!line.startsWith('+') || !line.contains(':')) continue;
    final parts = line.split(':');
    if (parts.length < 2) continue;
    final key = parts[0].replaceFirst('+', '').trim();
    final value = parts.sublist(1).join(':').trim();

    switch (key) {
      case 'Device Note':     deviceNote = value;
      case 'HW Version':      hwVersion = value;
      case 'FW Version':      fwVersion = value;
      case 'FW Release Time': fwReleaseTime = value;
      case 'Modbus Address':  modbusAddress = int.tryParse(value);
      case 'BACnet/IP Datalink': bacnetIPDatalink = value;
    }
  }

  return DeviceInfo(
    deviceNote: deviceNote,
    hwVersion: hwVersion,
    fwVersion: fwVersion,
    fwReleaseTime: fwReleaseTime,
    modbusAddress: modbusAddress,
    bacnetIPDatalink: bacnetIPDatalink,
    ethernet: _parseEthernet(clean),
    wifi: _parseWiFi(clean),
    lora: _parseLoRa(clean),
    raw: lines,
  );
}

EthernetStatus? _parseEthernet(List<String> lines) =>
    parseInterfaceSection(lines, 'Ethernet interface', (kv) => EthernetStatus(
      macAddress: kv['MAC address'], ipAddress: kv['IP address'],
      subnetMask: kv['Subnet mask'], gateway: kv['Gateway address'],
      dns: kv['DNS address'],
    ));

WiFiStatus? _parseWiFi(List<String> lines) =>
    parseInterfaceSection(lines, 'WiFi interface', (kv) => WiFiStatus(
      mode: kv['Mode'], macAddress: kv['MAC address'],
      ssid: kv['Access point'], status: kv['Status'],
      ipAddress: kv['IP address'], subnetMask: kv['Subnet mask'],
      gateway: kv['Gateway address'], dns: kv['DNS address'],
    ));

LoRaStatus? _parseLoRa(List<String> lines) =>
    parseInterfaceSection(lines, 'LoRa interface', (kv) => LoRaStatus(
      detected: kv['Detected']?.toLowerCase() == 'yes',
      uniqueAddress: kv['Unique Address'],
      bridgeAddress: kv['Bridge Address'],
    ));
