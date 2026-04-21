import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Result from the Add Widget dialog.
class AddWidgetResult {
  final String nodeType;
  final String widgetType;
  final Map<String, dynamic> extraSettings;

  const AddWidgetResult({
    required this.nodeType,
    required this.widgetType,
    this.extraSettings = const {},
  });
}

/// Two-step dialog: pick widget category/type, then configure.
class AddWidgetDialog extends StatefulWidget {
  const AddWidgetDialog({super.key});

  static Future<AddWidgetResult?> show(BuildContext context) {
    return showDialog<AddWidgetResult>(
      context: context,
      builder: (_) => const AddWidgetDialog(),
    );
  }

  @override
  State<AddWidgetDialog> createState() => _AddWidgetDialogState();
}

class _AddWidgetDialogState extends State<AddWidgetDialog> {
  static const _categories = <String, List<_WidgetOption>>{
    'DISPLAY': [
      _WidgetOption('Gauge', 'ui.display', 'gauge', LucideIcons.gauge),
      _WidgetOption('Label', 'ui.display', 'label', LucideIcons.type),
      _WidgetOption('LED', 'ui.display', 'led', LucideIcons.circle),
    ],
    'INPUT': [
      _WidgetOption('Slider', 'ui.source', 'slider', LucideIcons.sliders),
      _WidgetOption('Toggle', 'ui.source', 'toggle', LucideIcons.toggleRight),
      _WidgetOption('Button', 'ui.source', 'button', LucideIcons.mousePointerClick),
    ],
    'HISTORY': [
      _WidgetOption('Chart', 'history.display', 'chart', LucideIcons.lineChart),
      _WidgetOption('Sparkline', 'history.display', 'sparkline', LucideIcons.activity),
    ],
    'SCHEDULE': [
      _WidgetOption('Status', 'schedule.display', 'status', LucideIcons.calendarCheck),
      _WidgetOption('Label', 'schedule.display', 'label', LucideIcons.tag),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(LucideIcons.layoutGrid, color: RubixTokens.accentCool, size: 20),
          const SizedBox(width: Spacing.xs),
          Text('Add Widget', style: tokens.heading(fontSize: 18)),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final entry in _categories.entries) ...[
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.sm, bottom: Spacing.xs),
                  child: Text(
                    entry.key,
                    style: tokens.mono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: tokens.textMuted,
                    ),
                  ),
                ),
                Wrap(
                  spacing: Spacing.xs,
                  runSpacing: Spacing.xs,
                  children: entry.value
                      .map((opt) => _OptionChip(
                            option: opt,
                            onTap: () => _select(opt),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  void _select(_WidgetOption opt) {
    Navigator.pop(
      context,
      AddWidgetResult(
        nodeType: opt.nodeType,
        widgetType: opt.widgetType,
      ),
    );
  }
}

class _WidgetOption {
  final String label;
  final String nodeType;
  final String widgetType;
  final IconData icon;

  const _WidgetOption(this.label, this.nodeType, this.widgetType, this.icon);
}

class _OptionChip extends StatelessWidget {
  final _WidgetOption option;
  final VoidCallback onTap;

  const _OptionChip({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return Material(
      color: tokens.surfaceBright,
      borderRadius: BorderRadius.circular(RubixTokens.radiusPill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RubixTokens.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(option.icon, size: 16, color: RubixTokens.accentCool),
              const SizedBox(width: 6),
              Text(option.label,
                  style: tokens.inter(fontSize: 13, color: tokens.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
