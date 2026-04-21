import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

import 'package:dart_red/src/client/runtime_client.dart';
import '../nodes/styles/headers.dart' show colorForDomain;
import '../nodes/styles/node_icons.dart';

/// Node palette sidebar — built dynamically from GET /api/v1/palette.
///
/// Tonal surface panel, items are transparent with hover shifts.
class NodePalette extends StatelessWidget {
  final FlNodeEditorController controller;
  final List<PaletteEntry> palette;

  const NodePalette({
    super.key,
    required this.controller,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    // Group by domain
    final grouped = <String, List<PaletteEntry>>{};
    for (final entry in palette) {
      grouped.putIfAbsent(entry.domain, () => []).add(entry);
    }

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: tokens.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'NODES',
              style: RubixTokens.mono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: tokens.textMuted,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: grouped.entries.map((group) {
                // Use the first entry's icon as the category/domain icon
                final domainIcon = group.value.isNotEmpty
                    ? resolveNodeIcon(group.value.first.icon)
                    : null;
                return _PaletteSection(
                  title: group.key.toUpperCase(),
                  color: colorForDomain(group.key),
                  icon: domainIcon,
                  items: group.value
                      .map((e) =>
                          _PaletteItem(entry: e, controller: controller))
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteSection extends StatelessWidget {
  final String title;
  final Color color;
  final IconData? icon;
  final List<_PaletteItem> items;

  const _PaletteSection({
    required this.title,
    required this.color,
    this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Row(
            children: [
              if (icon != null)
                Icon(icon, size: 12, color: color)
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                title,
                style: RubixTokens.mono(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        ...items,
      ],
    );
  }
}

class _PaletteItem extends StatefulWidget {
  final PaletteEntry entry;
  final FlNodeEditorController controller;

  const _PaletteItem({required this.entry, required this.controller});

  @override
  State<_PaletteItem> createState() => _PaletteItemState();
}

class _PaletteItemState extends State<_PaletteItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);
    final label = widget.entry.type.split('.').last;
    final icon = resolveNodeIcon(widget.entry.icon);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.controller.addNode(widget.entry.type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? tokens.surfaceBright : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: _hovered ? tokens.textSecondary : tokens.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: RubixTokens.inter(
                    fontSize: 12,
                    fontWeight: _hovered ? FontWeight.w500 : FontWeight.w400,
                    color: _hovered
                        ? tokens.textPrimary
                        : tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
