import '../../node.dart';
import '../../port.dart';

/// Display widget node — receives a value from the graph and shows it.
///
/// execute() is a no-op — the runtime gathers inputs and persists them.
/// The display node exists so the dashboard knows what to render.
///
/// Settings: {
///   "pages": ["<page-id>", ...],   // appears on these pages
///   "widgetType": "gauge",         // gauge | label | led
///   "label": "Result",
///   "unit": "",
///   "min": 0,
///   "max": 100
/// }
class UiDisplayNode extends SinkNode {
  @override
  String get typeName => 'ui.display';

  @override
  String get description => 'Display widget (gauge, label, LED)';

  @override
  String get iconName => 'monitor';

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
            'enum': ['gauge', 'label', 'led'],
            'default': 'label',
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
        // Cascading: widgetType determines extra fields
        'allOf': [
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'gauge'},
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
                'unit': {
                  'type': 'string',
                  'title': 'Unit',
                  'default': '',
                  'x-placeholder': 'e.g. °F, %, PSI',
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
          {
            'if': {
              'properties': {
                'widgetType': {'const': 'led'},
              },
            },
            'then': {
              'properties': {
                'onColor': {
                  'type': 'string',
                  'title': 'On Color',
                  'default': 'green',
                  'enum': ['green', 'red', 'yellow', 'blue', 'teal'],
                },
                'offColor': {
                  'type': 'string',
                  'title': 'Off Color',
                  'default': 'gray',
                  'enum': ['gray', 'red', 'yellow'],
                },
              },
            },
          },
        ],
      };

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'dynamic'),
      ];

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    // No-op — value is gathered by the runtime and persisted via batch persist.
    return null;
  }
}
