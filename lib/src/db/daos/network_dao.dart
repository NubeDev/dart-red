import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/networks.dart';

part 'network_dao.g.dart';

@DriftAccessor(tables: [Networks])
class NetworkDao extends DatabaseAccessor<AppDatabase>
    with _$NetworkDaoMixin {
  NetworkDao(super.db);

  Stream<List<NetworkRow>> watchAll() => select(networks).watch();

  Future<List<NetworkRow>> getAll() => select(networks).get();

  Future<NetworkRow?> getById(String id) =>
      (select(networks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(NetworksCompanion entry) =>
      into(networks).insertOnConflictUpdate(entry);

  Future<void> remove(String id) =>
      (delete(networks)..where((t) => t.id.equals(id))).go();
}
