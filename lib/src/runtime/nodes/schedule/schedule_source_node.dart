import 'dart:async';
import 'dart:io';

import '../../../schedules/schedule.dart';
import '../../../schedules/evaluator.dart';
import '../../node.dart';
import '../../port.dart';

/// Schedule source node — wraps the existing ScheduleEvaluator.
///
/// Outputs three booleans showing who's active at each layer, plus a
/// final value that the exception layer can override:
///
///   weeklyActive     — true if the 7-day weekly schedule says "on" right now
///   exceptionActive  — true if a 365-day exception (holiday, override) is active
///   active           — final result: exception wins if active, else weekly
///   value            — activeValue or inactiveValue based on final result
///
/// Auto-re-evaluates on nextTransition — no polling needed.
///
/// Settings:
/// ```json
/// {
///   "schedules": [
///     {
///       "name": "Office Hours",
///       "priority": 1,
///       "weekly": {
///         "1": [{"start": "08:00", "stop": "17:00"}],
///         "2": [{"start": "08:00", "stop": "17:00"}],
///         "3": [{"start": "08:00", "stop": "17:00"}],
///         "4": [{"start": "08:00", "stop": "17:00"}],
///         "5": [{"start": "08:00", "stop": "17:00"}]
///       },
///       "exceptions": [
///         {
///           "start": "2026-12-25T00:00:00",
///           "stop": "2026-12-26T00:00:00",
///           "priority": 10,
///           "type": "holiday"
///         }
///       ]
///     }
///   ],
///   "activeValue": 72,
///   "inactiveValue": 60
/// }
/// ```
class ScheduleSourceNode extends SourceNode {
  @override
  String get typeName => 'schedule.source';

  @override
  String get description => 'Time-based schedule with weekly + exception layers';

  @override
  String get iconName => 'calendar-clock';

  @override
  @override
  List<Port> get outputPorts => const [
        Port(name: 'weeklyActive', type: 'bool'),
        Port(name: 'exceptionActive', type: 'bool'),
        Port(name: 'active', type: 'bool'),
        Port(name: 'value', type: 'dynamic'),
        Port(name: 'time', type: 'text'),
        Port(name: 'timezone', type: 'text'),
        Port(name: 'tzName', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'activeValue': {
            'title': 'Active Value',
            'description': 'Output when schedule is active',
            'type': 'number',
            'default': 1,
          },
          'inactiveValue': {
            'title': 'Inactive Value',
            'description': 'Output when schedule is inactive',
            'type': 'number',
            'default': 0,
          },
          'schedules': {
            'type': 'array',
            'title': 'Schedules',
            'description': 'Priority-ordered schedules (highest priority wins)',
            'items': {
              'type': 'object',
              'required': ['name'],
              'properties': {
                'name': {
                  'type': 'string',
                  'title': 'Name',
                  'x-placeholder': 'e.g. Office Hours',
                },
                'priority': {
                  'type': 'integer',
                  'title': 'Priority',
                  'description': '1=local, 10=master, 20=emergency',
                  'default': 1,
                  'minimum': 1,
                  'maximum': 20,
                },
                'weekly': {
                  'type': 'object',
                  'title': 'Weekly Schedule',
                  'description': 'Time ranges per day of week',
                  'properties': {
                    '1': _daySchema('Monday'),
                    '2': _daySchema('Tuesday'),
                    '3': _daySchema('Wednesday'),
                    '4': _daySchema('Thursday'),
                    '5': _daySchema('Friday'),
                    '6': _daySchema('Saturday'),
                    '7': _daySchema('Sunday'),
                  },
                },
                'exceptions': {
                  'type': 'array',
                  'title': 'Exceptions',
                  'description': 'Date-based overrides (holidays, maintenance)',
                  'items': {
                    'type': 'object',
                    'required': ['start', 'stop', 'type'],
                    'properties': {
                      'type': {
                        'type': 'string',
                        'title': 'Type',
                        'enum': [
                          'holiday',
                          'override',
                          'maintenance',
                          'temporary',
                        ],
                        'default': 'holiday',
                      },
                      'start': {
                        'type': 'string',
                        'title': 'Start',
                        'x-widget': 'datetime',
                      },
                      'stop': {
                        'type': 'string',
                        'title': 'End',
                        'x-widget': 'datetime',
                      },
                      'priority': {
                        'type': 'integer',
                        'title': 'Priority',
                        'default': 10,
                        'minimum': 1,
                        'maximum': 20,
                      },
                    },
                  },
                },
              },
            },
          },
        },
      };

