import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/points.dart';

part 'point_dao.g.dart';

@DriftAccessor(tables: [Points])
class PointDao extends DatabaseAccessor<AppDatabase> with _$PointDaoMixin {
  PointDao(super.db);

  Stream<List<PointRow>> watchByDevice(String deviceId) =>
      (select(points)..where((t) => t.deviceId.equals(deviceId))).watch();

  Future<List<PointRow>> getByDevice(String deviceId) =>
      (select(points)..where((t) => t.deviceId.equals(deviceId))).get();

  Future<List<PointRow>> getAll() => select(points).get();

  Stream<List<PointRow>> watchAll() => select(points).watch();

  Future<PointRow?> getById(String id) =>
      (select(points)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(PointsCompanion entry) =>
      into(points).insertOnConflictUpdate(entry);

  Future<void> remove(String id) =>
      (delete(points)..where((t) => t.id.equals(id))).go();

  Future<void> removeByDevice(String deviceId) =>
      (delete(points)..where((t) => t.deviceId.equals(deviceId))).go();
}
