import 'dart:async';

import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';

import 'package:dart_red/src/client/runtime_client.dart';
import '../nodes/prototypes/bms_nodes.dart';

/// Manages the sync between the fl_nodes canvas and the runtime REST API.
///
/// Owns the ID mappings (fl_nodes <-> runtime), live-value polling, and
/// translates editor events into REST calls.
class FlowSyncManager {
  final RuntimeApiClient api;
  final FlNodeEditorController controller;

  /// fl_nodes node ID -> runtime node ID.
  final Map<String, String> nodeIdMap = {};

  /// fl_nodes link ID -> runtime edge ID.
  final Map<String, String> linkIdMap = {};

  /// Live values polled from the runtime: runtime node ID -> value.
  final Map<String, dynamic> liveValues = {};

  /// Live statuses: runtime node ID -> status string.
  final Map<String, String> liveStatuses = {};

  /// Which child types each node allows (for showing "Open" in context menu).
  final Map<String, List<String>> liveAllowedChildTypes = {};

  /// Link (hidden edge) counts per runtime node ID — polled alongside values.
  final Map<String, int> liveLinkCounts = {};

  /// Cached link details from GET /api/v1/links — refreshed on each poll.
  /// Used by the badge popup and input port value overlays.
  List<Map<String, dynamic>> liveLinks = [];

  /// Palette entries — cached for icon lookups when creating per-instance protos.
  List<PaletteEntry> _palette = [];

  /// True while loading nodes/edges from the runtime — suppresses event
  /// handlers so we don't POST duplicates back.
  bool syncing = false;

  /// Current scope — null = root level, otherwise the parent node ID.
  /// Nodes created on this canvas get this as their parentId.
  String? scopeParentId;

  Timer? pollTimer;
  Duration pollInterval;
  bool pollPaused = false;

  /// Debounce timer for saving node positions after drag.
  Timer? _positionSaveTimer;

  /// Called when a REST call fails.
  final void Function(String message) onError;

  /// Called after poll completes so the screen can rebuild.
  final VoidCallback? onPollComplete;

  FlowSyncManager({
    required this.api,
    required this.controller,
    required this.onError,
    this.onPollComplete,
    this.pollInterval = const Duration(seconds: 2),
  });

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Connect, fetch palette, load flow, start polling.
  ///
  /// Returns `(connected, palette, errorMessage)`.
  Future<({bool connected, List<PaletteEntry> palette, String? error})>
      connect() async {
    // Clear previous state
    pollTimer?.cancel();
    pollTimer = null;
    syncing = true;
    liveValues.clear();
    liveStatuses.clear();
    liveAllowedChildTypes.clear();
    liveLinkCounts.clear();

    // Remove existing canvas nodes/links so reload doesn't duplicate
    for (final flId in nodeIdMap.keys.toList()) {
      controller.removeNodeById(flId);
    }
    nodeIdMap.clear();
    linkIdMap.clear();
    syncing = false;

    final alive = await api.isAlive();
    if (!alive) {
      return (
        connected: false,
        palette: <PaletteEntry>[],
        error:
            'Runtime daemon not reachable on localhost:8080.\n'
            'Start it with: dart run bin/runtime_server.dart --port 8080',
      );
    }

    // 1. Fetch palette -> register prototypes dynamically
    final palette = await api.palette.getAll();
    _palette = palette;
    registerFromPalette(controller, palette);

    // 2. Load existing flow
    await _loadFlowFromRuntime();

    // 3. Start polling
    _startPolling();

    return (connected: true, palette: palette, error: null);
  }

  /// Reload the canvas at the current scope (e.g. after navigating into/out of
  /// a container node). Doesn't reconnect or re-fetch palette.
  Future<void> reload() async {
    syncing = true;
    liveValues.clear();
    liveStatuses.clear();
    liveAllowedChildTypes.clear();
    liveLinkCounts.clear();

    for (final flId in nodeIdMap.keys.toList()) {
      controller.removeNodeById(flId);
    }
    nodeIdMap.clear();
    linkIdMap.clear();
    syncing = false;

    await _loadFlowFromRuntime();
  }

  // ---------------------------------------------------------------------------
  // Load existing graph from runtime
  // ---------------------------------------------------------------------------

