part of 'runtime.dart';

// =============================================================================
// Node & edge CRUD
//
// Create, read, update, delete nodes and edges.
// Handles graph rebuild, incremental edge updates, validation.
// =============================================================================

extension RuntimeCrud on MicroBmsRuntime {
  // ---------------------------------------------------------------------------
  // Node value / settings
  // ---------------------------------------------------------------------------

  /// Get current output value + status of a node.
  ({Map<String, dynamic> value, NodeStatus status})? getNodeValue(
      String nodeId) {
    if (!_nodeTypes.containsKey(nodeId)) return null;
    return (
      value: _nodeValues[nodeId] ?? {},
      status: _nodeStatuses[nodeId] ?? NodeStatus.stale,
    );
  }

  /// Set a node's value externally (for ui.source, system.variable).
  /// Updates in-memory, marks dirty, triggers evaluation and persist.
  Future<void> setNodeValue(String nodeId, dynamic value) async {
    if (!_nodeTypes.containsKey(nodeId)) {
      throw ArgumentError('Node not found: $nodeId');
    }
    _nodeValues[nodeId] = {'value': value};
    _nodeStatuses[nodeId] = NodeStatus.ok;
    _dirtyNodes.add(nodeId);
    await _evaluate();
  }

  /// Get a node's current settings.
  Map<String, dynamic>? getNodeSettings(String nodeId) {
    if (!_nodeTypes.containsKey(nodeId)) return null;
    return _nodeSettings[nodeId] ?? {};
  }

  /// Get the JSON Schema for a node's settings (based on its type).
  ///
  /// Resolves dynamic fields: `x-widget: node-picker` fields get their
  /// enum values populated from the current flow's nodes of the matching
  /// `x-node-type`. Supports both single-select (string) and multi-select
  /// (array). The UI just sees normal dropdowns/checkboxes.
  ///
  /// Also injects `x-warnings` with validation messages (duplicate order,
  /// missing page selection, etc.)
  Future<Map<String, dynamic>?> getNodeSettingsSchema(String nodeId) async {
    final type = _nodeTypes[nodeId];
    if (type == null) return null;

    // Deep-copy so we don't mutate the prototype's schema
    final schema = _deepCopyJson(type.settingsSchema);
    _hideParentSatisfiedFields(schema, nodeId);
    _resolveNodePickers(schema, nodeId);

    // Resolve system-level pickers (async — needs I/O)
    final interfaces = await _getNetworkInterfaces();
    _resolveInterfacePickers(schema, interfaces);
    await _refreshSerialPorts();
    _resolveSerialPortPickers(schema);

    // Hide fields based on parent node's settings
    _hideByParentSetting(schema, nodeId);

    _injectValidationWarnings(schema, nodeId);
    return schema;
  }

  /// Cache of network interface names.
  static List<String>? _cachedInterfaces;
  static DateTime? _interfacesCacheTime;

  /// Get network interface names, cached for 30s.
  static Future<List<String>> _getNetworkInterfaces() async {
    final now = DateTime.now();
    if (_cachedInterfaces != null &&
        _interfacesCacheTime != null &&
        now.difference(_interfacesCacheTime!) < const Duration(seconds: 30)) {
      return _cachedInterfaces!;
    }
    try {
      final ifaces = await NetworkInterface.list();
      _cachedInterfaces = ifaces.map((i) => i.name).toList();
      _interfacesCacheTime = now;
      return _cachedInterfaces!;
    } catch (_) {
      return _cachedInterfaces ?? [];
    }
  }

  /// Cache of serial ports.
  static List<SerialPortInfo>? _cachedSerialPorts;
  static DateTime? _serialPortsCacheTime;

  /// Refresh the serial port cache. Called on schema resolution.
  Future<void> _refreshSerialPorts() async {
    final now = DateTime.now();
    if (_cachedSerialPorts != null &&
        _serialPortsCacheTime != null &&
        now.difference(_serialPortsCacheTime!) < const Duration(seconds: 5)) {
      return;
    }
    try {
      final scanner = SerialScanner();
      _cachedSerialPorts = await scanner.listPorts();
      _serialPortsCacheTime = now;
    } catch (_) {
      _cachedSerialPorts ??= [];
    }
  }

