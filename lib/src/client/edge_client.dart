import 'package:dio/dio.dart';

/// REST client for runtime edges — full CRUD.
class EdgeClient {
  final Dio _dio;

  EdgeClient(this._dio);

  /// List all edges in the flow.
  Future<List<Map<String, dynamic>>> list() async {
    final res = await _dio.get('/api/v1/edges');
    final data = res.data as Map<String, dynamic>;
    return (data['edges'] as List).cast<Map<String, dynamic>>();
  }

  /// Get a single edge.
  Future<Map<String, dynamic>> get(String id) async {
    final res = await _dio.get('/api/v1/edges/$id');
    return res.data as Map<String, dynamic>;
  }

  /// Create an edge. Returns the new edge's ID.
  ///
  /// Set [hidden] to `true` for portless links (cross-scope connections
  /// that appear in the Links panel instead of as canvas wires).
  Future<String> create({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
    bool hidden = false,
  }) async {
    final res = await _dio.post('/api/v1/edges', data: {
      'sourceNodeId': sourceNodeId,
      'sourcePort': sourcePort,
      'targetNodeId': targetNodeId,
      'targetPort': targetPort,
      if (hidden) 'hidden': true,
    });
    return res.data['id'] as String;
  }

  /// Delete an edge.
  Future<void> delete(String id) async {
    await _dio.delete('/api/v1/edges/$id');
  }
}