  Future<void> _loadFlowFromRuntime() async {
    syncing = true;
    try {
      final flowData = await api.flow.get();

      final nodes = flowData['nodes'] as List<dynamic>? ?? [];
      final edges = flowData['edges'] as List<dynamic>? ?? [];

      // Only show nodes at the current scope level
      for (final n in nodes) {
        final nodeMap = n as Map<String, dynamic>;
        final type = nodeMap['type'] as String;
        final runtimeId = nodeMap['id'] as String;
        final parentId = nodeMap['parentId'] as String?;
        final posX = (nodeMap['posX'] as num?)?.toDouble() ?? 0.0;
        final posY = (nodeMap['posY'] as num?)?.toDouble() ?? 0.0;
        final label = nodeMap['label'] as String?;

        // Filter: only nodes whose parent matches current scope
        if (parentId != scopeParentId) continue;

        if (!controller.nodePrototypes.containsKey(type)) continue;

        // Check if this instance needs a custom prototype
        // (variadic ports or user-set label)
        final instanceInputs = nodeMap['inputs'] as List<dynamic>?;
        final instanceOutputs = nodeMap['outputs'] as List<dynamic>?;
        var protoId = type;
        final hasLabel = label != null && label.isNotEmpty;

        // Determine port names
        final inputNames = instanceInputs
                ?.map((p) => (p as Map<String, dynamic>)['name'] as String)
                .toList() ??
            [];
        final outputNames = instanceOutputs
                ?.map((p) => (p as Map<String, dynamic>)['name'] as String)
                .toList() ??
            [];

        // Check if ports differ from palette default
        final defaultProto = controller.nodePrototypes[type]!;
        final defaultPortCount = defaultProto.ports.length;
        final instancePortCount = inputNames.length + outputNames.length;
        final hasCustomPorts = (instanceInputs != null || instanceOutputs != null) &&
            instancePortCount != defaultPortCount;

        if (hasCustomPorts || hasLabel) {
          // Register a unique prototype for this instance.
          // Unregister first — fl_nodes uses putIfAbsent, so stale
          // prototypes from a previous load would block updates.
          protoId = '$type#$runtimeId';
          if (controller.nodePrototypes.containsKey(protoId)) {
            controller.unregisterNodePrototype(protoId);
          }
          final domain = type.split('.').first;
          // Look up icon from palette entries
          final paletteIcon = _findPaletteIcon(type);
          final instanceProto = buildInstancePrototype(
            type: type,
            domain: domain,
            inputs: hasCustomPorts ? inputNames : _defaultPortNames(defaultProto, true),
            outputs: hasCustomPorts ? outputNames : _defaultPortNames(defaultProto, false),
            instanceId: runtimeId,
            iconName: paletteIcon,
            label: label,
          );
          controller.registerNodePrototype(instanceProto);
        }

        final flNode = controller.addNode(protoId, offset: Offset(posX, posY));
        nodeIdMap[flNode.id] = runtimeId;

        // Track which nodes support children
        final allowed = nodeMap['allowedChildTypes'];
        if (allowed is List && allowed.isNotEmpty) {
          liveAllowedChildTypes[runtimeId] =
              allowed.map((e) => e.toString()).toList();
        }
      }

      // Reverse map: runtime ID -> fl_nodes ID
      final reverseNodeMap = <String, String>{};
      nodeIdMap.forEach((flId, rtId) => reverseNodeMap[rtId] = flId);

      for (final e in edges) {
        final edgeMap = e as Map<String, dynamic>;
        final runtimeEdgeId = edgeMap['id'] as String;
        final srcRtId = edgeMap['sourceNodeId'] as String;
        final srcPort = edgeMap['sourcePort'] as String;
        final tgtRtId = edgeMap['targetNodeId'] as String;
        final tgtPort = edgeMap['targetPort'] as String;
        final isHidden = edgeMap['hidden'] as bool? ?? false;

        // Skip hidden (portless link) edges — they don't draw wires
        if (isHidden) continue;

        final srcFlId = reverseNodeMap[srcRtId];
        final tgtFlId = reverseNodeMap[tgtRtId];
        if (srcFlId == null || tgtFlId == null) continue;

        // fl_nodes FromTo field mapping is misleading:
        //   from = source node ID, to = source port name,
        //   fromPort = target node ID, toPort = target port name
        final link = FlLinkDataModel(
          id: runtimeEdgeId,
          fromTo: (
            from: srcFlId,
            to: srcPort,
            fromPort: tgtFlId,
            toPort: tgtPort,
          ),
          state: FlLinkState(),
        );
        controller.addLinkFromExisting(link);
        linkIdMap[runtimeEdgeId] = runtimeEdgeId;
      }
    } finally {
      syncing = false;
    }
  }

  // ---------------------------------------------------------------------------
  // fl_nodes events -> REST calls
  // ---------------------------------------------------------------------------