  static Map<String, dynamic> _daySchema(String label) => {
        'type': 'array',
        'title': label,
        'items': {
          'type': 'object',
          'properties': {
            'start': {
              'type': 'string',
              'title': 'Start',
              'x-widget': 'time',
              'x-placeholder': 'HH:MM',
            },
            'stop': {
              'type': 'string',
              'title': 'Stop',
              'x-widget': 'time',
              'x-placeholder': 'HH:MM',
            },
          },
        },
      };

  final _timers = <String, Timer>{};
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _evaluators = <String, ScheduleEvaluator>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    _callbacks[nodeId] = onOutput;

    // Build evaluator from settings
    final evaluator = ScheduleEvaluator();
    final schedulesList = settings['schedules'] as List<dynamic>? ?? [];
    for (final s in schedulesList) {
      evaluator.addSchedule(Schedule.fromJson(s as Map<String, dynamic>));
    }
    _evaluators[nodeId] = evaluator;

    // Initial evaluation
    _emitState(nodeId, settings);
  }

  void _emitState(String nodeId, Map<String, dynamic> settings) {
    final evaluator = _evaluators[nodeId];
    final callback = _callbacks[nodeId];
    if (evaluator == null || callback == null) return;

    final activeValue = settings['activeValue'] ?? 1;
    final inactiveValue = settings['inactiveValue'] ?? 0;

    // Get the combined state (exception wins over weekly)
    final state = evaluator.getState();

    // Get layer-level detail
    final allStatuses = evaluator.getAllStatuses();
    var weeklyActive = false;
    var exceptionActive = false;

    for (final entry in allStatuses.values) {
      if (entry.weeklyActive) weeklyActive = true;
      if (entry.exceptionActive) exceptionActive = true;
    }

    // Final result: exception overrides weekly
    // If exception is active, it wins regardless of weekly
    // If no exception, weekly decides
    final active = state.isActive;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    callback({
      'weeklyActive': weeklyActive,
      'exceptionActive': exceptionActive,
      'active': active,
      'value': active ? activeValue : inactiveValue,
      'time': timeStr,
      'timezone': now.timeZoneName,
      'tzName': Platform.environment['TZ'] ?? now.timeZoneName,
    });

    print('schedule.source[$nodeId]: '
        'weekly=${weeklyActive ? "ON" : "off"}, '
        'exception=${exceptionActive ? "OVERRIDE" : "none"}, '
        'result=${active ? "ACTIVE" : "inactive"} '
        '(source: ${state.activeSource})');

    // Schedule re-evaluation at next transition
    _timers[nodeId]?.cancel();
    final next = state.nextTransition;
    if (next != null) {
      final delay = next.difference(DateTime.now());
      if (delay.isNegative || delay.inSeconds < 1) {
        // Transition is imminent or past — re-evaluate in 1 second
        _timers[nodeId] = Timer(
          const Duration(seconds: 1),
          () => _emitState(nodeId, settings),
        );
      } else {
        print('schedule.source[$nodeId]: next transition in ${delay.inMinutes}m');
        _timers[nodeId] = Timer(
          delay,
          () => _emitState(nodeId, settings),
        );
      }
    }
  }

  @override
  Future<void> stop(String nodeId) async {
    _timers[nodeId]?.cancel();
    _timers.remove(nodeId);
    _callbacks.remove(nodeId);
    _evaluators.remove(nodeId);
  }
}
