import 'package:dart_red/src/client/runtime_client.dart';

import 'runtime_service.dart';

/// HTTP-based runtime — delegates everything to [RuntimeApiClient].
///
/// Used when the Flutter app is a thin client connecting to a remote
/// gateway/daemon that runs the actual [MicroBmsRuntime].
class RemoteRuntimeService implements RuntimeService {
  final RuntimeApiClient _client;
  bool _connected = false;

  RemoteRuntimeService({required String baseUrl})
      : _client = RuntimeApiClient(baseUrl: baseUrl);

  /// Access the underlying HTTP client (for advanced use / testing).
  RuntimeApiClient get client => _client;

  @override
  bool get isRunning => _connected;

  @override
  Future<void> start() async {
    if (!await _client.isAlive()) {
      throw StateError('Runtime daemon not reachable');
    }
    _connected = true;
  }

  @override
  Future<void> stop() async {
    _connected = false;
  }

  // ---------------------------------------------------------------------------
  // Pages
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getPages() {
    return _client.pages.getAll();
  }

  // ---------------------------------------------------------------------------
  // Nodes — CRUD
  // ---------------------------------------------------------------------------

  @override
  Future<String> createNode({
    required String type,
    Map<String, dynamic> settings = const {},
    String? label,
    String? parentId,
    double posX = 0.0,
    double posY = 0.0,
  }) {
    return _client.nodes.create(
      type: type,
      settings: settings,
      label: label,
      parentId: parentId,
      posX: posX,
      posY: posY,
    );
  }

  @override
  Future<void> updateNode(String nodeId, {String? label}) {
    return _client.nodes.update(nodeId, label: label);
  }

  @override
  Future<void> updateNodePosition(String nodeId, double posX, double posY) {
    return _client.nodes.updatePosition(nodeId, posX, posY);
  }

  @override
  Future<void> deleteNode(String nodeId) {
    return _client.nodes.delete(nodeId);
  }

  @override
  Future<Map<String, dynamic>?> getNode(String nodeId,
      {bool includeChildren = false}) async {
    return _client.nodes.get(nodeId, includeChildren: includeChildren);
  }

  @override
  Future<List<Map<String, dynamic>>> getNodes() {
    return _client.nodes.list();
  }

  @override
  Future<List<Map<String, dynamic>>> getChildNodes(String nodeId) {
    return _client.nodes.getChildren(nodeId);
  }

  // ---------------------------------------------------------------------------
  // Nodes — value
  // ---------------------------------------------------------------------------

  @override
  Future<({dynamic value, String status})> getNodeValue(String nodeId) {
    return _client.nodes.getValue(nodeId);
  }

  @override
  Future<void> setNodeValue(String nodeId, dynamic value) {
    return _client.nodes.setValue(nodeId, value);
  }

  // ---------------------------------------------------------------------------
  // Nodes — settings
  // ---------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getNodeSettings(String nodeId) {
    return _client.nodes.getSettings(nodeId);
  }

  @override
  Future<Map<String, dynamic>> getNodeSettingsSchema(String nodeId) {
    return _client.nodes.getSettingsSchema(nodeId);
  }

  @override
  Future<void> updateNodeSettings(String nodeId, Map<String, dynamic> patch) {
    return _client.nodes.updateSettings(nodeId, patch);
  }

  // ---------------------------------------------------------------------------
  // Nodes — history
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getHistory(String nodeId,
      {int limit = 100}) {
    return _client.nodes.getHistory(nodeId, limit: limit);
  }

  @override
  Future<void> deleteHistory(String nodeId) {
    return _client.nodes.deleteHistory(nodeId);
  }

  // ---------------------------------------------------------------------------
  // Edges
  // ---------------------------------------------------------------------------

  @override
  Future<String> createEdge({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
  }) {
    return _client.edges.create(
      sourceNodeId: sourceNodeId,
      sourcePort: sourcePort,
      targetNodeId: targetNodeId,
      targetPort: targetPort,
    );
  }

  @override
  Future<void> deleteEdge(String edgeId) {
    return _client.edges.delete(edgeId);
  }

  @override
  Future<Map<String, dynamic>?> getEdge(String edgeId) async {
    return _client.edges.get(edgeId);
  }

  @override
  Future<List<Map<String, dynamic>>> getEdges() {
    return _client.edges.list();
  }

  // ---------------------------------------------------------------------------
  // Flow
  // ---------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getFlowState() {
    return _client.flow.get();
  }

  @override
  Future<void> updateFlow({String? name}) {
    return _client.flow.update(name: name);
  }

  @override
  Future<void> enableFlow() {
    return _client.flow.enable();
  }

  @override
  Future<void> disableFlow() {
    return _client.flow.disable();
  }

  // ---------------------------------------------------------------------------
  // Palette
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getPalette() async {
    final entries = await _client.palette.getAll();
    return entries
        .map((e) => {
              'type': e.type,
              'domain': e.domain,
              'category': e.category,
              'description': e.description,
              'inputs': e.inputs
                  .map((p) => {
                        'name': p.name,
                        'type': p.type,
                        'required': p.required,
                        'defaultValue': p.defaultValue,
                      })
                  .toList(),
              'outputs': e.outputs
                  .map((p) => {
                        'name': p.name,
                        'type': p.type,
                        'required': p.required,
                        'defaultValue': p.defaultValue,
                      })
                  .toList(),
              'settingsSchema': e.settingsSchema,
            })
        .toList();
  }
}
