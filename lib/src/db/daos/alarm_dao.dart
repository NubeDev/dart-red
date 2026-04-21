import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/alarms.dart';

part 'alarm_dao.g.dart';

@DriftAccessor(tables: [Alarms])
class AlarmDao extends DatabaseAccessor<AppDatabase> with _$AlarmDaoMixin {
  AlarmDao(super.db);

  Stream<List<AlarmRow>> watchAll() =>
      (select(alarms)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Stream<List<AlarmRow>> watchUnacknowledged() =>
      (select(alarms)
            ..where((t) => t.acknowledgedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<int> countUnacknowledged() async {
    final c = countAll();
    final query = selectOnly(alarms)
      ..where(alarms.acknowledgedAt.isNull())
      ..addColumns([c]);
    final row = await query.getSingle();
    return row.read(c)!;
  }

  Future<void> insert(AlarmsCompanion entry) =>
      into(alarms).insert(entry);

  Future<void> acknowledge(String id) =>
      (update(alarms)..where((t) => t.id.equals(id)))
          .write(AlarmsCompanion(acknowledgedAt: Value(DateTime.now())));

  Future<void> acknowledgeAll() =>
      update(alarms).write(
          AlarmsCompanion(acknowledgedAt: Value(DateTime.now())));

  Future<void> remove(String id) =>
      (delete(alarms)..where((t) => t.id.equals(id))).go();

  Future<void> clearAll() => delete(alarms).go();
}
