import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/runtime_flows.dart';
import '../tables/runtime_nodes.dart';
import '../tables/runtime_edges.dart';
import '../tables/runtime_history.dart';
import '../tables/runtime_insights.dart';

part 'runtime_dao.g.dart';

@DriftAccessor(tables: [RuntimeFlows, RuntimeNodes, RuntimeEdges, RuntimeHistory, RuntimeInsights])
class RuntimeDao extends DatabaseAccessor<AppDatabase>
    with _$RuntimeDaoMixin {
  RuntimeDao(super.db);

  // ---------------------------------------------------------------------------
  // Flow CRUD
  // ---------------------------------------------------------------------------

  Future<List<RuntimeFlowRow>> getAllFlows() => select(runtimeFlows).get();

  Future<RuntimeFlowRow?> getFlowById(String id) =>
      (select(runtimeFlows)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertFlow(RuntimeFlowsCompanion entry) =>
      into(runtimeFlows).insertOnConflictUpdate(entry);

  /// Partial update — only touches columns present in [patch].
  Future<void> updateFlow(String id, RuntimeFlowsCompanion patch) =>
      (update(runtimeFlows)..where((t) => t.id.equals(id))).write(patch);

  Future<void> removeFlow(String id) =>
      (delete(runtimeFlows)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Node CRUD
  // ---------------------------------------------------------------------------

  Future<List<RuntimeNodeRow>> getNodesByFlow(String flowId) =>
      (select(runtimeNodes)..where((t) => t.flowId.equals(flowId))).get();

  Future<RuntimeNodeRow?> getNodeById(String id) =>
      (select(runtimeNodes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertNode(RuntimeNodesCompanion entry) =>
      into(runtimeNodes).insertOnConflictUpdate(entry);

  /// Partial update — only touches columns present in [patch].
  Future<void> updateNode(String id, RuntimeNodesCompanion patch) =>
      (update(runtimeNodes)..where((t) => t.id.equals(id))).write(patch);

  /// Get direct children of a node.
  Future<List<RuntimeNodeRow>> getChildNodes(String parentId) =>
      (select(runtimeNodes)..where((t) => t.parentId.equals(parentId))).get();

  /// Remove a node, its edges, history, and all descendant nodes (cascade).
  Future<void> removeNode(String id) async {
    // Recursively delete children first
    final children = await getChildNodes(id);
    for (final child in children) {
      await removeNode(child.id);
    }
    // Delete history and insights for this node
    await deleteHistoryForNode(id);
    await deleteInsightsForNode(id);
    // Delete edges connected to this node
    await (delete(runtimeEdges)
          ..where((t) =>
              t.sourceNodeId.equals(id) | t.targetNodeId.equals(id)))
        .go();
    await (delete(runtimeNodes)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------------
  // Edge CRUD
  // ---------------------------------------------------------------------------

  Future<List<RuntimeEdgeRow>> getEdgesByFlow(String flowId) =>
      (select(runtimeEdges)..where((t) => t.flowId.equals(flowId))).get();

  Future<RuntimeEdgeRow?> getEdgeById(String id) =>
      (select(runtimeEdges)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertEdge(RuntimeEdgesCompanion entry) =>
      into(runtimeEdges).insertOnConflictUpdate(entry);

  Future<void> removeEdge(String id) =>
      (delete(runtimeEdges)..where((t) => t.id.equals(id))).go();

  // ---------------------------------------------------------------------------
  // Watch streams
  // ---------------------------------------------------------------------------

  /// Fires when nodes or edges are added/removed or settings change.
  /// Does NOT fire on value-only updates (separate stream).
  Stream<List<RuntimeNodeRow>> watchStructure(String flowId) =>
      (select(runtimeNodes)..where((t) => t.flowId.equals(flowId))).watch();

  Stream<List<RuntimeEdgeRow>> watchEdges(String flowId) =>
      (select(runtimeEdges)..where((t) => t.flowId.equals(flowId))).watch();

  // ---------------------------------------------------------------------------
  // Batch value update — single transaction
  // ---------------------------------------------------------------------------

  /// Persist multiple node values + statuses in one transaction.
  /// [updates] maps nodeId → { "value": jsonEncodedValue, "status": statusStr }
  Future<void> updateNodeValues(
      Map<String, ({String value, String status})> updates) {
    return transaction(() async {
      for (final entry in updates.entries) {
        await (update(runtimeNodes)..where((t) => t.id.equals(entry.key)))
            .write(RuntimeNodesCompanion(
          value: Value(entry.value.value),
          status: Value(entry.value.status),
        ));
      }
    });
  }

  // ---------------------------------------------------------------------------
  // History — bulk insert, query, trim
  // ---------------------------------------------------------------------------

  /// Bulk insert history samples in a single transaction.
  Future<void> insertHistoryBatch(List<RuntimeHistoryCompanion> rows) {
    return transaction(() async {
      for (final row in rows) {
        await into(runtimeHistory).insert(row);
      }
    });
  }

  /// Get latest N samples for a node, newest first.
  Future<List<RuntimeHistoryRow>> getHistory(String nodeId,
      {int limit = 100}) {
    return (select(runtimeHistory)
          ..where((t) => t.nodeId.equals(nodeId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// Delete oldest samples beyond the retention limit for a node.
  Future<void> trimHistory(String nodeId, int maxSamples) async {
    // Find the timestamp of the Nth newest row
    final cutoffRows = await (select(runtimeHistory)
          ..where((t) => t.nodeId.equals(nodeId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(1, offset: maxSamples))
        .get();

    if (cutoffRows.isEmpty) return; // under the limit

    final cutoff = cutoffRows.first.timestamp;
    await (delete(runtimeHistory)
          ..where(
              (t) => t.nodeId.equals(nodeId) & t.timestamp.isSmallerOrEqual(
                  Variable<DateTime>(cutoff))))
        .go();
  }

  /// Delete all history for a node.
  Future<void> deleteHistoryForNode(String nodeId) =>
      (delete(runtimeHistory)..where((t) => t.nodeId.equals(nodeId))).go();

  // ---------------------------------------------------------------------------
  // Insights — insert, query, update, trim
  // ---------------------------------------------------------------------------

  /// Insert a single insight event.
  Future<void> insertInsight(RuntimeInsightsCompanion row) =>
      into(runtimeInsights).insert(row);

  /// Get insights for a node, newest first.
  Future<List<RuntimeInsightRow>> getInsights(String nodeId,
      {int limit = 100}) {
    return (select(runtimeInsights)
          ..where((t) => t.nodeId.equals(nodeId))
          ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
          ..limit(limit))
        .get();
  }

  /// Get all active (un-cleared) insights across all nodes.
  Future<List<RuntimeInsightRow>> getActiveInsights() {
    return (select(runtimeInsights)
          ..where((t) => t.state.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)]))
        .get();
  }

  /// Get insight counts grouped by state for a set of node IDs.
  /// Returns { 'active': N, 'acknowledged': N, 'cleared': N, 'inhibited': N }
  Future<Map<String, int>> getInsightStats() async {
    final rows = await select(runtimeInsights).get();
    final stats = <String, int>{
      'active': 0,
      'acknowledged': 0,
      'cleared': 0,
      'inhibited': 0,
      'total': rows.length,
    };
    for (final row in rows) {
      stats[row.state] = (stats[row.state] ?? 0) + 1;
    }
    return stats;
  }

  /// Update an insight's state (e.g. active → acknowledged → cleared).
  Future<void> updateInsightState(
      String id, String state, {DateTime? clearedAt, DateTime? acknowledgedAt}) {
    return (update(runtimeInsights)..where((t) => t.id.equals(id))).write(
      RuntimeInsightsCompanion(
        state: Value(state),
        clearedAt: Value(clearedAt),
        acknowledgedAt: Value(acknowledgedAt),
      ),
    );
  }

  /// Clear an active insight by ID.
  Future<void> clearInsight(String id) => updateInsightState(
        id,
        'cleared',
        clearedAt: DateTime.now(),
      );

  /// Acknowledge an active insight by ID.
  Future<void> acknowledgeInsight(String id) => updateInsightState(
        id,
        'acknowledged',
        acknowledgedAt: DateTime.now(),
      );

  /// Find the most recent active insight for a node (if any).
  Future<RuntimeInsightRow?> getActiveInsightForNode(String nodeId) {
    return (select(runtimeInsights)
          ..where(
              (t) => t.nodeId.equals(nodeId) & t.state.equals('active'))
          ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Trim old cleared insights beyond a retention limit per node.
  Future<void> trimInsights(String nodeId, int maxRetained) async {
    final cutoffRows = await (select(runtimeInsights)
          ..where((t) =>
              t.nodeId.equals(nodeId) & t.state.equals('cleared'))
          ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
          ..limit(1, offset: maxRetained))
        .get();

    if (cutoffRows.isEmpty) return;

    final cutoff = cutoffRows.first.triggeredAt;
    await (delete(runtimeInsights)
          ..where((t) =>
              t.nodeId.equals(nodeId) &
              t.state.equals('cleared') &
              t.triggeredAt.isSmallerOrEqual(Variable<DateTime>(cutoff))))
        .go();
  }

  /// Delete all insights for a node.
  Future<void> deleteInsightsForNode(String nodeId) =>
      (delete(runtimeInsights)..where((t) => t.nodeId.equals(nodeId))).go();
}
