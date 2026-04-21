import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import '../tcp/acbm_params.dart';
import 'client_base.dart';
import 'client_params.dart';
import 'client_system.dart';

/// Network config: Ethernet, WiFi, LoRa, getInterfaces.
mixin ClientNetworkMixin on AcbmClientBase, ClientParamsMixin, ClientSystemMixin {
  // ─── Ethernet ─────────────────────────────────────────────────────────

  Future<models.EthernetConfig> getEthernetConfig() async {
    final params = await paramMap();
    ParamValue? _p(String alias) => params[alias];
    return models.EthernetConfig(
      dhcpEnabled: _p(AcbmParams.ethDhcpEnabled)?.asBool() ?? true,
      staticIP: _p(AcbmParams.ethStaticIp)?.asIP(),
      subnetMask: _p(AcbmParams.ethStaticNm)?.asIP(),
      gateway: _p(AcbmParams.ethStaticGw)?.asIP(),
      dns: _p(AcbmParams.ethStaticDns)?.asIP(),
      isDefaultInterface: _p(AcbmParams.ethIsDefaultNetif)?.asBool() ?? true,
    );
  }

  Future<models.EthernetStatus> getEthernetStatus() async {
    final info = await getDeviceInfo();
    return info.ethernet ?? const models.EthernetStatus();
  }

  Future<void> setEthernetStatic({
    required String ip, required String subnetMask,
    required String gateway, String? dns,
  }) async {
    await paramSet(AcbmParams.ethDhcpEnabled, false);
    await paramSet(AcbmParams.ethStaticIp, ipToBlob(ip));
    await paramSet(AcbmParams.ethStaticNm, ipToBlob(subnetMask));
    await paramSet(AcbmParams.ethStaticGw, ipToBlob(gateway));
    if (dns != null) await paramSet(AcbmParams.ethStaticDns, ipToBlob(dns));
  }

  Future<void> setEthernetDHCP() async {
    await paramSet(AcbmParams.ethDhcpEnabled, true);
  }

  // ─── WiFi ─────────────────────────────────────────────────────────────

  Future<models.WiFiConfig> getWiFiConfig() async {
    final params = await paramMap();
    ParamValue? _p(String alias) => params[alias];
    final modeVal = _p(AcbmParams.wifiMode)?.asInt() ?? 0;
    return models.WiFiConfig(
      enabled: _p(AcbmParams.wifiEnabled)?.asBool() ?? false,
      mode: modeVal == 1 ? models.WiFiMode.accessPoint : models.WiFiMode.station,
      ssid: _p(AcbmParams.wifiStaSsid)?.asString(),
      password: _p(AcbmParams.wifiStaPassword)?.asString(),
      dhcpEnabled: _p(AcbmParams.wifiStaDhcpEnabled)?.asBool() ?? true,
      staticIP: _p(AcbmParams.wifiStaStaticIp)?.asIP(),
      subnetMask: _p(AcbmParams.wifiStaStaticNm)?.asIP(),
      gateway: _p(AcbmParams.wifiStaStaticGw)?.asIP(),
      dns: _p(AcbmParams.wifiStaStaticDns)?.asIP(),
    );
  }

  Future<models.WiFiStatus> getWiFiStatus() async {
    final info = await getDeviceInfo();
    return info.wifi ?? const models.WiFiStatus();
  }

  Future<void> setWiFiStation({
    required String ssid, required String password,
    bool dhcp = true, String? staticIP, String? subnetMask,
    String? gateway, String? dns,
  }) async {
    await paramSet(AcbmParams.wifiMode, 0);
    await paramSet(AcbmParams.wifiStaSsid, ssid);
    await paramSet(AcbmParams.wifiStaPassword, password);
    await paramSet(AcbmParams.wifiStaDhcpEnabled, dhcp);
    if (!dhcp && staticIP != null) {
      await paramSet(AcbmParams.wifiStaStaticIp, ipToBlob(staticIP));
      if (subnetMask != null) await paramSet(AcbmParams.wifiStaStaticNm, ipToBlob(subnetMask));
      if (gateway != null) await paramSet(AcbmParams.wifiStaStaticGw, ipToBlob(gateway));
      if (dns != null) await paramSet(AcbmParams.wifiStaStaticDns, ipToBlob(dns));
    }
  }

  Future<void> enableWiFi() => paramSet(AcbmParams.wifiEnabled, true);
  Future<void> disableWiFi() => paramSet(AcbmParams.wifiEnabled, false);

  // ─── LoRa ─────────────────────────────────────────────────────────────

  Future<models.LoRaConfig> getLoRaConfig() async {
    final params = await paramMap();
    ParamValue? _p(String alias) => params[alias];
    return models.LoRaConfig(
      enabled: _p(AcbmParams.ifConnLoraraw)?.asBool() ?? false,
      uniqueAddress: _p(AcbmParams.lrrUniqueAddr)?.asString(),
      bridgeAddress: _p(AcbmParams.lrrBridgeAddr)?.asString(),
    );
  }

  Future<void> enableLoRa() => paramSet(AcbmParams.ifConnLoraraw, true);
  Future<void> disableLoRa() => paramSet(AcbmParams.ifConnLoraraw, false);

  // ─── Combined ─────────────────────────────────────────────────────────

  Future<models.NetworkInterfaces> getInterfaces() async {
    final eth = await getEthernetConfig();
    final wifi = await getWiFiConfig();
    final lora = await getLoRaConfig();
    return models.NetworkInterfaces(ethernet: eth, wifi: wifi, lora: lora);
  }
}
