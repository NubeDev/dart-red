import 'package:drift/drift.dart';

/// Alerts when something goes wrong.
@DataClassName('AlarmRow')
class Alarms extends Table {
  TextColumn get id => text()();
  TextColumn get pointId => text().nullable()();
  TextColumn get networkId => text().nullable()();
  TextColumn get type =>
      text()(); // outOfRange, connectionLost, publishFailed
  TextColumn get severity =>
      text().withDefault(const Constant('warning'))(); // info, warning, critical
  TextColumn get message => text()();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
