import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pages.dart';

part 'page_dao.g.dart';

@DriftAccessor(tables: [Pages, Widgets])
class PageDao extends DatabaseAccessor<AppDatabase> with _$PageDaoMixin {
  PageDao(super.db);

  // --- Pages ---

  Stream<List<PageRow>> watchAllPages() =>
      (select(pages)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<PageRow>> getAllPages() =>
      (select(pages)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<PageRow?> getPageById(String id) =>
      (select(pages)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertPage(PagesCompanion entry) =>
      into(pages).insertOnConflictUpdate(entry);

  Future<void> removePage(String id) async {
    // Cascade: delete widgets on this page first
    await (delete(widgets)..where((t) => t.pageId.equals(id))).go();
    await (delete(pages)..where((t) => t.id.equals(id))).go();
  }

  // --- Widgets ---

  Stream<List<WidgetRow>> watchWidgetsByPage(String pageId) =>
      (select(widgets)
            ..where((t) => t.pageId.equals(pageId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<List<WidgetRow>> getWidgetsByPage(String pageId) =>
      (select(widgets)
            ..where((t) => t.pageId.equals(pageId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<void> upsertWidget(WidgetsCompanion entry) =>
      into(widgets).insertOnConflictUpdate(entry);

  Future<void> removeWidget(String id) =>
      (delete(widgets)..where((t) => t.id.equals(id))).go();
}
