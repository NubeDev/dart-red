import 'package:drift/drift.dart';

/// Single automation flow — the entire Micro-BMS graph.
@DataClassName('RuntimeFlowRow')
class RuntimeFlows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant('Default Flow'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
