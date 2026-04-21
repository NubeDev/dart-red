import 'dart:async';
import 'dart:convert';

import 'package:fl_nodes/fl_nodes.dart';
import 'package:fl_nodes/src/widgets/context_menu.dart' as fl_ctx;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:rubix_ui/rubix_ui.dart';
import 'package:dart_red/src/client/runtime_client.dart';
import '../../../core/runtime/runtime_providers.dart';
import '../widgets/connection_badge.dart';
import '../widgets/link_count_badges.dart';
import '../widgets/links_panel.dart';
import '../widgets/live_values_panel.dart';
import '../widgets/node_palette.dart';
import '../widgets/node_settings_dialog.dart';
import '../widgets/wire_value_badges.dart';
import '../nodes/styles/editor_theme.dart';
import 'dashboard_tab.dart';
import '../sync/flow_sync_manager.dart';

/// Main flow editor screen — embedded inside rubix-app as a route.
///
/// On startup:
///   1. Connects to the runtime daemon
///   2. Fetches palette via GET /api/v1/palette -> registers fl_nodes prototypes
///   3. Loads existing flow via GET /api/v1/flow -> renders nodes + edges
///   4. Polls live values every 2s via GET /api/v1/nodes/:id/value
///
/// Every user action is a REST call:
///   - Click palette item -> POST /api/v1/nodes
///   - Connect ports -> POST /api/v1/edges
///   - Delete node -> DELETE /api/v1/nodes/:id
///   - Delete edge -> DELETE /api/v1/edges/:id
class FlowEditorScreen extends ConsumerStatefulWidget {
  const FlowEditorScreen({super.key});

  @override
  ConsumerState<FlowEditorScreen> createState() => _FlowEditorScreenState();
}

