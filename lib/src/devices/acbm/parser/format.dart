import 'dart:typed_data';

/// Format a Dart value for sending via param_set.
/// Port of Go `FormatParamValue`.
String formatParamValue(Object value) {
  if (value is String) return value;
  if (value is int) return value.toString();
  if (value is double) return value.toString();
  if (value is bool) return value ? '1' : '0';
  if (value is Uint8List) {
    return value.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join('-');
  }
  throw ArgumentError('Unsupported param value type: ${value.runtimeType}');
}

/// Convert an IPv4 string to blob format for param_set.
/// "192.168.15.10" → "C0-A8-0F-0A"
String ipToBlob(String ip) {
  final parts = ip.split('.');
  if (parts.length != 4) throw ArgumentError('Invalid IPv4: $ip');
  final bytes = Uint8List.fromList(parts.map((p) => int.parse(p)).toList());
  return formatParamValue(bytes);
}
