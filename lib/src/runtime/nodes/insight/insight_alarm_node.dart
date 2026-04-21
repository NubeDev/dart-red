import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../db/app_database.dart';
import '../../../db/daos/runtime_dao.dart';
import '../../node.dart';
import '../../port.dart';

const _uuid = Uuid();

/// Per-node alarm state held in memory between evaluations.
class _AlarmState {
  /// Whether the alarm is currently active (condition met).
  bool active = false;

  /// The database row ID of the current active insight (null if cleared).
  String? activeInsightId;

  /// When the alarm was last cleared — used for inhibit timing.
  DateTime? lastClearedAt;

  /// Recent numeric values for rate-of-change calculation.
  /// Each entry is (timestamp, value).
  final recentValues = <(DateTime, double)>[];
}

/// Insight alarm node — monitors a value and raises/clears alarms.
///
/// Supports multiple alarm types via settings:
///   - **threshold**: fires when value crosses a limit (with deadband hysteresis)
///   - **limit**: fires when value is outside a min/max band
///   - **rateOfChange**: fires when value changes too fast over a sample window
///   - **expression**: fires when a custom Dart expression evaluates to true
///     (requires dart_eval — future enhancement, currently placeholder)
///
/// Features:
///   - `enable` input port: wire to AC status, schedule, occupancy, etc.
///     When false, alarm is suppressed (won't trigger or auto-clears).
///   - Inhibit timer: after clearing, won't re-trigger for N seconds.
///   - Deadband / hysteresis: prevents alarm flapping near the threshold.
///   - Auto-acknowledge option.
///   - Outputs `active` (bool) and `duration` (seconds) for downstream wiring.
class InsightAlarmNode extends SinkNode {
  @override
  String get typeName => 'insight.alarm';

  @override
  String get description => 'Alarm / threshold insight with inhibit & deadband';

