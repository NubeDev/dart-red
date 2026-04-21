import '../../node_helpers.dart';

/// Add two numbers (a + b) → out
class MathAddNode extends BinaryMathNode {
  @override
  String get typeName => 'math.add';

  @override
  String get description => 'Add two numbers (a + b)';

  @override
  String get iconName => 'plus';

  @override
  num compute(num a, num b) => a + b;
}
