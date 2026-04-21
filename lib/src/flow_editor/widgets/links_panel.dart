import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rubix_ui/rubix_ui.dart';
import 'package:dart_red/src/client/runtime_client.dart';

/// Panel that shows all portless links (hidden edges) and lets the user
/// create, delete, and navigate to linked nodes.
///
/// Modelled after Niagara's Link Table — a flat list of cross-scope
/// connections that exist in the runtime but aren't drawn as wires.
class LinksPanel extends StatefulWidget {
  final RuntimeApiClient api;

  /// Called when the user taps "Go to" on a link row.
  /// Receives the runtime node ID to navigate to.
  final void Function(String nodeId) onNavigateToNode;

  const LinksPanel({
    super.key,
    required this.api,
    required this.onNavigateToNode,
  });

  @override
  State<LinksPanel> createState() => LinksPanelState();
}

class LinksPanelState extends State<LinksPanel> {
  List<Map<String, dynamic>> _links = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    setState(() => _loading = true);
    try {
      _links = await widget.api.links.list();
    } catch (_) {
      _links = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _deleteLink(String edgeId) async {
    try {
      await widget.api.edges.delete(edgeId);
      await refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete link: $e')),
        );
      }
    }
  }

  Future<void> _showCreateLinkDialog() async {
    final result = await showDialog<_CreateLinkResult>(
      context: context,
      builder: (_) => _CreateLinkDialog(api: widget.api),
    );
    if (result != null) {
      try {
        await widget.api.links.create(
          sourceNodeId: result.sourceNodeId,
          sourcePort: result.sourcePort,
          targetNodeId: result.targetNodeId,
          targetPort: result.targetPort,
        );
        await refresh();
      } catch (e) {
        if (mounted) {
          // Extract the server error message from DioException if available
          String msg = '$e';
          if (e is DioException && e.response?.data is Map) {
            msg = (e.response!.data as Map)['error']?.toString() ?? msg;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create link: $msg')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return Container(
      width: 420,
      constraints: const BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(RubixTokens.radiusCard),
        boxShadow: tokens.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 8),
            child: Row(
              children: [
                Icon(LucideIcons.link, size: 14, color: tokens.textMuted),
                const SizedBox(width: 8),
                Text(
                  'LINKS',
                  style: tokens.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: tokens.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_links.length}',
                  style: tokens.mono(
                    fontSize: 10,
                    color: tokens.textMuted,
                  ),
                ),
                const Spacer(),
                _IconButton(
                  icon: LucideIcons.plus,
                  tooltip: 'Create link',
                  onTap: _showCreateLinkDialog,
                ),
                _IconButton(
                  icon: LucideIcons.refreshCw,
                  tooltip: 'Refresh',
                  onTap: refresh,
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: tokens.border),

          // Content
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_links.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.unlink, size: 28, color: tokens.textMuted),
                    const SizedBox(height: 8),
                    Text(
                      'No links yet',
                      style: tokens.inter(
                        fontSize: 13,
                        color: tokens.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create a link to connect nodes\nacross scopes without wires',
                      textAlign: TextAlign.center,
                      style: tokens.inter(
                        fontSize: 11,
                        color: tokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                itemCount: _links.length,
                separatorBuilder: (_ctx, _) =>
                    Container(height: 1, color: tokens.border.withValues(alpha: 0.4)),
                itemBuilder: (context, index) {
                  final link = _links[index];
                  return _LinkRow(
                    link: link,
                    onDelete: () => _deleteLink(link['id'] as String),
                    onNavigateSource: () =>
                        widget.onNavigateToNode(link['sourceNodeId'] as String),
                    onNavigateTarget: () =>
                        widget.onNavigateToNode(link['targetNodeId'] as String),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// Link row
// =============================================================================

class _LinkRow extends StatelessWidget {
  final Map<String, dynamic> link;
  final VoidCallback onDelete;
  final VoidCallback onNavigateSource;
  final VoidCallback onNavigateTarget;

  const _LinkRow({
    required this.link,
    required this.onDelete,
    required this.onNavigateSource,
    required this.onNavigateTarget,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    final srcPath = link['sourcePath'] as String? ?? '';
    final srcPort = link['sourcePort'] as String? ?? '';
    final tgtPath = link['targetPath'] as String? ?? '';
    final tgtPort = link['targetPort'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source row
          _EndpointRow(
            label: 'FROM',
            path: srcPath,
            port: srcPort,
            color: RubixTokens.accentCool,
            onNavigate: onNavigateSource,
          ),
          const SizedBox(height: 2),
          // Arrow
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Icon(LucideIcons.arrowDown, size: 12, color: tokens.textMuted),
          ),
          const SizedBox(height: 2),
          // Target row
          Row(
            children: [
              Expanded(
                child: _EndpointRow(
                  label: 'TO',
                  path: tgtPath,
                  port: tgtPort,
                  color: RubixTokens.accentHeat,
                  onNavigate: onNavigateTarget,
                ),
              ),
              _IconButton(
                icon: LucideIcons.trash2,
                tooltip: 'Delete link',
                size: 14,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EndpointRow extends StatelessWidget {
  final String label;
  final String path;
  final String port;
  final Color color;
  final VoidCallback onNavigate;

  const _EndpointRow({
    required this.label,
    required this.path,
    required this.port,
    required this.color,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return Row(
      children: [
        Container(
          width: 28,
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: tokens.mono(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onNavigate,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    path,
                    style: tokens.inter(
                      fontSize: 11,
                      color: tokens.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '.$port',
                  style: tokens.mono(
                    fontSize: 10,
                    color: tokens.textMuted,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(LucideIcons.externalLink,
                    size: 10, color: tokens.textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Create Link Dialog
// =============================================================================

class _CreateLinkResult {
  final String sourceNodeId;
  final String sourcePort;
  final String targetNodeId;
  final String targetPort;

  _CreateLinkResult({
    required this.sourceNodeId,
    required this.sourcePort,
    required this.targetNodeId,
    required this.targetPort,
  });
}

class _CreateLinkDialog extends StatefulWidget {
  final RuntimeApiClient api;

  const _CreateLinkDialog({required this.api});

  @override
  State<_CreateLinkDialog> createState() => _CreateLinkDialogState();
}

class _CreateLinkDialogState extends State<_CreateLinkDialog> {
  List<Map<String, dynamic>> _allNodes = [];
  bool _loading = true;

  // Source selection
  String? _sourceNodeId;
  String? _sourcePort;
  List<String> _sourceOutputPorts = [];

  // Target selection
  String? _targetNodeId;
  String? _targetPort;
  List<String> _targetInputPorts = [];

  @override
  void initState() {
    super.initState();
    _loadNodes();
  }

  Future<void> _loadNodes() async {
    try {
      _allNodes = await widget.api.nodes.list();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  void _onSourceNodeChanged(String? nodeId) {
    setState(() {
      _sourceNodeId = nodeId;
      _sourcePort = null;
      if (nodeId != null) {
        final node = _allNodes.firstWhere((n) => n['id'] == nodeId);
        final outputs = node['outputs'] as List<dynamic>? ?? [];
        _sourceOutputPorts =
            outputs.map((p) => (p as Map<String, dynamic>)['name'] as String).toList();
        // Auto-select if only one port
        if (_sourceOutputPorts.length == 1) {
          _sourcePort = _sourceOutputPorts.first;
        }
      } else {
        _sourceOutputPorts = [];
      }
    });
  }

  void _onTargetNodeChanged(String? nodeId) {
    setState(() {
      _targetNodeId = nodeId;
      _targetPort = null;
      if (nodeId != null) {
        final node = _allNodes.firstWhere((n) => n['id'] == nodeId);
        final inputs = node['inputs'] as List<dynamic>? ?? [];
        _targetInputPorts =
            inputs.map((p) => (p as Map<String, dynamic>)['name'] as String).toList();
        // Auto-select if only one port
        if (_targetInputPorts.length == 1) {
          _targetPort = _targetInputPorts.first;
        }
      } else {
        _targetInputPorts = [];
      }
    });
  }

  String _nodeDisplayLabel(Map<String, dynamic> node) {
    final label = node['label'] as String?;
    final type = node['type'] as String? ?? '?';
    final id = (node['id'] as String).substring(0, 6);
    if (label != null && label.isNotEmpty) return '$label ($type)';
    return '$type [$id]';
  }

  bool get _canCreate =>
      _sourceNodeId != null &&
      _sourcePort != null &&
      _targetNodeId != null &&
      _targetPort != null &&
      _sourceNodeId != _targetNodeId;

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
          Text(
            'Create Link',
            style: RubixTokens.heading(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: tokens.textPrimary,
            ),
          ),
        ],
      ),
      content: _loading
          ? const SizedBox(
              width: 400,
              height: 200,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source — only show nodes that have output ports
                  _SectionLabel(label: 'SOURCE', color: RubixTokens.accentCool),
                  const SizedBox(height: 6),
                  _NodeDropdown(
                    nodes: _allNodes
                        .where((n) =>
                            (n['outputs'] as List<dynamic>?)?.isNotEmpty ?? false)
                        .toList(),
                    selectedId: _sourceNodeId,
                    label: 'Source node',
                    displayLabel: _nodeDisplayLabel,
                    onChanged: _onSourceNodeChanged,
                  ),
                  if (_sourceOutputPorts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _PortDropdown(
                      ports: _sourceOutputPorts,
                      selectedPort: _sourcePort,
                      label: 'Output port',
                      onChanged: (p) => setState(() => _sourcePort = p),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Arrow
                  Center(
                    child: Icon(LucideIcons.arrowDown,
                        size: 20, color: tokens.textMuted),
                  ),

                  const SizedBox(height: 20),

                  // Target — only show nodes that have input ports
                  _SectionLabel(label: 'TARGET', color: RubixTokens.accentHeat),
                  const SizedBox(height: 6),
                  _NodeDropdown(
                    nodes: _allNodes
                        .where((n) =>
                            (n['inputs'] as List<dynamic>?)?.isNotEmpty ?? false)
                        .toList(),
                    selectedId: _targetNodeId,
                    label: 'Target node',
                    displayLabel: _nodeDisplayLabel,
                    onChanged: _onTargetNodeChanged,
                  ),
                  if (_targetInputPorts.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _PortDropdown(
                      ports: _targetInputPorts,
                      selectedPort: _targetPort,
                      label: 'Input port',
                      onChanged: (p) => setState(() => _targetPort = p),
                    ),
                  ],

                  if (_sourceNodeId != null &&
                      _targetNodeId != null &&
                      _sourceNodeId == _targetNodeId) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(LucideIcons.alertTriangle,
                            size: 14, color: RubixTokens.statusWarning),
                        const SizedBox(width: 6),
                        Text(
                          'Source and target cannot be the same node',
                          style: tokens.inter(
                            fontSize: 12,
                            color: RubixTokens.statusWarning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: tokens.inter(color: tokens.textMuted)),
        ),
        TextButton(
          onPressed: _canCreate
              ? () => Navigator.pop(
                    context,
                    _CreateLinkResult(
                      sourceNodeId: _sourceNodeId!,
                      sourcePort: _sourcePort!,
                      targetNodeId: _targetNodeId!,
                      targetPort: _targetPort!,
                    ),
                  )
              : null,
          child: Text('Create',
              style: tokens.inter(
                color: _canCreate
                    ? RubixTokens.accentCool
                    : tokens.textMuted,
                fontWeight: FontWeight.w600,
              )),
        ),
      ],
    );
  }
}

// =============================================================================
// Shared widgets
// =============================================================================

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    return Text(
      label,
      style: tokens.mono(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: color,
      ),
    );
  }
}

class _NodeDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> nodes;
  final String? selectedId;
  final String label;
  final String Function(Map<String, dynamic>) displayLabel;
  final void Function(String?) onChanged;

  const _NodeDropdown({
    required this.nodes,
    required this.selectedId,
    required this.label,
    required this.displayLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return DropdownButtonFormField<String>(
      value: selectedId,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      dropdownColor: tokens.surfaceBright,
      style: tokens.inter(fontSize: 12, color: tokens.textPrimary),
      items: nodes.map((node) {
        final id = node['id'] as String;
        return DropdownMenuItem(
          value: id,
          child: Text(
            displayLabel(node),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _PortDropdown extends StatelessWidget {
  final List<String> ports;
  final String? selectedPort;
  final String label;
  final void Function(String?) onChanged;

  const _PortDropdown({
    required this.ports,
    required this.selectedPort,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return DropdownButtonFormField<String>(
      value: selectedPort,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      dropdownColor: tokens.surfaceBright,
      style: tokens.mono(fontSize: 12, color: tokens.textPrimary),
      items: ports
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onTap;
  final double size;

  const _IconButton({
    required this.icon,
    this.tooltip,
    this.onTap,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: size, color: tokens.textMuted),
        ),
      ),
    );
  }
}
