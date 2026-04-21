import 'package:drift/drift.dart';

/// Shared broker/bus config — MQTT now, BACnet/Modbus-gateway future.
@DataClassName('NetworkRow')
class Networks extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get protocol => text().withDefault(const Constant('mqtt'))();
  TextColumn get host => text()();
  IntColumn get port => integer().withDefault(const Constant(1883))();
  TextColumn get username => text().nullable()();
  TextColumn get password => text().nullable()();
  BoolColumn get useTls => boolean().withDefault(const Constant(false))();
  TextColumn get prefix => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
  /// Protocol-specific config JSON (BACnet: bbmdHost, apduTimeout, etc.)
  TextColumn get settings => text().withDefault(const Constant('{}'))();
  /// Cloud sync: Rubix cloud node ID (null = not synced).
  TextColumn get cloudNodeId => text().nullable()();
  /// Cloud sync: which location (server) to sync to.
  TextColumn get locationId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
