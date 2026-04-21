/// Topological sort + cycle detection for the node graph.
class GraphSolver {
  /// Returns node IDs in topological order (sources first, sinks last).
  /// Throws [CycleDetectedException] if the graph contains cycles.
  static List<String> topologicalSort({
    required List<String> nodeIds,
    required Map<String, List<String>> adjacency, // nodeId → downstream nodeIds
  }) {
    final inDegree = <String, int>{};
    for (final id in nodeIds) {
      inDegree[id] = 0;
    }

    for (final entry in adjacency.entries) {
      for (final target in entry.value) {
        inDegree[target] = (inDegree[target] ?? 0) + 1;
      }
    }

    final queue = <String>[];
    for (final id in nodeIds) {
      if (inDegree[id] == 0) queue.add(id);
    }

    final sorted = <String>[];
    while (queue.isNotEmpty) {
      final node = queue.removeAt(0);
      sorted.add(node);
      for (final target in (adjacency[node] ?? [])) {
        inDegree[target] = inDegree[target]! - 1;
        if (inDegree[target] == 0) queue.add(target);
      }
    }

    if (sorted.length != nodeIds.length) {
      throw CycleDetectedException(
        'Graph contains a cycle — ${nodeIds.length - sorted.length} nodes involved',
      );
    }

    return sorted;
  }

  /// Given a set of dirty node IDs and the topological order,
  /// returns only the nodes that need re-evaluation (dirty + all downstream).
  static List<String> dirtySubgraph({
    required Set<String> dirtyIds,
    required List<String> topoOrder,
    required Map<String, List<String>> adjacency,
  }) {
    final reachable = <String>{...dirtyIds};

    for (final nodeId in topoOrder) {
      if (!reachable.contains(nodeId)) continue;
      for (final target in (adjacency[nodeId] ?? [])) {
        reachable.add(target);
      }
    }

    // Return in topo order
    return topoOrder.where(reachable.contains).toList();
  }
}

class CycleDetectedException implements Exception {
  final String message;
  CycleDetectedException(this.message);

  @override
  String toString() => 'CycleDetectedException: $message';
}
