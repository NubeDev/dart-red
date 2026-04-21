import 'port.dart';

/// Base class for all runtime nodes.
abstract class NodeType {
  /// Unique type identifier, e.g. "mqtt.subscribe", "math.add"
  String get typeName;

  /// "source", "transform", or "sink"
  String get category;

  /// Human-readable description for the palette UI.
  String get description;

  /// Lucide icon name for this node type, shown in the palette and header.
  /// Override to provide a custom icon per node type.
  /// Default is derived from the category: source → 'radio', transform → 'shuffle', sink → 'arrow-down-to-line'.
  String get iconName => switch (category) {
        'source' => 'radio',
        'transform' => 'shuffle',
        'sink' => 'arrow-down-to-line',
        _ => 'circle-dot',
      };

  /// JSON Schema for this node type's settings.
  /// The UI auto-generates a form from this — no hardcoded fields.
  /// Supports standard JSON Schema features including if/then/else for
  /// cascading fields.
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {},
      };

  /// Human-readable label for this node instance, used in node-picker
  /// dropdowns and UI listings. Override to surface the most useful
  /// setting (e.g. host, topic, page name). Default: short ID.
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    return settings['label'] as String? ?? nodeId.substring(0, 8);
  }

  /// Node types that can be children of this node (containment).
  /// Empty = no children allowed (leaf node).
  /// Example: mqtt.broker allows ['mqtt.subscribe', 'mqtt.publish']
  List<String> get allowedChildTypes => const [];

  /// Whether this node type must have a parent of a specific type.
  /// null = can be a root node. Override to enforce hierarchy.
  /// Example: mqtt.subscribe requires parent of type 'mqtt.broker'
  String? get requiredParentType => null;

  /// Ports declared by this node type.
  /// For static ports, override the getter directly.
  /// For variadic ports (count from settings), override [getInputPorts]
  /// or [getOutputPorts] instead.
  List<Port> get inputPorts;
  List<Port> get outputPorts;

  /// Returns the actual input ports for a specific node instance.
  /// Override this for variadic nodes where port count comes from settings.
  /// Default: returns [inputPorts] (static).
  List<Port> getInputPorts(Map<String, dynamic> settings) => inputPorts;

  /// Returns the actual output ports for a specific node instance.
  /// Override this for variadic nodes where port count comes from settings.
  /// Default: returns [outputPorts] (static).
  List<Port> getOutputPorts(Map<String, dynamic> settings) => outputPorts;

  /// Called once when the node is added to the running graph.
  /// Source nodes start their subscriptions here.
  /// [parentId] is the containing node (null if root).
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {}

  /// Called when the node is removed from the running graph.
  Future<void> stop(String nodeId) async {}
}

/// A source node produces values from external events (MQTT, constants, etc.)
abstract class SourceNode extends NodeType {
  @override
  String get category => 'source';

  @override
  List<Port> get inputPorts => const [];
}

/// A transform node computes outputs from inputs (pure, synchronous).
abstract class TransformNode extends NodeType {
  @override
  String get category => 'transform';

  /// Pure evaluation: given input values, return output values.
  /// Return null to signal "can't compute" (propagates stale).
  Map<String, dynamic>? evaluate(Map<String, dynamic> inputs);
}

/// A sink node performs side effects (write, publish, alarm, etc.)
abstract class SinkNode extends NodeType {
  @override
  String get category => 'sink';

  @override
  List<Port> get outputPorts => const [];

  /// Execute the side effect. May be async.
  /// [parentId] is the containing node (null if root).
  /// Returns output values (optional). If non-null, these become the node's
  /// output — wirable to downstream nodes. If null, inputs are used as value.
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  });
}
