import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import '../tcp/acbm_params.dart';
import 'client_base.dart';
import 'client_params.dart';

/// RS485 and BACnet configuration.
mixin ClientConfigMixin on AcbmClientBase, ClientParamsMixin {
  // ─── RS485 ────────────────────────────────────────────────────────────

  Future<models.RS485Config> getRS485Config() async {
    final params = await paramMap();
    ParamValue? _p(String alias) => params[alias];

    models.RS485Protocol _toProto(int? val) => switch (val) {
      1 => models.RS485Protocol.modbusMaster,
      2 => models.RS485Protocol.modbusSlave,
      3 => models.RS485Protocol.bacnet,
      _ => models.RS485Protocol.none,
    };

    return models.RS485Config(
      port1: _toProto(_p(AcbmParams.ifConnRs485_1)?.asInt()),
      port2: _toProto(_p(AcbmParams.ifConnRs485_2)?.asInt()),
    );
  }

  Future<void> setRS485Config(models.RS485Config config) async {
    int _fromProto(models.RS485Protocol p) => switch (p) {
      models.RS485Protocol.none => 0,
      models.RS485Protocol.modbusMaster => 1,
      models.RS485Protocol.modbusSlave => 2,
      models.RS485Protocol.bacnet => 3,
    };
    await paramSet(AcbmParams.ifConnRs485_1, _fromProto(config.port1));
    await paramSet(AcbmParams.ifConnRs485_2, _fromProto(config.port2));
  }

  // ─── BACnet ───────────────────────────────────────────────────────────

  Future<models.BACnetConfig> getBACnetConfig() async {
    final params = await paramMap();
    ParamValue? _p(String alias) => params[alias];
    final datalinkVal = _p(AcbmParams.bacBipDatalinkIf)?.asInt();
    return models.BACnetConfig(
      deviceId: _p(AcbmParams.bacDeviceId)?.asInt(),
      deviceName: _p(AcbmParams.bacDeviceName)?.asString(),
      deviceDescription: _p(AcbmParams.bacDeviceDesc)?.asString(),
      bipPort: _p(AcbmParams.bacBipPort)?.asInt(),
      mstpAddress: _p(AcbmParams.bacMstpMac)?.asInt(),
      bipNetworkNumber: _p(AcbmParams.bacBipNwkNumber)?.asInt(),
      mstpNetworkNumber: _p(AcbmParams.bacMstpNwkNumber)?.asInt(),
      bipDatalinkInterface: datalinkVal == 1 ? 'WiFi' : 'Ethernet',
    );
  }

  Future<void> setBACnetConfig(models.BACnetConfig config) async {
    if (config.deviceId != null) await paramSet(AcbmParams.bacDeviceId, config.deviceId!);
    if (config.deviceName != null) await paramSet(AcbmParams.bacDeviceName, config.deviceName!);
    if (config.deviceDescription != null) await paramSet(AcbmParams.bacDeviceDesc, config.deviceDescription!);
    if (config.bipPort != null) await paramSet(AcbmParams.bacBipPort, config.bipPort!);
    if (config.mstpAddress != null) await paramSet(AcbmParams.bacMstpMac, config.mstpAddress!);
  }
}