  /// Walk the schema and resolve any `x-widget: node-picker` fields
  /// into regular enum dropdowns populated from live node data.
  ///
  /// Handles two shapes:
  ///   - `type: string` + node-picker → single-select enum dropdown
  ///   - `type: array` + node-picker → multi-select (enum on items)
  void _resolveNodePickers(Map<String, dynamic> schema, String excludeNodeId) {
    final props = schema['properties'] as Map<String, dynamic>?;
    if (props == null) return;

    for (final entry in props.entries) {
      final prop = entry.value;
      if (prop is! Map<String, dynamic>) continue;

      if (prop['x-widget'] == 'node-picker') {
        final filterType = prop['x-node-type'] as String?;
        final isArray = prop['type'] == 'array';

        // Find matching nodes in the current flow
        final matching = _nodeTypes.entries.where((e) {
          if (e.key == excludeNodeId) return false;
          if (filterType == null) return true;
          return e.value.typeName == filterType;
        });

        final enumValues = <String>[];
        final enumLabels = <String>[];

        for (final e in matching) {
          enumValues.add(e.key);
          final settings = _nodeSettings[e.key] ?? {};
          final label = e.value.displayLabel(e.key, settings);
          enumLabels.add('$label (${e.value.typeName})');
        }

        prop.remove('x-widget');
        prop.remove('x-node-type');

        if (isArray) {
          // Multi-select: put enum on items, UI renders as checkbox list
          prop['items'] = {
            'type': 'string',
            'enum': enumValues,
            'x-enum-labels': enumLabels,
          };
        } else {
          // Single-select: regular enum dropdown
          prop['enum'] = enumValues;
          prop['x-enum-labels'] = enumLabels;
        }

        if (enumValues.isEmpty) {
          prop['description'] =
              'No ${filterType ?? "nodes"} available — create one first';
        }
      }
    }

    // Also resolve inside allOf/if/then blocks
    final allOf = schema['allOf'] as List<dynamic>?;
    if (allOf != null) {
      for (final rule in allOf) {
        if (rule is Map<String, dynamic>) {
          final thenBlock = rule['then'] as Map<String, dynamic>?;
          if (thenBlock != null) _resolveNodePickers(thenBlock, excludeNodeId);
        }
      }
    }
  }

  /// Resolve `x-widget: interface-picker` fields into enum dropdowns
  /// populated from the system's network interfaces.
  void _resolveInterfacePickers(
      Map<String, dynamic> schema, List<String> interfaces) {
    final props = schema['properties'] as Map<String, dynamic>?;
    if (props != null) {
      for (final entry in props.entries) {
        final prop = entry.value;
        if (prop is! Map<String, dynamic>) continue;
        if (prop['x-widget'] != 'interface-picker') continue;

        prop.remove('x-widget');
        final enumValues = ['', ...interfaces];
        final enumLabels = ['(default)', ...interfaces];
        prop['enum'] = enumValues;
        prop['x-enum-labels'] = enumLabels;
      }
    }

    // Also resolve inside allOf/then blocks
    final allOf = schema['allOf'] as List<dynamic>?;
    if (allOf != null) {
      for (final rule in allOf) {
        if (rule is Map<String, dynamic>) {
          final thenBlock = rule['then'] as Map<String, dynamic>?;
          if (thenBlock != null) _resolveInterfacePickers(thenBlock, interfaces);
        }
      }
    }
  }

  /// Resolve `x-widget: serial-port-picker` fields into enum dropdowns
  /// populated from discovered serial ports.
  void _resolveSerialPortPickers(Map<String, dynamic> schema) {
    final props = schema['properties'] as Map<String, dynamic>?;
    if (props != null) {
      for (final entry in props.entries) {
        final prop = entry.value;
        if (prop is! Map<String, dynamic>) continue;
        if (prop['x-widget'] != 'serial-port-picker') continue;

        prop.remove('x-widget');
        final ports = _cachedSerialPorts ?? [];
        final enumValues = ['', ...ports.map((p) => p.portName)];
        final enumLabels = ['(none)', ...ports.map((p) => p.displayName)];
        prop['enum'] = enumValues;
        prop['x-enum-labels'] = enumLabels;
        if (ports.isEmpty) {
          prop['description'] = 'No serial ports found — plug in a USB serial device';
        }
      }
    }

    // Also resolve inside allOf/then blocks
    final allOf = schema['allOf'] as List<dynamic>?;
    if (allOf != null) {
      for (final rule in allOf) {
        if (rule is Map<String, dynamic>) {
          final thenBlock = rule['then'] as Map<String, dynamic>?;
          if (thenBlock != null) _resolveSerialPortPickers(thenBlock);
        }
      }
    }
  }

