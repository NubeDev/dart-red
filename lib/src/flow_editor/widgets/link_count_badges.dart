import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rubix_ui/rubix_ui.dart';

import '../nodes/styles/editor_theme.dart' show editorIsDark;

/// Shows clickable link badges on nodes + value pills on linked input ports.
///
/// Badge: blue chain-link icon at the top-right of the node. Click to show
/// a popup listing all hidden links for that node.
///
/// Input value: small pill next to input ports that receive a hidden link,
/// showing the incoming value and source path.
class LinkCountBadges extends StatelessWidget {
  final FlNodeEditorController controller;
  final Map<String, String> nodeIdMap;
  final Map<String, int> liveLinkCounts;
  final List<Map<String, dynamic>> liveLinks;
  final Map<String, dynamic> liveValues;

  const LinkCountBadges({
    super.key,
    required this.controller,
    required this.nodeIdMap,
    required this.liveLinkCounts,
    required this.liveLinks,
    required this.liveValues,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.viewportOffsetNotifier,
        controller.viewportZoomNotifier,
      ]),
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: _computeWidgets(
              context,
              constraints.biggest,
              controller.viewportZoom,
              controller.viewportOffset,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _computeWidgets(
      BuildContext context, Size size, double zoom, Offset vpOffset) {
    final nodes = controller.project.projectData.nodes;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final widgets = <Widget>[];

    // Reverse map for looking up fl_nodes IDs from runtime IDs
    final reverseMap = <String, String>{};
    nodeIdMap.forEach((flId, rtId) => reverseMap[rtId] = flId);

    // 1. Node-level link count badges (clickable)
    for (final entry in nodeIdMap.entries) {
      final flId = entry.key;
      final rtId = entry.value;
      final count = liveLinkCounts[rtId] ?? 0;
      if (count == 0) continue;

      final node = nodes[flId];
      if (node == null) continue;

      final nodePos = node.offset;
      final screen = _worldToScreen(
        Offset(nodePos.dx + 140, nodePos.dy - 10),
        cx, cy, zoom, vpOffset,
      );
      final screenX = screen.dx;
      final screenY = screen.dy;

      if (screenX < -40 || screenX > size.width + 40) continue;
      if (screenY < -40 || screenY > size.height + 40) continue;

      // Gather links for this node
      final nodeLinks = liveLinks.where(
        (l) => l['sourceNodeId'] == rtId || l['targetNodeId'] == rtId,
      ).toList();

      widgets.add(
        Positioned(
          left: screenX,
          top: screenY,
          child: _ClickableLinkBadge(
            count: count,
            zoom: zoom,
            links: nodeLinks,
            nodeId: rtId,
            liveValues: liveValues,
          ),
        ),
      );
    }

    // 2. Port value pills for hidden links on visible nodes
    for (final link in liveLinks) {
      final tgtRtId = link['targetNodeId'] as String;
      final tgtPort = link['targetPort'] as String;
      final srcRtId = link['sourceNodeId'] as String;
      final srcPort = link['sourcePort'] as String;
      final srcPath = link['sourcePath'] as String? ?? '';
      final tgtPath = link['targetPath'] as String? ?? '';

      // Get the source value flowing through this link
      final srcValue = liveValues[srcRtId];
      String? valueStr;
      if (srcValue is Map) {
        final portVal = srcValue[srcPort];
        if (portVal != null) valueStr = _fmt(portVal);
      } else if (srcValue != null) {
        valueStr = _fmt(srcValue);
      }

      // Input port pill — on the target node's input
      final tgtFlId = reverseMap[tgtRtId];
      if (tgtFlId != null) {
        final node = nodes[tgtFlId];
        if (node != null) {
          final port = node.ports[tgtPort];
          if (port != null) {
            final portWorld = node.offset + port.offset;
            final screen = _worldToScreen(
              Offset(portWorld.dx - 5, portWorld.dy),
              cx, cy, zoom, vpOffset,
            );

            if (screen.dx > -60 && screen.dx < size.width + 60 &&
                screen.dy > -30 && screen.dy < size.height + 30) {
              widgets.add(
                Positioned(
                  left: screen.dx,
                  top: screen.dy,
                  child: FractionalTranslation(
                    translation: const Offset(-1.0, -0.5),
                    child: _LinkedPortPill(
                      value: valueStr,
                      tooltip: 'from $srcPath.$srcPort',
                      isInput: true,
                      zoom: zoom,
                    ),
                  ),
                ),
              );
            }
          }
        }
      }

      // Output port pill — on the source node's output
      final srcFlId = reverseMap[srcRtId];
      if (srcFlId != null) {
        final node = nodes[srcFlId];
        if (node != null) {
          final port = node.ports[srcPort];
          if (port != null) {
            final portWorld = node.offset + port.offset;
            final screen = _worldToScreen(
              Offset(portWorld.dx + 5, portWorld.dy),
              cx, cy, zoom, vpOffset,
            );

            if (screen.dx > -60 && screen.dx < size.width + 60 &&
                screen.dy > -30 && screen.dy < size.height + 30) {
              widgets.add(
                Positioned(
                  left: screen.dx,
                  top: screen.dy,
                  child: FractionalTranslation(
                    translation: const Offset(0.0, -0.5),
                    child: _LinkedPortPill(
                      value: valueStr,
                      tooltip: 'to $tgtPath.$tgtPort',
                      isInput: false,
                      zoom: zoom,
                    ),
                  ),
                ),
              );
            }
          }
        }
      }
    }

    return widgets;
  }

  static Offset _worldToScreen(
      Offset world, double cx, double cy, double zoom, Offset vpOffset) {
    return Offset(
      cx + (world.dx + vpOffset.dx) * zoom,
      cy + (world.dy + vpOffset.dy) * zoom,
    );
  }

  static String _fmt(dynamic v) {
    if (v == null) return '';
    if (v is double) return v.toStringAsFixed(1);
    final s = '$v';
    return s.length > 8 ? '${s.substring(0, 8)}…' : s;
  }
}

// =============================================================================
// Clickable badge — shows popup on tap
// =============================================================================

class _ClickableLinkBadge extends StatelessWidget {
  final int count;
  final double zoom;
  final List<Map<String, dynamic>> links;
  final String nodeId;
  final Map<String, dynamic> liveValues;

