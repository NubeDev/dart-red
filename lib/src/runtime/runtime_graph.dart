part of 'runtime.dart';

// =============================================================================
// Graph building
//
// Load nodes/edges from Drift, build in-memory maps, topo sort, start sources.
// Restore persisted values for nodes that opt into persistence.
// =============================================================================

extension RuntimeGraph on MicroBmsRuntime {
  Future<void> _rebuildGraph() async {
    // Stop existing source nodes
    for (final entry in _nodeTypes.entries) {
      await entry.value.stop(entry.key);
    }
    _nodeTypes.clear();
    _nodeLabels.clear();
    _inputMap.clear();
    _adjacency.clear();
    _hiddenEdges.clear();
    _nodeParents.clear();
    _nodeChildren.clear();

    final nodes = await _dao.getNodesByFlow(_flowId!);
    final edges = await _dao.getEdgesByFlow(_flowId!);

    // Build node instances + parent/child maps
    for (final node in nodes) {
      final type = _registry.create(node.type);
      if (type == null) {
        print('MicroBmsRuntime: unknown node type "${node.type}", skipping');
        continue;
      }
      _nodeTypes[node.id] = type;
      _nodeSettings[node.id] = node.settings;
      _nodeCategories[node.id] = node.category;
      _nodeStatuses[node.id] = NodeStatus.fromString(node.status);
      _nodePositions[node.id] = (x: node.posX, y: node.posY);
      _nodeLabels[node.id] = node.label;
      _nodeParents[node.id] = node.parentId;

      // Restore persisted values — only if node opts into persistence.
      if (RuntimeEvaluation._shouldPersist(node.settings, node.category)) {
        try {
          final decoded = jsonDecode(node.value) as Map<String, dynamic>;
          if (decoded.isNotEmpty) {
            _nodeValues[node.id] = decoded;
          }
        } catch (e) {
          print(
              'MicroBmsRuntime: failed to restore value for ${node.id}: $e');
        }
      }
    }

    // Inject dependencies into nodes that need them
    _injectNodeDependencies();

    // Build children map from parent relationships
    for (final nodeId in _nodeTypes.keys) {
      _nodeChildren[nodeId] = [];
    }
    for (final entry in _nodeParents.entries) {
      if (entry.value != null && _nodeChildren.containsKey(entry.value)) {
        _nodeChildren[entry.value]!.add(entry.key);
      }
    }

    // Build edge mappings
    for (final nodeId in _nodeTypes.keys) {
      _adjacency[nodeId] = [];
      _inputMap[nodeId] = {};
    }

    for (final edge in edges) {
      if (!_nodeTypes.containsKey(edge.sourceNodeId) ||
          !_nodeTypes.containsKey(edge.targetNodeId)) continue;

      _adjacency[edge.sourceNodeId]!.add(edge.targetNodeId);
      _inputMap[edge.targetNodeId]![edge.targetPort] = (
        nodeId: edge.sourceNodeId,
        port: edge.sourcePort,
      );
      if (edge.hidden) {
        _hiddenEdges.add(
            '${edge.sourceNodeId}:${edge.sourcePort}->${edge.targetNodeId}:${edge.targetPort}');
      }
    }

    // Topological sort
    _topoOrder = GraphSolver.topologicalSort(
      nodeIds: _nodeTypes.keys.toList(),
      adjacency: _adjacency,
    );

    // Start source nodes — parents before children (tree order)
    final startOrder = _treeOrderedSourceIds();
    for (final nodeId in startOrder) {
      final type = _nodeTypes[nodeId]!;

      await type.start(
        nodeId,
        _nodeSettings[nodeId] ?? {},
        (outputs) => _onSourceOutput(nodeId, outputs),
        parentId: _nodeParents[nodeId],
      );
    }

    // Start sink nodes that need initialization (e.g. history flush timers)
    for (final nodeId in _nodeTypes.keys) {
      final type = _nodeTypes[nodeId]!;
      if (type is SinkNode &&
          (type is HistoryLogNode || type is HistoryDisplayNode)) {
        await type.start(
          nodeId,
          _nodeSettings[nodeId] ?? {},
          (_) {}, // sinks don't produce output
        );
      }
    }
  }

  /// Returns source node IDs in tree order: parents before children.
  /// Roots first, then their children, depth-first.
  List<String> _treeOrderedSourceIds() {
    final result = <String>[];

    void walk(String nodeId) {
      final type = _nodeTypes[nodeId];
      if (type is SourceNode) {
        result.add(nodeId);
      }
      for (final childId in _nodeChildren[nodeId] ?? <String>[]) {
        walk(childId);
      }
    }

    // Start from root nodes (no parent)
    for (final nodeId in _nodeTypes.keys) {
      if (_nodeParents[nodeId] == null) {
        walk(nodeId);
      }
    }

    return result;
  }

  /// Inject DAO and manager defaults into nodes that need them.
  void _injectNodeDependencies() {
    final (managerDefaults, insightManagerDefaults) = _findManagerDefaults();

    for (final entry in _nodeTypes.entries) {
      _injectSingleNode(entry.value, managerDefaults, insightManagerDefaults);
    }
  }

  /// Inject dependencies into a single newly-added node.
  void _injectSingleNodeDependencies(NodeType type) {
    final (managerDefaults, insightManagerDefaults) = _findManagerDefaults();
    _injectSingleNode(type, managerDefaults, insightManagerDefaults);
  }

  /// Find current manager defaults from the live graph.
  (Map<String, dynamic>, Map<String, dynamic>) _findManagerDefaults() {
    Map<String, dynamic> managerDefaults = {};
    Map<String, dynamic> insightManagerDefaults = {};
    for (final entry in _nodeTypes.entries) {
      if (entry.value.typeName == 'history.manager') {
        managerDefaults = _nodeSettings[entry.key] ?? {};
      } else if (entry.value.typeName == 'insight.manager') {
        insightManagerDefaults = _nodeSettings[entry.key] ?? {};
      }
    }
    return (managerDefaults, insightManagerDefaults);
  }

  /// Apply dependencies to a single node instance.
  void _injectSingleNode(
    NodeType type,
    Map<String, dynamic> managerDefaults,
    Map<String, dynamic> insightManagerDefaults,
  ) {
    if (type is HistoryLogNode) {
      type.dao = _dao;
      type.managerDefaults = managerDefaults;
    } else if (type is HistoryDisplayNode) {
      type.dao = _dao;
      type.managerDefaults = managerDefaults;
    } else if (type is InsightManagerNode) {
      type.dao = _dao;
    } else if (type is InsightAlarmNode) {
      type.dao = _dao;
      type.managerDefaults = insightManagerDefaults;
    }
  }
}
