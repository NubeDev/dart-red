import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import '../transport.dart';

/// Base class providing transport access and shared helpers.
///
/// Domain-specific methods live in mixins (client_system.dart, etc.)
/// and are composed together in [AcbmClient].
abstract class AcbmClientBase {
  AcbmTransport get transport;

  /// Fetch the full parameter list as a map keyed by alias.
  Future<Map<String, ParamValue>> paramMap() async {
    final lines = await transport.execute('param_list');
    final params = parseParamList(lines);
    return {for (final p in params) p.alias: p};
  }

  /// Best-effort numeric parse from raw response lines.
  models.PointValue parsePointValue(List<String> lines) {
    final raw = lines.join('\n');
    final clean = lines.map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (clean.isEmpty) return models.PointValue(value: 0, raw: raw);
    final num = double.tryParse(clean.last) ?? 0;
    return models.PointValue(value: num, raw: raw);
  }
}
