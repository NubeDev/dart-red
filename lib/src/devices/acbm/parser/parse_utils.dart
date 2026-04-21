/// Shared parser utilities.

/// Clean empty lines from response — done first in Go's ParseResponse.
List<String> cleanLines(List<String> lines) =>
    lines.map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

/// Generic section parser: find "+ <header>" line, collect indented key-value
/// lines below it until the next section or end.
T? parseInterfaceSection<T>(
  List<String> lines,
  String header,
  T Function(Map<String, String>) builder,
) {
  var inSection = false;
  final kv = <String, String>{};

  for (final line in lines) {
    if (line.startsWith('+') && line.contains(header)) {
      inSection = true;
      continue;
    }
    if (inSection && line.startsWith('+') && !line.startsWith('+ ')) break;

    if (inSection && line.contains(':')) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join(':').trim();
        if (key.isNotEmpty) kv[key] = value;
      }
    }
  }

  return kv.isEmpty ? null : builder(kv);
}
