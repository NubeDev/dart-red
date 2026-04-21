import 'package:drift/drift.dart';

import 'runtime_flows.dart';
import 'runtime_nodes.dart';

/// A directed edge connecting an output port of one node to an input port
/// of another.
@DataClassName('RuntimeEdgeRow')
class RuntimeEdges extends Table {
  TextColumn get id => text()();
  TextColumn get flowId => text().references(RuntimeFlows, #id)();
  TextColumn get sourceNodeId => text().references(RuntimeNodes, #id)();
  TextColumn get sourcePort => text()();
  TextColumn get targetNodeId => text().references(RuntimeNodes, #id)();
  TextColumn get targetPort => text()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
