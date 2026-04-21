import 'runtime_service.dart';

/// No-op runtime service — the app runs without any runtime.
///
/// All reads return empty data. All writes are silently ignored.
/// Used when the app is launched with RUNTIME_MODE=none.
class DisabledRuntimeService implements RuntimeService {
  @override
  bool get isRunning => false;

  @override
  Future<void> start() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<List<Map<String, dynamic>>> getPages() async => [];

  @override
  Future<String> createNode({
    required String type,
    Map<String, dynamic> settings = const {},
    String? label,
    String? parentId,
    double posX = 0.0,
    double posY = 0.0,
  }) async =>
      throw StateError('Runtime is disabled');

  @override
  Future<void> updateNode(String nodeId, {String? label}) async {}

  @override
  Future<void> updateNodePosition(String nodeId, double posX, double posY) async {}

  @override
  Future<void> deleteNode(String nodeId) async {}

  @override
  Future<Map<String, dynamic>?> getNode(String nodeId,
          {bool includeChildren = false}) async =>
      null;

  @override
  Future<List<Map<String, dynamic>>> getNodes() async => [];

  @override
  Future<List<Map<String, dynamic>>> getChildNodes(String nodeId) async => [];

  @override
  Future<({dynamic value, String status})> getNodeValue(String nodeId) async =>
      (value: null, status: 'stale');

  @override
  Future<void> setNodeValue(String nodeId, dynamic value) async {}

  @override
  Future<Map<String, dynamic>> getNodeSettings(String nodeId) async => {};

  @override
  Future<Map<String, dynamic>> getNodeSettingsSchema(String nodeId) async => {};

  @override
  Future<void> updateNodeSettings(
      String nodeId, Map<String, dynamic> patch) async {}

  @override
  Future<List<Map<String, dynamic>>> getHistory(String nodeId,
          {int limit = 100}) async =>
      [];

  @override
  Future<void> deleteHistory(String nodeId) async {}

  @override
  Future<String> createEdge({
    required String sourceNodeId,
    required String sourcePort,
    required String targetNodeId,
    required String targetPort,
  }) async =>
      throw StateError('Runtime is disabled');

  @override
  Future<void> deleteEdge(String edgeId) async {}

  @override
  Future<Map<String, dynamic>?> getEdge(String edgeId) async => null;

  @override
  Future<List<Map<String, dynamic>>> getEdges() async => [];

  @override
  Future<Map<String, dynamic>> getFlowState() async => {
        'flow': {'id': null, 'name': null, 'enabled': false},
        'nodes': <Map<String, dynamic>>[],
        'edges': <Map<String, dynamic>>[],
      };

  @override
  Future<void> updateFlow({String? name}) async {}

  @override
  Future<void> enableFlow() async {}

  @override
  Future<void> disableFlow() async {}

  @override
  Future<List<Map<String, dynamic>>> getPalette() async => [];
}