  /// Remove fields whose `x-hide-if-parent-setting` matches the parent's
  /// current setting value. E.g. hide host/port on modbus.device when
  /// the parent modbus.driver has transport=rtu.
  void _hideByParentSetting(Map<String, dynamic> schema, String nodeId) {
    final parentId = _nodeParents[nodeId];
    if (parentId == null) return;

    final parentSettings = _nodeSettings[parentId] ?? {};
    final props = schema['properties'] as Map<String, dynamic>?;
    if (props == null) return;

    final keysToRemove = <String>[];
    for (final entry in props.entries) {
      final prop = entry.value;
      if (prop is! Map<String, dynamic>) continue;
      final rule = prop['x-hide-if-parent-setting'];
      if (rule is! Map<String, dynamic>) continue;

      final settingKey = rule['key'] as String?;
      final settingValue = rule['value'];
      if (settingKey != null && parentSettings[settingKey] == settingValue) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      props.remove(key);
      final required = schema['required'];
      if (required is List) {
        required.remove(key);
      }
    }
  }

  /// Remove fields that are satisfied by parent containment.
  /// e.g. `brokerNodeId` on mqtt.subscribe is hidden when the node
  /// lives inside an mqtt.broker (parentId is set).
  void _hideParentSatisfiedFields(
      Map<String, dynamic> schema, String nodeId) {
    final parentId = _nodeParents[nodeId];
    if (parentId == null) return; // root node, nothing to hide

    final parentType = _nodeTypes[parentId]?.typeName;
    if (parentType == null) return;

    final props = schema['properties'] as Map<String, dynamic>?;
    if (props == null) return;

    final keysToRemove = <String>[];
    for (final entry in props.entries) {
      final prop = entry.value;
      if (prop is! Map<String, dynamic>) continue;
      if (prop['x-hide-if-parent'] == parentType) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      props.remove(key);
      // Also remove from required list
      final required = schema['required'];
      if (required is List) {
        required.remove(key);
      }
    }
  }

  /// Inject `x-warnings` into the schema with validation messages about
  /// the current settings (duplicate order on same page, no page selected).
  void _injectValidationWarnings(
      Map<String, dynamic> schema, String nodeId) {
    final type = _nodeTypes[nodeId];
    if (type == null) return;
    final typeName = type.typeName;

    // Only validate widget nodes
    if (typeName != 'ui.source' && typeName != 'ui.display') return;

    final settings = _nodeSettings[nodeId] ?? {};
    final warnings = <String>[];

    // Check: no pages selected
    final pages = settings['pages'];
    if (pages == null || (pages is List && pages.isEmpty)) {
      warnings.add('No pages selected — widget won\'t appear on dashboard');
    }

    // Check: duplicate order on same page
    if (pages is List && pages.isNotEmpty) {
      final myOrder = settings['order'] as int? ?? 0;

      for (final pageId in pages) {
        final conflicts = <String>[];
        for (final other in _nodeTypes.entries) {
          if (other.key == nodeId) continue;
          final otherType = other.value.typeName;
          if (otherType != 'ui.source' && otherType != 'ui.display') continue;

          final otherSettings = _nodeSettings[other.key] ?? {};
          final otherPages = otherSettings['pages'];
          if (otherPages is! List || !otherPages.contains(pageId)) continue;

          final otherOrder = otherSettings['order'] as int? ?? 0;
          if (otherOrder == myOrder) {
            final otherLabel =
                otherSettings['label'] as String? ?? other.key.substring(0, 8);
            conflicts.add(otherLabel);
          }
        }

        if (conflicts.isNotEmpty) {
          final pageType = _nodeTypes[pageId];
          final pageName = pageType != null
              ? pageType.displayLabel(pageId as String, _nodeSettings[pageId] ?? {})
              : 'page';
          warnings.add(
              'Order $myOrder conflicts with ${conflicts.join(", ")} on "$pageName"');
        }
      }
    }

    if (warnings.isNotEmpty) {
      schema['x-warnings'] = warnings;
    }
  }

