import '../../node_helpers.dart';

/// Interactive widget node — holds a user-writable value (slider, toggle, etc.)
class UiSourceNode extends SingleOutputSource {
  @override
  String get typeName => 'ui.source';

  @override
  String get description => 'Interactive widget (slider, toggle, button)';

  @override
  String get iconName => 'sliders-horizontal';

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['widgetType', 'label'],
        'properties': {
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
            'enum': ['slider', 'toggle', 'button'],
            'default': 'slider',
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
        },
        // Cascading: widgetType determines which extra fields appear
        'allOf': [
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'slider'},
              },
            },
            'then': {
              'properties': {
                'min': {
                  'type': 'number',
                  'title': 'Minimum',
                  'default': 0,
                },
                'max': {
                  'type': 'number',
                  'title': 'Maximum',
                  'default': 100,
                },
                'step': {
                  'type': 'number',
                  'title': 'Step',
                  'default': 1,
                },
              },
            },
          },
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'toggle'},
              },
            },
            'then': {
              'properties': {
                'onLabel': {
                  'type': 'string',
                  'title': 'On Label',
                  'default': 'On',
                },
                'offLabel': {
                  'type': 'string',
                  'title': 'Off Label',
                  'default': 'Off',
                },
              },
            },
          },
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'button'},
              },
            },
            'then': {
              'properties': {
                'momentary': {
                  'type': 'boolean',
                  'title': 'Momentary',
                  'description': 'Emit true for one cycle then revert to false',
                  'default': true,
                },
              },
            },
          },
        ],
      };

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    // No-op: values are set externally via runtime.setNodeValue()
  }

  @override
  Future<void> stop(String nodeId) async {}
}
