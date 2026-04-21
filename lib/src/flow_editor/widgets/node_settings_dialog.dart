import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';

/// Dialog that renders a settings form from a JSON Schema and current values.
///
/// Supports: string, string+enum, integer, number, boolean, array+enum (multi-select).
/// Supports cascading fields via `allOf[{if/then}]`.
/// Displays `x-warnings` from the runtime as validation messages.
///
/// Dynamic fields like node-pickers are resolved server-side — the runtime
/// populates enum values before sending the schema, so the UI just renders
/// normal widgets.
/// Result from the settings dialog — settings + optional label change.
class NodeSettingsResult {
  final Map<String, dynamic> settings;
  final String? label;

  const NodeSettingsResult({required this.settings, this.label});
}

class NodeSettingsDialog extends StatefulWidget {
  final String nodeId;
  final String nodeType;
  final Map<String, dynamic> schema;
  final Map<String, dynamic> currentSettings;
  final String? currentLabel;

  const NodeSettingsDialog({
    super.key,
    required this.nodeId,
    required this.nodeType,
    required this.schema,
    required this.currentSettings,
    this.currentLabel,
  });

  /// Show the dialog and return updated settings + label, or null if cancelled.
  static Future<NodeSettingsResult?> show(
    BuildContext context, {
    required String nodeId,
    required String nodeType,
    required Map<String, dynamic> schema,
    required Map<String, dynamic> currentSettings,
    String? currentLabel,
  }) {
    return showDialog<NodeSettingsResult>(
      context: context,
      builder: (_) => NodeSettingsDialog(
        nodeId: nodeId,
        nodeType: nodeType,
        schema: schema,
        currentSettings: currentSettings,
        currentLabel: currentLabel,
      ),
    );
  }

  @override
  State<NodeSettingsDialog> createState() => _NodeSettingsDialogState();
}

