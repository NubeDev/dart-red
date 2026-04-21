import 'package:drift/drift.dart';

import 'runtime_nodes.dart';

/// Time-series history samples for runtime nodes.
///
/// Typed columns (numValue, boolValue, strValue) allow efficient queries
/// without JSON parsing. Only one column is populated per row based on
/// the node's valueType setting.
@DataClassName('RuntimeHistoryRow')
class RuntimeHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nodeId => text().references(RuntimeNodes, #id)();

  /// Numeric value (temperature, setpoint, count, etc.)
  RealColumn get numValue => real().nullable()();

  /// Boolean value (on/off, active/inactive, alarm state)
  BoolColumn get boolValue => boolean().nullable()();

  /// String value (status text, mode name, etc.)
  TextColumn get strValue => text().nullable()();

  DateTimeColumn get timestamp => dateTime()();
}
