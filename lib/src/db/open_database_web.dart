import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

import 'app_database.dart';

Future<AppDatabase> openDatabase() async {
  final result = await WasmDatabase.open(
    databaseName: 'rubix_app',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );

  debugPrint('[DRIFT-WEB] storage: ${result.chosenImplementation}');
  if (result.missingFeatures.isNotEmpty) {
    debugPrint('[DRIFT-WEB] missing: ${result.missingFeatures}');
  }

  return AppDatabase(result.resolvedExecutor);
}
