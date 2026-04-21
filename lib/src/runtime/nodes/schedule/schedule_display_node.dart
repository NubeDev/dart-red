import 'dart:async';
import 'dart:io';

import '../../../schedules/schedule.dart';
import '../../../schedules/evaluator.dart';
import '../../node.dart';
import '../../port.dart';

/// Schedule display node — time-based schedule that also appears on the dashboard.
///
/// Same evaluation logic as [schedule.source] (weekly + exception layers,
/// auto-re-evaluates on nextTransition), but with dashboard visibility via
/// [pages], [widgetType], [label], and [order] settings.
///
/// Widget types:
///   - status  — active/inactive indicator (LED-style)
///   - label   — shows the current value with a label
///   - weekly  — visual weekly grid showing on/off blocks
class ScheduleDisplayNode extends SourceNode {
  @override
  String get typeName => 'schedule.display';

  @override
  String get description =>
      'Time-based schedule with dashboard display';

  @override
  String get iconName => 'calendar-clock';

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
        'required': ['widgetType', 'label'],
        'properties': {
          // ── UI / display settings ──
          'pages': {
            'type': 'array',
            'title': 'Pages',
            'description': 'Dashboard pages this widget appears on',
            'items': {'type': 'string'},
            'x-widget': 'node-picker',
            'x-node-type': 'ui.page',
          },
          'widgetType': {
            'type': 'string',
            'title': 'Widget Type',
            'enum': ['status', 'label', 'weekly'],
            'default': 'status',
          },
          'label': {
            'type': 'string',
            'title': 'Label',
          },
          'order': {
            'type': 'integer',
            'title': 'Display Order',
            'default': 0,
          },
          // ── Schedule settings ──
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
        'allOf': [
          // ── Widget type cascading ──
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'status'},
              },
            },
            'then': {
              'properties': {
                'onColor': {
                  'type': 'string',
                  'title': 'Active Color',
                  'default': 'green',
                  'enum': ['green', 'red', 'yellow', 'blue', 'teal'],
                },
                'offColor': {
                  'type': 'string',
                  'title': 'Inactive Color',
                  'default': 'gray',
                  'enum': ['gray', 'red', 'yellow'],
                },
              },
            },
          },
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'label'},
              },
            },
            'then': {
              'properties': {
                'unit': {
                  'type': 'string',
                  'title': 'Unit',
                  'default': '',
                },
              },
            },
          },
        ],
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

    final evaluator = ScheduleEvaluator();
    final schedulesList = settings['schedules'] as List<dynamic>? ?? [];
    for (final s in schedulesList) {
      evaluator.addSchedule(Schedule.fromJson(s as Map<String, dynamic>));
    }
    _evaluators[nodeId] = evaluator;

    _emitState(nodeId, settings);
  }

  void _emitState(String nodeId, Map<String, dynamic> settings) {
    final evaluator = _evaluators[nodeId];
    final callback = _callbacks[nodeId];
    if (evaluator == null || callback == null) return;

    final activeValue = settings['activeValue'] ?? 1;
    final inactiveValue = settings['inactiveValue'] ?? 0;

    final state = evaluator.getState();

    final allStatuses = evaluator.getAllStatuses();
    var weeklyActive = false;
    var exceptionActive = false;

    for (final entry in allStatuses.values) {
      if (entry.weeklyActive) weeklyActive = true;
      if (entry.exceptionActive) exceptionActive = true;
    }

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

    print('schedule.display[$nodeId]: '
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
        _timers[nodeId] = Timer(
          const Duration(seconds: 1),
          () => _emitState(nodeId, settings),
        );
      } else {
        print(
            'schedule.display[$nodeId]: next transition in ${delay.inMinutes}m');
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
