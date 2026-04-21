import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/devices.dart';

part 'device_dao.g.dart';

@DriftAccessor(tables: [Devices])
class DeviceDao extends DatabaseAccessor<AppDatabase> with _$DeviceDaoMixin {
  DeviceDao(super.db);

  Stream<List<DeviceRow>> watchAll() => select(devices).watch();

  Future<List<DeviceRow>> getAll() => select(devices).get();

  Stream<List<DeviceRow>> watchByNetwork(String networkId) =>
      (select(devices)..where((t) => t.networkId.equals(networkId))).watch();

  Future<List<DeviceRow>> getByNetwork(String networkId) =>
      (select(devices)..where((t) => t.networkId.equals(networkId))).get();

  Future<DeviceRow?> getById(String id) =>
      (select(devices)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(DevicesCompanion entry) =>
      into(devices).insertOnConflictUpdate(entry);

  Future<void> remove(String id) =>
      (delete(devices)..where((t) => t.id.equals(id))).go();

  Future<void> removeByNetwork(String networkId) =>
      (delete(devices)..where((t) => t.networkId.equals(networkId))).go();

  Future<void> clearAll() => delete(devices).go();
}
