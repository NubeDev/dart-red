import 'package:drift/drift.dart';

/// Time-series samples for trend/sparkline.
@DataClassName('PointHistoryRow')
class PointHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pointId => text()();
  RealColumn get value => real().nullable()();
  TextColumn get stringValue => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
}
