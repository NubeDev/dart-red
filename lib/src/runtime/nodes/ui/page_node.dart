import '../../node_helpers.dart';

/// Dashboard page container — metadata only, no ports or evaluation.
class UiPageNode extends SourceNode {
  @override
  String get typeName => 'ui.page';

  @override
  String get description => 'Dashboard page container';

  @override
  String get iconName => 'layout-dashboard';

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['name'],
        'properties': {
          'name': {
            'type': 'string',
            'title': 'Page Name',
            'default': 'Untitled',
          },
          'icon': {
            'type': 'string',
            'title': 'Icon',
            'default': 'layout',
            'description': 'Lucide icon name',
          },
        },
      };

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    return settings['name'] as String? ?? super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [];

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    // No-op — page is a metadata container, not a data source.
  }
}
