import 'dart:async';

import '../../../db/daos/runtime_dao.dart';
import '../../node.dart';
import '../../port.dart';

/// Global insight configuration + live stats node.
///
/// One per flow. Sets default severity, inhibit duration, and retention
/// for all insight nodes. Periodically queries the database and outputs
/// current insight statistics so you can wire them to a dashboard.
class InsightManagerNode extends SourceNode {
  @override
  String get typeName => 'insight.manager';

  @override
  String get description => 'Global insight config & live stats';

  @override
  String get iconName => 'bell';

  @override
  List<Port> get outputPorts => const [
        Port(name: 'activeCount', type: 'num'),
        Port(name: 'acknowledgedCount', type: 'num'),
        Port(name: 'clearedCount', type: 'num'),
        Port(name: 'totalCount', type: 'num'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'defaultSeverity': {
            'type': 'string',
            'title': 'Default Severity',
            'description': 'Default severity for insight nodes',
            'enum': ['critical', 'high', 'medium', 'low', 'info'],
            'default': 'medium',
          },
          'defaultInhibitDuration': {
            'type': 'integer',
            'title': 'Default Inhibit Duration (seconds)',
            'description':
                'Default delay before an alarm can re-trigger after clearing',
            'default': 300,
            'minimum': 0,
          },
          'maxRetainedInsights': {
            'type': 'integer',
            'title': 'Max Retained Insights',
            'description':
                'Default max cleared insights to keep per node (oldest trimmed)',
            'default': 500,
            'minimum': 1,
          },
          'statsInterval': {
            'type': 'integer',
            'title': 'Stats Refresh Interval (seconds)',
            'description': 'How often to refresh insight statistics',
            'default': 30,
            'minimum': 5,
          },
        },
      };

  /// Injected by the runtime during graph build.
  RuntimeDao? dao;

  final _timers = <String, Timer>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    // Emit config immediately (zero stats until first poll)
    onOutput({
      'activeCount': 0,
      'acknowledgedCount': 0,
      'clearedCount': 0,
      'totalCount': 0,
    });

    // Start periodic stats refresh
    final intervalSecs =
        (settings['statsInterval'] as num?)?.toInt() ?? 30;

    _timers[nodeId]?.cancel();
    _timers[nodeId] = Timer.periodic(
      Duration(seconds: intervalSecs),
      (_) => _refreshStats(nodeId, onOutput),
    );

    // Initial refresh
    await _refreshStats(nodeId, onOutput);
  }

  Future<void> _refreshStats(
    String nodeId,
    void Function(Map<String, dynamic> outputs) onOutput,
  ) async {
    if (dao == null) return;

    try {
      final stats = await dao!.getInsightStats();
      onOutput({
        'activeCount': stats['active'] ?? 0,
        'acknowledgedCount': stats['acknowledged'] ?? 0,
        'clearedCount': stats['cleared'] ?? 0,
        'totalCount': stats['total'] ?? 0,
      });
    } catch (e) {
      print('insight.manager[$nodeId]: stats refresh failed: $e');
    }
  }

  @override
  Future<void> stop(String nodeId) async {
    _timers[nodeId]?.cancel();
    _timers.remove(nodeId);
  }
}