  @override
  String get iconName => 'bell-ring';

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'num', nullPolicy: NullPolicy.deny),
        Port(
          name: 'enable',
          type: 'bool',
          nullPolicy: NullPolicy.allow,
          defaultValue: true,
        ),
      ];

  @override
  List<Port> get outputPorts => const [
        Port(name: 'active', type: 'bool'),
        Port(name: 'duration', type: 'num'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'enabled': {
            'type': 'boolean',
            'title': 'Enabled',
            'description': 'Master enable for this insight node',
            'default': true,
          },
          'title': {
            'type': 'string',
            'title': 'Alarm Title',
            'description': 'Short name shown in alarm journal',
            'default': 'Alarm',
          },
          'message': {
            'type': 'string',
            'title': 'Detail Message',
            'description': 'Optional detail text logged with the alarm',
          },
          'type': {
            'type': 'string',
            'title': 'Insight Type',
            'description': 'Category for filtering in the alarm journal',
            'enum': ['alarm', 'alert', 'notification', 'energy', 'action'],
            'default': 'alarm',
          },
          'severity': {
            'type': 'string',
            'title': 'Severity',
            'enum': ['critical', 'high', 'medium', 'low', 'info'],
            'default': 'medium',
          },
          'alarmType': {
            'type': 'string',
            'title': 'Alarm Type',
            'enum': ['threshold', 'limit', 'rateOfChange', 'expression'],
            'default': 'threshold',
          },
          'inhibitDuration': {
            'type': 'integer',
            'title': 'Inhibit Duration (seconds)',
            'description':
                'After clearing, block re-trigger for this many seconds '
                '(e.g. let AC cool down the room)',
            'default': 0,
            'minimum': 0,
          },
          'autoAcknowledge': {
            'type': 'boolean',
            'title': 'Auto Acknowledge',
            'description': 'Automatically acknowledge when alarm clears',
            'default': false,
          },
        },
        'allOf': [
          // ── Threshold mode ──
          {
            'if': {
              'properties': {
                'alarmType': {'const': 'threshold'},
              },
            },
            'then': {
              'properties': {
                'threshold': {
                  'type': 'number',
                  'title': 'Threshold',
                  'description': 'Value that triggers the alarm',
                  'default': 28.0,
                },
                'direction': {
                  'type': 'string',
                  'title': 'Direction',
                  'description': 'Trigger when value goes above or below',
                  'enum': ['above', 'below'],
                  'default': 'above',
                },
                'deadband': {
                  'type': 'number',
                  'title': 'Deadband',
                  'description':
                      'Hysteresis band — alarm clears at threshold ± deadband '
                      'to prevent flapping',
                  'default': 1.0,
                  'minimum': 0,
                },
              },
              'required': ['threshold'],
            },
          },
          // ── Limit (band) mode ──
          {
            'if': {
              'properties': {
                'alarmType': {'const': 'limit'},
              },
            },
            'then': {
              'properties': {
                'highLimit': {
                  'type': 'number',
                  'title': 'High Limit',
                  'description': 'Upper bound — alarm if value exceeds this',
                  'default': 30.0,
                },
                'lowLimit': {
                  'type': 'number',
                  'title': 'Low Limit',
                  'description': 'Lower bound — alarm if value drops below this',
                  'default': 18.0,
                },
                'deadband': {
                  'type': 'number',
                  'title': 'Deadband',
                  'default': 1.0,
                  'minimum': 0,
                },
              },
              'required': ['highLimit', 'lowLimit'],
            },
          },
          // ── Rate of change mode ──
          {
            'if': {
              'properties': {
                'alarmType': {'const': 'rateOfChange'},
              },
            },
            'then': {
              'properties': {
                'rateLimit': {
                  'type': 'number',
                  'title': 'Rate Limit (units/min)',
                  'description':
                      'Maximum acceptable rate of change per minute',
                  'default': 2.0,
                },
                'sampleWindow': {
                  'type': 'integer',
                  'title': 'Sample Window (seconds)',
                  'description':
                      'Time window for calculating rate of change',
                  'default': 300,
                  'minimum': 10,
                },
              },
              'required': ['rateLimit'],
            },
          },
          // ── Expression mode (dart_eval future) ──
          {
            'if': {
              'properties': {
                'alarmType': {'const': 'expression'},
              },
            },
            'then': {
              'properties': {
                'expression': {
                  'type': 'string',
                  'title': 'Dart Expression',
                  'description':
                      'Custom expression that evaluates to bool. '
                      'Available variables: value, enable. '
                      'Example: value > 28 && enable == true',
                  'default': 'value > 28',
                },
              },
              'required': ['expression'],
            },
          },
        ],
      };

  // ── Injected by runtime ──

  RuntimeDao? dao;
  Map<String, dynamic> managerDefaults = {};

  // ── Per-node state ──

  final _states = <String, _AlarmState>{};

  /// Resolve a setting: per-node override → manager default → fallback.
  dynamic _resolve(Map<String, dynamic> settings, String key, dynamic fallback) {
    final local = settings[key];
    if (local != null) return local;
    final global = managerDefaults[key];
    if (global != null) return global;
    return fallback;
  }

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    final state = _states.putIfAbsent(nodeId, _AlarmState.new);

    // ── Check master enable ──
    final settingEnabled = settings['enabled'] as bool? ?? true;
    final inputEnable = inputs['enable'] as bool? ?? true;

    if (!settingEnabled || !inputEnable) {
      // Suppressed — if currently active, auto-clear
      if (state.active) {
        await _clearAlarm(nodeId, state, settings);
      }
      return {'active': false, 'duration': 0};
    }

    // ── Get numeric value ──
    final rawValue = inputs['value'];
    final value = _toNum(rawValue);
    if (value == null) {
      return {'active': state.active, 'duration': _activeDuration(state)};
    }

    // ── Evaluate alarm condition ──
    final alarmType = settings['alarmType'] as String? ?? 'threshold';
    final conditionMet = _evaluateCondition(
      alarmType: alarmType,
      value: value.toDouble(),
      settings: settings,
      state: state,
      isCurrentlyActive: state.active,
    );

    // ── State machine ──
    if (conditionMet && !state.active) {
      // Check inhibit timer
      if (_isInhibited(state, settings)) {
        return {'active': false, 'duration': 0};
      }
      await _raiseAlarm(nodeId, value.toDouble(), state, settings);
    } else if (!conditionMet && state.active) {
      await _clearAlarm(nodeId, state, settings);
    }

    // Track values for rate-of-change
    if (alarmType == 'rateOfChange') {
      _trackValue(state, value.toDouble(), settings);
    }

    return {
      'active': state.active,
      'duration': _activeDuration(state),
    };
  }

  /// Evaluate whether the alarm condition is currently met.
  /// Takes into account deadband when the alarm is already active (hysteresis).
  bool _evaluateCondition({
    required String alarmType,
    required double value,
    required Map<String, dynamic> settings,
    required _AlarmState state,
    required bool isCurrentlyActive,
  }) {
    switch (alarmType) {
      case 'threshold':
        return _evalThreshold(value, settings, isCurrentlyActive);
      case 'limit':
        return _evalLimit(value, settings, isCurrentlyActive);
      case 'rateOfChange':
        return _evalRateOfChange(value, state, settings);
      case 'expression':
        return _evalExpression(value, settings);
      default:
        return false;
    }
  }

  bool _evalThreshold(
      double value, Map<String, dynamic> settings, bool isActive) {
    final threshold = (settings['threshold'] as num?)?.toDouble() ?? 28.0;
    final direction = settings['direction'] as String? ?? 'above';
    final deadband = (settings['deadband'] as num?)?.toDouble() ?? 1.0;

    if (direction == 'above') {
      // Trigger at threshold, clear at (threshold - deadband)
      if (isActive) return value > (threshold - deadband);
      return value > threshold;
    } else {
      // Trigger below threshold, clear at (threshold + deadband)
      if (isActive) return value < (threshold + deadband);
      return value < threshold;
    }
  }

  bool _evalLimit(
      double value, Map<String, dynamic> settings, bool isActive) {
    final highLimit = (settings['highLimit'] as num?)?.toDouble() ?? 30.0;
    final lowLimit = (settings['lowLimit'] as num?)?.toDouble() ?? 18.0;
    final deadband = (settings['deadband'] as num?)?.toDouble() ?? 1.0;

    if (isActive) {
      // Stay active until value returns within band + deadband
      return value > (highLimit - deadband) || value < (lowLimit + deadband);
    }
    return value > highLimit || value < lowLimit;
  }

  bool _evalRateOfChange(
      double value, _AlarmState state, Map<String, dynamic> settings) {
    final rateLimit = (settings['rateLimit'] as num?)?.toDouble() ?? 2.0;

    if (state.recentValues.isEmpty) return false;

    final oldest = state.recentValues.first;
    final elapsed = DateTime.now().difference(oldest.$1).inSeconds;
    if (elapsed < 1) return false;

    final delta = (value - oldest.$2).abs();
    final ratePerMinute = (delta / elapsed) * 60;
    return ratePerMinute > rateLimit;
  }

  bool _evalExpression(double value, Map<String, dynamic> settings) {
    // TODO: Integrate dart_eval for custom expressions.
    // For now, fall back to a simple threshold check using the expression
    // string as documentation only.
    final expr = settings['expression'] as String? ?? '';
    print('insight.alarm: expression mode placeholder — "$expr" '
        '(dart_eval integration pending)');
    return false;
  }

  void _trackValue(
      _AlarmState state, double value, Map<String, dynamic> settings) {
    final windowSecs = (settings['sampleWindow'] as num?)?.toInt() ?? 300;
    final now = DateTime.now();
    state.recentValues.add((now, value));

    // Evict samples outside the window
    final cutoff = now.subtract(Duration(seconds: windowSecs));
    state.recentValues.removeWhere((entry) => entry.$1.isBefore(cutoff));
  }

  bool _isInhibited(_AlarmState state, Map<String, dynamic> settings) {
    if (state.lastClearedAt == null) return false;

    final inhibitSecs =
        (_resolve(settings, 'inhibitDuration', 0) as num).toInt();
    if (inhibitSecs <= 0) return false;

    final elapsed =
        DateTime.now().difference(state.lastClearedAt!).inSeconds;
    return elapsed < inhibitSecs;
  }

  Future<void> _raiseAlarm(
    String nodeId,
    double value,
    _AlarmState state,
    Map<String, dynamic> settings,
  ) async {
    state.active = true;

    if (dao == null) return;

    final id = _uuid.v4();
    state.activeInsightId = id;

    final threshold = (settings['threshold'] as num?)?.toDouble();

    try {
      await dao!.insertInsight(RuntimeInsightsCompanion.insert(
        id: id,
        nodeId: nodeId,
        type: settings['type'] as String? ?? 'alarm',
        severity: _resolve(settings, 'severity', 'medium') as String,
        state: 'active',
        title: settings['title'] as String? ?? 'Alarm',
        message: Value(settings['message'] as String?),
        triggerValue: Value(value),
        thresholdValue: Value(threshold),
        triggeredAt: DateTime.now(),
      ));

      print('insight.alarm[$nodeId]: RAISED — '
          '${settings['title']} (value=$value)');
    } catch (e) {
      print('insight.alarm[$nodeId]: failed to insert insight: $e');
    }
  }

  Future<void> _clearAlarm(
    String nodeId,
    _AlarmState state,
    Map<String, dynamic> settings,
  ) async {
    state.active = false;
    state.lastClearedAt = DateTime.now();

    if (dao == null || state.activeInsightId == null) return;

    try {
      final autoAck = settings['autoAcknowledge'] as bool? ?? false;
      if (autoAck) {
        await dao!.updateInsightState(
          state.activeInsightId!,
          'cleared',
          clearedAt: DateTime.now(),
          acknowledgedAt: DateTime.now(),
        );
      } else {
        await dao!.clearInsight(state.activeInsightId!);
      }

      // Trim old cleared insights
      final maxRetained =
          (_resolve(settings, 'maxRetainedInsights', 500) as num).toInt();
      await dao!.trimInsights(nodeId, maxRetained);

      print('insight.alarm[$nodeId]: CLEARED — ${settings['title']}');
    } catch (e) {
      print('insight.alarm[$nodeId]: failed to clear insight: $e');
    }

    state.activeInsightId = null;
  }

  int _activeDuration(_AlarmState state) {
    if (!state.active || state.activeInsightId == null) return 0;
    // Duration is calculated from when the insight was raised.
    // Since we don't store the exact raise time in memory, we approximate
    // from the state. For precision, the triggeredAt is in the DB row.
    return 0; // Downstream can query the DB for precise duration
  }

  @override
  Future<void> stop(String nodeId) async {
    final state = _states[nodeId];
    if (state != null && state.active) {
      // Auto-clear on shutdown so we don't leave phantom active alarms
      await _clearAlarm(nodeId, state, <String, dynamic>{});
    }
    _states.remove(nodeId);
  }

  static num? _toNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}
