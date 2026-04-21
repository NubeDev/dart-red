import 'package:dio/dio.dart';

/// REST client for the runtime flow.
class FlowClient {
  final Dio _dio;

  FlowClient(this._dio);

  /// Get the full flow state: flow metadata + all nodes + all edges.
  Future<Map<String, dynamic>> get() async {
    final res = await _dio.get('/api/v1/flow');
    return res.data as Map<String, dynamic>;
  }

  /// Update flow metadata.
  Future<void> update({String? name}) async {
    await _dio.put('/api/v1/flow', data: {
      if (name != null) 'name': name,
    });
  }

  /// Enable the flow (start the runtime).
  Future<void> enable() async {
    await _dio.post('/api/v1/flow/enable');
  }

  /// Disable the flow (stop the runtime).
  Future<void> disable() async {
    await _dio.post('/api/v1/flow/disable');
  }
}
