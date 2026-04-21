import '../../node.dart';
import '../../port.dart';

/// Portal node inside a folder — represents one external input port.
///
/// Lives inside a `system.folder`. When the folder receives a value on the
/// matching external input, this node emits it into the internal graph.
///
/// The port name is set via settings and must match an input port defined
/// on the parent folder.
class FolderInputNode extends SourceNode {
  @override
  String get typeName => 'folder.input';

  @override
  String get description => 'Receives values from a folder input port';

  @override
  String get iconName => 'log-in';

  @override
  String? get requiredParentType => 'system.folder';

  @override
  List<Port> get outputPorts => const [
        Port(name: 'value', type: 'dynamic'),
      ];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final portName = settings['portName'] as String?;
    return portName != null && portName.isNotEmpty ? 'IN: $portName' : 'Input';
  }

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['portName'],
        'properties': {
          'portName': {
            'type': 'string',
            'title': 'Port Name',
            'description': 'Must match an input port on the parent folder',
            'x-placeholder': 'e.g. temperature',
          },
        },
      };

  // Per-instance state
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _parentIds = <String, String?>{};
  final _portNames = <String, String?>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    _callbacks[nodeId] = onOutput;
    _parentIds[nodeId] = parentId;
    _portNames[nodeId] = settings['portName'] as String?;

    // Register with the folder's input registry so we can be notified
    if (parentId != null) {
      _registerWithFolder(nodeId, parentId);
    }
  }

  void _registerWithFolder(String nodeId, String folderId) {
    // The folder node's inputValues registry is checked by the runtime
    // when evaluating — we just need to be registered so the runtime
    // knows to push values to us.
    _folderInputNodes.putIfAbsent(folderId, () => {});
    _folderInputNodes[folderId]![nodeId] = _portNames[nodeId] ?? '';
  }

  /// Push a value from the parent folder's external input into this portal.
  void pushValue(String nodeId, dynamic value) {
    _callbacks[nodeId]?.call({'value': value});
  }

  @override
  Future<void> stop(String nodeId) async {
    final parentId = _parentIds[nodeId];
    if (parentId != null) {
      _folderInputNodes[parentId]?.remove(nodeId);
    }
    _callbacks.remove(nodeId);
    _parentIds.remove(nodeId);
    _portNames.remove(nodeId);
  }

  /// folderId → { portalNodeId → portName }
  /// Used by the runtime to find which portal nodes to feed when a folder
  /// receives input values.
  static final _folderInputNodes = <String, Map<String, String>>{};

  /// Get all registered input portals for a folder.
  static Map<String, String>? getPortalsForFolder(String folderId) {
    return _folderInputNodes[folderId];
  }
}
