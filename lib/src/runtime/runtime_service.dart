/// Abstract interface for runtime operations.
///
/// Two implementations:
///   [EmbeddedRuntimeService] — direct in-process calls to [MicroBmsRuntime]
///   [RemoteRuntimeService]   — HTTP calls via [RuntimeApiClient]
///
/// The dashboard, settings, and every feature call [RuntimeService] —
/// never [RuntimeApiClient] or [MicroBmsRuntime] directly.
abstract class RuntimeService {
  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  Future<void> start();
  Future<void> stop();
  bool get isRunning;

  // ---------------------------------------------------------------------------
  // Pages (dashboard)
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getPages();

  // ---------------------------------------------------------------------------
  // Nodes — CRUD
  // ---------------------------------------------------------------------------

  Future<String> createNode({
    required String type,
    Map<String, dynamic> settings = const {},
    String? label,
    String? parentId,
    double posX = 0.0,
    double posY = 0.0,
  });

  Future<void> updateNode(String nodeId, {String? label});
  Future<void> updateNodePosition(String nodeId, double posX, double posY);
  Future<void> deleteNode(String nodeId);

  Future<Map<String, dynamic>?> getNode(String nodeId,
      {bool includeChildren = false});
  Future<List<Map<String, dynamic>>> getNodes();
  Future<List<Map<String, dynamic>>> getChildNodes(String nodeId);

  // ---------------------------------------------------------------------------
  // Nodes — value
  // ---------------------------------------------------------------------------

  Future<({dynamic value, String status})> getNodeValue(String nodeId);
  Future<void> setNodeValue(String nodeId, dynamic value);

  // ---------------------------------------------------------------------------
  // Nodes — settings
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getNodeSettings(String nodeId);
  Future<Map<String, dynamic>> getNodeSettingsSchema(String nodeId);
  Future<void> updateNodeSettings(String nodeId, Map<String, dynamic> patch);

  // ---------------------------------------------------------------------------
  // Nodes — history
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getHistory(String nodeId,
      {int limit = 100});
  Future<void> deleteHistory(String nodeId);

  // ---------------------------------------------------------------------------
  // Edges
  // ---------------------------------------------------------------------------

  Future<String> createEdge({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
  });

  Future<void> deleteEdge(String edgeId);
  Future<Map<String, dynamic>?> getEdge(String edgeId);
  Future<List<Map<String, dynamic>>> getEdges();

  // ---------------------------------------------------------------------------
  // Flow
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getFlowState();
  Future<void> updateFlow({String? name});
  Future<void> enableFlow();
  Future<void> disableFlow();

  // ---------------------------------------------------------------------------
  // Palette
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getPalette();
}
