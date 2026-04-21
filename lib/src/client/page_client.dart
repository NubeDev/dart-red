import 'package:dio/dio.dart';

/// REST client for runtime dashboard pages.
class PageClient {
  final Dio _dio;

  PageClient(this._dio);

  /// Get all pages with their widgets and current values.
  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _dio.get('/api/v1/pages');
    final data = res.data as Map<String, dynamic>;
    final pages = data['pages'] as List<dynamic>;
    return pages.cast<Map<String, dynamic>>();
  }
}
