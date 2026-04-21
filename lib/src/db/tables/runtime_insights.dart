import 'package:drift/drift.dart';

import 'runtime_nodes.dart';

/// Insight transaction log — alarms, alerts, notifications, energy events.
///
/// Each row is a single insight event with full lifecycle tracking:
/// active → acknowledged → cleared. The [metadata] column holds extensible
/// JSON for alarm-type-specific data (threshold, deadband, expression, etc.)
@DataClassName('RuntimeInsightRow')
class RuntimeInsights extends Table {
  /// Primary key — UUID assigned when the insight is created.
  TextColumn get id => text()();

  /// The insight node that generated this event.
  TextColumn get nodeId => text().references(RuntimeNodes, #id)();

  /// Insight category: 'alarm', 'alert', 'notification', 'energy', 'action'.
  TextColumn get type => text()();

  /// Severity level: 'critical', 'high', 'medium', 'low', 'info'.
  TextColumn get severity => text()();

  /// Lifecycle state: 'active', 'acknowledged', 'cleared', 'inhibited'.
  TextColumn get state => text()();

  /// Short human-readable title, e.g. "High Room Temperature".
  TextColumn get title => text()();

  /// Optional detail message, e.g. "Zone 3 hit 28°C while AC running".
  TextColumn get message => text().nullable()();

  /// The value that triggered the insight (if numeric).
  RealColumn get triggerValue => real().nullable()();

  /// The configured threshold that was breached (if applicable).
  RealColumn get thresholdValue => real().nullable()();

  /// When the insight was first triggered.
  DateTimeColumn get triggeredAt => dateTime()();

  /// When the insight was cleared (condition no longer met).
  DateTimeColumn get clearedAt => dateTime().nullable()();

  /// When a user acknowledged the insight.
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();

  /// Extensible JSON bag for alarm-specific context:
  /// deadband, inhibit duration, expression, input snapshot, etc.
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}
