import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../db/daos/runtime_dao.dart';
import '../serial/serial_scanner.dart';
import 'graph_solver.dart';
import 'node.dart';
import 'node_status.dart';
import 'node_registry.dart';
import 'port.dart';
import 'nodes/history/history_display_node.dart';
import 'nodes/history/history_log_node.dart';
import 'nodes/insight/insight_alarm_node.dart';
import 'nodes/insight/insight_manager_node.dart';
import 'nodes/system/folder_node.dart';
import 'nodes/system/folder_input_node.dart';
import 'nodes/system/folder_output_node.dart';

part 'runtime_evaluate.dart';
part 'runtime_graph.dart';
part 'runtime_crud.dart';
part 'runtime_pages.dart';

const _uuid = Uuid();

/// The Micro-BMS evaluation engine.
///
/// On start: loads flow from Drift, builds graph, starts source nodes.
/// Source node produces value → markDirty() → topo-sort walk dirty transforms
/// (sync) → sinks (async) → persist changed values to Drift.
///
/// Split across files via `part`:
///   runtime.dart          — class def, fields, start/stop
///   runtime_evaluate.dart — evaluation loop, input gathering, persistence
///   runtime_graph.dart    — graph building from Drift, topo sort, source start
///   runtime_crud.dart     — node/edge CRUD, value/settings, palette
///   runtime_pages.dart    — dashboard pages, flow state, enable/disable
class MicroBmsRuntime {
  final RuntimeDao _dao;
  final NodeRegistry _registry;

  String? _flowId;
  bool _running = false;

  // In-memory graph state
  final _nodeTypes = <String, NodeType>{}; // nodeId → NodeType instance
  final _nodeSettings = <String, Map<String, dynamic>>{};
  final _nodeCategories = <String, String>{};
  final _nodeValues = <String, Map<String, dynamic>>{}; // nodeId → output values
  final _nodeStatuses = <String, NodeStatus>{};
  final _nodePositions = <String, ({double x, double y})>{};
  final _nodeLabels = <String, String?>{}; // nodeId → user-set label

  // Containment hierarchy
  final _nodeParents = <String, String?>{}; // nodeId → parentId (null = root)
  final _nodeChildren = <String, List<String>>{}; // nodeId → [childIds]

  // Edge mappings
  // targetNodeId → { targetPort → (sourceNodeId, sourcePort) }
  final _inputMap =
      <String, Map<String, ({String nodeId, String port})>>{};
  // sourceNodeId → [targetNodeId]
  final _adjacency = <String, List<String>>{};

  // Hidden (portless link) edges — stored as "srcId:srcPort->tgtId:tgtPort"
  // for fast lookup without hitting the DB.
  final _hiddenEdges = <String>{};

  List<String> _topoOrder = [];

  // Dirty nodes waiting for evaluation
  final _dirtyNodes = <String>{};
  bool _evaluating = false;

  MicroBmsRuntime({
    required RuntimeDao dao,
    required NodeRegistry registry,
  })  : _dao = dao,
        _registry = registry;

  String? get flowId => _flowId;
  bool get isRunning => _running;

  // ---------------------------------------------------------------------------
  // Startup / shutdown
  // ---------------------------------------------------------------------------

  /// Initialize the runtime: ensure a default flow exists, load graph, start.
  Future<void> start() async {
    if (_running) return;

    // Ensure a default flow exists
    final flows = await _dao.getAllFlows();
    if (flows.isEmpty) {
      final id = _uuid.v4();
      await _dao.upsertFlow(RuntimeFlowsCompanion.insert(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      _flowId = id;
    } else {
      _flowId = flows.first.id;
    }

    await _rebuildGraph();
    _running = true;
    print('MicroBmsRuntime: started (flow=$_flowId, '
        '${_nodeTypes.length} nodes, ${_topoOrder.length} in topo order)');

    // If nodes have persisted values, re-evaluate the full graph
    if (_nodeValues.values.any((v) => v.isNotEmpty)) {
      print('MicroBmsRuntime: re-evaluating from persisted values');
      _dirtyNodes.addAll(
        _nodeTypes.keys.where((id) => _nodeCategories[id] == 'source'),
      );
      await _evaluate();
    }
  }

  Future<void> stop() async {
    _running = false;
    for (final entry in _nodeTypes.entries) {
      await entry.value.stop(entry.key);
    }
    _nodeTypes.clear();
    _nodeValues.clear();
    _nodeStatuses.clear();
    _nodePositions.clear();
    _nodeParents.clear();
    _nodeChildren.clear();
    _inputMap.clear();
    _adjacency.clear();
    _hiddenEdges.clear();
    _topoOrder.clear();
    _dirtyNodes.clear();
    print('MicroBmsRuntime: stopped');
  }
}
