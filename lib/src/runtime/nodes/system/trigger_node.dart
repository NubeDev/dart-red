import 'dart:async';
import 'dart:math';

import '../../node.dart';
import '../../port.dart';

/// Periodic trigger node — fires on a configurable interval.
///
/// Outputs:
///   trigger  — alternates true/false each tick
///   count    — increments each tick (resets on restart)
///   random   — random number between min and max each tick
class TriggerNode extends SourceNode {
  @override
  String get typeName => 'system.trigger';

  @override
  String get description => 'Periodic trigger (interval timer)';

  @override
  String get iconName => 'timer';

  @override
  List<Port> get outputPorts => const [
        Port(name: 'trigger', type: 'bool'),
        Port(name: 'count', type: 'num'),
        Port(name: 'random', type: 'num'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'interval': {
            'type': 'integer',
            'title': 'Interval',
            'description': 'How often to fire',
            'default': 10,
            'minimum': 1,
          },
          'unit': {
            'type': 'string',
            'title': 'Unit',
            'enum': ['seconds', 'minutes', 'hours'],
            'default': 'seconds',
          },
          'min': {
            'type': 'number',
            'title': 'Random Min',
            'description': 'Minimum value for random output',
            'default': 0,
          },
          'max': {
            'type': 'number',
            'title': 'Random Max',
            'description': 'Maximum value for random output',
            'default': 100,
          },
        },
      };

  final _timers = <String, Timer>{};
  final _counts = <String, int>{};
  final _toggles = <String, bool>{};
  final _rng = Random();

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    _counts[nodeId] = 0;
    _toggles[nodeId] = false;

    final interval = (settings['interval'] as num?)?.toInt() ?? 10;
    final unit = settings['unit'] as String? ?? 'seconds';
    final duration = switch (unit) {
      'minutes' => Duration(minutes: interval),
      'hours' => Duration(hours: interval),
      _ => Duration(seconds: interval),
    };

    // Emit immediately on start
    _emit(nodeId, settings, onOutput);

    _timers[nodeId]?.cancel();
    _timers[nodeId] = Timer.periodic(duration, (_) {
      _emit(nodeId, settings, onOutput);
    });

    print('system.trigger[$nodeId]: every $interval $unit');
  }

  void _emit(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic>) onOutput,
  ) {
    final count = (_counts[nodeId] ?? 0) + 1;
    _counts[nodeId] = count;

    final toggle = !(_toggles[nodeId] ?? false);
    _toggles[nodeId] = toggle;

    final min = (settings['min'] as num?)?.toDouble() ?? 0;
    final max = (settings['max'] as num?)?.toDouble() ?? 100;
    final range = max - min;
    final random = min + _rng.nextDouble() * range;
    // Round to 2 decimal places
    final randomRounded = (random * 100).roundToDouble() / 100;

    onOutput({
      'trigger': toggle,
      'count': count,
      'random': randomRounded,
    });
  }

  @override
  Future<void> stop(String nodeId) async {
    _timers[nodeId]?.cancel();
    _timers.remove(nodeId);
    _counts.remove(nodeId);
    _toggles.remove(nodeId);
  }
}
