import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database_provider.dart';
import '../db/daos/pinned_page_dao.dart';
import 'pinned_page.dart';

const _kMaxPins = 8;

class PinnedPagesNotifier extends StateNotifier<List<PinnedPage>> {
  final PinnedPageDao _dao;

  PinnedPagesNotifier(this._dao) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await _dao.getAll();
  }

  bool isPinned({required String nodeId, String? pageId}) {
    return state.any((p) => p.nodeId == nodeId && p.pageId == pageId);
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
    if (state.length >= _kMaxPins) return false;

    final page = PinnedPage.create(
      locationId: locationId,
      locationName: locationName,
      nodeId: nodeId,
      nodeLabel: nodeLabel,
      pageId: pageId,
      pageTitle: pageTitle,
    );
    await _dao.upsert(page);
    await _load();
    return true;
  }

  Future<void> unpin({required String nodeId, String? pageId}) async {
    final existing = state
        .where((p) => p.nodeId == nodeId && p.pageId == pageId)
        .firstOrNull;
    if (existing != null) {
      await _dao.remove(existing.id);
      await _load();
    }
  }

  Future<void> removeById(String id) async {
    await _dao.remove(id);
    await _load();
  }
}

final pinnedPagesProvider =
    StateNotifierProvider<PinnedPagesNotifier, List<PinnedPage>>((ref) {
  final dao = ref.watch(pinnedPageDaoProvider);
  return PinnedPagesNotifier(dao);
});
