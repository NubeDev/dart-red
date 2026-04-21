import 'package:drift/drift.dart';

import '../converters.dart';
import 'points.dart';

/// Named schedule definitions stored locally.
@DataClassName('ScheduleEntryRow')
class ScheduleEntries extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get schedule => text().map(const ScheduleConverter())();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// "When schedule X is active, publish Y to point Z."
@DataClassName('ScheduleBindingRow')
class ScheduleBindings extends Table {
  TextColumn get id => text()();
  TextColumn get scheduleId => text().references(ScheduleEntries, #id)();
  TextColumn get pointId => text().references(Points, #id)();
  TextColumn get activeValue => text()();
  TextColumn get inactiveValue => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
