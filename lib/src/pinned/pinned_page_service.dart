import 'package:shared_preferences/shared_preferences.dart';
import '../storage/local_collection.dart';
import 'pinned_page.dart';

const _kStorageKey = 'rubix_pinned_pages';
const _kMaxPins = 8;

/// CRUD service for pinned pages, backed by [LocalCollection].
class PinnedPageService {
  late final LocalCollection<PinnedPage> _collection;

  PinnedPageService(SharedPreferences prefs) {
    _collection = LocalCollection<PinnedPage>(
      key: _kStorageKey,
      fromJson: PinnedPage.fromJson,
      toJson: (p) => p.toJson(),
      getId: (p) => p.id,
      prefs: prefs,
    );
  }

  List<PinnedPage> getAll() {
    final pages = _collection.getAll();
    pages.sort((a, b) => a.pinnedAt.compareTo(b.pinnedAt));
    return pages;
  }

  bool isPinned({required String nodeId, String? pageId}) {
    return getAll().any(
      (p) => p.nodeId == nodeId && p.pageId == pageId,
    );
  }

  PinnedPage? findPin({required String nodeId, String? pageId}) {
    try {
      return getAll().firstWhere(
        (p) => p.nodeId == nodeId && p.pageId == pageId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> pin({
    required String locationId,
    required String locationName,
    required String nodeId,
    required String nodeLabel,
    String? pageId,
    String? pageTitle,
  }) async {
    if (isPinned(nodeId: nodeId, pageId: pageId)) return false;
    if (getAll().length >= _kMaxPins) return false;

    final page = PinnedPage.create(
      locationId: locationId,
      locationName: locationName,
      nodeId: nodeId,
      nodeLabel: nodeLabel,
      pageId: pageId,
      pageTitle: pageTitle,
    );
    await _collection.save(page);
    return true;
  }

  Future<void> unpin({required String nodeId, String? pageId}) async {
    final existing = findPin(nodeId: nodeId, pageId: pageId);
    if (existing != null) {
      await _collection.delete(existing.id);
    }
  }

  Future<void> removeById(String id) async {
    await _collection.delete(id);
  }

  Future<void> clear() async {
    await _collection.clear();
  }
}
