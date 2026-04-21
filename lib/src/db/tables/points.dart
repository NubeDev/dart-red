import 'package:drift/drift.dart';

import 'devices.dart';

/// A sensor/control value on a device.
@DataClassName('PointRow')
class Points extends Table {
  TextColumn get id => text()();
  TextColumn get deviceId => text().references(Devices, #id)();
  TextColumn get name => text()();
  TextColumn get topic => text()();
  TextColumn get valueType =>
      text().withDefault(const Constant('number'))(); // bool, number, string
  TextColumn get mode =>
      text().withDefault(const Constant('rw'))(); // ro, wo, rw
  RealColumn get min => real().nullable()();
  RealColumn get max => real().nullable()();
  TextColumn get unit => text().nullable()();
  /// Widget used for writing values: toggle, slider, numberInput, textInput
  TextColumn get writeWidget =>
      text().withDefault(const Constant('numberInput'))();
  TextColumn get readStrategy =>
      text().withDefault(const Constant('sub'))(); // sub, poll, both
  IntColumn get pollIntervalSecs =>
      integer().withDefault(const Constant(30))();

  /// History recording: none, cov, cron
  TextColumn get historyType =>
      text().withDefault(const Constant('none'))();

  /// COV threshold — record when value changes by more than this amount.
  RealColumn get covThreshold => real().nullable()();

  /// Cron interval in seconds (60, 300, 900 = 1m, 5m, 15m).
  IntColumn get historyIntervalSecs =>
      integer().withDefault(const Constant(300))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
