import 'package:dio/dio.dart';

/// REST client for portless links (hidden edges) — list, create, delete.
///
/// Links are runtime edges with `hidden: true`.  They connect nodes across
/// scopes without drawing a wire on the canvas.  Creation and deletion go
/// through the normal edge endpoints with the hidden flag set.
class LinkClient {
  final Dio _dio;

  LinkClient(this._dio);

  /// List all links (hidden edges) with enriched labels and paths.
  Future<List<Map<String, dynamic>>> list() async {
    final res = await _dio.get('/api/v1/links');
    final data = res.data as Map<String, dynamic>;
    return (data['links'] as List).cast<Map<String, dynamic>>();
  }

  /// Create a link (hidden edge). Returns the new edge ID.
  Future<String> create({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
  }) async {
    final res = await _dio.post('/api/v1/edges', data: {
      'sourceNodeId': sourceNodeId,
      'sourcePort': sourcePort,
      'targetNodeId': targetNodeId,
      'targetPort': targetPort,
      'hidden': true,
    });
    return res.data['id'] as String;
  }

  /// Delete a link (delegates to edge delete).
  Future<void> delete(String id) async {
    await _dio.delete('/api/v1/edges/$id');
  }
}
