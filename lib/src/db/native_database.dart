import 'dart:io';

import 'package:drift/native.dart';

import 'app_database.dart';

/// Opens (or creates) the SQLite database at the given [path].
///
/// Pure Dart — no Flutter dependency. Use this for headless / server mode.
/// Not available on web.
AppDatabase openDatabaseAt(String path) {
  return AppDatabase(NativeDatabase(File(path)));
}