  /// Deep copy a JSON-like structure so mutations don't affect the original.
  static Map<String, dynamic> _deepCopyJson(Map<String, dynamic> source) {
    return source.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, _deepCopyJson(value));
      } else if (value is List) {
        return MapEntry(key, _deepCopyList(value));
      }
      return MapEntry(key, value);
    });
  }

  static List<dynamic> _deepCopyList(List<dynamic> source) {
    return source.map((item) {
      if (item is Map<String, dynamic>) return _deepCopyJson(item);
      if (item is List) return _deepCopyList(item);
      return item;
    }).toList();
  }

  /// Get the node palette — all available node types with ports + schema.
  List<Map<String, dynamic>> getPalette() => _registry.getPalette();

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Get latest N history samples for a node.
  Future<List<Map<String, dynamic>>> getHistory(String nodeId,
      {int limit = 100}) async {
    final rows = await _dao.getHistory(nodeId, limit: limit);
    return rows
        .map((r) => {
              'id': r.id,
              'nodeId': r.nodeId,
              'numValue': r.numValue,
              'boolValue': r.boolValue,
              'strValue': r.strValue,
              'timestamp': r.timestamp.toIso8601String(),
            })
        .toList();
  }

  /// Delete all history for a node.
  Future<void> deleteHistory(String nodeId) async {
    await _dao.deleteHistoryForNode(nodeId);
  }

  // ---------------------------------------------------------------------------
  // Node CRUD
  // ---------------------------------------------------------------------------

  /// Create a new node in the flow. Returns the new node ID.
  ///
  /// Hot-insert: adds the node to the live graph without rebuilding.
  /// Existing sources, subscriptions, and timers continue uninterrupted.
  Future<String> createNode({
    required String type,
    Map<String, dynamic> settings = const {},
    String? label,
    String? parentId,
    double posX = 0.0,
    double posY = 0.0,
  }) async {
    final nodeType = _registry.create(type);
    if (nodeType == null) throw ArgumentError('Unknown node type: $type');

    // Validate parent exists if specified
    if (parentId != null) {
      if (!_nodeTypes.containsKey(parentId)) {
        throw ArgumentError('Parent node not found: $parentId');
      }
    }

    final id = _uuid.v4();
    final now = DateTime.now();

    // Persist to database
    await _dao.upsertNode(RuntimeNodesCompanion(
      id: drift.Value(id),
      flowId: drift.Value(_flowId!),
      type: drift.Value(type),
      category: drift.Value(nodeType.category),
      settings: drift.Value(settings),
      label: drift.Value(label),
      parentId: drift.Value(parentId),
      posX: drift.Value(posX),
      posY: drift.Value(posY),
      createdAt: drift.Value(now),
    ));

    // --- Hot-insert into the live graph (no rebuild) ---

    // 1. Register in all in-memory maps
    _nodeTypes[id] = nodeType;
    _nodeSettings[id] = settings;
    _nodeCategories[id] = nodeType.category;
    _nodeStatuses[id] = NodeStatus.stale;
    _nodePositions[id] = (x: posX, y: posY);
    _nodeLabels[id] = label;
    _nodeParents[id] = parentId;
    _nodeChildren[id] = [];

    // Add as child of parent
    if (parentId != null && _nodeChildren.containsKey(parentId)) {
      _nodeChildren[parentId]!.add(id);
    }

    // 2. Initialize edge maps (no edges yet, but maps must exist)
    _adjacency[id] = [];
    _inputMap[id] = {};

    // 3. Re-sort (new node slots into topo order)
    _topoOrder = GraphSolver.topologicalSort(
      nodeIds: _nodeTypes.keys.toList(),
      adjacency: _adjacency,
    );

    // 4. Inject dependencies (DAO, manager defaults)
    _injectSingleNodeDependencies(nodeType);

    // 5. Start the node if it's a source or an initializable sink
    if (nodeType is SourceNode) {
      await nodeType.start(
        id,
        settings,
        (outputs) => _onSourceOutput(id, outputs),
        parentId: parentId,
      );
    } else if (nodeType is SinkNode &&
        (nodeType is HistoryLogNode || nodeType is HistoryDisplayNode)) {
      await nodeType.start(id, settings, (_) {});
    }

    return id;
  }

  /// Update a node's settings. Merges with existing settings.
  Future<void> updateNodeSettings(
      String nodeId, Map<String, dynamic> patch) async {
    if (!_nodeTypes.containsKey(nodeId)) {
      throw ArgumentError('Node not found: $nodeId');
    }

    final current = Map<String, dynamic>.from(_nodeSettings[nodeId] ?? {});
    current.addAll(patch);

    // Persist to Drift
    await _dao.updateNode(
      nodeId,
      RuntimeNodesCompanion(settings: drift.Value(current)),
    );

    // Update in-memory
    _nodeSettings[nodeId] = current;

    // Auto-sync folder portal nodes when ports change
    final type = _nodeTypes[nodeId];
    if (type is SystemFolderNode) {
      await _syncFolderPortals(nodeId, current);
    }

    // Re-evaluate after settings change
    if (type is SourceNode) {
      // Source: restart to re-emit with new settings
      await type.stop(nodeId);
      await type.start(
          nodeId, current, (outputs) => _onSourceOutput(nodeId, outputs),
          parentId: _nodeParents[nodeId]);
    } else {
      // Transform/sink: mark dirty so it re-evaluates with new settings
      _dirtyNodes.add(nodeId);
      await _evaluate();
    }
  }

  /// Sync portal nodes inside a folder to match the folder's port definitions.
  ///
  /// Creates missing `folder.input` / `folder.output` nodes.
  /// Removes portal nodes whose portName no longer exists in the folder ports.
  Future<void> _syncFolderPortals(
    String folderId,
    Map<String, dynamic> settings,
  ) async {
    final rawPorts = settings['ports'];
    if (rawPorts is! List) return;

    // Build set of expected portals: (direction, name)
    final expected = <(String, String)>{};
    for (final item in rawPorts) {
      if (item is! Map) continue;
      final name = item['name'] as String?;
      final dir = item['direction'] as String?;
      if (name != null && name.isNotEmpty && dir != null) {
        expected.add((dir, name));
      }
    }

    // Find existing portal children
    final childIds = _nodeChildren[folderId] ?? [];
    final existing = <(String, String), String>{}; // (dir, name) → nodeId
    final toRemove = <String>[];

    for (final childId in childIds) {
      final childType = _nodeTypes[childId];
      if (childType == null) continue;
      final childSettings = _nodeSettings[childId] ?? {};
      final portName = childSettings['portName'] as String? ?? '';

      String? dir;
      if (childType.typeName == 'folder.input') dir = 'input';
      if (childType.typeName == 'folder.output') dir = 'output';
      if (dir == null) continue; // not a portal node

      final key = (dir, portName);
      if (expected.contains(key)) {
        existing[key] = childId;
      } else {
        // Portal no longer matches any folder port — remove it
        toRemove.add(childId);
      }
    }

    // Remove stale portals
    for (final id in toRemove) {
      await deleteNode(id);
    }

    // Create missing portals
    for (final (dir, name) in expected) {
      if (existing.containsKey((dir, name))) continue;

      final portalType = dir == 'input' ? 'folder.input' : 'folder.output';
      await createNode(
        type: portalType,
        settings: {'portName': name},
        label: '${dir == 'input' ? 'IN' : 'OUT'}: $name',
        parentId: folderId,
      );
    }
  }

  /// Update a node's metadata (label, etc). Does NOT touch settings.
  Future<void> updateNode(String nodeId, {String? label}) async {
    if (!_nodeTypes.containsKey(nodeId)) {
      throw ArgumentError('Node not found: $nodeId');
    }
    _nodeLabels[nodeId] = label;
    await _dao.updateNode(
      nodeId,
      RuntimeNodesCompanion(label: drift.Value(label)),
    );
  }

  /// Update a node's canvas position.
  Future<void> updateNodePosition(
      String nodeId, double posX, double posY) async {
    if (!_nodeTypes.containsKey(nodeId)) {
      throw ArgumentError('Node not found: $nodeId');
    }
    _nodePositions[nodeId] = (x: posX, y: posY);
    await _dao.updateNode(
      nodeId,
      RuntimeNodesCompanion(
        posX: drift.Value(posX),
        posY: drift.Value(posY),
      ),
    );
  }

  /// Remove a node, its children, and connected edges.
  ///
  /// Hot-remove: patches the live graph without rebuilding.
  /// Only the deleted node (and its subtree) are stopped — all other
  /// sources, subscriptions, and timers continue uninterrupted.
  Future<void> deleteNode(String nodeId) async {
    // 1. Collect the full subtree (node + all descendants, depth-first)
    final subtree = <String>[];
    void collectSubtree(String nid) {
      for (final childId in _nodeChildren[nid] ?? <String>[]) {
        collectSubtree(childId);
      }
      subtree.add(nid);
    }
    collectSubtree(nodeId);

    // 2. Stop all nodes in the subtree (children before parents)
    for (final nid in subtree) {
      final type = _nodeTypes[nid];
      if (type != null) await type.stop(nid);
    }

    // 3. Find downstream nodes that will lose an input (need re-evaluation)
    final affectedDownstream = <String>{};
    for (final nid in subtree) {
      for (final targetId in _adjacency[nid] ?? <String>[]) {
        if (!subtree.contains(targetId)) {
          affectedDownstream.add(targetId);
        }
      }
    }

    // 4. Remove edges from adjacency, inputMap, and hiddenEdges
    for (final nid in subtree) {
      // Remove outgoing edges from adjacency
      _adjacency.remove(nid);

      // Remove incoming edges from inputMap
      _inputMap.remove(nid);

      // Remove this node from other nodes' adjacency lists
      for (final adj in _adjacency.values) {
        adj.remove(nid);
      }

      // Remove references to this node from other nodes' inputMaps
      for (final inputs in _inputMap.values) {
        inputs.removeWhere((_, source) => source.nodeId == nid);
      }

      // Remove any hidden edge keys mentioning this node
      _hiddenEdges.removeWhere((key) => key.contains(nid));
    }

    // 5. Detach from parent's children list (before we clear maps)
    final parentId = _nodeParents[nodeId];
    if (parentId != null && _nodeChildren.containsKey(parentId)) {
      _nodeChildren[parentId]!.remove(nodeId);
    }

    // 6. Remove from all in-memory maps
    for (final nid in subtree) {
      _nodeTypes.remove(nid);
      _nodeSettings.remove(nid);
      _nodeCategories.remove(nid);
      _nodeValues.remove(nid);
      _nodeStatuses.remove(nid);
      _nodePositions.remove(nid);
      _nodeLabels.remove(nid);
      _nodeParents.remove(nid);
      _nodeChildren.remove(nid);
    }

    // 7. Re-sort the remaining graph
    if (_nodeTypes.isNotEmpty) {
      _topoOrder = GraphSolver.topologicalSort(
        nodeIds: _nodeTypes.keys.toList(),
        adjacency: _adjacency,
      );
    } else {
      _topoOrder = [];
    }

    // 8. Persist deletion (DAO cascade-deletes children, edges, history)
    await _dao.removeNode(nodeId);

    // 9. Mark affected downstream nodes dirty and re-evaluate
    if (affectedDownstream.isNotEmpty) {
      _dirtyNodes.addAll(affectedDownstream);
      await _evaluate();
    }
  }

  // ---------------------------------------------------------------------------
  // Node read
  // ---------------------------------------------------------------------------

  /// Get a single node as a JSON map.
  /// Returns the actual ports for this instance (respects variadic settings).
  Map<String, dynamic>? getNode(String nodeId) {
    if (!_nodeTypes.containsKey(nodeId)) return null;
    final type = _nodeTypes[nodeId]!;
    final values = _nodeValues[nodeId] ?? {};
    final pos = _nodePositions[nodeId];
    final settings = _nodeSettings[nodeId] ?? {};
    return {
      'id': nodeId,
      'type': type.typeName,
      'category': type.category,
      'status': (_nodeStatuses[nodeId] ?? NodeStatus.stale).name,
      'value': values.length == 1 ? values.values.first : values,
      'settings': settings,
      'label': _nodeLabels[nodeId] ?? settings['label'],
      'parentId': _nodeParents[nodeId],
      'allowedChildTypes': type.allowedChildTypes,
      'children': _nodeChildren[nodeId] ?? [],
      'inputs': type.getInputPorts(settings).map((p) => p.toJson()).toList(),
      'outputs': type.getOutputPorts(settings).map((p) => p.toJson()).toList(),
      'linkCount': getLinkCount(nodeId),
      'posX': pos?.x ?? 0.0,
      'posY': pos?.y ?? 0.0,
    };
  }

  /// List all nodes in the flow.
  List<Map<String, dynamic>> getNodes() {
    return _nodeTypes.keys.map((id) => getNode(id)!).toList();
  }

  /// Get direct children of a node (flat list, one level).
  List<Map<String, dynamic>> getChildNodes(String nodeId) {
    final childIds = _nodeChildren[nodeId] ?? [];
    return childIds
        .map((id) => getNode(id))
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Get the full subtree of a node (recursive, includes nested children).
  List<Map<String, dynamic>> getNodeTree(String nodeId) {
    final childIds = _nodeChildren[nodeId] ?? [];
    return childIds.map((id) {
      final node = getNode(id);
      if (node == null) return null;
      final grandchildren = getNodeTree(id);
      if (grandchildren.isNotEmpty) {
        node['childNodes'] = grandchildren;
      }
      return node;
    }).whereType<Map<String, dynamic>>().toList();
  }

  // ---------------------------------------------------------------------------
  // Edge CRUD
  // ---------------------------------------------------------------------------

  /// Create an edge. Returns the new edge ID.
  ///
  /// Set [hidden] to `true` for portless links — these are cross-scope
  /// connections that exist in the runtime graph but are not drawn as
  /// wires on the canvas.  They appear in the Links panel instead.
  Future<String> createEdge({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
    bool hidden = false,
  }) async {
    // Validate nodes exist
    if (!_nodeTypes.containsKey(sourceNodeId)) {
      throw ArgumentError('Source node not found: $sourceNodeId');
    }
    if (!_nodeTypes.containsKey(targetNodeId)) {
      throw ArgumentError('Target node not found: $targetNodeId');
    }

    // Validate ports exist on the node types (use settings-aware getters
    // so variadic and folder nodes with dynamic ports pass validation)
    final sourceType = _nodeTypes[sourceNodeId]!;
    final targetType = _nodeTypes[targetNodeId]!;
    final sourceSettings = _nodeSettings[sourceNodeId] ?? {};
    final targetSettings = _nodeSettings[targetNodeId] ?? {};
    if (!sourceType.getOutputPorts(sourceSettings).any((p) => p.name == sourcePort)) {
      throw ArgumentError(
          'Output port "$sourcePort" not found on $sourceNodeId');
    }
    if (!targetType.getInputPorts(targetSettings).any((p) => p.name == targetPort)) {
      throw ArgumentError(
          'Input port "$targetPort" not found on $targetNodeId');
    }

    // Reject if input port already has a connection (one source per input)
    final existingSource = _inputMap[targetNodeId]?[targetPort];
    if (existingSource != null) {
      throw ArgumentError(
          'Input port "$targetPort" on $targetNodeId already connected '
          'to ${existingSource.nodeId}:${existingSource.port} — '
          'disconnect it first');
    }

    // Cycle check BEFORE persisting
    final testAdjacency = Map<String, List<String>>.from(
      _adjacency.map((k, v) => MapEntry(k, List<String>.from(v))),
    );
    testAdjacency[sourceNodeId] = [
      ...(testAdjacency[sourceNodeId] ?? []),
      targetNodeId,
    ];
    GraphSolver.topologicalSort(
      nodeIds: _nodeTypes.keys.toList(),
      adjacency: testAdjacency,
    ); // throws if cycle detected

    final id = _uuid.v4();
    await _dao.upsertEdge(RuntimeEdgesCompanion.insert(
      id: id,
      flowId: _flowId!,
      sourceNodeId: sourceNodeId,
      sourcePort: sourcePort,
      targetNodeId: targetNodeId,
      targetPort: targetPort,
      hidden: drift.Value(hidden),
      createdAt: DateTime.now(),
    ));

    // Incremental update — no full rebuild needed for edge changes
    _adjacency[sourceNodeId]!.add(targetNodeId);
    _inputMap[targetNodeId]![targetPort] = (
      nodeId: sourceNodeId,
      port: sourcePort,
    );
    if (hidden) {
      _hiddenEdges.add('$sourceNodeId:$sourcePort->$targetNodeId:$targetPort');
    }
    _topoOrder = GraphSolver.topologicalSort(
      nodeIds: _nodeTypes.keys.toList(),
      adjacency: _adjacency,
    );

    // Always re-evaluate: the target now has a new input
    _dirtyNodes.add(targetNodeId);
    await _evaluate();

    return id;
  }

  /// Remove an edge.
  Future<void> deleteEdge(String edgeId) async {
    final edge = await _dao.getEdgeById(edgeId);
    await _dao.removeEdge(edgeId);

    if (edge != null) {
      // Incremental update — remove from adjacency and input map
      _adjacency[edge.sourceNodeId]?.remove(edge.targetNodeId);
      _inputMap[edge.targetNodeId]?.remove(edge.targetPort);
      _hiddenEdges.remove(
          '${edge.sourceNodeId}:${edge.sourcePort}->${edge.targetNodeId}:${edge.targetPort}');
      _topoOrder = GraphSolver.topologicalSort(
        nodeIds: _nodeTypes.keys.toList(),
        adjacency: _adjacency,
      );

      // Re-evaluate: target lost an input, may go stale
      _dirtyNodes.add(edge.targetNodeId);
      await _evaluate();
    }
  }

  // ---------------------------------------------------------------------------
  // Edge read
  // ---------------------------------------------------------------------------

  /// Get a single edge as a JSON map.
  Future<Map<String, dynamic>?> getEdge(String edgeId) async {
    final edge = await _dao.getEdgeById(edgeId);
    if (edge == null) return null;
    return {
      'id': edge.id,
      'sourceNodeId': edge.sourceNodeId,
      'sourcePort': edge.sourcePort,
      'targetNodeId': edge.targetNodeId,
      'targetPort': edge.targetPort,
      'hidden': edge.hidden,
    };
  }

  /// List all edges in the flow.
  Future<List<Map<String, dynamic>>> getEdges() async {
    final edges = await _dao.getEdgesByFlow(_flowId!);
    return edges
        .map((e) => {
              'id': e.id,
              'sourceNodeId': e.sourceNodeId,
              'sourcePort': e.sourcePort,
              'targetNodeId': e.targetNodeId,
              'targetPort': e.targetPort,
              'hidden': e.hidden,
            })
        .toList();
  }

  /// Get all hidden (portless) links in the flow, enriched with node
  /// labels and paths for the Links panel UI.
  Future<List<Map<String, dynamic>>> getLinks() async {
    final edges = await _dao.getEdgesByFlow(_flowId!);
    return edges
        .where((e) => e.hidden)
        .map((e) {
          final srcType = _nodeTypes[e.sourceNodeId];
          final tgtType = _nodeTypes[e.targetNodeId];
          final srcSettings = _nodeSettings[e.sourceNodeId] ?? {};
          final tgtSettings = _nodeSettings[e.targetNodeId] ?? {};
          return {
            'id': e.id,
            'sourceNodeId': e.sourceNodeId,
            'sourcePort': e.sourcePort,
            'sourceLabel': srcType?.displayLabel(e.sourceNodeId, srcSettings) ?? e.sourceNodeId,
            'sourcePath': _buildNodePath(e.sourceNodeId),
            'targetNodeId': e.targetNodeId,
            'targetPort': e.targetPort,
            'targetLabel': tgtType?.displayLabel(e.targetNodeId, tgtSettings) ?? e.targetNodeId,
            'targetPath': _buildNodePath(e.targetNodeId),
          };
        })
        .toList();
  }

  /// Build a human-readable path for a node (e.g. "BACnet Driver / Device 1 / Temperature").
  String _buildNodePath(String nodeId) {
    final segments = <String>[];
    String? current = nodeId;
    while (current != null) {
      final type = _nodeTypes[current];
      final settings = _nodeSettings[current] ?? {};
      segments.insert(0, type?.displayLabel(current, settings) ?? current.substring(0, 8));
      current = _nodeParents[current];
    }
    return segments.join(' / ');
  }

  /// Count hidden links attached to a node (as source or target).
  int getLinkCount(String nodeId) {
    int count = 0;
    // Count as source: check adjacency for hidden edges
    for (final targetId in _adjacency[nodeId] ?? <String>[]) {
      final inputs = _inputMap[targetId] ?? {};
      for (final entry in inputs.entries) {
        if (entry.value.nodeId == nodeId) {
          // Check DB... but we need a faster way. Use in-memory set.
          if (_hiddenEdges.contains('$nodeId:${entry.value.port}->$targetId:${entry.key}')) {
            count++;
          }
        }
      }
    }
    // Count as target
    final inputs = _inputMap[nodeId] ?? {};
    for (final entry in inputs.entries) {
      if (_hiddenEdges.contains('${entry.value.nodeId}:${entry.value.port}->$nodeId:${entry.key}')) {
        count++;
      }
    }
    return count;
  }
}
