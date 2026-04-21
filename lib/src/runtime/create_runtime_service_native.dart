import '../db/app_database.dart';
import 'disabled_runtime_service.dart';
import 'embedded_runtime_service.dart';
import 'remote_runtime_service.dart';
import 'runtime_service.dart';

/// Creates the runtime service based on the compile-time mode.
/// Native platforms support embedded, remote, and none.
Future<RuntimeService> createRuntimeService({
  required String mode,
  required String remoteUrl,
  required AppDatabase db,
}) async {
  switch (mode) {
    case 'embedded':
      final embedded = EmbeddedRuntimeService(db: db, serveApi: true);
      await embedded.start();
      return embedded;
    case 'remote':
      final remote = RemoteRuntimeService(baseUrl: remoteUrl);
      await remote.start();
      return remote;
    default:
      return DisabledRuntimeService();
  }
}
