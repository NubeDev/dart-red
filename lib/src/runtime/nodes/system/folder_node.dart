import '../../node.dart';
import '../../port.dart';

/// User-defined composite node — a container with custom input/output ports.
///
/// Users create ports via settings, then wire them from outside like any node.
/// Inside the folder, `folder.input` and `folder.output` portal nodes bridge
/// external ports to the internal graph.
///
/// The folder itself is a TransformNode: it gathers external inputs, stores
/// them in a shared registry, and exposes collected outputs.
///
/// Nested folders are supported — folders can contain other folders.
class SystemFolderNode extends TransformNode {
  @override
  String get typeName => 'system.folder';

  @override
  String get description => 'Custom container with user-defined ports';

  @override
  String get iconName => 'folder';

  /// Accept any node type as a child (wildcard).
  @override
  List<String> get allowedChildTypes => const ['*'];

  // ---------------------------------------------------------------------------
  // Dynamic ports — built from the `ports` setting
  // ---------------------------------------------------------------------------

  @override
  List<Port> get inputPorts => const [];

  @override
  List<Port> get outputPorts => const [];

  @override
  List<Port> getInputPorts(Map<String, dynamic> settings) {
    return _portsFromSettings(settings, 'input');
  }

  @override
  List<Port> getOutputPorts(Map<String, dynamic> settings) {
    return _portsFromSettings(settings, 'output');
  }

  static List<Port> _portsFromSettings(
    Map<String, dynamic> settings,
    String direction,
  ) {
    final raw = settings['ports'];
    if (raw is! List) return const [];
    final ports = <Port>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final dir = item['direction'] as String? ?? 'input';
      if (dir != direction) continue;
      final name = item['name'] as String?;
      if (name == null || name.isEmpty) continue;
      ports.add(Port(name: name, type: 'dynamic'));
    }
    return ports;
  }

  // ---------------------------------------------------------------------------
  // Shared value registries — portal nodes read/write these
  // ---------------------------------------------------------------------------

  /// folderId → { portName → value } — values arriving on external inputs.
  /// Written by the folder's evaluate(), read by folder.input portal nodes.
  static final inputValues = <String, Map<String, dynamic>>{};

  /// folderId → { portName → value } — values pushed by folder.output portals.
  /// Written by folder.output nodes, read by the folder to produce outputs.
  static final outputValues = <String, Map<String, dynamic>>{};

  // ---------------------------------------------------------------------------
  // Settings schema
  // ---------------------------------------------------------------------------

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'ports': {
            'type': 'array',
            'title': 'Ports',
            'description': 'Define custom inputs and outputs for this folder',
            'items': {
              'type': 'object',
              'properties': {
                'name': {
                  'type': 'string',
                  'title': 'Name',
                  'x-placeholder': 'e.g. temperature',
                },
                'direction': {
                  'type': 'string',
                  'title': 'Direction',
                  'enum': ['input', 'output'],
                  'default': 'input',
                },
              },
              'required': ['name', 'direction'],
            },
          },
        },
      };

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    return settings['label'] as String? ?? 'Folder';
  }

  // ---------------------------------------------------------------------------
  // Evaluate — pass external inputs into the shared registry
  // ---------------------------------------------------------------------------

  @override
  Map<String, dynamic>? evaluate(Map<String, dynamic> inputs) {
    // This gets called with the node's ID via the evaluation engine.
    // We can't get nodeId here directly — the registry is populated
    // in the runtime evaluation extension instead.
    //
    // Return current output values (collected from folder.output portals).
    // The actual bridge is handled by the runtime's folder-aware evaluation.
    return null;
  }
}
