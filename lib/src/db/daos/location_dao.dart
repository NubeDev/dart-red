import 'package:drift/drift.dart';

import '../../models/location.dart';
import '../app_database.dart';
import '../tables/locations.dart';

part 'location_dao.g.dart';

@DriftAccessor(tables: [Locations])
class LocationDao extends DatabaseAccessor<AppDatabase>
    with _$LocationDaoMixin {
  LocationDao(super.db);

  // --- Queries ---

  Future<List<Location>> getAll() async {
    final rows = await select(locations).get();
    return rows.map(_toModel).toList();
  }

  Stream<List<Location>> watchAll() =>
      select(locations).watch().map((rows) => rows.map(_toModel).toList());

  Future<Location?> getById(String id) async {
    final row = await (select(locations)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Future<Location?> getActive() async {
    final row =
        await (select(locations)..where((t) => t.isActive.equals(true)))
            .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  Stream<Location?> watchActive() =>
      (select(locations)..where((t) => t.isActive.equals(true)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _toModel(row));

  // --- Mutations ---

  Future<void> upsert(Location location) async {
    await into(locations).insertOnConflictUpdate(_toCompanion(location));
  }

  Future<void> remove(String id) async {
    await (delete(locations)..where((t) => t.id.equals(id))).go();
  }

  Future<void> setActive(String locationId) async {
    await transaction(() async {
      // Deactivate all
      await update(locations)
          .write(const LocationsCompanion(isActive: Value(false)));
      // Activate the chosen one + stamp lastUsed
      await (update(locations)..where((t) => t.id.equals(locationId))).write(
        LocationsCompanion(
          isActive: const Value(true),
          lastUsed: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> insertAll(List<Location> items) async {
    await batch((b) {
      b.insertAll(
        locations,
        items.map(_toCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> clearAll() async {
    await delete(locations).go();
  }

  // --- Mapping ---

  Location _toModel(LocationRow row) => Location(
        id: row.id,
        name: row.name,
        url: row.url,
        orgId: row.orgId,
        isActive: row.isActive,
        lastUsed: row.lastUsed,
        address: row.address,
        latitude: row.latitude,
        longitude: row.longitude,
      );

  LocationsCompanion _toCompanion(Location m) => LocationsCompanion(
        id: Value(m.id),
        name: Value(m.name),
        url: Value(m.url),
        orgId: Value(m.orgId),
        isActive: Value(m.isActive),
        lastUsed: Value(m.lastUsed),
        address: Value(m.address),
        latitude: Value(m.latitude),
        longitude: Value(m.longitude),
      );
}
