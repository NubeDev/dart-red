import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Simple dialog for creating or renaming a page.
class EditPageDialog extends StatefulWidget {
  final String title;
  final String? initialName;

  const EditPageDialog({
    super.key,
    required this.title,
    this.initialName,
  });

  /// Show the dialog and return the entered name, or null if cancelled.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? initialName,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => EditPageDialog(title: title, initialName: initialName),
    );
  }

  @override
  State<EditPageDialog> createState() => _EditPageDialogState();
}

class _EditPageDialogState extends State<EditPageDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      Navigator.pop(context, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    return AlertDialog(
      title: Text(widget.title, style: tokens.heading(fontSize: 17)),
      content: RubixInput(
        controller: _controller,
        label: 'PAGE NAME',
        placeholder: 'e.g. HVAC, Lighting',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        RubixButton.primary(
          onPressed: _submit,
          label: 'Save',
        ),
      ],
    );
  }
}
