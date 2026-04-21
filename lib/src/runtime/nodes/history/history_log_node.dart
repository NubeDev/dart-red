import 'dart:async';

import 'package:drift/drift.dart';

import '../../../db/app_database.dart';
import '../../../db/daos/runtime_dao.dart';
import '../../node.dart';
import '../../port.dart';

/// Sample waiting in the buffer before flush.
class _Sample {
  final double? numValue;
  final bool? boolValue;
  final String? strValue;
  final DateTime timestamp;

  _Sample({this.numValue, this.boolValue, this.strValue, required this.timestamp});
}

/// History sink node — logs time-series values to RuntimeHistory.
///
/// Buffered bulk writes every [flushInterval] seconds. Two record modes:
///   - COV: log only when value changes beyond [covThreshold]
///   - Cron: log every [cronInterval] seconds regardless of change
///
/// Per-node retention: keeps latest [maxSamples], deletes oldest on flush.
class HistoryLogNode extends SinkNode {
  @override
  String get typeName => 'history.log';

  @override
  String get description => 'Log values to time-series history';

  @override
  String get iconName => 'database';

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'dynamic'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'mode': {
            'type': 'string',
            'title': 'Record Mode',
            'enum': ['cov', 'cron'],
            'default': 'cov',
          },
          'maxSamples': {
            'type': 'integer',
            'title': 'Max Samples (override)',
            'description': 'Override the global default from history.manager',
          },
          'flushInterval': {
            'type': 'integer',
            'title': 'Flush Interval (override)',
            'description': 'Override the global default from history.manager',
          },
          'valueType': {
            'type': 'string',
            'title': 'Value Type (override)',
            'description': 'Override the global default from history.manager',
            'enum': ['number', 'bool', 'string'],
          },
        },
        'allOf': [
          {
            'if': {
              'properties': {
                'mode': {'const': 'cov'},
              },
            },
            'then': {
              'properties': {
                'covThreshold': {
                  'type': 'number',
                  'title': 'COV Threshold',
                  'description': 'Minimum change to trigger a log entry',
                  'default': 0.5,
                },
              },
              'required': ['covThreshold'],
            },
          },
          {
            'if': {
              'properties': {
                'mode': {'const': 'cron'},
              },
            },
            'then': {
              'properties': {
                'cronInterval': {
                  'type': 'integer',
                  'title': 'Cron Interval (seconds)',
                  'description': 'Log every N seconds',
                  'default': 60,
                },
              },
              'required': ['cronInterval'],
            },
          },
        ],
      };

  // Per-node state
  final _buffers = <String, List<_Sample>>{};
  final _lastValues = <String, dynamic>{};
  final _lastCronTime = <String, DateTime>{};
  final _flushTimers = <String, Timer>{};

  /// The DAO is injected via the runtime — not available at construction.
  RuntimeDao? dao;

  /// Global defaults from history.manager node, injected by the runtime.
  Map<String, dynamic> managerDefaults = {};

  /// Resolve a setting: per-node override wins, then manager default, then hardcoded.
  dynamic _resolve(Map<String, dynamic> settings, String key, dynamic fallback) {
    final local = settings[key];
    if (local != null) return local;
    final global = managerDefaults[key];
    if (global != null) return global;
    return fallback;
  }

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    _buffers[nodeId] = [];
    final flushSecs = (_resolve(settings, 'flushInterval', 30) as num).toInt();

    _flushTimers[nodeId]?.cancel();
    _flushTimers[nodeId] = Timer.periodic(
      Duration(seconds: flushSecs),
      (_) => _flush(nodeId, settings),
    );
  }

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    final value = inputs['value'];
    final mode = settings['mode'] as String? ?? 'cov';

    if (mode == 'cov') {
      if (!_shouldLogCov(nodeId, value, settings)) return null;
    } else {
      if (!_shouldLogCron(nodeId, settings)) return null;
    }

    final valueType = _resolve(settings, 'valueType', 'number') as String;
    final sample = _toSample(value, valueType);
    _buffers[nodeId] ??= [];
    _buffers[nodeId]!.add(sample);
    _lastValues[nodeId] = value;
    return null;
  }

  bool _shouldLogCov(
      String nodeId, dynamic value, Map<String, dynamic> settings) {
    final last = _lastValues[nodeId];
    if (last == null) return true; // first value always logged

    final threshold =
        (settings['covThreshold'] as num?)?.toDouble() ?? 0.5;
    final valueType = _resolve(settings, 'valueType', 'number') as String;

    if (valueType == 'bool') {
      return value != last;
    }
    if (valueType == 'string') {
      return value?.toString() != last?.toString();
    }
    // number
    final numValue = _toNum(value);
    final numLast = _toNum(last);
    if (numValue == null || numLast == null) return true;
    return (numValue - numLast).abs() > threshold;
  }

  bool _shouldLogCron(String nodeId, Map<String, dynamic> settings) {
    final intervalSecs =
        (settings['cronInterval'] as num?)?.toInt() ?? 60;
    final now = DateTime.now();
    final lastTime = _lastCronTime[nodeId];

    if (lastTime == null ||
        now.difference(lastTime).inSeconds >= intervalSecs) {
      _lastCronTime[nodeId] = now;
      return true;
    }
    return false;
  }

  _Sample _toSample(dynamic value, String valueType) {
    final now = DateTime.now();
    switch (valueType) {
      case 'bool':
        return _Sample(
          boolValue: value is bool ? value : value?.toString() == 'true',
          timestamp: now,
        );
      case 'string':
        return _Sample(strValue: value?.toString(), timestamp: now);
      case 'number':
      default:
        return _Sample(numValue: _toNum(value)?.toDouble(), timestamp: now);
    }
  }

  Future<void> _flush(String nodeId, Map<String, dynamic> settings) async {
    final buffer = _buffers[nodeId];
    if (buffer == null || buffer.isEmpty || dao == null) return;

    // Drain buffer
    final samples = List<_Sample>.from(buffer);
    buffer.clear();

    // Bulk insert
    final rows = samples
        .map((s) => RuntimeHistoryCompanion.insert(
              nodeId: nodeId,
              numValue: Value(s.numValue),
              boolValue: Value(s.boolValue),
              strValue: Value(s.strValue),
              timestamp: s.timestamp,
            ))
        .toList();

    try {
      await dao!.insertHistoryBatch(rows);

      // Trim oldest beyond maxSamples
      final maxSamples =
          (_resolve(settings, 'maxSamples', 100) as num).toInt();
      await dao!.trimHistory(nodeId, maxSamples);

      print('history.log[$nodeId]: flushed ${rows.length} samples '
          '(max=$maxSamples)');
    } catch (e) {
      print('history.log[$nodeId]: flush failed: $e');
      // Put samples back so they're not lost
      _buffers[nodeId]?.insertAll(0, samples);
    }
  }

  /// Flush remaining samples on shutdown. Never throws — deletion must succeed.
  @override
  Future<void> stop(String nodeId) async {
    _flushTimers[nodeId]?.cancel();
    _flushTimers.remove(nodeId);

    // Best-effort final flush — don't block deletion if it fails
    try {
      final settings = <String, dynamic>{};
      await _flush(nodeId, settings);
    } catch (e) {
      print('history.log[$nodeId]: final flush failed (node may be deleted): $e');
    }

    _buffers.remove(nodeId);
    _lastValues.remove(nodeId);
    _lastCronTime.remove(nodeId);
  }

  static num? _toNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}
