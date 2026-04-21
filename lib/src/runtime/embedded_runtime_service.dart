import '../db/app_database.dart';
import 'api/runtime_api.dart';
import 'runtime.dart';
import 'runtime_builder.dart';
import 'runtime_service.dart';

/// In-process runtime — no HTTP, no daemon.
///
/// Owns the [MicroBmsRuntime] directly. Used on Linux desktop and Android
/// tablets where the runtime runs inside the Flutter app.
///
/// Optionally starts the REST API too ([serveApi]) so external tools
/// like the flow editor can still connect over HTTP.
class EmbeddedRuntimeService implements RuntimeService {
  final AppDatabase _db;
  late final MicroBmsRuntime _runtime;
  RuntimeApi? _api;
  bool _started = false;

  /// If true, also start the REST API on [apiPort] for external tools.
  final bool serveApi;
  final int apiPort;

  EmbeddedRuntimeService({
    required AppDatabase db,
    this.serveApi = false,
    this.apiPort = 8080,
  }) : _db = db;

  @override
  bool get isRunning => _started && _runtime.isRunning;

  /// Access the underlying runtime (for advanced use / testing).
  MicroBmsRuntime get runtime => _runtime;

  @override
  Future<void> start() async {
    if (_started) return;

    _runtime = RuntimeBuilder(dao: _db.runtimeDao)
        .withAllNodes()
        .build();
    await _runtime.start();
    _started = true;

    if (serveApi) {
      _api = RuntimeApi(_runtime);
      await _api!.serve(port: apiPort);
    }
  }

  @override
  Future<void> stop() async {
    await _api?.stop();
    _api = null;
    if (_started) {
      await _runtime.stop();
      _started = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Pages
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getPages() async {
    return _runtime.getPages();
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
    return _runtime.createNode(
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
    return _runtime.updateNode(nodeId, label: label);
  }

  @override
  Future<void> updateNodePosition(String nodeId, double posX, double posY) {
    return _runtime.updateNodePosition(nodeId, posX, posY);
  }

  @override
  Future<void> deleteNode(String nodeId) {
    return _runtime.deleteNode(nodeId);
  }

  @override
  Future<Map<String, dynamic>?> getNode(String nodeId,
      {bool includeChildren = false}) async {
    final node = _runtime.getNode(nodeId);
    if (node == null) return null;
    if (includeChildren) {
      node['childNodes'] = _runtime.getNodeTree(nodeId);
    }
    return node;
  }

  @override
  Future<List<Map<String, dynamic>>> getNodes() async {
    return _runtime.getNodes();
  }

  @override
  Future<List<Map<String, dynamic>>> getChildNodes(String nodeId) async {
    return _runtime.getChildNodes(nodeId);
  }

  // ---------------------------------------------------------------------------
  // Nodes — value
  // ---------------------------------------------------------------------------

  @override
  Future<({dynamic value, String status})> getNodeValue(String nodeId) async {
    final result = _runtime.getNodeValue(nodeId);
    if (result == null) {
      throw ArgumentError('Node not found: $nodeId');
    }
    final value =
        result.value.length == 1 ? result.value.values.first : result.value;
    return (value: value, status: result.status.name);
  }

  @override
  Future<void> setNodeValue(String nodeId, dynamic value) {
    return _runtime.setNodeValue(nodeId, value);
  }

  // ---------------------------------------------------------------------------
  // Nodes — settings
  // ---------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getNodeSettings(String nodeId) async {
    final settings = _runtime.getNodeSettings(nodeId);
    if (settings == null) throw ArgumentError('Node not found: $nodeId');
    return settings;
  }

  @override
  Future<Map<String, dynamic>> getNodeSettingsSchema(String nodeId) async {
    final schema = await _runtime.getNodeSettingsSchema(nodeId);
    if (schema == null) throw ArgumentError('Node not found: $nodeId');
    return schema;
  }

  @override
  Future<void> updateNodeSettings(String nodeId, Map<String, dynamic> patch) {
    return _runtime.updateNodeSettings(nodeId, patch);
  }

  // ---------------------------------------------------------------------------
  // Nodes — history
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getHistory(String nodeId,
      {int limit = 100}) {
    return _runtime.getHistory(nodeId, limit: limit);
  }

  @override
  Future<void> deleteHistory(String nodeId) {
    return _runtime.deleteHistory(nodeId);
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
    return _runtime.createEdge(
      sourceNodeId: sourceNodeId,
      sourcePort: sourcePort,
      targetNodeId: targetNodeId,
      targetPort: targetPort,
    );
  }

  @override
  Future<void> deleteEdge(String edgeId) {
    return _runtime.deleteEdge(edgeId);
  }

  @override
  Future<Map<String, dynamic>?> getEdge(String edgeId) {
    return _runtime.getEdge(edgeId);
  }

  @override
  Future<List<Map<String, dynamic>>> getEdges() {
    return _runtime.getEdges();
  }

  // ---------------------------------------------------------------------------
  // Flow
  // ---------------------------------------------------------------------------

  @override
  Future<Map<String, dynamic>> getFlowState() {
    return _runtime.getFlowState();
  }

  @override
  Future<void> updateFlow({String? name}) {
    return _runtime.updateFlow(name: name);
  }

  @override
  Future<void> enableFlow() {
    return _runtime.enableFlow();
  }

  @override
  Future<void> disableFlow() {
    return _runtime.disableFlow();
  }

  // ---------------------------------------------------------------------------
  // Palette
  // ---------------------------------------------------------------------------

  @override
  Future<List<Map<String, dynamic>>> getPalette() async {
    return _runtime.getPalette();
  }
}
