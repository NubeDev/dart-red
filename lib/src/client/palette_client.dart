import 'package:dio/dio.dart';

/// A single node type definition from the palette.
class PaletteEntry {
  final String type;
  final String domain;
  final String category;
  final String description;

  /// Lucide icon name for this node type (e.g. 'server', 'gauge', 'cpu').
  final String icon;

  final List<PalettePort> inputs;
  final List<PalettePort> outputs;

  /// JSON Schema for the node's settings. The UI auto-generates
  /// a form from this — supports if/then/else for cascading fields.
  final Map<String, dynamic> settingsSchema;

  const PaletteEntry({
    required this.type,
    required this.domain,
    required this.category,
    required this.description,
    required this.icon,
    required this.inputs,
    required this.outputs,
    required this.settingsSchema,
  });

  factory PaletteEntry.fromJson(Map<String, dynamic> json) {
    return PaletteEntry(
      type: json['type'] as String,
      domain: json['domain'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String? ?? 'circle-dot',
      inputs: (json['inputs'] as List)
          .map((p) => PalettePort.fromJson(p as Map<String, dynamic>))
          .toList(),
      outputs: (json['outputs'] as List)
          .map((p) => PalettePort.fromJson(p as Map<String, dynamic>))
          .toList(),
      settingsSchema:
          (json['settingsSchema'] as Map<String, dynamic>?) ?? {},
    );
  }
}

/// Port definition within a palette entry.
class PalettePort {
  final String name;
  final String type;
  final bool required;
  final dynamic defaultValue;

  const PalettePort({
    required this.name,
    required this.type,
    required this.required,
    this.defaultValue,
  });

  factory PalettePort.fromJson(Map<String, dynamic> json) {
    return PalettePort(
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool? ?? true,
      defaultValue: json['defaultValue'],
    );
  }
}

/// REST client for the node palette — available node types and their ports.
class PaletteClient {
  final Dio _dio;

  PaletteClient(this._dio);

  /// Get all available node types grouped by domain.
  Future<List<PaletteEntry>> getAll() async {
    final res = await _dio.get('/api/v1/palette');
    final data = res.data as Map<String, dynamic>;
    final nodes = data['nodes'] as List<dynamic>;
    return nodes
        .map((n) => PaletteEntry.fromJson(n as Map<String, dynamic>))
        .toList();
  }

  /// Get available node types filtered by domain (mqtt, math, bool, etc.)
  Future<List<PaletteEntry>> getByDomain(String domain) async {
    final all = await getAll();
    return all.where((e) => e.domain == domain).toList();
  }

  /// Get available node types filtered by category (source, transform, sink).
  Future<List<PaletteEntry>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((e) => e.category == category).toList();
  }
}
