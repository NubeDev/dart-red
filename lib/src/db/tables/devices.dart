import 'package:drift/drift.dart';

import '../converters.dart';
import 'networks.dart';

/// Physical controllers — one row per device, always belongs to a network.
@DataClassName('DeviceRow')
class Devices extends Table {
  TextColumn get id => text()();
  TextColumn get networkId => text().references(Networks, #id)();
  TextColumn get name => text()();
  TextColumn get type => text().nullable()(); // ACBM, ACBL, custom
  TextColumn get topicPrefix => text().withDefault(const Constant(''))();
  // TCP connection (optional — for direct management/scanning)
  TextColumn get host => text().nullable()();
  IntColumn get port => integer().nullable()();
  // Serial connection (optional)
  TextColumn get serialPort => text().nullable()();
  IntColumn get baudRate => integer().nullable()();
  // Shared credentials (TCP/serial login)
  TextColumn get username => text().nullable()();
  TextColumn get password => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get tags =>
      text().map(const StringListConverter()).withDefault(const Constant('[]'))();
  TextColumn get metadata =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();
  /// Cloud sync: Rubix cloud node ID (null = not synced).
  TextColumn get cloudNodeId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
