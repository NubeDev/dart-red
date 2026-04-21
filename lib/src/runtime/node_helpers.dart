import 'node.dart';
import 'port.dart';

export 'node.dart';
export 'port.dart';

/// Parse a value to num, handling strings. Returns null if unparseable.
num? parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

// ---------------------------------------------------------------------------
// Transform helpers
// ---------------------------------------------------------------------------

/// Base for nodes that take N numeric inputs and produce one output.
///
/// Supports variadic inputs — the user sets `inputCount` in settings
/// (default 2, min 2, max 16). Ports are named `in_1`, `in_2`, etc.
///
/// Subclass only needs: typeName, description, compute().
///
/// ```dart
/// class MathAddNode extends VariadicMathNode {
///   @override String get typeName => 'math.add';
///   @override String get description => 'Add numbers';
///   @override num compute(num a, num b) => a + b;
/// }
/// ```
abstract class VariadicMathNode extends TransformNode {
  /// Default input count when no setting is provided.
  int get defaultInputCount => 2;

  @override
  List<Port> get inputPorts => _makePorts(defaultInputCount);

  @override
  List<Port> getInputPorts(Map<String, dynamic> settings) {
    final count = settings['inputCount'] as int? ?? defaultInputCount;
    return _makePorts(count.clamp(2, 16));
  }

  List<Port> _makePorts(int count) {
    return List.generate(
      count,
      (i) => Port(name: 'in_${i + 1}', type: 'num'),
    );
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'out', type: 'num'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'inputCount': {
            'type': 'integer',
            'title': 'Number of Inputs',
            'default': defaultInputCount,
            'minimum': 2,
            'maximum': 16,
          },
        },
      };

  /// Pairwise operation applied across all inputs (left fold).
  num compute(num a, num b);

  @override
  Map<String, dynamic>? evaluate(Map<String, dynamic> inputs) {
    final values = <num>[];
    for (final entry in inputs.entries) {
      final v = parseNum(entry.value);
      if (v != null) values.add(v);
    }
    if (values.isEmpty) return {'out': null};
    if (values.length == 1) return {'out': values.first};
    return {'out': values.reduce(compute)};
  }
}

// Keep backward compat alias
typedef BinaryMathNode = VariadicMathNode;

/// Base for nodes that take one numeric input and produce one output.
abstract class UnaryMathNode extends TransformNode {
  @override
  List<Port> get inputPorts => const [
        Port(name: 'in', type: 'num'),
      ];

  @override
  List<Port> get outputPorts => const [
        Port(name: 'out', type: 'num'),
      ];

  /// Pure math operation on one number.
  num compute(num value);

  @override
  Map<String, dynamic>? evaluate(Map<String, dynamic> inputs) {
    final v = parseNum(inputs['in']);
    if (v == null) return {'out': null};
    return {'out': compute(v)};
  }
}

// ---------------------------------------------------------------------------
// Source helpers
// ---------------------------------------------------------------------------

/// A source node with a single "value" output port (the most common pattern).
abstract class SingleOutputSource extends SourceNode {
  @override
  List<Port> get outputPorts => const [
        Port(name: 'value', type: 'dynamic'),
      ];
}
