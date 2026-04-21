part of 'runtime.dart';

// =============================================================================
// Pages & flow control
//
// Dashboard page assembly, flow metadata, enable/disable.
// =============================================================================

extension RuntimePages on MicroBmsRuntime {
  // ---------------------------------------------------------------------------
  // Dashboard pages
  // ---------------------------------------------------------------------------

  /// Get assembled page data for the dashboard API.
  List<Map<String, dynamic>> getPages() {
    final pages = <Map<String, dynamic>>[];

    // Find all ui.page nodes
    for (final entry in _nodeTypes.entries) {
      if (entry.value.typeName != 'ui.page') continue;
      final pageId = entry.key;
      final settings = _nodeSettings[pageId] ?? {};

      // Find widgets belonging to this page
      final widgets = <Map<String, dynamic>>[];
      for (final wEntry in _nodeTypes.entries) {
        final wType = wEntry.value.typeName;
        if (wType != 'ui.source' &&
            wType != 'ui.display' &&
            wType != 'history.display' &&
            wType != 'schedule.display') continue;

        final wSettings = _nodeSettings[wEntry.key] ?? {};
        // Widget uses "pages" array — appears on every page it lists
        final pagesList = wSettings['pages'];
        if (pagesList is List) {
          if (!pagesList.contains(pageId)) continue;
        } else if (wSettings['pageNodeId'] != pageId) {
          // Fallback: legacy single pageNodeId
          continue;
        }

        final values = _nodeValues[wEntry.key] ?? {};
        // For single-port nodes, unwrap the value
        final value = values.length == 1 ? values.values.first : values;

        widgets.add({
          'id': wEntry.key,
          'type': wType,
          'widgetType': wSettings['widgetType'] ?? 'label',
          'label': wSettings['label'] ?? '',
          'value': value,
          'status': (_nodeStatuses[wEntry.key] ?? NodeStatus.stale).name,
          'settings': wSettings,
        });
      }

      pages.add({
        'id': pageId,
        'name': settings['name'] ?? 'Untitled',
        'icon': settings['icon'] ?? 'layout',
        'widgets': widgets,
      });
    }

    return pages;
  }

  // ---------------------------------------------------------------------------
  // Flow state & control
  // ---------------------------------------------------------------------------

  /// Get the full flow state for the REST API.
  Future<Map<String, dynamic>> getFlowState() async {
    final flow = await _dao.getFlowById(_flowId!);
    return {
      'flow': {
        'id': flow?.id,
        'name': flow?.name,
        'enabled': flow?.enabled,
      },
      'nodes': getNodes(),
      'edges': await getEdges(),
    };
  }

  /// Update flow metadata (name).
  Future<void> updateFlow({String? name}) async {
    if (_flowId == null) return;
    await _dao.updateFlow(
      _flowId!,
      RuntimeFlowsCompanion(
        updatedAt: drift.Value(DateTime.now()),
        name: name != null ? drift.Value(name) : const drift.Value.absent(),
      ),
    );
  }

  /// Enable the flow (start the runtime if stopped).
  Future<void> enableFlow() async {
    if (_flowId == null) return;
    await _dao.updateFlow(
      _flowId!,
      RuntimeFlowsCompanion(
        enabled: const drift.Value(true),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
    if (!_running) await start();
  }

  /// Disable the flow (stop the runtime).
  Future<void> disableFlow() async {
    if (_flowId == null) return;
    await _dao.updateFlow(
      _flowId!,
      RuntimeFlowsCompanion(
        enabled: const drift.Value(false),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
    await stop();
  }
}
