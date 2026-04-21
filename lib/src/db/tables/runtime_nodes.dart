import 'package:drift/drift.dart';

import '../converters.dart';
import 'runtime_flows.dart';

/// A node in the automation graph (source, transform, or sink).
@DataClassName('RuntimeNodeRow')
class RuntimeNodes extends Table {
  TextColumn get id => text()();
  TextColumn get flowId => text().references(RuntimeFlows, #id)();

  /// Node type identifier, e.g. "mqtt.subscribe", "math.add", "system.constant"
  TextColumn get type => text()();

  /// Category: "source", "transform", or "sink"
  TextColumn get category => text()();

  /// Runtime status: "ok", "stale", "error", "disabled"
  TextColumn get status => text().withDefault(const Constant('stale'))();

  /// Current output value(s) as JSON — persisted on every change.
  TextColumn get value => text().withDefault(const Constant('{}'))();

  /// Node-specific configuration as JSON (e.g. {"topic": "sensor/a"})
  TextColumn get settings =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();

  /// Optional display label
  TextColumn get label => text().nullable()();

  /// Parent node ID for containment hierarchy.
  /// null = root node. Examples: device → network, point → device,
  /// subscribe → broker, display → page.
  TextColumn get parentId => text().nullable()();

  /// Canvas position (persisted so the UI can restore node layout).
  RealColumn get posX => real().withDefault(const Constant(0.0))();
  RealColumn get posY => real().withDefault(const Constant(0.0))();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
