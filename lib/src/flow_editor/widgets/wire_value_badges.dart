import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

import '../nodes/styles/editor_theme.dart' show editorIsDark;

/// Shows small pill badges on wires and unconnected output ports with live values.
class WireValueBadges extends StatelessWidget {
  final FlNodeEditorController controller;
  final Map<String, String> nodeIdMap;
  final Map<String, dynamic> liveValues;

  const WireValueBadges({
    super.key,
    required this.controller,
    required this.nodeIdMap,
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
          final badges = _computeBadges(
            constraints.biggest,
            controller.viewportZoom,
            controller.viewportOffset,
          );
          return Stack(children: badges);
        },
      ),
    );
  }

  List<Widget> _computeBadges(Size size, double zoom, Offset vpOffset) {
    final nodes = controller.project.projectData.nodes;
    final links = controller.project.projectData.links;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final badges = <Widget>[];
    final portsWithBadge = <String>{};

    for (final link in links.values) {
      final srcNode = nodes[link.fromTo.from];
      final tgtNode = nodes[link.fromTo.fromPort];
      if (srcNode == null || tgtNode == null) continue;

      final srcPort = srcNode.ports[link.fromTo.to];
      final tgtPort = tgtNode.ports[link.fromTo.toPort];
      if (srcPort == null || tgtPort == null) continue;

      final rtId = nodeIdMap[link.fromTo.from];
      if (rtId == null) continue;
      final value = liveValues[rtId];
      if (value == null) continue;

      final portName = link.fromTo.to;
      final formatted = _getPortValue(value, portName);
      if (formatted == null) continue;

      portsWithBadge.add('${link.fromTo.from}:$portName');

      final srcWorld = srcNode.offset + srcPort.offset;
      final tgtWorld = tgtNode.offset + tgtPort.offset;
      final mid = Offset(
        (srcWorld.dx + tgtWorld.dx) / 2,
        (srcWorld.dy + tgtWorld.dy) / 2,
      );

      final screen = _worldToScreen(mid, cx, cy, zoom, vpOffset);
      final full = _fullValue(value, portName);
      badges.add(_Badge(
        key: ValueKey('wire:${link.id}'),
        position: screen,
        text: formatted,
        fullText: full,
        zoom: zoom,
      ));
    }

    for (final entry in nodeIdMap.entries) {
      final flId = entry.key;
      final rtId = entry.value;
      final node = nodes[flId];
      if (node == null) continue;
      final value = liveValues[rtId];
      if (value == null) continue;

      for (final portEntry in node.ports.entries) {
        final portName = portEntry.key;
        final port = portEntry.value;
        if (port.prototype.direction == FlPortDirection.input) continue;
        if (portsWithBadge.contains('$flId:$portName')) continue;

        final formatted = _getPortValue(value, portName);
        if (formatted == null) continue;

        final portWorld = node.offset + port.offset;
        final badgeWorld = Offset(portWorld.dx + 30, portWorld.dy);
        final screen = _worldToScreen(badgeWorld, cx, cy, zoom, vpOffset);
        final full = _fullValue(value, portName);

        badges.add(_Badge(
          key: ValueKey('port:$flId:$portName'),
          position: screen,
          text: formatted,
          fullText: full,
          zoom: zoom,
        ));
      }
    }

    return badges;
  }

  static Offset _worldToScreen(
      Offset world, double cx, double cy, double zoom, Offset vpOffset) {
    return Offset(
      cx + (world.dx + vpOffset.dx) * zoom,
      cy + (world.dy + vpOffset.dy) * zoom,
    );
  }

  static String? _getPortValue(dynamic value, String portName) {
    if (value is Map) {
      final portVal = value[portName];
      if (portVal == null) return null;
      return _fmt(portVal);
    }
    return _fmt(value);
  }

  static String _fullValue(dynamic value, String portName) {
    if (value is Map) {
      final portVal = value[portName];
      return '$portName: $portVal';
    }
    return '$value';
  }

  static String _fmt(dynamic v) {
    if (v == null) return '';
    if (v is double) return v.toStringAsFixed(1);
    final s = '$v';
    return s.length > 8 ? '${s.substring(0, 8)}…' : s;
  }
}

class _Badge extends StatelessWidget {
  final Offset position;
  final String text;
  final String fullText;
  final double zoom;

  const _Badge({
    super.key,
    required this.position,
    required this.text,
    required this.fullText,
    required this.zoom,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = (10 * zoom).clamp(7.0, 14.0);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Tooltip(
          message: fullText,
          waitDuration: const Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8 * zoom.clamp(0.5, 1.5),
              vertical: 3 * zoom.clamp(0.5, 1.5),
            ),
            decoration: BoxDecoration(
              color: (editorIsDark
                      ? RubixTokens.surfaceMatte
                      : RubixTokens.lightSurfaceMatte)
                  .withAlpha(240),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: RubixTokens.accentCool,
                width: 1.2,
              ),
            ),
            child: Text(
              text,
              style: RubixTokens.mono(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: editorIsDark
                    ? RubixTokens.inkPrimary
                    : RubixTokens.lightInkPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