  Future<void> onNodeAdded(FlAddNodeEvent event) async {
    final node = event.node;
    if (syncing || nodeIdMap.containsKey(node.id)) return;

    try {
      final runtimeId = await api.nodes.create(
        type: node.prototype.idName,
        parentId: scopeParentId,
        posX: node.offset.dx,
        posY: node.offset.dy,
      );
      nodeIdMap[node.id] = runtimeId;
    } catch (e) {
      onError('Failed to create node: $e');
    }
  }

  /// Called on every drag delta — debounces and saves positions after drag stops.
  void onNodesDragged(Set<String> flNodeIds) {
    _positionSaveTimer?.cancel();
    _positionSaveTimer = Timer(const Duration(milliseconds: 500), () {
      _saveNodePositions(flNodeIds);
    });
  }

  Future<void> _saveNodePositions(Set<String> flNodeIds) async {
    for (final flId in flNodeIds) {
      final runtimeId = nodeIdMap[flId];
      if (runtimeId == null) continue;
      final node = controller.project.projectData.nodes[flId];
      if (node == null) continue;

      try {
        await api.nodes.updatePosition(
          runtimeId,
          node.offset.dx,
          node.offset.dy,
        );
      } catch (e) {
        onError('Failed to save position: $e');
      }
    }
  }

  Future<void> onNodeRemoved(FlRemoveNodeEvent event) async {
    final runtimeId = nodeIdMap.remove(event.node.id);
    if (runtimeId == null) return;

    try {
      await api.nodes.delete(runtimeId);
    } catch (e) {
      onError('Failed to delete node: $e');
    }
  }

  Future<void> onLinkAdded(FlAddLinkEvent event) async {
    final link = event.link;
    if (syncing || linkIdMap.containsKey(link.id)) return;

    // fl_nodes FromTo: from=srcNode, to=srcPort, fromPort=tgtNode, toPort=tgtPort
    final srcRuntimeId = nodeIdMap[link.fromTo.from];
    final tgtRuntimeId = nodeIdMap[link.fromTo.fromPort];
    if (srcRuntimeId == null || tgtRuntimeId == null) return;

    try {
      final edgeId = await api.edges.create(
        sourceNodeId: srcRuntimeId,
        sourcePort: link.fromTo.to,
        targetNodeId: tgtRuntimeId,
        targetPort: link.fromTo.toPort,
      );
      linkIdMap[link.id] = edgeId;
    } catch (e) {
      onError('Failed to create edge: $e');
    }
  }

  Future<void> onLinkRemoved(FlRemoveLinkEvent event) async {
    final runtimeEdgeId = linkIdMap.remove(event.link.id);
    if (runtimeEdgeId == null) return;

    try {
      await api.edges.delete(runtimeEdgeId);
    } catch (e) {
      onError('Failed to delete edge: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Poll live values
  // ---------------------------------------------------------------------------

  void _startPolling() {
    pollTimer?.cancel();
    pollTimer = Timer.periodic(pollInterval, (_) {
      if (!pollPaused) pollValues();
    });
  }

  void setPollInterval(Duration interval) {
    pollInterval = interval;
    _startPolling();
  }

  void togglePause() {
    pollPaused = !pollPaused;
  }

  Future<void> pollValues() async {
    try {
      final results = await Future.wait([
        api.nodes.list(),
        api.links.list(),
      ]);
      final nodes = results[0];
      final links = results[1];

      for (final node in nodes) {
        final id = node['id'] as String;
        liveValues[id] = node['value'];
        liveStatuses[id] = (node['status'] as String?) ?? 'stale';
        liveLinkCounts[id] = (node['linkCount'] as int?) ?? 0;
      }
      liveLinks = links;

      onPollComplete?.call();
    } catch (_) {
      // Runtime may be temporarily unreachable
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Find the icon name for a node type from the cached palette.
  String? _findPaletteIcon(String type) {
    for (final entry in _palette) {
      if (entry.type == type) return entry.icon;
    }
    return null;
  }

  /// Extract port names from a default prototype (for when ports haven't
  /// changed but we still need a custom proto for the label).
  static List<String> _defaultPortNames(FlNodePrototype proto, bool inputs) {
    return proto.ports
        .where((p) => inputs
            ? p is FlDataInputPortPrototype
            : p is FlDataOutputPortPrototype)
        .map((p) => p.idName)
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  void dispose() {
    pollTimer?.cancel();
    _positionSaveTimer?.cancel();
  }
}
