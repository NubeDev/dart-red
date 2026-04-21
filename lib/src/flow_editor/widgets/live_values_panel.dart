import 'package:fl_nodes/fl_nodes.dart';
import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Floating panel that shows live values polled from the runtime daemon.
class LiveValuesPanel extends StatelessWidget {
  final Map<String, String> nodeIdMap;
  final Map<String, dynamic> liveValues;
  final Map<String, String> liveStatuses;
  final FlNodeEditorController controller;

  const LiveValuesPanel({
    super.key,
    required this.nodeIdMap,
    required this.liveValues,
    required this.liveStatuses,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (liveValues.isEmpty) return const SizedBox.shrink();
    final tokens = RubixTokens.of(context);

    return Container(
      width: 280,
      constraints: const BoxConstraints(maxHeight: 400),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(RubixTokens.radiusCard),
        boxShadow: tokens.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'LIVE VALUES',
              style: tokens.mono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: tokens.textMuted,
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: nodeIdMap.entries.map((entry) {
                final flId = entry.key;
                final rtId = entry.value;
                final value = liveValues[rtId];
                final status = liveStatuses[rtId] ?? 'unknown';

                final flNode = controller.project.projectData.nodes[flId];
                final typeName = flNode?.prototype.idName ?? '?';

                final statusColor = switch (status) {
                  'ok' => RubixTokens.statusSuccess,
                  'stale' => RubixTokens.statusWarning,
                  'error' => RubixTokens.statusError,
                  _ => tokens.textMuted,
                };

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Expanded(
                        child: Text(
                          typeName,
                          style: tokens.inter(fontSize: 11, color: tokens.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: Spacing.xs),
                      Flexible(
                        child: _ValueDisplay(value: value),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueDisplay extends StatelessWidget {
  final dynamic value;
  const _ValueDisplay({required this.value});

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    if (value == null) {
      return Text(
        '—',
        style: tokens.mono(fontSize: 12, color: tokens.textMuted),
        textAlign: TextAlign.right,
      );
    }

    if (value is Map) {
      final map = value as Map;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: map.entries.map((e) {
          return Text(
            '${e.key}: ${_formatValue(e.value)}',
            style: tokens.mono(fontSize: 11, color: tokens.textPrimary),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          );
        }).toList(),
      );
    }

    return Text(
      _formatValue(value),
      style: tokens.mono(fontSize: 12, fontWeight: FontWeight.w600),
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
    );
  }

  static String _formatValue(dynamic v) {
    if (v == null) return 'null';
    if (v is double) return v.toStringAsFixed(2);
    return '$v';
  }
}