class _FlowEditorScreenState extends ConsumerState<FlowEditorScreen>
    with SingleTickerProviderStateMixin {
  late final FlNodeEditorController _controller;
  late final FlowSyncManager _sync;
  late final StreamSubscription _eventSub;
  late final TabController _tabController;
  final _dashboardKey = GlobalKey<DashboardTabState>();

  List<PaletteEntry> _palette = [];
  String? _selectedFlNodeId;

  /// Current scope — null = root, otherwise the runtime node ID we're "inside".
  String? _scopeNodeId;

  /// Breadcrumb: list of (runtimeId, label) pairs from root to current scope.
  final List<({String id, String label})> _breadcrumb = [];

  bool _connected = false;
  bool _loading = true;
  String? _error;
  bool _showLivePanel = false;
  bool _showLinksPanel = false;
  final _linksPanelKey = GlobalKey<LinksPanelState>();

  /// Link clipboard — stores pending "Link From" / "Link To" selections.
  /// Last 3 entries, newest first. Each entry is a node+port ready to connect.
  final List<_LinkClipEntry> _linkClipboard = [];

  /// Right-click state — used to bypass fl_nodes' context menus which render
  /// at wrong positions due to the ShellRoute's nested Navigator.
  Offset _lastSecondaryPos = Offset.zero;
  Set<String> _selectionBeforeClick = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_onTabChanged);
    _controller = FlNodeEditorController(
      style: rubixEditorStyleFor(editorIsDark),
      config: const FlNodeEditorConfig(
        autoBuildGraph: false,
        autoRunGraph: false,
      ),
    );
    final apiClient = ref.read(runtimeApiClientProvider);
    _sync = FlowSyncManager(
      api: apiClient,
      controller: _controller,
      onError: _showError,
      onPollComplete: () {
        if (mounted) setState(() {});
      },
    );
    _eventSub = _controller.eventBus.events.listen(_onEditorEvent);
    _init();
  }

  Future<void> _init() async {
    try {
      _selectedFlNodeId = null;

      final result = await _sync.connect();
      _connected = result.connected;
      _palette = result.palette;

      setState(() {
        _loading = false;
        _error = result.error;
      });
    } catch (e) {
      _sync.syncing = false;
      setState(() {
        _loading = false;
        _error = 'Failed to connect: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Tab switching
  // ---------------------------------------------------------------------------

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return; // wait for animation to settle
    if (_tabController.index == 0) {
      // Switched to Flow — reload canvas from runtime
      _sync.reload();
    } else {
      // Switched to Dashboard — refresh page data
      _dashboardKey.currentState?.refresh();
    }
  }

  // ---------------------------------------------------------------------------
  // Editor events
  // ---------------------------------------------------------------------------

  void _onEditorEvent(dynamic event) {
    if (event is FlAddNodeEvent) {
      _sync.onNodeAdded(event);
    } else if (event is FlRemoveNodeEvent) {
      _sync.onNodeRemoved(event);
    } else if (event is FlAddLinkEvent) {
      _sync.onLinkAdded(event);
    } else if (event is FlRemoveLinkEvent) {
      _sync.onLinkRemoved(event);
    } else if (event is FlDragSelectionEvent) {
      _sync.onNodesDragged(event.nodeIds);
    } else if (event is FlNodeSelectionEvent) {
      setState(() {
        _selectedFlNodeId =
            event.nodeIds.length == 1 ? event.nodeIds.first : null;
      });
    }
  }

  void _deleteSelection() {
    for (final nodeId in _controller.selectedNodeIds.toList()) {
      _controller.removeNodeById(nodeId);
    }
    for (final linkId in _controller.selectedLinkIds.toList()) {
      _controller.removeLinkById(linkId);
    }
    _controller.clearSelection();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Navigate to a node by its runtime ID — used by the Links panel.
  ///
  /// Switches scope to the node's parent so the node is visible on the canvas,
  /// then selects it.
  Future<void> _navigateToNode(String runtimeId) async {
    try {
      final nodeData = await _sync.api.nodes.get(runtimeId);
      final parentId = nodeData['parentId'] as String?;

      // Navigate to the node's parent scope
      _breadcrumb.clear();

      if (parentId != null) {
        // Build breadcrumb by walking up the parent chain
        final crumbs = <({String id, String label})>[];
        String? current = parentId;
        while (current != null) {
          final data = await _sync.api.nodes.get(current);
          final type = data['type'] as String? ?? '?';
          final label = data['label'] as String? ?? type;
          crumbs.insert(0, (id: current, label: label));
          current = data['parentId'] as String?;
        }
        _breadcrumb.addAll(crumbs);
        _scopeNodeId = parentId;
        _sync.scopeParentId = parentId;
      } else {
        _scopeNodeId = null;
        _sync.scopeParentId = null;
      }

      _selectedFlNodeId = null;
      setState(() { _loading = true; });
      await _sync.reload();
      setState(() { _loading = false; });

      // Find and select the target node on the canvas
      for (final entry in _sync.nodeIdMap.entries) {
        if (entry.value == runtimeId) {
          _controller.selectNodesById({entry.key});
          break;
        }
      }
    } catch (e) {
      _showError('Failed to navigate to node: $e');
    }
  }

  /// "Link From…" — create a link from this node's output to another node's input.
  Future<void> _showLinkFromDialog(String sourceNodeId) async {
    final result = await showDialog<({String port, String targetNodeId, String targetPort})>(
      context: context,
      builder: (_) => _LinkEndpointDialog(
        api: _sync.api,
        fixedNodeId: sourceNodeId,
        mode: _LinkDialogMode.from,
      ),
    );
    if (result == null) return;

    try {
      await _sync.api.links.create(
        sourceNodeId: sourceNodeId,
        sourcePort: result.port,
        targetNodeId: result.targetNodeId,
        targetPort: result.targetPort,
      );
      _linksPanelKey.currentState?.refresh();
      await _sync.pollValues();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Failed to create link: $e');
    }
  }

  /// "Link To…" — create a link from another node's output to this node's input.
  Future<void> _showLinkToDialog(String targetNodeId) async {
    final result = await showDialog<({String port, String sourceNodeId, String sourcePort})>(
      context: context,
      builder: (_) => _LinkEndpointDialog(
        api: _sync.api,
        fixedNodeId: targetNodeId,
        mode: _LinkDialogMode.to,
      ),
    );
    if (result == null) return;

    try {
      await _sync.api.links.create(
        sourceNodeId: result.sourceNodeId,
        sourcePort: result.sourcePort,
        targetNodeId: targetNodeId,
        targetPort: result.port,
      );
      _linksPanelKey.currentState?.refresh();
      await _sync.pollValues();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Failed to create link: $e');
    }
  }

  /// "Manage Links" — show links for a specific node with delete options.
  Future<void> _showManageLinksDialog(String nodeId) async {
    final nodeLinks = _sync.liveLinks.where(
      (l) => l['sourceNodeId'] == nodeId || l['targetNodeId'] == nodeId,
    ).toList();

    await showDialog<void>(
      context: context,
      builder: (_) => _ManageLinksDialog(
        api: _sync.api,
        nodeId: nodeId,
        links: nodeLinks,
        onChanged: () async {
          _linksPanelKey.currentState?.refresh();
          await _sync.pollValues();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Context menus — we bypass fl_nodes' built-in menus because ShellRoute's
  // nested Navigator causes global screen coordinates to be offset by the
  // sidebar width.  All menus use showMenu(useRootNavigator: true) instead.
  // ---------------------------------------------------------------------------

  /// Determines what was right-clicked (node vs background) from the
  /// controller selection state and shows the appropriate menu.
  void _resolveContextMenu() {
    fl_ctx.isContextMenuVisible = false;
    if (!mounted) return;

    final nowSelected = _controller.selectedNodeIds;

    // A new node was selected during this click → right-clicked a node.
    if (!_setEquals(nowSelected, _selectionBeforeClick) &&
        nowSelected.length == 1) {
      final node =
          _controller.project.projectData.nodes[nowSelected.first];
      if (node != null) {
        _showNodeContextMenu(_lastSecondaryPos, node);
        return;
      }
    }

    // Selection unchanged but a single node is still selected →
    // treat as a re-click on that node (keeps UX consistent).
    if (nowSelected.length == 1) {
      final node =
          _controller.project.projectData.nodes[nowSelected.first];
      if (node != null) {
        _showNodeContextMenu(_lastSecondaryPos, node);
        return;
      }
    }

    // No node selected → background click.
    _showEditorContextMenu(_lastSecondaryPos);
  }

  static bool _setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  /// Position helper — converts a global screen offset into a RelativeRect
  /// suitable for [showMenu] on the root Navigator's overlay.
  RelativeRect _menuPosition(Offset global) {
    final overlay =
        Overlay.of(context, rootOverlay: true).context.findRenderObject()!
            as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromLTWH(global.dx, global.dy, 0, 0),
      Offset.zero & overlay.size,
    );
  }

  void _showNodeContextMenu(Offset position, FlNodeDataModel node) {
    final runtimeId = _sync.nodeIdMap[node.id];
    final hasChildren = runtimeId != null &&
        (_sync.liveAllowedChildTypes[runtimeId]?.isNotEmpty ?? false);
    final linkCount = runtimeId != null
        ? (_sync.liveLinkCounts[runtimeId] ?? 0)
        : 0;
    final outputPorts = node.ports.entries
        .where((e) => e.value.prototype.direction == FlPortDirection.output)
        .map((e) => e.key)
        .toList();
    final inputPorts = node.ports.entries
        .where((e) => e.value.prototype.direction == FlPortDirection.input)
        .map((e) => e.key)
        .toList();
    final tokens = RubixTokens.of(context);

    // Build "Paste Link" items from clipboard entries that can connect here
    final pasteItems = <PopupMenuEntry<String>>[];
    for (var i = 0; i < _linkClipboard.length; i++) {
      final clip = _linkClipboard[i];
      if (clip.nodeId == runtimeId) continue; // can't link to self

      if (clip.direction == _LinkDirection.from) {
        // Clipboard has a source — show matching input ports
        for (final port in inputPorts) {
          pasteItems.add(PopupMenuItem(
            value: 'paste:$i:$port',
            height: 36,
            child: _linkMenuItem(
              icon: LucideIcons.arrowRightToLine,
              label: '${clip.label}.${clip.port} → .$port',
              tokens: tokens,
            ),
          ));
        }
      } else {
        // Clipboard has a target — show matching output ports
        for (final port in outputPorts) {
          pasteItems.add(PopupMenuItem(
            value: 'paste:$i:$port',
            height: 36,
            child: _linkMenuItem(
              icon: LucideIcons.arrowRightFromLine,
              label: '.$port → ${clip.label}.${clip.port}',
              tokens: tokens,
            ),
          ));
        }
      }
    }

    showMenu<String>(
      context: context,
      useRootNavigator: true,
      position: _menuPosition(position),
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        if (hasChildren)
          PopupMenuItem(value: 'open', height: 36,
              child: _menuRow(Icons.open_in_new, 'Open', tokens)),
        PopupMenuItem(value: 'settings', height: 36,
            child: _menuRow(Icons.settings, 'Settings', tokens)),
        const PopupMenuDivider(height: 1),

        // Link From — submenu per output port
        if (outputPorts.isNotEmpty)
          ...outputPorts.length == 1
              ? [PopupMenuItem(value: 'linkFrom:${outputPorts.first}', height: 36,
                  child: _menuRow(LucideIcons.arrowRightFromLine,
                      'Link From .${outputPorts.first}', tokens))]
              : [
                  PopupMenuItem(enabled: false, height: 24,
                      child: Text('LINK FROM', style: tokens.mono(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        letterSpacing: 1.5, color: tokens.textMuted,
                      ))),
                  for (final port in outputPorts)
                    PopupMenuItem(value: 'linkFrom:$port', height: 32,
                        child: _linkMenuItem(
                          icon: LucideIcons.arrowRightFromLine,
                          label: '.$port', tokens: tokens,
                        )),
                ],

        // Link To — submenu per input port
        if (inputPorts.isNotEmpty)
          ...inputPorts.length == 1
              ? [PopupMenuItem(value: 'linkTo:${inputPorts.first}', height: 36,
                  child: _menuRow(LucideIcons.arrowRightToLine,
                      'Link To .${inputPorts.first}', tokens))]
              : [
                  PopupMenuItem(enabled: false, height: 24,
                      child: Text('LINK TO', style: tokens.mono(
                        fontSize: 9, fontWeight: FontWeight.w700,
                        letterSpacing: 1.5, color: tokens.textMuted,
                      ))),
                  for (final port in inputPorts)
                    PopupMenuItem(value: 'linkTo:$port', height: 32,
                        child: _linkMenuItem(
                          icon: LucideIcons.arrowRightToLine,
                          label: '.$port', tokens: tokens,
                        )),
                ],

        // Paste Link — complete a pending connection
        if (pasteItems.isNotEmpty) ...[
          const PopupMenuDivider(height: 1),
          PopupMenuItem(enabled: false, height: 24,
              child: Text('PASTE LINK', style: tokens.mono(
                fontSize: 9, fontWeight: FontWeight.w700,
                letterSpacing: 1.5, color: RubixTokens.accentCool,
              ))),
          ...pasteItems,
        ],

        if (linkCount > 0) ...[
          const PopupMenuDivider(height: 1),
          PopupMenuItem(value: 'manageLinks', height: 36,
              child: _menuRow(LucideIcons.link, 'Manage Links ($linkCount)', tokens)),
        ],

        const PopupMenuDivider(height: 1),
        PopupMenuItem(value: 'delete', height: 36,
            child: _menuRow(Icons.delete, 'Delete', tokens)),
        PopupMenuItem(value: 'cut', height: 36,
            child: _menuRow(Icons.cut, 'Cut', tokens)),
        PopupMenuItem(value: 'copy', height: 36,
            child: _menuRow(Icons.copy, 'Copy', tokens)),
      ],
    ).then((value) {
      if (value == null || runtimeId == null) return;

      if (value.startsWith('linkFrom:')) {
        final port = value.substring('linkFrom:'.length);
        final nodeLabel = _friendlyNodeLabel(node, runtimeId);
        _addToLinkClipboard(_LinkClipEntry(
          nodeId: runtimeId,
          port: port,
          label: nodeLabel,
          direction: _LinkDirection.from,
        ));
        _showNotice('Link From: $nodeLabel.$port — right-click target to paste');
      } else if (value.startsWith('linkTo:')) {
        final port = value.substring('linkTo:'.length);
        final nodeLabel = _friendlyNodeLabel(node, runtimeId);
        _addToLinkClipboard(_LinkClipEntry(
          nodeId: runtimeId,
          port: port,
          label: nodeLabel,
          direction: _LinkDirection.to,
        ));
        _showNotice('Link To: $nodeLabel.$port — right-click source to paste');
      } else if (value.startsWith('paste:')) {
        final parts = value.substring('paste:'.length).split(':');
        final clipIndex = int.parse(parts[0]);
        final localPort = parts[1];
        _executePasteLink(clipIndex, runtimeId, localPort);
      } else {
        switch (value) {
          case 'open':
            _openScope(node.id);
          case 'settings':
            _openNodeSettings(node.id);
          case 'manageLinks':
            _showManageLinksDialog(runtimeId);
          case 'delete':
            _controller.removeNodeById(node.id);
          case 'cut':
            _controller.clipboard.cutSelection(context: context);
          case 'copy':
            _controller.clipboard.copySelection(context: context);
        }
      }
    });
  }

  void _addToLinkClipboard(_LinkClipEntry entry) {
    // Remove duplicates of the same node+port+direction
    _linkClipboard.removeWhere((e) =>
        e.nodeId == entry.nodeId && e.port == entry.port && e.direction == entry.direction);
    _linkClipboard.insert(0, entry);
    // Keep last 3
    while (_linkClipboard.length > 3) {
      _linkClipboard.removeLast();
    }
  }

  Future<void> _executePasteLink(int clipIndex, String localNodeId, String localPort) async {
    if (clipIndex >= _linkClipboard.length) return;
    final clip = _linkClipboard[clipIndex];

    try {
      if (clip.direction == _LinkDirection.from) {
        // Clip is the source, local node is the target
        await _sync.api.links.create(
          sourceNodeId: clip.nodeId,
          sourcePort: clip.port,
          targetNodeId: localNodeId,
          targetPort: localPort,
        );
      } else {
        // Clip is the target, local node is the source
        await _sync.api.links.create(
          sourceNodeId: localNodeId,
          sourcePort: localPort,
          targetNodeId: clip.nodeId,
          targetPort: clip.port,
        );
      }
      _linksPanelKey.currentState?.refresh();
      await _sync.pollValues();
      if (mounted) setState(() {});
    } catch (e) {
      _showError('Failed to create link: $e');
    }
  }

  /// Get a human-readable label for a node — uses the prototype's display
  /// name which includes the user label (e.g. "HEY (math.add)" or "math.add").
  String _friendlyNodeLabel(FlNodeDataModel node, String runtimeId) {
    return node.prototype.displayName(context);
  }

  Widget _linkMenuItem({
    required IconData icon,
    required String label,
    required RubixColors tokens,
  }) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Icon(icon, size: 14, color: RubixTokens.accentCool),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: RubixTokens.mono(fontSize: 11, color: tokens.textPrimary),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  void _showEditorContextMenu(Offset position) {
    final tokens = RubixTokens.of(context);

    showMenu<String>(
      context: context,
      useRootNavigator: true,
      position: _menuPosition(position),
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem(value: 'center', height: 36,
            child: _menuRow(Icons.center_focus_strong, 'Center View', tokens)),
        PopupMenuItem(value: 'resetZoom', height: 36,
            child: _menuRow(Icons.zoom_in, 'Reset Zoom', tokens)),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'create',
          height: 36,
          child: _menuRow(Icons.add, 'Create', tokens),
        ),
        PopupMenuItem(value: 'paste', height: 36,
            child: _menuRow(Icons.paste, 'Paste', tokens)),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(value: 'undo', height: 36,
            child: _menuRow(Icons.undo, 'Undo', tokens)),
        PopupMenuItem(value: 'redo', height: 36,
            child: _menuRow(Icons.redo, 'Redo', tokens)),
      ],
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'center':
          _controller.setViewportOffset(Offset.zero, absolute: true);
        case 'resetZoom':
          _controller.setViewportZoom(1.0, absolute: true);
        case 'create':
          _showCreateSubmenu(position);
        case 'paste':
          _controller.clipboard.pasteSelection();
        case 'undo':
          _controller.history.undo();
        case 'redo':
          _controller.history.redo();
      }
    });
  }

  void _showCreateSubmenu(Offset position) {
    final tokens = RubixTokens.of(context);

    showMenu<String>(
      context: context,
      useRootNavigator: true,
      position: _menuPosition(position),
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        for (final entry in _palette)
          PopupMenuItem(
            value: entry.type,
            height: 36,
            child: _menuRow(Icons.dashboard, entry.type.split('.').last, tokens),
          ),
      ],
    ).then((type) {
      if (type != null) _controller.addNode(type);
    });
  }

  Widget _menuRow(IconData icon, String label, RubixColors tokens) {
    return Row(
      children: [
        Icon(icon, size: 16, color: tokens.textMuted),
        const SizedBox(width: 10),
        Text(label,
            style: RubixTokens.inter(
                fontSize: 13, color: tokens.textPrimary)),
      ],
    );
  }

  /// Navigate into a container node — show its children on the canvas.
  Future<void> _openScope(String flNodeId) async {
    final runtimeId = _sync.nodeIdMap[flNodeId];
    if (runtimeId == null) return;

    // Get the node label for breadcrumb
    final flNode = _controller.project.projectData.nodes[flNodeId];
    final typeName = flNode?.prototype.idName ?? '?';

    _breadcrumb.add((id: runtimeId, label: typeName));
    _scopeNodeId = runtimeId;
    _sync.scopeParentId = runtimeId;
    _selectedFlNodeId = null;

    setState(() { _loading = true; });
    await _sync.reload();
    setState(() { _loading = false; });
  }

  /// Navigate back to parent scope (or root).
  Future<void> _navigateUp() async {
    if (_breadcrumb.isEmpty) return;
    _breadcrumb.removeLast();

    if (_breadcrumb.isEmpty) {
      _scopeNodeId = null;
      _sync.scopeParentId = null;
    } else {
      _scopeNodeId = _breadcrumb.last.id;
      _sync.scopeParentId = _breadcrumb.last.id;
    }

    _selectedFlNodeId = null;
    setState(() { _loading = true; });
    await _sync.reload();
    setState(() { _loading = false; });
  }

  Future<void> _openNodeSettings([String? nodeId]) async {
    final flId = nodeId ?? _selectedFlNodeId;
    if (flId == null) return;
    final runtimeId = _sync.nodeIdMap[flId];
    if (runtimeId == null) return;

    final flNode = _controller.project.projectData.nodes[flId];
    final nodeType = flNode?.prototype.idName ?? '?';

    try {
      final schema = await _sync.api.nodes.getSettingsSchema(runtimeId);
      final current = await _sync.api.nodes.getSettings(runtimeId);
      final nodeData = await _sync.api.nodes.get(runtimeId);
      final currentLabel = nodeData['label'] as String?;

      if (!mounted) return;

      final result = await NodeSettingsDialog.show(
        context,
        nodeId: runtimeId,
        nodeType: nodeType,
        schema: schema,
        currentSettings: current,
        currentLabel: currentLabel,
      );

      if (result != null) {
        await _sync.api.nodes.updateSettings(runtimeId, result.settings);

        // Save label separately (stored in node metadata, not settings)
        if (result.label != currentLabel) {
          await _sync.api.nodes.update(runtimeId, label: result.label);
        }

        // Reload canvas to pick up any port changes (variadic inputs) or label
        setState(() { _loading = true; });
        await _sync.reload();
        setState(() { _loading = false; });
      }
    } catch (e) {
      _showError('Failed to load settings: $e');
    }
  }

  void _exportJson() {
    final nodes = _sync.nodeIdMap.entries.map((e) {
      final flNode = _controller.project.projectData.nodes[e.key];
      return {
        'flNodeId': e.key,
        'runtimeId': e.value,
        'type': flNode?.prototype.idName,
        'value': _sync.liveValues[e.value],
        'status': _sync.liveStatuses[e.value],
      };
    }).toList();

    final links = _sync.linkIdMap.entries
        .map((e) => {'flLinkId': e.key, 'runtimeEdgeId': e.value})
        .toList();

    final json = const JsonEncoder.withIndent('  ')
        .convert({'nodes': nodes, 'links': links});

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Graph State'),
        content: SizedBox(
          width: 500,
          height: 400,
          child: SelectableText(
            json,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: RubixTokens.statusError),
    );
  }

  void _showNotice(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: RubixTokens.accentCool,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventSub.cancel();
    _sync.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    // Sync the editor theme with the app theme.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (editorIsDark != isDark) {
      editorIsDark = isDark;
      _controller.setStyle(rubixEditorStyleFor(isDark));
    }

    if (_loading) {
      return Scaffold(
        backgroundColor: tokens.bg,
        body: const RubixLoader(message: 'Connecting to runtime'),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: tokens.bg,
        body: RubixErrorState.offline(
          message: 'Runtime not reachable',
          detail: _error,
          onRetry: () {
            setState(() { _loading = true; _error = null; });
            _init();
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: tokens.bg,
      body: Column(
        children: [
          // ── Title row — editorial heading ──
          _buildTitleRow(tokens),

          // ── Control strip — slim, functional ──
          _buildControlStrip(tokens),

          // ── Content ──
          Expanded(
            child: ListenableBuilder(
              listenable: _tabController,
              builder: (context, _) => IndexedStack(
                index: _tabController.index,
                children: [
                  _buildFlowTab(tokens),
                  DashboardTab(key: _dashboardKey, api: _sync.api),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Title row — matches the editorial heading pattern ──────────────────────

  Widget _buildTitleRow(RubixColors tokens) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Back button when scoped
          if (_scopeNodeId != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GestureDetector(
                onTap: _navigateUp,
                child: Icon(LucideIcons.arrowLeft,
                    size: 20, color: tokens.textMuted),
              ),
            ),
            const SizedBox(width: 12),
          ],

          // Title + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_breadcrumb.isEmpty)
                Text(
                  'Flow Editor',
                  style: RubixTokens.heading(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: tokens.textPrimary,
                    letterSpacing: -0.5,
                  ),
                )
              else
                _buildBreadcrumb(tokens),
              const SizedBox(height: 3),
              Text(
                _connected
                    ? 'Runtime connected'
                    : 'Runtime offline',
                style: RubixTokens.heading(
                  fontSize: 13,
                  color: tokens.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: ConnectionBadge(connected: _connected),
          ),

          const Spacer(),

          // Pill tab switcher — anchored right in the title row
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: _buildPillTabs(tokens),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(RubixColors tokens) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        GestureDetector(
          onTap: () {
            _breadcrumb.clear();
            _scopeNodeId = null;
            _sync.scopeParentId = null;
            _selectedFlNodeId = null;
            setState(() { _loading = true; });
            _sync.reload().then((_) {
              if (mounted) setState(() { _loading = false; });
            });
          },
          child: Text('Flow Editor',
              style: RubixTokens.heading(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: tokens.textMuted,
                letterSpacing: -0.5,
              )),
        ),
        for (final crumb in _breadcrumb) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(LucideIcons.chevronRight,
                size: 18, color: tokens.textMuted),
          ),
          Text(
            crumb.label,
            style: RubixTokens.heading(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: tokens.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }

  // ─── Pill tab switcher ──────────────────────────────────────────────────────

  Widget _buildPillTabs(RubixColors tokens) {
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: tokens.surfaceWell,
        borderRadius: BorderRadius.circular(11),
      ),
      child: ListenableBuilder(
        listenable: _tabController,
        builder: (context, _) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _pillTab(0, 'Flow', LucideIcons.workflow, tokens),
            _pillTab(1, 'Dashboard', LucideIcons.layoutDashboard, tokens),
          ],
        ),
      ),
    );
  }

  Widget _pillTab(
      int index, String label, IconData icon, RubixColors tokens) {
    final isActive = _tabController.index == index;
    return GestureDetector(
      onTap: () => _tabController.animateTo(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? tokens.surfaceBright : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? RubixTokens.accentCool : tokens.textMuted,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: RubixTokens.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? tokens.textPrimary : tokens.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Control strip — slim action bar ────────────────────────────────────────

  Widget _buildControlStrip(RubixColors tokens) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Left: node count
          Text(
            '${_sync.nodeIdMap.length} nodes',
            style: RubixTokens.mono(
              fontSize: 10,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          if (_sync.linkIdMap.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 3, height: 3,
                decoration: BoxDecoration(
                  color: tokens.textMuted.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              '${_sync.linkIdMap.length} links',
              style: RubixTokens.mono(
                fontSize: 10,
                letterSpacing: 0.5,
                color: tokens.textMuted,
              ),
            ),
          ],

          const Spacer(),

          // Right: actions as ghost buttons
          _controlAction(
            icon: LucideIcons.link,
            label: 'Links',
            tokens: tokens,
            active: _showLinksPanel,
            onTap: () => setState(() => _showLinksPanel = !_showLinksPanel),
          ),
          const SizedBox(width: 4),
          _controlAction(
            icon: _showLivePanel
                ? LucideIcons.panelRightClose
                : LucideIcons.panelRightOpen,
            label: 'Values',
            tokens: tokens,
            active: _showLivePanel,
            onTap: () => setState(() => _showLivePanel = !_showLivePanel),
          ),
          const SizedBox(width: 4),
          _controlAction(
            icon: LucideIcons.settings2,
            label: 'Settings',
            tokens: tokens,
            onTap: _selectedFlNodeId != null ? _openNodeSettings : null,
          ),
          const SizedBox(width: 4),
          _controlAction(
            icon: _sync.pollPaused ? LucideIcons.play : LucideIcons.pause,
            label: _sync.pollPaused
                ? 'Paused'
                : '${_sync.pollInterval.inSeconds}s',
            tokens: tokens,
            active: !_sync.pollPaused,
            onTap: () => setState(() => _sync.togglePause()),
          ),
          const SizedBox(width: 4),
          _buildPollIntervalButton(tokens),
          const SizedBox(width: 4),
          _controlAction(
            icon: LucideIcons.refreshCw,
            tokens: tokens,
            onTap: () {
              setState(() { _loading = true; _error = null; });
              _init();
            },
          ),
          const SizedBox(width: 4),
          _controlAction(
            icon: LucideIcons.download,
            tokens: tokens,
            onTap: _exportJson,
          ),
        ],
      ),
    );
  }

  Widget _controlAction({
    required IconData icon,
    required RubixColors tokens,
    String? label,
    VoidCallback? onTap,
    bool active = false,
  }) {
    final isDisabled = onTap == null;
    final color = isDisabled
        ? tokens.textMuted.withValues(alpha: 0.3)
        : active
            ? RubixTokens.accentCool
            : tokens.textMuted;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26,
        padding: EdgeInsets.symmetric(
          horizontal: label != null ? 8 : 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            if (label != null) ...[
              const SizedBox(width: 5),
              Text(
                label,
                style: RubixTokens.mono(
                  fontSize: 10,
                  color: color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPollIntervalButton(RubixColors tokens) {
    return PopupMenuButton<int>(
      tooltip: '',
      offset: const Offset(0, 30),
      color: tokens.surfaceBright,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onSelected: (secs) {
        setState(() {
          _sync.setPollInterval(Duration(seconds: secs));
        });
      },
      itemBuilder: (_) => [
        for (final s in [1, 2, 5, 10])
          PopupMenuItem(
            height: 32,
            value: s,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  child: _sync.pollInterval.inSeconds == s
                      ? Icon(LucideIcons.check,
                          size: 12, color: RubixTokens.accentCool)
                      : null,
                ),
                const SizedBox(width: 6),
                Text(
                  '${s}s',
                  style: RubixTokens.mono(
                    fontSize: 11,
                    color: _sync.pollInterval.inSeconds == s
                        ? RubixTokens.accentCool
                        : tokens.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.gauge, size: 13, color: tokens.textMuted),
            const SizedBox(width: 4),
            Text(
              '${_sync.pollInterval.inSeconds}s',
              style: RubixTokens.mono(
                fontSize: 10,
                color: tokens.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Flow tab ───────────────────────────────────────────────────────────────

  Widget _buildFlowTab(RubixColors tokens) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.delete): _deleteSelection,
        const SingleActivator(LogicalKeyboardKey.backspace): _deleteSelection,
      },
      child: Focus(
        autofocus: true,
        child: Row(
          children: [
            Expanded(
              child: ColoredBox(
                color: tokens.bg,
                child: Stack(
                  children: [
                    FlNodeEditorWidget(
                      controller: _controller,
                      expandToParent: true,
                      overlay: () => [],
                    ),
                    IgnorePointer(
                      child: WireValueBadges(
                        controller: _controller,
                        nodeIdMap: _sync.nodeIdMap,
                        liveValues: _sync.liveValues,
                      ),
                    ),
                    LinkCountBadges(
                      controller: _controller,
                      nodeIdMap: _sync.nodeIdMap,
                      liveLinkCounts: _sync.liveLinkCounts,
                      liveLinks: _sync.liveLinks,
                      liveValues: _sync.liveValues,
                    ),
                    if (_showLinksPanel)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: LinksPanel(
                          key: _linksPanelKey,
                          api: _sync.api,
                          onNavigateToNode: _navigateToNode,
                        ),
                      ),
                    if (_showLivePanel)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: LiveValuesPanel(
                          nodeIdMap: _sync.nodeIdMap,
                          liveValues: _sync.liveValues,
                          liveStatuses: _sync.liveStatuses,
                          controller: _controller,
                        ),
                      ),
                    // Transparent overlay — last child so it is hit-tested
                    // first.  Fires BEFORE fl_nodes' internal Listeners,
                    // letting us block all mis-positioned context menus.
                    Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (event) {
                        if (event.buttons == kSecondaryMouseButton) {
                          _selectionBeforeClick =
                              Set.of(_controller.selectedNodeIds);
                          _lastSecondaryPos = event.position;
                          fl_ctx.isContextMenuVisible = true;

                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _resolveContextMenu());
                        }
                      },
                      child: const SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
            NodePalette(controller: _controller, palette: _palette),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Link From / Link To dialog
// =============================================================================

// =============================================================================
// Link clipboard entry
// =============================================================================

enum _LinkDirection { from, to }

class _LinkClipEntry {
  final String nodeId;
  final String port;
  final String label;
  final _LinkDirection direction;

  _LinkClipEntry({
    required this.nodeId,
    required this.port,
    required this.label,
    required this.direction,
  });
}

enum _LinkDialogMode { from, to }

class _LinkEndpointDialog extends StatefulWidget {
  final RuntimeApiClient api;
  final String fixedNodeId;
  final _LinkDialogMode mode;

  const _LinkEndpointDialog({
    required this.api,
    required this.fixedNodeId,
    required this.mode,
  });

  @override
  State<_LinkEndpointDialog> createState() => _LinkEndpointDialogState();
}

class _LinkEndpointDialogState extends State<_LinkEndpointDialog> {
  List<Map<String, dynamic>> _allNodes = [];
  Map<String, dynamic>? _fixedNode;
  bool _loading = true;

  // Fixed node's port
  String? _fixedPort;
  List<String> _fixedPorts = [];

  // Remote node + port
  String? _remoteNodeId;
  String? _remotePort;
  List<String> _remotePorts = [];

  bool get _isFrom => widget.mode == _LinkDialogMode.from;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        widget.api.nodes.list(),
        widget.api.nodes.get(widget.fixedNodeId),
      ]);
      _allNodes = results[0] as List<Map<String, dynamic>>;
      _fixedNode = results[1] as Map<String, dynamic>;

      // Get the fixed node's ports
      if (_isFrom) {
        final outputs = _fixedNode!['outputs'] as List<dynamic>? ?? [];
        _fixedPorts = outputs
            .map((p) => (p as Map<String, dynamic>)['name'] as String)
            .toList();
      } else {
        final inputs = _fixedNode!['inputs'] as List<dynamic>? ?? [];
        _fixedPorts = inputs
            .map((p) => (p as Map<String, dynamic>)['name'] as String)
            .toList();
      }
      if (_fixedPorts.length == 1) _fixedPort = _fixedPorts.first;
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _onRemoteNodeChanged(String? nodeId) {
    setState(() {
      _remoteNodeId = nodeId;
      _remotePort = null;
      if (nodeId != null) {
        final node = _allNodes.firstWhere((n) => n['id'] == nodeId);
        if (_isFrom) {
          final inputs = node['inputs'] as List<dynamic>? ?? [];
          _remotePorts = inputs
              .map((p) => (p as Map<String, dynamic>)['name'] as String)
              .toList();
        } else {
          final outputs = node['outputs'] as List<dynamic>? ?? [];
          _remotePorts = outputs
              .map((p) => (p as Map<String, dynamic>)['name'] as String)
              .toList();
        }
        if (_remotePorts.length == 1) _remotePort = _remotePorts.first;
      } else {
        _remotePorts = [];
      }
    });
  }

  String _nodeLabel(Map<String, dynamic> node) {
    final label = node['label'] as String?;
    final type = node['type'] as String? ?? '?';
    final id = (node['id'] as String).substring(0, 6);
    if (label != null && label.isNotEmpty) return '$label ($type)';
    return '$type [$id]';
  }

  bool get _canCreate =>
      _fixedPort != null &&
      _remoteNodeId != null &&
      _remotePort != null &&
      _remoteNodeId != widget.fixedNodeId;

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    final title = _isFrom ? 'Link From' : 'Link To';
    final icon = _isFrom
        ? LucideIcons.arrowRightFromLine
        : LucideIcons.arrowRightToLine;

    return AlertDialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RubixTokens.radiusCard),
      ),
      title: Row(
        children: [
          Icon(icon, size: 18, color: RubixTokens.accentCool),
          const SizedBox(width: 8),
          Text(title, style: RubixTokens.heading(
            fontSize: 18, fontWeight: FontWeight.w700, color: tokens.textPrimary,
          )),
        ],
      ),
      content: _loading
          ? const SizedBox(width: 400, height: 150,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
          : SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed node (read-only)
                  Text(
                    _isFrom ? 'SOURCE (this node)' : 'TARGET (this node)',
                    style: tokens.mono(
                      fontSize: 9, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5, color: RubixTokens.accentCool,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: tokens.surfaceWell,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: tokens.border),
                    ),
                    child: Text(
                      _fixedNode != null ? _nodeLabel(_fixedNode!) : '…',
                      style: tokens.inter(fontSize: 12, color: tokens.textPrimary),
                    ),
                  ),
                  if (_fixedPorts.length > 1) ...[
                    const SizedBox(height: 8),
                    _buildPortDropdown(
                      ports: _fixedPorts,
                      selected: _fixedPort,
                      label: _isFrom ? 'Output port' : 'Input port',
                      onChanged: (p) => setState(() => _fixedPort = p),
                      tokens: tokens,
                    ),
                  ] else if (_fixedPorts.length == 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Port: ${_fixedPorts.first}',
                        style: tokens.mono(fontSize: 11, color: tokens.textMuted),
                      ),
                    ),

                  const SizedBox(height: 16),
                  Center(child: Icon(
                    _isFrom ? LucideIcons.arrowDown : LucideIcons.arrowUp,
                    size: 18, color: tokens.textMuted,
                  )),
                  const SizedBox(height: 16),

                  // Remote node
                  Text(
                    _isFrom ? 'TARGET' : 'SOURCE',
                    style: tokens.mono(
                      fontSize: 9, fontWeight: FontWeight.w700,
                      letterSpacing: 1.5, color: RubixTokens.accentHeat,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildNodeDropdown(tokens),
                  if (_remotePorts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildPortDropdown(
                      ports: _remotePorts,
                      selected: _remotePort,
                      label: _isFrom ? 'Input port' : 'Output port',
                      onChanged: (p) => setState(() => _remotePort = p),
                      tokens: tokens,
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: tokens.inter(color: tokens.textMuted)),
        ),
        TextButton(
          onPressed: _canCreate ? _onCreate : null,
          child: Text('Create', style: tokens.inter(
            color: _canCreate ? RubixTokens.accentCool : tokens.textMuted,
            fontWeight: FontWeight.w600,
          )),
        ),
      ],
    );
  }

  void _onCreate() {
    if (_isFrom) {
      Navigator.pop(context, (
        port: _fixedPort!,
        targetNodeId: _remoteNodeId!,
        targetPort: _remotePort!,
      ));
    } else {
      Navigator.pop(context, (
        port: _fixedPort!,
        sourceNodeId: _remoteNodeId!,
        sourcePort: _remotePort!,
      ));
    }
  }

  Widget _buildNodeDropdown(RubixColors tokens) {
    // Filter: show nodes with the right port direction, exclude self
    final filtered = _allNodes.where((n) {
      if (n['id'] == widget.fixedNodeId) return false;
      if (_isFrom) {
        return (n['inputs'] as List<dynamic>?)?.isNotEmpty ?? false;
      } else {
        return (n['outputs'] as List<dynamic>?)?.isNotEmpty ?? false;
      }
    }).toList();

    return DropdownButtonFormField<String>(
      value: _remoteNodeId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: _isFrom ? 'Target node' : 'Source node',
        labelStyle: tokens.inter(fontSize: 12, color: tokens.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tokens.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      dropdownColor: tokens.surfaceBright,
      style: tokens.inter(fontSize: 12, color: tokens.textPrimary),
      items: filtered.map((n) => DropdownMenuItem(
        value: n['id'] as String,
        child: Text(_nodeLabel(n), overflow: TextOverflow.ellipsis),
      )).toList(),
      onChanged: _onRemoteNodeChanged,
    );
  }

  Widget _buildPortDropdown({
    required List<String> ports,
    required String? selected,
    required String label,
    required void Function(String?) onChanged,
    required RubixColors tokens,
  }) {
    return DropdownButtonFormField<String>(
      value: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: tokens.inter(fontSize: 12, color: tokens.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tokens.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: tokens.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      dropdownColor: tokens.surfaceBright,
      style: tokens.mono(fontSize: 12, color: tokens.textPrimary),
      items: ports.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
      onChanged: onChanged,
    );
  }
}

// =============================================================================
// Manage Links dialog — shows links for a specific node with delete
// =============================================================================

class _ManageLinksDialog extends StatefulWidget {
  final RuntimeApiClient api;
  final String nodeId;
  final List<Map<String, dynamic>> links;
  final VoidCallback onChanged;

  const _ManageLinksDialog({
    required this.api,
    required this.nodeId,
    required this.links,
    required this.onChanged,
  });

  @override
  State<_ManageLinksDialog> createState() => _ManageLinksDialogState();
}

class _ManageLinksDialogState extends State<_ManageLinksDialog> {
  late List<Map<String, dynamic>> _links;

  @override
  void initState() {
    super.initState();
    _links = List.from(widget.links);
  }

  Future<void> _deleteLink(int index) async {
    final id = _links[index]['id'] as String;
    try {
      await widget.api.edges.delete(id);
      setState(() => _links.removeAt(index));
      widget.onChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return AlertDialog(
      backgroundColor: tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RubixTokens.radiusCard),
      ),
      title: Row(
        children: [
          Icon(LucideIcons.link, size: 18, color: RubixTokens.accentCool),
          const SizedBox(width: 8),
          Text('Manage Links', style: RubixTokens.heading(
            fontSize: 18, fontWeight: FontWeight.w700, color: tokens.textPrimary,
          )),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: _links.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text('No links', style: tokens.inter(
                  fontSize: 13, color: tokens.textMuted,
                )),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < _links.length; i++) ...[
                    _ManageLinkRow(
                      link: _links[i],
                      nodeId: widget.nodeId,
                      onDelete: () => _deleteLink(i),
                    ),
                    if (i < _links.length - 1)
                      Divider(height: 1, color: tokens.border.withValues(alpha: 0.3)),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: tokens.inter(color: tokens.textMuted)),
        ),
      ],
    );
  }
}

class _ManageLinkRow extends StatelessWidget {
  final Map<String, dynamic> link;
  final String nodeId;
  final VoidCallback onDelete;

  const _ManageLinkRow({
    required this.link,
    required this.nodeId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    final srcRtId = link['sourceNodeId'] as String;
    final srcPort = link['sourcePort'] as String;
    final srcPath = link['sourcePath'] as String? ?? '?';
    final tgtPort = link['targetPort'] as String;
    final tgtPath = link['targetPath'] as String? ?? '?';

    final isSource = srcRtId == nodeId;
    final direction = isSource ? 'OUT' : 'IN';
    final dirColor = isSource ? RubixTokens.accentHeat : RubixTokens.accentCool;
    final remotePath = isSource ? tgtPath : srcPath;
    final localPort = isSource ? srcPort : tgtPort;
    final remotePort = isSource ? tgtPort : srcPort;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: dirColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(direction, style: tokens.mono(
              fontSize: 8, fontWeight: FontWeight.w700, color: dirColor,
            )),
          ),
          const SizedBox(width: 6),
          Text('.$localPort', style: tokens.mono(fontSize: 10, color: tokens.textMuted)),
          const SizedBox(width: 4),
          Icon(
            isSource ? LucideIcons.arrowRight : LucideIcons.arrowLeft,
            size: 10, color: tokens.textMuted,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '$remotePath.$remotePort',
              style: tokens.inter(fontSize: 10, color: tokens.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(LucideIcons.trash2, size: 14, color: tokens.textMuted),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}
