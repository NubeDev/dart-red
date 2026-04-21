import '../../common/device_models.dart' as models;
import 'client_base.dart';

/// Modbus and BACnet point read/write.
mixin ClientPointsMixin on AcbmClientBase {
  // ─── Modbus ───────────────────────────────────────────────────────────

  Future<models.PointValue> modbusReadAI(int slaveId, int register) async =>
      parsePointValue(await transport.execute('mb_read_ai $slaveId $register'));

  Future<models.PointValue> modbusReadAO(int slaveId, int register) async =>
      parsePointValue(await transport.execute('mb_read_ao $slaveId $register'));

  Future<void> modbusWriteAO(int slaveId, int register, int value) async =>
      transport.execute('mb_write_ao $slaveId $register $value');

  Future<models.PointValue> modbusReadDI(int slaveId, int address) async =>
      parsePointValue(await transport.execute('mb_read_di $slaveId $address'));

  Future<models.PointValue> modbusReadDO(int slaveId, int address) async =>
      parsePointValue(await transport.execute('mb_read_do $slaveId $address'));

  Future<void> modbusWriteDO(int slaveId, int address, bool value) async =>
      transport.execute('mb_write_do $slaveId $address ${value ? 1 : 0}');

  // ─── BACnet ───────────────────────────────────────────────────────────

  Future<models.PointValue> bacnetReadAI(int deviceId, int objectId) async =>
      parsePointValue(await transport.execute('bac_read_ai $deviceId $objectId'));

  Future<models.PointValue> bacnetReadAO(int deviceId, int objectId) async =>
      parsePointValue(await transport.execute('bac_read_ao $deviceId $objectId'));

  Future<void> bacnetWriteAO(int deviceId, int objectId, double value) async =>
      transport.execute('bac_write_ao $deviceId $objectId $value');

  Future<models.PointValue> bacnetReadAV(int deviceId, int objectId) async =>
      parsePointValue(await transport.execute('bac_read_av $deviceId $objectId'));

  Future<void> bacnetWriteAV(int deviceId, int objectId, double value) async =>
      transport.execute('bac_write_av $deviceId $objectId $value');

  Future<models.PointValue> bacnetReadBI(int deviceId, int objectId) async =>
      parsePointValue(await transport.execute('bac_read_bi $deviceId $objectId'));

  Future<models.PointValue> bacnetReadBO(int deviceId, int objectId) async =>
      parsePointValue(await transport.execute('bac_read_bo $deviceId $objectId'));

  Future<void> bacnetWriteBO(int deviceId, int objectId, bool value) async =>
      transport.execute('bac_write_bo $deviceId $objectId ${value ? 1 : 0}');
}
