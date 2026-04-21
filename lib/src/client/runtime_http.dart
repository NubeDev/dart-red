import 'package:dio/dio.dart';

/// Shared Dio instance for the runtime daemon API.
///
/// All resource clients receive this — one place to configure
/// base URL, timeouts, interceptors, and error handling.
class RuntimeHttp {
  final Dio dio;

  RuntimeHttp({String baseUrl = 'http://localhost:8080'})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          headers: {'Content-Type': 'application/json'},
        ));

  /// For testing or when you already have a configured Dio.
  RuntimeHttp.withDio(this.dio);

  /// Check if the runtime daemon is reachable.
  Future<bool> isAlive() async {
    try {
      await dio.get('/api/v1/flow');
      return true;
    } catch (_) {
      return false;
    }
  }
}