  const _ClickableLinkBadge({
    required this.count,
    required this.zoom,
    required this.links,
    required this.nodeId,
    required this.liveValues,
  });

  void _showPopup(BuildContext context) {
    final tokens = RubixTokens.of(context);
    final overlay =
        Overlay.of(context, rootOverlay: true).context.findRenderObject()!
            as RenderBox;
    final box = context.findRenderObject()! as RenderBox;
    final position = box.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<void>(
      context: context,
      useRootNavigator: true,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + box.size.height + 4,
        position.dx + 300,
        0,
      ),
      color: tokens.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      constraints: const BoxConstraints(maxWidth: 360),
      items: [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: _LinkDetailPopup(
            links: links,
            nodeId: nodeId,
            liveValues: liveValues,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = (zoom * 0.9).clamp(0.5, 1.2);

    return GestureDetector(
      onTap: () => _showPopup(context),
      child: Transform.scale(
        scale: scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: RubixTokens.accentCool.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.link, size: 10, color: Colors.white),
              const SizedBox(width: 3),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Link detail popup content
// =============================================================================

class _LinkDetailPopup extends StatelessWidget {
  final List<Map<String, dynamic>> links;
  final String nodeId;
  final Map<String, dynamic> liveValues;

  const _LinkDetailPopup({
    required this.links,
    required this.nodeId,
    required this.liveValues,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return Container(
      width: 340,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.link, size: 12, color: RubixTokens.accentCool),
              const SizedBox(width: 6),
              Text(
                'LINKS (${links.length})',
                style: tokens.mono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: tokens.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final link in links) ...[
            _LinkDetailRow(link: link, nodeId: nodeId, liveValues: liveValues),
            if (link != links.last)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  height: 1,
                  color: tokens.border.withValues(alpha: 0.3),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _LinkDetailRow extends StatelessWidget {
  final Map<String, dynamic> link;
  final String nodeId;
  final Map<String, dynamic> liveValues;

  const _LinkDetailRow({
    required this.link,
    required this.nodeId,
    required this.liveValues,
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

    // Get live value
    final srcValue = liveValues[srcRtId];
    String? valueStr;
    if (srcValue is Map) {
      final v = srcValue[srcPort];
      if (v != null) valueStr = _fmt(v);
    } else if (srcValue != null) {
      valueStr = _fmt(srcValue);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: dirColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                direction,
                style: tokens.mono(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: dirColor,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '.$localPort',
              style: tokens.mono(fontSize: 10, color: tokens.textMuted),
            ),
            const SizedBox(width: 4),
            Icon(
              isSource ? LucideIcons.arrowRight : LucideIcons.arrowLeft,
              size: 10,
              color: tokens.textMuted,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$remotePath.$remotePort',
                style: tokens.inter(fontSize: 10, color: tokens.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (valueStr != null) ...[
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: tokens.surfaceWell,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                valueStr,
                style: tokens.mono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: tokens.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  static String _fmt(dynamic v) {
    if (v == null) return 'null';
    if (v is double) return v.toStringAsFixed(2);
    final s = '$v';
    return s.length > 20 ? '${s.substring(0, 20)}…' : s;
  }
}

// =============================================================================
// Linked port pill — shows value + link icon on input or output ports
// =============================================================================

class _LinkedPortPill extends StatelessWidget {
  final String? value;
  final String tooltip;
  final bool isInput;
  final double zoom;

  const _LinkedPortPill({
    required this.value,
    required this.tooltip,
    required this.isInput,
    required this.zoom,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = (10 * zoom).clamp(7.0, 13.0);
    final scale = zoom.clamp(0.5, 1.3);

    return Transform.scale(
      scale: scale,
      alignment: isInput ? Alignment.centerRight : Alignment.centerLeft,
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: (editorIsDark
                    ? RubixTokens.surfaceMatte
                    : RubixTokens.lightSurfaceMatte)
                .withAlpha(230),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: RubixTokens.accentCool.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.link, size: fontSize * 0.8,
                  color: RubixTokens.accentCool),
              const SizedBox(width: 3),
              Text(
                value ?? '—',
                style: RubixTokens.mono(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: editorIsDark
                      ? RubixTokens.inkPrimary
                      : RubixTokens.lightInkPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
