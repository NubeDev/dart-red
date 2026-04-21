import '../db/app_database.dart';
import 'disabled_runtime_service.dart';
import 'remote_runtime_service.dart';
import 'runtime_service.dart';

/// Creates the runtime service for web.
/// Web only supports remote and none — embedded requires dart:io.
Future<RuntimeService> createRuntimeService({
  required String mode,
  required String remoteUrl,
  required AppDatabase db,
}) async {
  switch (mode) {
    case 'remote':
      final remote = RemoteRuntimeService(baseUrl: remoteUrl);
      await remote.start();
      return remote;
    default:
      return DisabledRuntimeService();
  }
}