class _NodeSettingsDialogState extends State<NodeSettingsDialog> {
  late Map<String, dynamic> _values;
  late String _label;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.currentSettings);
    _label = widget.currentLabel ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final properties = _visibleProperties();
    final rawWarnings = widget.schema['x-warnings'];
    final warnings = rawWarnings is List ? rawWarnings : null;

    return AlertDialog(
      backgroundColor: RubixTokens.surfaceMatte,
      title: Row(
        children: [
          const Icon(Icons.settings, size: 20, color: RubixTokens.inkSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.nodeType,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Node label — always shown
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  initialValue: _label,
                  decoration: const InputDecoration(
                    labelText: 'Label',
                    helperText: 'Custom name for this node',
                    hintText: 'e.g. AHU-1 Supply Temp',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: RubixTokens.surfaceWell,
                  ),
                  onChanged: (v) => _label = v,
                ),
              ),
              // Validation warnings from the runtime
              if (warnings != null && warnings.isNotEmpty) ...[
                for (final w in warnings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.warning_amber,
                            size: 16, color: RubixTokens.statusWarning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            w.toString(),
                            style: const TextStyle(
                              color: RubixTokens.statusWarning,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(color: RubixTokens.ghostBorderDark),
                const SizedBox(height: 4),
              ],
              // Fields
              if (properties.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No configurable settings for this node.',
                    style: TextStyle(color: RubixTokens.inkMuted),
                  ),
                )
              else
                ...properties.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildField(e.key, e.value),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            NodeSettingsResult(
              settings: _values,
              label: _label.isNotEmpty ? _label : null,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  /// Collect base properties + any conditional properties whose `if` matches.
  Map<String, Map<String, dynamic>> _visibleProperties() {
    final props = <String, Map<String, dynamic>>{};
    final schemaProps =
        widget.schema['properties'] as Map<String, dynamic>? ?? {};

    for (final entry in schemaProps.entries) {
      props[entry.key] = Map<String, dynamic>.from(entry.value as Map);
    }

    final allOf = widget.schema['allOf'] as List<dynamic>? ?? [];
    for (final rule in allOf) {
      final ruleMap = rule as Map<String, dynamic>;
      final ifBlock = ruleMap['if'] as Map<String, dynamic>?;
      final thenBlock = ruleMap['then'] as Map<String, dynamic>?;
      if (ifBlock == null || thenBlock == null) continue;

      if (_evaluateIf(ifBlock)) {
        final thenProps =
            thenBlock['properties'] as Map<String, dynamic>? ?? {};
        for (final entry in thenProps.entries) {
          props[entry.key] = Map<String, dynamic>.from(entry.value as Map);
        }
      }
    }

    return props;
  }

  bool _evaluateIf(Map<String, dynamic> ifBlock) {
    final ifProps = ifBlock['properties'] as Map<String, dynamic>? ?? {};
    for (final entry in ifProps.entries) {
      final constraint = entry.value as Map<String, dynamic>;
      final constVal = constraint['const'];
      if (constVal != null && _values[entry.key] != constVal) {
        return false;
      }
    }
    return true;
  }

  Widget _buildField(String key, Map<String, dynamic> propSchema) {
    final type = propSchema['type'] as String? ?? 'string';
    final title = propSchema['title'] as String? ?? key;
    final description = propSchema['description'] as String?;
    final enumValues = propSchema['enum'] as List<dynamic>?;
    final enumLabels = propSchema['x-enum-labels'] as List<dynamic>?;
    final xWidget = propSchema['x-widget'] as String?;
    final placeholder = propSchema['x-placeholder'] as String?;

    // Array
    if (type == 'array') {
      final items = propSchema['items'] as Map<String, dynamic>?;
      if (items != null) {
        final itemEnum = items['enum'] as List<dynamic>?;
        final itemLabels = items['x-enum-labels'] as List<dynamic>?;
        if (itemEnum != null) {
          return _buildMultiSelect(
              key, title, description, itemEnum, itemLabels);
        }
        // Array of objects -> list with add/remove
        if (items['type'] == 'object') {
          return _buildObjectArray(key, title, description, items);
        }
      }
    }

    // Nested object -> grouped section
    if (type == 'object') {
      return _buildNestedObject(key, title, description, propSchema);
    }

    // Time picker
    if (xWidget == 'time') {
      return _buildTimePicker(key, title, description, placeholder);
    }

    // Datetime picker
    if (xWidget == 'datetime') {
      return _buildDateTimePicker(key, title, description);
    }

    // Enum -> dropdown
    if (enumValues != null) {
      return _buildDropdown(
          key, title, description, enumValues, enumLabels, type);
    }

    // Boolean -> switch
    if (type == 'boolean') {
      return _buildSwitch(key, title, description, propSchema);
    }

    // Number / integer -> numeric input
    if (type == 'integer' || type == 'number') {
      return _buildNumericField(key, title, description, propSchema);
    }

    // String (or password)
    return _buildTextField(
        key, title, description, placeholder, xWidget == 'password');
  }

  // ---------------------------------------------------------------------------
  // Array of objects — list with add/remove
  // ---------------------------------------------------------------------------

  Widget _buildObjectArray(
    String key,
    String title,
    String? description,
    Map<String, dynamic> itemSchema,
  ) {
    final raw = _values[key];
    final items = List<Map<String, dynamic>>.from(
      raw is List ? raw.map((e) => Map<String, dynamic>.from(e as Map)) : [],
    );
    final itemProps =
        itemSchema['properties'] as Map<String, dynamic>? ?? {};

    return _Section(
      title: title,
      description: description,
      trailing: IconButton(
        icon: const Icon(Icons.add, size: 18),
        tooltip: 'Add',
        onPressed: () {
          setState(() {
            // Create new item with defaults from schema
            final newItem = <String, dynamic>{};
            for (final entry in itemProps.entries) {
              final prop = entry.value as Map<String, dynamic>;
              if (prop.containsKey('default')) {
                newItem[entry.key] = prop['default'];
              }
            }
            items.add(newItem);
            _values[key] = items;
          });
        },
      ),
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('None added yet.',
                  style: TextStyle(color: RubixTokens.inkMuted, fontSize: 12)),
            )
          : Column(
              children: List.generate(items.length, (i) {
                return _ObjectArrayItem(
                  index: i,
                  itemCount: items.length,
                  item: items[i],
                  itemSchema: itemSchema,
                  onChanged: (updated) {
                    setState(() {
                      items[i] = updated;
                      _values[key] = items;
                    });
                  },
                  onRemove: () {
                    setState(() {
                      items.removeAt(i);
                      _values[key] = items;
                    });
                  },
                  onMoveUp: i > 0
                      ? () {
                          setState(() {
                            final item = items.removeAt(i);
                            items.insert(i - 1, item);
                            _values[key] = items;
                          });
                        }
                      : null,
                  onMoveDown: i < items.length - 1
                      ? () {
                          setState(() {
                            final item = items.removeAt(i);
                            items.insert(i + 1, item);
                            _values[key] = items;
                          });
                        }
                      : null,
                  buildField: _buildFieldForValue,
                );
              }),
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // Nested object — grouped section with sub-fields
  // ---------------------------------------------------------------------------

  Widget _buildNestedObject(
    String key,
    String title,
    String? description,
    Map<String, dynamic> propSchema,
  ) {
    final objProps = propSchema['properties'] as Map<String, dynamic>? ?? {};
    final objValues = Map<String, dynamic>.from(
      _values[key] is Map ? _values[key] as Map : {},
    );

    return _Section(
      title: title,
      description: description,
      child: Column(
        children: objProps.entries.map((entry) {
          final subKey = entry.key;
          final subSchema = Map<String, dynamic>.from(entry.value as Map);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildFieldForValue(
              subKey,
              subSchema,
              objValues,
              (newObjValues) {
                setState(() {
                  _values[key] = newObjValues;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Time picker (x-widget: 'time') — HH:MM
  // ---------------------------------------------------------------------------

  Widget _buildTimePicker(
    String key,
    String title,
    String? description,
    String? placeholder,
  ) {
    final current = _values[key]?.toString() ?? '';

    return TextFormField(
      initialValue: current,
      decoration: InputDecoration(
        labelText: title,
        helperText: description,
        hintText: placeholder ?? 'HH:MM',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: RubixTokens.surfaceWell,
        suffixIcon: IconButton(
          icon: const Icon(Icons.access_time, size: 18),
          onPressed: () async {
            final parts = current.split(':');
            final initial = TimeOfDay(
              hour: int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 8,
              minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
            );
            final picked = await showTimePicker(
              context: context,
              initialTime: initial,
            );
            if (picked != null) {
              final formatted =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              setState(() => _values[key] = formatted);
            }
          },
        ),
      ),
      onChanged: (v) => _values[key] = v,
    );
  }

  // ---------------------------------------------------------------------------
  // Datetime picker (x-widget: 'datetime') — ISO 8601
  // ---------------------------------------------------------------------------

  Widget _buildDateTimePicker(
    String key,
    String title,
    String? description,
  ) {
    final current = _values[key]?.toString() ?? '';
    DateTime? parsed;
    try {
      parsed = DateTime.parse(current);
    } catch (_) {}

    final displayText = parsed != null
        ? '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} '
            '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}'
        : current;

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: parsed ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2040),
        );
        if (date == null || !mounted) return;

        final time = await showTimePicker(
          context: context,
          initialTime: parsed != null
              ? TimeOfDay.fromDateTime(parsed)
              : const TimeOfDay(hour: 0, minute: 0),
        );
        if (time == null) return;

        final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() => _values[key] = dt.toIso8601String());
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: title,
          helperText: description,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: RubixTokens.surfaceWell,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          displayText.isNotEmpty ? displayText : 'Tap to select',
          style: TextStyle(
            color: displayText.isNotEmpty ? RubixTokens.inkPrimary : RubixTokens.inkMuted,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Generic field builder for nested values (arrays/objects)
  // ---------------------------------------------------------------------------

  Widget _buildFieldForValue(
    String key,
    Map<String, dynamic> propSchema,
    Map<String, dynamic> values,
    void Function(Map<String, dynamic> updated) onChanged,
  ) {
    final type = propSchema['type'] as String? ?? 'string';
    final title = propSchema['title'] as String? ?? key;
    final description = propSchema['description'] as String?;
    final enumValues = propSchema['enum'] as List<dynamic>?;
    final enumLabels = propSchema['x-enum-labels'] as List<dynamic>?;
    final xWidget = propSchema['x-widget'] as String?;
    final placeholder = propSchema['x-placeholder'] as String?;

    // Recursive: array of objects
    if (type == 'array') {
      final items = propSchema['items'] as Map<String, dynamic>?;
      if (items != null && items['type'] == 'object') {
        final raw = values[key];
        final list = List<Map<String, dynamic>>.from(
          raw is List
              ? raw.map((e) => Map<String, dynamic>.from(e as Map))
              : [],
        );
        final itemProps = items['properties'] as Map<String, dynamic>? ?? {};

        return _Section(
          title: title,
          description: description,
          trailing: IconButton(
            icon: const Icon(Icons.add, size: 18),
            tooltip: 'Add',
            onPressed: () {
              final newItem = <String, dynamic>{};
              for (final entry in itemProps.entries) {
                final prop = entry.value as Map<String, dynamic>;
                if (prop.containsKey('default')) {
                  newItem[entry.key] = prop['default'];
                }
              }
              list.add(newItem);
              values[key] = list;
              onChanged(Map<String, dynamic>.from(values));
            },
          ),
          child: list.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text('None',
                      style: TextStyle(color: RubixTokens.inkMuted, fontSize: 12)),
                )
              : Column(
                  children: List.generate(list.length, (i) {
                    return _ObjectArrayItem(
                      index: i,
                      itemCount: list.length,
                      item: list[i],
                      itemSchema: items,
                      onChanged: (updated) {
                        list[i] = updated;
                        values[key] = list;
                        onChanged(Map<String, dynamic>.from(values));
                      },
                      onRemove: () {
                        list.removeAt(i);
                        values[key] = list;
                        onChanged(Map<String, dynamic>.from(values));
                      },
                      onMoveUp: i > 0
                          ? () {
                              final item = list.removeAt(i);
                              list.insert(i - 1, item);
                              values[key] = list;
                              onChanged(Map<String, dynamic>.from(values));
                            }
                          : null,
                      onMoveDown: i < list.length - 1
                          ? () {
                              final item = list.removeAt(i);
                              list.insert(i + 1, item);
                              values[key] = list;
                              onChanged(Map<String, dynamic>.from(values));
                            }
                          : null,
                      buildField: _buildFieldForValue,
                    );
                  }),
                ),
        );
      }
    }

    // Recursive: nested object
    if (type == 'object') {
      final objProps = propSchema['properties'] as Map<String, dynamic>? ?? {};
      final objValues = Map<String, dynamic>.from(
        values[key] is Map ? values[key] as Map : {},
      );

      return _Section(
        title: title,
        description: description,
        child: Column(
          children: objProps.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildFieldForValue(
                entry.key,
                Map<String, dynamic>.from(entry.value as Map),
                objValues,
                (updated) {
                  values[key] = updated;
                  onChanged(Map<String, dynamic>.from(values));
                },
              ),
            );
          }).toList(),
        ),
      );
    }

    // --- Leaf fields ---

    if (xWidget == 'time') {
      final current = values[key]?.toString() ?? '';
      return TextFormField(
        key: ValueKey('$key-$current'),
        initialValue: current,
        decoration: InputDecoration(
          labelText: title,
          helperText: description,
          hintText: placeholder ?? 'HH:MM',
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: RubixTokens.surfaceWell,
        ),
        onChanged: (v) {
          values[key] = v;
          onChanged(Map<String, dynamic>.from(values));
        },
      );
    }

    if (xWidget == 'datetime') {
      final current = values[key]?.toString() ?? '';
      DateTime? parsed;
      try {
        parsed = DateTime.parse(current);
      } catch (_) {}
      final display = parsed != null
          ? '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} '
              '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}'
          : '';

      return InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: parsed ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2040),
          );
          if (date == null || !mounted) return;
          final time = await showTimePicker(
            context: context,
            initialTime: parsed != null
                ? TimeOfDay.fromDateTime(parsed)
                : const TimeOfDay(hour: 0, minute: 0),
          );
          if (time == null) return;
          final dt = DateTime(
              date.year, date.month, date.day, time.hour, time.minute);
          values[key] = dt.toIso8601String();
          onChanged(Map<String, dynamic>.from(values));
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: title,
            helperText: description,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: RubixTokens.surfaceWell,
            suffixIcon: const Icon(Icons.calendar_today, size: 18),
          ),
          child: Text(
            display.isNotEmpty ? display : 'Tap to select',
            style: TextStyle(
              color: display.isNotEmpty ? RubixTokens.inkPrimary : RubixTokens.inkMuted,
            ),
          ),
        ),
      );
    }

    if (enumValues != null) {
      dynamic current = values[key];
      if (current != null && !enumValues.contains(current)) current = null;

      return DropdownButtonFormField<dynamic>(
        value: current,
        decoration: InputDecoration(
          labelText: title,
          helperText: description,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: RubixTokens.surfaceWell,
        ),
        dropdownColor: RubixTokens.surfaceMatte,
        items: enumValues.asMap().entries.map((e) {
          final label = (enumLabels != null && e.key < enumLabels.length)
              ? enumLabels[e.key].toString()
              : e.value.toString();
          return DropdownMenuItem(value: e.value, child: Text(label));
        }).toList(),
        onChanged: (v) {
          values[key] = v;
          onChanged(Map<String, dynamic>.from(values));
        },
      );
    }

    if (type == 'boolean') {
      final defaultVal = propSchema['default'] as bool? ?? false;
      final current = values[key] as bool? ?? defaultVal;
      return SwitchListTile(
        dense: true,
        title: Text(title),
        subtitle: description != null ? Text(description) : null,
        value: current,
        contentPadding: EdgeInsets.zero,
        onChanged: (v) {
          values[key] = v;
          onChanged(Map<String, dynamic>.from(values));
        },
      );
    }

    if (type == 'integer' || type == 'number') {
      final defaultVal = propSchema['default'];
      final currentVal = values[key] ?? defaultVal;
      return TextFormField(
        key: ValueKey('$key-$currentVal'),
        initialValue: currentVal?.toString() ?? '',
        decoration: InputDecoration(
          labelText: title,
          helperText: description,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: RubixTokens.surfaceWell,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v) {
          if (v.isEmpty) {
            values.remove(key);
          } else {
            final parsed = num.tryParse(v);
            if (parsed != null) {
              values[key] = type == 'integer' ? parsed.toInt() : parsed;
            }
          }
          onChanged(Map<String, dynamic>.from(values));
        },
      );
    }

    // String (default)
    return TextFormField(
      key: ValueKey('$key-${values[key]}'),
      initialValue: (values[key] ?? '').toString(),
      decoration: InputDecoration(
        labelText: title,
        helperText: description,
        hintText: placeholder,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: RubixTokens.surfaceWell,
      ),
      obscureText: xWidget == 'password',
      onChanged: (v) {
        values[key] = v;
        onChanged(Map<String, dynamic>.from(values));
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Multi-select (array + items.enum) — checkbox list
  // ---------------------------------------------------------------------------

  Widget _buildMultiSelect(
    String key,
    String title,
    String? description,
    List<dynamic> enumValues,
    List<dynamic>? enumLabels,
  ) {
    // Handle existing values that might be a string instead of a list
    final raw = _values[key];
    final selected = List<dynamic>.from(
      raw is List ? raw : (raw != null ? [raw] : []),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: RubixTokens.inkPrimary, fontSize: 12)),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: Text(description,
                style: const TextStyle(color: RubixTokens.inkMuted, fontSize: 11)),
          ),
        if (enumValues.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('None available — create one first',
                style: TextStyle(color: RubixTokens.inkMuted, fontSize: 12)),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: RubixTokens.surfaceWell,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: RubixTokens.ghostBorderDark),
            ),
            child: Column(
              children: enumValues.asMap().entries.map((e) {
                final value = e.value;
                final label = (enumLabels != null && e.key < enumLabels.length)
                    ? enumLabels[e.key].toString()
                    : value.toString();
                final isSelected = selected.contains(value);

                return CheckboxListTile(
                  dense: true,
                  title: Text(label, style: const TextStyle(fontSize: 13)),
                  value: isSelected,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selected.add(value);
                      } else {
                        selected.remove(value);
                      }
                      _values[key] = selected;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Single-value fields
  // ---------------------------------------------------------------------------

  Widget _buildTextField(
    String key,
    String title,
    String? description,
    String? placeholder,
    bool obscure,
  ) {
    return TextFormField(
      initialValue: (_values[key] ?? '').toString(),
      decoration: InputDecoration(
        labelText: title,
        helperText: description,
        hintText: placeholder,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: RubixTokens.surfaceWell,
      ),
      obscureText: obscure,
      onChanged: (v) => _values[key] = v,
    );
  }

  Widget _buildNumericField(
    String key,
    String title,
    String? description,
    Map<String, dynamic> propSchema,
  ) {
    final defaultVal = propSchema['default'];
    final currentVal = _values[key] ?? defaultVal;

    return TextFormField(
      initialValue: currentVal?.toString() ?? '',
      decoration: InputDecoration(
        labelText: title,
        helperText: description,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: RubixTokens.surfaceWell,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (v) {
        if (v.isEmpty) {
          _values.remove(key);
        } else {
          final parsed = num.tryParse(v);
          if (parsed != null) {
            _values[key] =
                propSchema['type'] == 'integer' ? parsed.toInt() : parsed;
          }
        }
      },
    );
  }

  Widget _buildSwitch(
    String key,
    String title,
    String? description,
    Map<String, dynamic> propSchema,
  ) {
    final defaultVal = propSchema['default'] as bool? ?? false;
    final current = _values[key] as bool? ?? defaultVal;

    return SwitchListTile(
      title: Text(title),
      subtitle: description != null ? Text(description) : null,
      value: current,
      contentPadding: EdgeInsets.zero,
      onChanged: (v) => setState(() => _values[key] = v),
    );
  }

  Widget _buildDropdown(
    String key,
    String title,
    String? description,
    List<dynamic> enumValues,
    List<dynamic>? enumLabels,
    String type,
  ) {
    dynamic current = _values[key];

    if (current != null && !enumValues.contains(current)) {
      if (type == 'integer') {
        final asInt = current is int ? current : int.tryParse('$current');
        if (asInt != null && enumValues.contains(asInt)) {
          current = asInt;
        } else {
          current = null;
        }
      } else {
        current = null;
      }
    }

    return DropdownButtonFormField<dynamic>(
      initialValue: current,
      decoration: InputDecoration(
        labelText: title,
        helperText: description,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: RubixTokens.surfaceWell,
      ),
      dropdownColor: RubixTokens.surfaceMatte,
      items: enumValues.asMap().entries.map((e) {
        final label = (enumLabels != null && e.key < enumLabels.length)
            ? enumLabels[e.key].toString()
            : e.value.toString();
        return DropdownMenuItem(value: e.value, child: Text(label));
      }).toList(),
      onChanged: (v) => setState(() => _values[key] = v),
    );
  }
}

// =============================================================================
// Reusable helpers — generic, not tied to any node type.
// =============================================================================

/// Collapsible section header with optional trailing action (e.g. + Add button).
class _Section extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;
  final Widget child;

  const _Section({
    required this.title,
    this.description,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: RubixTokens.inkPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  if (description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(description!,
                          style: const TextStyle(
                              color: RubixTokens.inkMuted, fontSize: 11)),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: child,
        ),
      ],
    );
  }
}

/// A single item in an object array — card with fields, reorder, and remove.
class _ObjectArrayItem extends StatelessWidget {
  final int index;
  final int itemCount;
  final Map<String, dynamic> item;
  final Map<String, dynamic> itemSchema;
  final void Function(Map<String, dynamic> updated) onChanged;
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final Widget Function(
    String key,
    Map<String, dynamic> propSchema,
    Map<String, dynamic> values,
    void Function(Map<String, dynamic> updated) onChanged,
  ) buildField;

  const _ObjectArrayItem({
    required this.index,
    this.itemCount = 1,
    required this.item,
    required this.itemSchema,
    required this.onChanged,
    required this.onRemove,
    this.onMoveUp,
    this.onMoveDown,
    required this.buildField,
  });

  @override
  Widget build(BuildContext context) {
    final props = itemSchema['properties'] as Map<String, dynamic>? ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RubixTokens.surfaceWell,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: RubixTokens.ghostBorderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with index + reorder + remove
          Row(
            children: [
              Text('#${index + 1}',
                  style: const TextStyle(
                      color: RubixTokens.inkMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              if (onMoveUp != null)
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 14, color: RubixTokens.inkMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Move up',
                  onPressed: onMoveUp,
                ),
              if (onMoveDown != null)
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 14, color: RubixTokens.inkMuted),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Move down',
                  onPressed: onMoveDown,
                ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.close, size: 16, color: RubixTokens.inkMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Remove',
                onPressed: onRemove,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Fields
          ...props.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: buildField(
                entry.key,
                Map<String, dynamic>.from(entry.value as Map),
                item,
                onChanged,
              ),
            );
          }),
        ],
      ),
    );
  }
}
