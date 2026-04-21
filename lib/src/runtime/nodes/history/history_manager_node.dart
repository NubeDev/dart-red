import '../../node.dart';
import '../../port.dart';

/// Global history configuration node.
///
/// One per flow. Sets default maxSamples, flushInterval, and valueType
/// for all history.log nodes. Individual history.log nodes inherit these
/// unless they override in their own settings.
///
/// Also outputs the current config as values so you can see what's active
/// on the canvas.
class HistoryManagerNode extends SourceNode {
  @override
  String get typeName => 'history.manager';

  @override
  String get description => 'Global history defaults (samples, flush, type)';

  @override
  String get iconName => 'database';

  @override
  List<Port> get outputPorts => const [
        Port(name: 'maxSamples', type: 'num'),
        Port(name: 'flushInterval', type: 'num'),
        Port(name: 'valueType', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'maxSamples': {
            'type': 'integer',
            'title': 'Max Samples',
            'description':
                'Default retention per node — keep latest N, delete oldest',
            'default': 100,
            'minimum': 1,
          },
          'flushInterval': {
            'type': 'integer',
            'title': 'Flush Interval (seconds)',
            'description':
                'Default seconds between bulk writes to database',
            'default': 30,
            'minimum': 5,
          },
          'valueType': {
            'type': 'string',
            'title': 'Default Value Type',
            'description': 'How to store values unless overridden',
            'enum': ['number', 'bool', 'string'],
            'default': 'number',
          },
        },
      };

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    onOutput({
      'maxSamples': settings['maxSamples'] ?? 100,
      'flushInterval': settings['flushInterval'] ?? 30,
      'valueType': settings['valueType'] ?? 'number',
    });
  }
}
