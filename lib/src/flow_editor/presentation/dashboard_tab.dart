import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rubix_ui/rubix_ui.dart';
import 'package:dart_red/src/client/runtime_client.dart';

import '../widgets/add_widget_dialog.dart';
import '../widgets/edit_page_dialog.dart';
import '../widgets/node_settings_dialog.dart';

/// Dashboard tab — shows live page data with view and edit modes.
///
/// View mode: polls GET /api/v1/pages every 2s, renders widget cards.
/// Edit mode: pauses polling, shows drag handles + CRUD controls.
class DashboardTab extends StatefulWidget {
  final RuntimeApiClient api;

  const DashboardTab({super.key, required this.api});

  @override
  DashboardTabState createState() => DashboardTabState();
}

class DashboardTabState extends State<DashboardTab>
    with WidgetsBindingObserver, PollingLifecycleMixin {
  List<Map<String, dynamic>> _pages = [];
  int _selectedPageIndex = 0;
  bool _editMode = false;
  bool _loading = true;
  String? _error;
  late final DashboardPoller _poller;

  /// History samples cache: nodeId -> samples list.
  final Map<String, List<Map<String, dynamic>>> _historyCache = {};

  @override
  void initState() {
    super.initState();
    _poller = DashboardPoller(
      onPoll: _loadPages,
      interval: const Duration(seconds: 2),
    );
    _loadPages();
    initPolling(_poller);
  }

  @override
  void dispose() {
    disposePolling();
    super.dispose();
  }

  /// Called externally (e.g. on tab switch) to reload page data from the API.
  void refresh() => _loadPages();

  // ---------------------------------------------------------------------------
  // Polling
  // ---------------------------------------------------------------------------

  Future<void> _loadPages() async {
    try {
      final pages = await widget.api.pages.getAll();
      if (!mounted) return;

      // Fetch history for any history.display widgets
      await _fetchHistoryData(pages);

      setState(() {
        _pages = pages;
        _loading = false;
        _error = null;
        if (_selectedPageIndex >= _pages.length && _pages.isNotEmpty) {
          _selectedPageIndex = _pages.length - 1;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _pages.isEmpty ? 'Failed to load pages: $e' : null;
      });
    }
  }

  Future<void> _fetchHistoryData(List<Map<String, dynamic>> pages) async {
    for (final page in pages) {
      final widgets = page['widgets'] as List<dynamic>? ?? [];
      for (final w in widgets) {
        final wMap = w as Map<String, dynamic>;
        final nodeType = wMap['type'] as String? ?? '';
        if (nodeType != 'history.display') continue;

        final nodeId = wMap['id'] as String;
        final settings = wMap['settings'] as Map<String, dynamic>? ?? {};
        final limit = (settings['displaySamples'] as num?)?.toInt() ?? 50;

        try {
          final samples = await widget.api.nodes.getHistory(nodeId, limit: limit);
          _historyCache[nodeId] = samples;
        } catch (_) {
          // Keep stale data if fetch fails
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Edit mode
  // ---------------------------------------------------------------------------

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;
      if (_editMode) {
        _poller.pause();
      } else {
        _poller.resume();
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Page CRUD
  // ---------------------------------------------------------------------------

  Future<void> _addPage() async {
    final name = await EditPageDialog.show(context, title: 'Add Page');
    if (name == null || name.isEmpty) return;

    try {
      await widget.api.nodes.create(
        type: 'ui.page',
        settings: {'name': name},
      );
      await _loadPages();
      setState(() {
        _selectedPageIndex = _pages.length - 1;
      });
    } catch (e) {
      _showError('Failed to create page: $e');
    }
  }

  Future<void> _renamePage(int index) async {
    if (index >= _pages.length) return;
    final page = _pages[index];
    final currentName =
        (page['settings'] as Map<String, dynamic>?)?['name'] as String? ??
            'Untitled';
    final name = await EditPageDialog.show(
      context,
      title: 'Rename Page',
      initialName: currentName,
    );
    if (name == null || name.isEmpty) return;

    try {
      final pageId = page['id'] as String;
      await widget.api.nodes.updateSettings(pageId, {'name': name});
      await _loadPages();
    } catch (e) {
      _showError('Failed to rename page: $e');
    }
  }

  Future<void> _deletePage(int index) async {
    if (index >= _pages.length) return;
    final page = _pages[index];
    final pageId = page['id'] as String;
    final name =
        (page['settings'] as Map<String, dynamic>?)?['name'] as String? ??
            'Untitled';

    final confirmed = await showRubixConfirm(
      context,
      title: 'Delete Page',
      description: 'Delete "$name" and all its widgets?',
    );
    if (!confirmed) return;

    try {
      await widget.api.nodes.delete(pageId);
      await _loadPages();
    } catch (e) {
      _showError('Failed to delete page: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Widget CRUD
  // ---------------------------------------------------------------------------

  Future<void> _addWidget() async {
    if (_pages.isEmpty) return;
    final page = _pages[_selectedPageIndex];
    final pageId = page['id'] as String;

    final result = await AddWidgetDialog.show(context);
    if (result == null) return;

    // Auto-assign order to end of list
    final widgetsList =
        (page['widgets'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final nextOrder = widgetsList.length;

    try {
      final nodeId = await widget.api.nodes.create(
        type: result.nodeType,
        settings: {
          'widgetType': result.widgetType,
          'pages': [pageId],
          'order': nextOrder,
          ...result.extraSettings,
        },
      );

      // Open settings dialog for further configuration
      if (mounted) {
        try {
          final schema = await widget.api.nodes.getSettingsSchema(nodeId);
          final current = await widget.api.nodes.getSettings(nodeId);
          if (!mounted) return;

          final existingPages =
              (current['pages'] as List<dynamic>?)?.cast<String>() ?? [];
          if (!existingPages.contains(pageId)) {
            current['pages'] = [...existingPages, pageId];
          }

          _removeOrderFromSchema(schema);

          final result2 = await NodeSettingsDialog.show(
            context,
            nodeId: nodeId,
            nodeType: result.nodeType,
            schema: schema,
            currentSettings: current,
          );
          if (result2 != null) {
            final settings = result2.settings;
            final updatedPages =
                (settings['pages'] as List<dynamic>?)?.cast<String>() ?? [];
            if (!updatedPages.contains(pageId)) {
              settings['pages'] = [...updatedPages, pageId];
            }
            await widget.api.nodes.updateSettings(nodeId, settings);
            if (result2.label != null) {
              await widget.api.nodes.update(nodeId, label: result2.label);
            }
          }
        } catch (_) {
          // Settings dialog is optional — widget is already created
        }
      }

      await _loadPages();
    } catch (e) {
      _showError('Failed to add widget: $e');
    }
  }

  Future<void> _editWidget(Map<String, dynamic> widgetData) async {
    final nodeId = widgetData['id'] as String;
    final nodeType = widgetData['type'] as String? ?? '?';

    try {
      final schema = await widget.api.nodes.getSettingsSchema(nodeId);
      final current = await widget.api.nodes.getSettings(nodeId);
      if (!mounted) return;

      _removeOrderFromSchema(schema);

      final result = await NodeSettingsDialog.show(
        context,
        nodeId: nodeId,
        nodeType: nodeType,
        schema: schema,
        currentSettings: current,
      );
      if (result != null) {
        final settings = result.settings;
        final existingOrder = current['order'];
        if (existingOrder != null && !settings.containsKey('order')) {
          settings['order'] = existingOrder;
        }
        await widget.api.nodes.updateSettings(nodeId, settings);
        if (result.label != null) {
          await widget.api.nodes.update(nodeId, label: result.label);
        }
        await _loadPages();
      }
    } catch (e) {
      _showError('Failed to edit widget: $e');
    }
  }

  Future<void> _removeWidget(Map<String, dynamic> widgetData) async {
    final nodeId = widgetData['id'] as String;
    try {
      await widget.api.nodes.delete(nodeId);
      await _loadPages();
    } catch (e) {
      _showError('Failed to remove widget: $e');
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (_pages.isEmpty) return;
    if (newIndex > oldIndex) newIndex--;

    final page = _pages[_selectedPageIndex];
    final widgets =
        (page['widgets'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    widgets.sort((a, b) {
      final oa =
          ((a['settings'] as Map<String, dynamic>?)?['order'] as num?)
                  ?.toInt() ??
              0;
      final ob =
          ((b['settings'] as Map<String, dynamic>?)?['order'] as num?)
                  ?.toInt() ??
              0;
      return oa.compareTo(ob);
    });

    final item = widgets.removeAt(oldIndex);
    widgets.insert(newIndex, item);

    for (var i = 0; i < widgets.length; i++) {
      final settings =
          widgets[i]['settings'] as Map<String, dynamic>? ?? {};
      settings['order'] = i;
      widgets[i]['settings'] = settings;
    }
    setState(() {});

    for (var i = 0; i < widgets.length; i++) {
      final id = widgets[i]['id'] as String;
      try {
        await widget.api.nodes.updateSettings(id, {'order': i});
      } catch (_) {}
    }
  }

  void _removeOrderFromSchema(Map<String, dynamic> schema) {
    final props = schema['properties'] as Map<String, dynamic>?;
    props?.remove('order');
    final required = schema['required'] as List<dynamic>?;
    required?.remove('order');
  }

  // ---------------------------------------------------------------------------
  // Interactive widget actions
  // ---------------------------------------------------------------------------

  Future<void> _setNodeValue(String nodeId, dynamic value) async {
    try {
      await widget.api.nodes.setValue(nodeId, value);
    } catch (e) {
      _showError('Failed to set value: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: RubixTokens.statusError),
    );
  }

  String _pageName(Map<String, dynamic> page) {
    final settings = page['settings'] as Map<String, dynamic>? ?? {};
    return settings['name'] as String? ?? 'Untitled';
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final tokens = RubixTokens.of(context);

    if (_loading && _pages.isEmpty) {
      return const RubixLoader(message: 'Loading dashboard');
    }

    if (_error != null && _pages.isEmpty) {
      return RubixErrorState(
        message: 'Failed to load dashboard',
        detail: _error,
        onRetry: _loadPages,
      );
    }

    return Column(
      children: [
        _buildPageBar(tokens),
        Expanded(child: _buildWidgetList(tokens)),
      ],
    );
  }

  Widget _buildPageBar(RubixColors tokens) {
    return Container(
      height: 42,
      color: tokens.surface,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xs, vertical: 3),
              child: _editMode
                  ? DashboardPageEditBar(
                      labels: _pages.map(_pageName).toList(),
                      selectedIndex: _selectedPageIndex,
                      onSelected: (i) =>
                          setState(() => _selectedPageIndex = i),
                      onAddPage: _addPage,
                      onRenamePage: _renamePage,
                      onDeletePage: _deletePage,
                    )
                  : DashboardPageTabBar(
                      labels: _pages.map(_pageName).toList(),
                      selectedIndex: _selectedPageIndex,
                      onSelected: (i) =>
                          setState(() => _selectedPageIndex = i),
                      style: DashboardTabStyle.underline,
                    ),
            ),
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: _toggleEditMode,
            icon: Icon(
              _editMode ? Icons.check : Icons.edit,
              size: 16,
            ),
            label: Text(
              _editMode ? 'Done' : 'Edit',
              style: const TextStyle(fontSize: 12),
            ),
            style: TextButton.styleFrom(
              foregroundColor:
                  _editMode ? RubixTokens.accentCool : tokens.textSecondary,
            ),
          ),
          const SizedBox(width: Spacing.xs),
        ],
      ),
    );
  }

  Widget _buildWidgetList(RubixColors tokens) {
    if (_pages.isEmpty) {
      return RubixEmptyState(
        title: 'No pages yet',
        subtitle: 'Create a page to start adding widgets',
        action: RubixButton.primary(
          onPressed: _addPage,
          label: 'Add Page',
          icon: Icons.add,
        ),
      );
    }

    final page = _pages[_selectedPageIndex];
    final widgetsList =
        (page['widgets'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    widgetsList.sort((a, b) {
      final oa =
          ((a['settings'] as Map<String, dynamic>?)?['order'] as num?)
                  ?.toInt() ??
              0;
      final ob =
          ((b['settings'] as Map<String, dynamic>?)?['order'] as num?)
                  ?.toInt() ??
              0;
      return oa.compareTo(ob);
    });

    if (widgetsList.isEmpty && !_editMode) {
      return Center(
        child: Text('No widgets on this page',
            style: tokens.inter(fontSize: 14, color: tokens.textMuted)),
      );
    }

    if (_editMode) {
      return _buildEditModeList(widgetsList);
    }
    return _buildViewModeGrid(widgetsList);
  }

  Widget _buildViewModeGrid(List<Map<String, dynamic>> widgets) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final w in widgets)
            SizedBox(
              width: _widgetWidth(w),
              child: _buildWidgetCard(w, editMode: false),
            ),
        ],
      ),
    );
  }

  Widget _buildEditModeList(List<Map<String, dynamic>> widgets) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: widgets.length,
            onReorder: _onReorder,
            proxyDecorator: (child, _, _) => Material(
              color: Colors.transparent,
              elevation: 4,
              child: child,
            ),
            itemBuilder: (_, i) {
              final w = widgets[i];
              return Padding(
                key: ValueKey(w['id']),
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildWidgetCard(w, editMode: true),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addWidget,
              icon: const Icon(Icons.add),
              label: const Text('Add Widget'),
            ),
          ),
        ),
      ],
    );
  }

  double _widgetWidth(Map<String, dynamic> w) {
    final nodeType = w['type'] as String? ?? '';
    final settings = w['settings'] as Map<String, dynamic>? ?? {};
    final wType = settings['widgetType'] as String? ?? '';

    if (nodeType == 'history.display' &&
        (wType == 'chart' || wType == 'sparkline')) {
      return 440;
    }
    return 220;
  }

  Widget _buildWidgetCard(Map<String, dynamic> w, {required bool editMode}) {
    final nodeType = w['type'] as String? ?? '';
    final settings = w['settings'] as Map<String, dynamic>? ?? {};
    final wType = settings['widgetType'] as String? ?? '';
    final name = settings['name'] as String? ??
        settings['label'] as String? ??
        wType;
    final value = w['value'];
    final status = w['status'] as String?;
    final nodeId = w['id'] as String;

    // Determine the effective widget type string and build DashboardValue
    final effectiveType = _resolveWidgetType(nodeType, wType);
    final dashValue = _buildDashboardValue(
        nodeType, wType, value, settings, status, nodeId);
    final history = _buildHistory(nodeType, nodeId);

    final (child, _) = DashboardWidgetFactory.build(
      widgetType: effectiveType,
      value: dashValue,
      settings: settings,
      history: history,
      onSliderChanged: (v) => _setNodeValue(nodeId, v),
      onToggleChanged: (v) {
        _poller.lock();
        _setNodeValue(nodeId, v).then((_) {
          Future.delayed(
              const Duration(milliseconds: 500), _poller.unlock);
        });
      },
      onButtonPressed: () => _setNodeValue(nodeId, true),
      onInteractionStart: _poller.lock,
      onInteractionEnd: _poller.unlock,
    );

    return DashboardWidgetCard(
      title: name,
      status: dashValue.status,
      editMode: editMode,
      onRemove: editMode ? () => _removeWidget(w) : null,
      onSettings: editMode ? () => _editWidget(w) : null,
      child: child,
    );
  }

  String _resolveWidgetType(String nodeType, String wType) {
    return switch (nodeType) {
      'ui.display' => wType.isNotEmpty ? wType : 'label',
      'ui.source' => wType.isNotEmpty ? wType : 'label',
      'history.display' => wType.isNotEmpty ? wType : 'chart',
      'schedule.display' => 'schedule',
      _ => 'label',
    };
  }

  DashboardValue _buildDashboardValue(
    String nodeType,
    String wType,
    dynamic value,
    Map<String, dynamic> settings,
    String? status,
    String nodeId,
  ) {
    // For history widgets showing latest value as gauge/label
    if (nodeType == 'history.display' &&
        (wType == 'gauge' || wType == 'label' || wType.isEmpty)) {
      final samples = _historyCache[nodeId] ?? [];
      final latest = samples.isNotEmpty ? samples.last['value'] : null;
      return DashboardValue.from(
        latest,
        unit: settings['unit'] as String?,
        status: status,
      );
    }

    // For schedule widgets
    if (nodeType == 'schedule.display') {
      return DashboardValue.from(
        value,
        unit: settings['unit'] as String?,
      );
    }

    return DashboardValue.from(
      value,
      unit: settings['unit'] as String?,
      status: status,
    );
  }

  List<HistorySample> _buildHistory(String nodeType, String nodeId) {
    if (nodeType != 'history.display') return const [];
    final samples = _historyCache[nodeId] ?? [];
    return samples
        .map((s) {
          final v = s['value'];
          final t = s['timestamp'];
          if (v is! num) return null;
          DateTime? time;
          if (t is String) time = DateTime.tryParse(t);
          if (t is int) {
            time = DateTime.fromMillisecondsSinceEpoch(t, isUtc: true);
          }
          if (time == null) return null;
          return HistorySample(time, v.toDouble());
        })
        .whereType<HistorySample>()
        .toList();
  }
}
