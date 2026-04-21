import '../../node_helpers.dart';

/// Source node that outputs a constant value from its settings.
class SystemConstantNode extends SingleOutputSource {
  @override
  String get typeName => 'system.constant';

  @override
  String get description => 'Output a fixed value from settings';

  @override
  String get iconName => 'hash';

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['value'],
        'properties': {
          'value': {
            'title': 'Value',
            'description': 'The constant value to output',
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
    final value = settings['value'];
    // Immediately emit the constant value
    onOutput({'value': value});
  }
}
