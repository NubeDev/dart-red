/// Runtime status of a node.
enum NodeStatus {
  ok,
  stale,
  error,
  disabled;

  /// Merge upstream statuses: worst status wins.
  static NodeStatus merge(Iterable<NodeStatus> statuses) {
    if (statuses.isEmpty) return NodeStatus.ok;
    var worst = NodeStatus.ok;
    for (final s in statuses) {
      if (s.index > worst.index) worst = s;
    }
    return worst;
  }

  static NodeStatus fromString(String s) {
    switch (s) {
      case 'ok':
        return NodeStatus.ok;
      case 'stale':
        return NodeStatus.stale;
      case 'error':
        return NodeStatus.error;
      case 'disabled':
        return NodeStatus.disabled;
      default:
        return NodeStatus.stale;
    }
  }
}
