/// Null policy for an input port — lets the node developer control
/// what happens when a port has no value (unwired or upstream is null).
///
/// Mirrors Niagara's approach: null is a first-class value that flows
/// through the graph. Each port decides whether to block or allow it.
enum NullPolicy {
  /// Allow null — the node's evaluate() receives null and decides what to do.
  /// Use for optional inputs. This is the default.
  allow,

  /// Deny null — if this input is null, the node does NOT evaluate.
  /// Output stays at its previous value (or null if never evaluated).
  /// Use for inputs that must have a value to produce a meaningful result.
  deny,
}

/// Describes an input or output slot on a node.
class Port {
  final String name;

  /// "num", "bool", "text", "dynamic"
  final String type;

  /// Controls whether null inputs block evaluation.
  final NullPolicy nullPolicy;

  /// Default value used when no edge feeds this port.
  final dynamic defaultValue;

  const Port({
    required this.name,
    this.type = 'dynamic',
    this.nullPolicy = NullPolicy.allow,
    this.defaultValue,
  });

  /// Whether this port requires a non-null value for the node to evaluate.
  bool get required => nullPolicy == NullPolicy.deny;

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'nullPolicy': nullPolicy.name,
        if (defaultValue != null) 'defaultValue': defaultValue,
      };
}
