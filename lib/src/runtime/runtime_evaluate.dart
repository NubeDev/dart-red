part of 'runtime.dart';

// =============================================================================
// Evaluation engine
//
// Dirty subgraph walk: sources → transforms (sync) → sinks (async) → persist.
// Input gathering, status propagation, persistence filtering.
// Folder bridge: folder inputs → portal sources, portal sinks → folder outputs.
// =============================================================================

extension RuntimeEvaluation on MicroBmsRuntime {
  void _onSourceOutput(String nodeId, Map<String, dynamic> outputs) {
    _nodeValues[nodeId] = outputs;
    _nodeStatuses[nodeId] = NodeStatus.ok;
    _dirtyNodes.add(nodeId);
    _schedulEvaluation();
  }

  void _schedulEvaluation() {
    if (_evaluating) return;
    scheduleMicrotask(() => _evaluate());
  }

  Future<void> _evaluate() async {
    if (_evaluating || _dirtyNodes.isEmpty) return;
    _evaluating = true;

    try {
      final walkOrder = GraphSolver.dirtySubgraph(
        dirtyIds: _dirtyNodes,
        topoOrder: _topoOrder,
        adjacency: _adjacency,
      );
      _dirtyNodes.clear();

      final changedValues = <String, ({String value, String status})>{};

      for (final nodeId in walkOrder) {
        final type = _nodeTypes[nodeId];
        if (type == null) continue;

        if (type is TransformNode) {
          _evaluateTransform(nodeId, type);
        } else if (type is SinkNode) {
          await _evaluateSink(nodeId, type);
        }

        // Record changed value for persistence — only for nodes that opt in.
        final settings = _nodeSettings[nodeId] ?? {};
        final category = _nodeCategories[nodeId] ?? 'transform';
        if (_shouldPersist(settings, category)) {
          changedValues[nodeId] = (
            value: jsonEncode(_nodeValues[nodeId] ?? {}),
            status: (_nodeStatuses[nodeId] ?? NodeStatus.stale).name,
          );
        }
      }

      // Batch persist to Drift
      if (changedValues.isNotEmpty) {
        await _dao.updateNodeValues(changedValues);
      }
    } finally {
      _evaluating = false;
    }

    // If new dirty nodes appeared during evaluation, run again
    if (_dirtyNodes.isNotEmpty) {
      await _evaluate();
    }
  }

  void _evaluateTransform(String nodeId, TransformNode type) {
    final settings = _nodeSettings[nodeId] ?? {};
    final ports = type.getInputPorts(settings);
    final inputs = _gatherInputs(nodeId, ports);
    if (inputs == null) {
      _nodeValues[nodeId] = {};
      _nodeStatuses[nodeId] = NodeStatus.stale;
    } else {
      final inheritedStatus = NodeStatus.merge(
        _upstreamStatuses(nodeId, ports),
      );

      // --- Folder bridge: push inputs to portal source nodes ---
      if (type is SystemFolderNode) {
        _evaluateFolder(nodeId, inputs, inheritedStatus);
        return;
      }

      try {
        final result = type.evaluate(inputs);
        if (result != null) {
          _nodeValues[nodeId] = result;
          _nodeStatuses[nodeId] = inheritedStatus;
        } else {
          _nodeValues[nodeId] = {};
          _nodeStatuses[nodeId] = NodeStatus.stale;
        }
      } catch (e) {
        print('MicroBmsRuntime: error evaluating $nodeId: $e');
        _nodeStatuses[nodeId] = NodeStatus.error;
      }
    }
  }

  /// Evaluate a folder node: push external inputs to portal sources,
  /// and return collected outputs from portal sinks.
  void _evaluateFolder(
    String folderId,
    Map<String, dynamic> inputs,
    NodeStatus inheritedStatus,
  ) {
    // 1. Store external input values in the shared registry
    SystemFolderNode.inputValues[folderId] = inputs;

    // 2. Find all folder.input portal children and push values to them
    final portals = FolderInputNode.getPortalsForFolder(folderId);
    if (portals != null) {
      for (final entry in portals.entries) {
        final portalNodeId = entry.key;
        final portName = entry.value;
        final value = inputs[portName];

        // Push value through the portal's source callback
        final portalType = _nodeTypes[portalNodeId];
        if (portalType is FolderInputNode) {
          portalType.pushValue(portalNodeId, value);
        }
      }
    }

    // 3. Return current output values (populated by folder.output portals)
    final outputs = SystemFolderNode.outputValues[folderId];
    if (outputs != null && outputs.isNotEmpty) {
      _nodeValues[folderId] = outputs;
      _nodeStatuses[folderId] = inheritedStatus;
    } else {
      _nodeValues[folderId] = {};
      _nodeStatuses[folderId] = inheritedStatus;
    }
  }

  Future<void> _evaluateSink(String nodeId, SinkNode type) async {
    final settings = _nodeSettings[nodeId] ?? {};
    final ports = type.getInputPorts(settings);
    final inputs = _gatherInputs(nodeId, ports);
    if (inputs == null) {
      _nodeValues[nodeId] = {};
      _nodeStatuses[nodeId] = NodeStatus.stale;
    } else {
      final inheritedStatus = NodeStatus.merge(
        _upstreamStatuses(nodeId, ports),
      );
      _nodeValues[nodeId] = inputs;
      _nodeStatuses[nodeId] = inheritedStatus;
      try {
        final result = await type.execute(
          nodeId,
          inputs,
          _nodeSettings[nodeId] ?? {},
          parentId: _nodeParents[nodeId],
        );
        // If sink returns outputs, use those instead of raw inputs
        if (result != null) {
          _nodeValues[nodeId] = result;
        }

        // If this is a folder.output portal, mark the parent folder dirty
        // so it re-evaluates and propagates the updated output values.
        if (type is FolderOutputNode) {
          final parentId = _nodeParents[nodeId];
          if (parentId != null && _nodeTypes[parentId] is SystemFolderNode) {
            _dirtyNodes.add(parentId);
          }
        }
      } catch (e) {
        print('MicroBmsRuntime: error executing sink $nodeId: $e');
        _nodeStatuses[nodeId] = NodeStatus.error;
      }
    }
  }

  /// Gather input values for a node. Returns null if a required input is missing.
  Map<String, dynamic>? _gatherInputs(String nodeId, List<Port> ports) {
    final inputs = <String, dynamic>{};
    for (final port in ports) {
      final source = _inputMap[nodeId]?[port.name];
      if (source != null) {
        final val = _nodeValues[source.nodeId]?[source.port];
        inputs[port.name] = val;
        if (val == null && port.required) return null;
      } else {
        inputs[port.name] = port.defaultValue;
        if (port.defaultValue == null && port.required) return null;
      }
    }
    return inputs;
  }

  /// Collect upstream statuses for status propagation.
  List<NodeStatus> _upstreamStatuses(String nodeId, List<Port> ports) {
    final statuses = <NodeStatus>[];
    for (final port in ports) {
      final source = _inputMap[nodeId]?[port.name];
      if (source != null) {
        statuses.add(_nodeStatuses[source.nodeId] ?? NodeStatus.stale);
      }
    }
    return statuses;
  }

  /// Whether a node's value should survive restarts.
  static bool _shouldPersist(
      Map<String, dynamic> settings, String category) {
    final explicit = settings['persist'];
    if (explicit is bool) return explicit;
    return category == 'source';
  }
}
