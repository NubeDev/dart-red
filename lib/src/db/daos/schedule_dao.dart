import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/schedules.dart';

part 'schedule_dao.g.dart';

@DriftAccessor(tables: [ScheduleEntries, ScheduleBindings])
class ScheduleDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduleDaoMixin {
  ScheduleDao(super.db);

  // --- Schedule entries ---

  Stream<List<ScheduleEntryRow>> watchAllEntries() =>
      select(scheduleEntries).watch();

  Future<List<ScheduleEntryRow>> getAllEntries() =>
      select(scheduleEntries).get();

  Future<ScheduleEntryRow?> getEntryById(String id) =>
      (select(scheduleEntries)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertEntry(ScheduleEntriesCompanion entry) =>
      into(scheduleEntries).insertOnConflictUpdate(entry);

  Future<void> removeEntry(String id) =>
      (delete(scheduleEntries)..where((t) => t.id.equals(id))).go();

  // --- Bindings ---

  Stream<List<ScheduleBindingRow>> watchAllBindings() =>
      select(scheduleBindings).watch();

  Future<List<ScheduleBindingRow>> getAllBindings() =>
      select(scheduleBindings).get();

  Stream<List<ScheduleBindingRow>> watchEnabledBindings() =>
      (select(scheduleBindings)..where((t) => t.enabled.equals(true)))
          .watch();

  Future<List<ScheduleBindingRow>> getEnabledBindings() =>
      (select(scheduleBindings)..where((t) => t.enabled.equals(true)))
          .get();

  Future<void> upsertBinding(ScheduleBindingsCompanion entry) =>
      into(scheduleBindings).insertOnConflictUpdate(entry);

  Future<void> removeBinding(String id) =>
      (delete(scheduleBindings)..where((t) => t.id.equals(id))).go();

  Future<void> removeBindingsBySchedule(String scheduleId) =>
      (delete(scheduleBindings)
            ..where((t) => t.scheduleId.equals(scheduleId)))
          .go();

  Future<void> removeBindingsByPoint(String pointId) =>
      (delete(scheduleBindings)..where((t) => t.pointId.equals(pointId)))
          .go();
}
