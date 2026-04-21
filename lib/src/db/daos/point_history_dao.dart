import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/point_history.dart';

part 'point_history_dao.g.dart';

@DriftAccessor(tables: [PointHistory])
class PointHistoryDao extends DatabaseAccessor<AppDatabase>
    with _$PointHistoryDaoMixin {
  PointHistoryDao(super.db);

  Future<void> insert(PointHistoryCompanion entry) =>
      into(pointHistory).insert(entry);

  Future<void> insertBatch(List<PointHistoryCompanion> entries) async {
    await batch((b) => b.insertAll(pointHistory, entries));
  }

  Future<List<PointHistoryRow>> getByPoint(
    String pointId, {
    int limit = 100,
  }) =>
      (select(pointHistory)
            ..where((t) => t.pointId.equals(pointId))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
            ..limit(limit))
          .get();

  Stream<List<PointHistoryRow>> watchByPoint(
    String pointId, {
    int limit = 100,
  }) =>
      (select(pointHistory)
            ..where((t) => t.pointId.equals(pointId))
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
            ..limit(limit))
          .watch();

  Future<int> countByPoint(String pointId) async {
    final count = pointHistory.id.count();
    final query = selectOnly(pointHistory)
      ..addColumns([count])
      ..where(pointHistory.pointId.equals(pointId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> deleteOlderThan(String pointId, DateTime before) =>
      (delete(pointHistory)
            ..where(
                (t) => t.pointId.equals(pointId) & t.timestamp.isSmallerThanValue(before)))
          .go();

  Future<void> clearByPoint(String pointId) =>
      (delete(pointHistory)..where((t) => t.pointId.equals(pointId))).go();

  Future<void> clearAll() => delete(pointHistory).go();
}
