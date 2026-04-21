import 'package:drift/drift.dart';

import '../../pinned/pinned_page.dart';
import '../app_database.dart';
import '../tables/pinned_pages.dart';

part 'pinned_page_dao.g.dart';

@DriftAccessor(tables: [PinnedPages])
class PinnedPageDao extends DatabaseAccessor<AppDatabase>
    with _$PinnedPageDaoMixin {
  PinnedPageDao(super.db);

  Future<List<PinnedPage>> getAll() async {
    final rows = await (select(pinnedPages)
          ..orderBy([(t) => OrderingTerm.asc(t.pinnedAt)]))
        .get();
    return rows.map(_toModel).toList();
  }

  Stream<List<PinnedPage>> watchAll() =>
      (select(pinnedPages)..orderBy([(t) => OrderingTerm.asc(t.pinnedAt)]))
          .watch()
          .map((rows) => rows.map(_toModel).toList());

  Future<PinnedPageRow?> findPin(
      {required String nodeId, String? pageId}) async {
    final query = select(pinnedPages)
      ..where((t) => t.nodeId.equals(nodeId));
    if (pageId != null) {
      query.where((t) => t.pageId.equals(pageId));
    } else {
      query.where((t) => t.pageId.isNull());
    }
    return query.getSingleOrNull();
  }

  Future<int> count() async {
    final c = countAll();
    final query = selectOnly(pinnedPages)..addColumns([c]);
    final row = await query.getSingle();
    return row.read(c)!;
  }

  Future<void> upsert(PinnedPage page) async {
    await into(pinnedPages).insertOnConflictUpdate(_toCompanion(page));
  }

  Future<void> remove(String id) async {
    await (delete(pinnedPages)..where((t) => t.id.equals(id))).go();
  }

  Future<void> insertAll(List<PinnedPage> items) async {
    await batch((b) {
      b.insertAll(
        pinnedPages,
        items.map(_toCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> clearAll() async {
    await delete(pinnedPages).go();
  }

  // --- Mapping ---

  PinnedPage _toModel(PinnedPageRow row) => PinnedPage(
        id: row.id,
        locationId: row.locationId,
        locationName: row.locationName,
        nodeId: row.nodeId,
        nodeLabel: row.nodeLabel,
        pageId: row.pageId,
        pageTitle: row.pageTitle,
        pinnedAt: row.pinnedAt,
      );

  PinnedPagesCompanion _toCompanion(PinnedPage m) => PinnedPagesCompanion(
        id: Value(m.id),
        locationId: Value(m.locationId),
        locationName: Value(m.locationName),
        nodeId: Value(m.nodeId),
        nodeLabel: Value(m.nodeLabel),
        pageId: Value(m.pageId),
        pageTitle: Value(m.pageTitle),
        pinnedAt: Value(m.pinnedAt),
      );
}
