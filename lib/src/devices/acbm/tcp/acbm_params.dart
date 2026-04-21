/// ACBM parameter PUC constants — direct port of Go `params.go`.
///
/// Each constant is the hex PUC string used with `param_get` / `param_set`.
class AcbmParams {
  AcbmParams._();

  // ─── Device Info (0x0000–0x0003) ──────────────────────────────────────
  static const infoDevNote = '0x0000';
  static const infoAppVersion = '0x0001';
  static const infoAppReleaseTime = '0x0002';
  static const infoHwVersion = '0x0003';
  static const infoHwVersionFac = '0x8003';

  // ─── RIOT Engine (0x0200–0x0201) ──────────────────────────────────────
  static const riotFlowApp = '0x0200';
  static const riotModbusId = '0x0201';

  // ─── LoRa Raw (0x0220–0x0222) ─────────────────────────────────────────
  static const lrrAesKey = '0x0220';
  static const lrrBridgeAddr = '0x0221';
  static const lrrUniqueAddr = '0x0222';

  // ─── Interface Connections (0x0240–0x0242) ─────────────────────────────
  static const ifConnLoraraw = '0x0240';
  static const ifConnLorarawFac = '0x8240';
  static const ifConnRs485_1 = '0x0241';
  static const ifConnRs485_1Fac = '0x8241';
  static const ifConnRs485_2 = '0x0242';
  static const ifConnRs485_2Fac = '0x8242';

  // ─── RS485 Configuration (0x0250–0x0251) ──────────────────────────────
  static const configRs485_1 = '0x0250';
  static const configRs485_2 = '0x0251';

  // ─── Ethernet (0x0260–0x0265) ─────────────────────────────────────────
  static const ethDhcpEnabled = '0x0260';
  static const ethStaticIp = '0x0261';
  static const ethStaticNm = '0x0262';
  static const ethStaticGw = '0x0263';
  static const ethStaticDns = '0x0264';
  static const ethIsDefaultNetif = '0x0265';

  // ─── WiFi (0x0270–0x027D) ─────────────────────────────────────────────
  static const wifiEnabled = '0x0270';
  static const wifiMode = '0x0271'; // 0=Station, 1=AP
  static const wifiStaDhcpEnabled = '0x0272';
  static const wifiStaStaticIp = '0x0273';
  static const wifiStaStaticNm = '0x0274';
  static const wifiStaStaticGw = '0x0275';
  static const wifiStaStaticDns = '0x0276';
  static const wifiStaSsid = '0x0277';
  static const wifiStaPassword = '0x0278';
  static const wifiSapSsid = '0x0279';
  static const wifiSapPassword = '0x027A';
  static const wifiSapStaticIp = '0x027B';
  static const wifiSapStaticNm = '0x027C';
  static const wifiSapStaticGw = '0x027D';

  // ─── BACnet (0x0280–0x0287) ───────────────────────────────────────────
  static const bacBipPort = '0x0280';
  static const bacMstpMac = '0x0281';
  static const bacBipNwkNumber = '0x0282';
  static const bacMstpNwkNumber = '0x0283';
  static const bacDeviceId = '0x0284';
  static const bacBipDatalinkIf = '0x0285'; // 0=Ethernet, 1=WiFi
  static const bacDeviceName = '0x0286';
  static const bacDeviceDesc = '0x0287';

  // ─── Logging & CLI (0x02A0–0x02A1) ────────────────────────────────────
  static const udpLoggerEnabled = '0x02A0';
  static const tcpCliEnabled = '0x02A1';

  // ─── MQTT (0x02B0–0x02B4) ─────────────────────────────────────────────
  static const mqttBrokerUri = '0x02B0';
  static const mqttClientId = '0x02B1';
  static const mqttUsername = '0x02B2';
  static const mqttPassword = '0x02B3';
  static const mqttEnabled = '0x02B4';
}
