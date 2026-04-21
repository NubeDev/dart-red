import 'package:drift_flutter/drift_flutter.dart';

import 'app_database.dart';

Future<AppDatabase> openDatabase() async {
  return AppDatabase(
    driftDatabase(name: 'rubix_app'),
  );
}
