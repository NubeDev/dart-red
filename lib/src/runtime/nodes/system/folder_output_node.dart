import '../../node.dart';
import '../../port.dart';
import 'folder_node.dart'; // for SystemFolderNode.outputValues

/// Portal node inside a folder — represents one external output port.
///
/// Lives inside a `system.folder`. When the internal graph produces a value
/// that reaches this node, it pushes it to the parent folder's output.
///
/// The port name is set via settings and must match an output port defined
/// on the parent folder.
class FolderOutputNode extends SinkNode {
  @override
  String get typeName => 'folder.output';

  @override
  String get description => 'Sends values to a folder output port';

  @override
  String get iconName => 'log-out';

  @override
  String? get requiredParentType => 'system.folder';

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'dynamic'),
      ];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final portName = settings['portName'] as String?;
    return portName != null && portName.isNotEmpty ? 'OUT: $portName' : 'Output';
  }

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['portName'],
        'properties': {
          'portName': {
            'type': 'string',
            'title': 'Port Name',
            'description': 'Must match an output port on the parent folder',
            'x-placeholder': 'e.g. result',
          },
        },
      };

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    if (parentId == null) return null;

    final portName = settings['portName'] as String?;
    if (portName == null || portName.isEmpty) return null;

    final value = inputs['value'];

    // Write to the folder's output registry.
    // The runtime marks the parent folder dirty after this executes,
    // causing it to re-evaluate and propagate the new output values.
    SystemFolderNode.outputValues.putIfAbsent(parentId, () => {});
    SystemFolderNode.outputValues[parentId]![portName] = value;

    return {'value': value};
  }
}
