import 'package:dio/dio.dart';

/// REST client for runtime nodes — full CRUD + value + settings.
class NodeClient {
  final Dio _dio;

  NodeClient(this._dio);

  // ---------------------------------------------------------------------------
  // CRUD
  // ---------------------------------------------------------------------------

  /// List all nodes in the flow.
  Future<List<Map<String, dynamic>>> list() async {
    final res = await _dio.get('/api/v1/nodes');
    final data = res.data as Map<String, dynamic>;
    return (data['nodes'] as List).cast<Map<String, dynamic>>();
  }

  /// Get a single node. If [includeChildren] is true, the response
  /// includes a `childNodes` field with the full subtree.
  Future<Map<String, dynamic>> get(
    String id, {
    bool includeChildren = false,
  }) async {
    final res = await _dio.get(
      '/api/v1/nodes/$id',
      queryParameters: {
        if (includeChildren) 'includeChildren': 'true',
      },
    );
    return res.data as Map<String, dynamic>;
  }

  /// Get direct children of a node (one level).
  Future<List<Map<String, dynamic>>> getChildren(String id) async {
    final res = await _dio.get('/api/v1/nodes/$id/children');
    final data = res.data as Map<String, dynamic>;
    return (data['children'] as List).cast<Map<String, dynamic>>();
  }

  /// Create a node. Returns the new node's ID.
  /// If [parentId] is set, the node is created as a child (containment).
  Future<String> create({
    required String type,
    Map<String, dynamic> settings = const {},
    String? label,
    String? parentId,
    double posX = 0.0,
    double posY = 0.0,
  }) async {
    final res = await _dio.post('/api/v1/nodes', data: {
      'type': type,
      'settings': settings,
      if (label != null) 'label': label,
      if (parentId != null) 'parentId': parentId,
      'posX': posX,
      'posY': posY,
    });
    return res.data['id'] as String;
  }

  /// Update a node's metadata (label, etc).
  /// Pass an empty string or null to clear the label.
  Future<void> update(String id, {String? label}) async {
    await _dio.put('/api/v1/nodes/$id', data: {
      'label': label,
    });
  }

  /// Update a node's canvas position.
  Future<void> updatePosition(String id, double posX, double posY) async {
    await _dio.put('/api/v1/nodes/$id/position', data: {
      'posX': posX,
      'posY': posY,
    });
  }

  /// Delete a node and its edges.
  Future<void> delete(String id) async {
    await _dio.delete('/api/v1/nodes/$id');
  }

  // ---------------------------------------------------------------------------
  // Value
  // ---------------------------------------------------------------------------

  /// Get current output value + status.
  Future<({dynamic value, String status})> getValue(String id) async {
    final res = await _dio.get('/api/v1/nodes/$id/value');
    final data = res.data as Map<String, dynamic>;
    return (value: data['value'], status: data['status'] as String);
  }

  /// Set a node's value (for ui.source, system.variable).
  Future<void> setValue(String id, dynamic value) async {
    await _dio.put('/api/v1/nodes/$id/value', data: {'value': value});
  }

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------

  /// Get a node's current settings.
  Future<Map<String, dynamic>> getSettings(String id) async {
    final res = await _dio.get('/api/v1/nodes/$id/settings');
    final data = res.data as Map<String, dynamic>;
    return data['settings'] as Map<String, dynamic>;
  }

  /// Get the JSON Schema for a node's settings.
  Future<Map<String, dynamic>> getSettingsSchema(String id) async {
    final res = await _dio.get('/api/v1/nodes/$id/settings/schema');
    final data = res.data as Map<String, dynamic>;
    return data['schema'] as Map<String, dynamic>;
  }

  /// Update a node's settings (merge patch).
  Future<void> updateSettings(
      String id, Map<String, dynamic> patch) async {
    await _dio.put('/api/v1/nodes/$id/settings', data: patch);
  }

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  /// Get latest N history samples for a node.
  Future<List<Map<String, dynamic>>> getHistory(String id,
      {int limit = 100}) async {
    final res = await _dio.get('/api/v1/nodes/$id/history',
        queryParameters: {'limit': limit});
    final data = res.data as Map<String, dynamic>;
    return (data['samples'] as List).cast<Map<String, dynamic>>();
  }

  /// Delete all history for a node.
  Future<void> deleteHistory(String id) async {
    await _dio.delete('/api/v1/nodes/$id/history');
  }
}
