import 'parse_utils.dart';
import 'types.dart';

/// Port of Go `parseRIOTStatus`.
RiotStatus parseRiotStatus(List<String> lines) {
  final clean = cleanLines(lines);
  if (clean.isEmpty) return const RiotStatus(message: '', code: -1);

  final text = clean.join(' ').trim();
  var code = -1;
  final codeMatch = RegExp(r'\(status code:\s*(\d+)\)').firstMatch(text);
  if (codeMatch != null) code = int.tryParse(codeMatch.group(1)!) ?? -1;

  var message = text;
  final parenIdx = text.indexOf('(status code:');
  if (parenIdx != -1) message = text.substring(0, parenIdx).trim();

  return RiotStatus(message: message, code: code, raw: lines);
}

/// Port of Go `ParseRIOTPackageInfo` — numbered list with "+ ID:" / "+ Version:".
List<RiotPackageEntry> parseRiotPackageInfo(List<String> lines) {
  final clean = cleanLines(lines);
  final packages = <RiotPackageEntry>[];
  String? currentName;
  int? currentId;
  String? currentVersion;

  void flush() {
    if (currentName != null) {
      packages.add(RiotPackageEntry(
        name: currentName!, id: currentId ?? 0, version: currentVersion ?? '',
      ));
    }
    currentName = null; currentId = null; currentVersion = null;
  }

  for (final line in clean) {
    if (line.contains(')') && !line.trimLeft().startsWith('+')) {
      flush();
      currentName = line.substring(line.indexOf(')') + 1).trim();
      continue;
    }
    if (line.trimLeft().startsWith('+') && line.contains(':')) {
      final content = line.substring(line.indexOf('+') + 1).trim();
      final colonIdx = content.indexOf(':');
      if (colonIdx == -1) continue;
      final key = content.substring(0, colonIdx).trim();
      final value = content.substring(colonIdx + 1).trim();
      switch (key) {
        case 'ID':      currentId = int.tryParse(value);
        case 'Version': currentVersion = value;
      }
    }
  }
  flush();
  return packages;
}

/// Port of Go `parseRIOTNodeInfo` — numbered nodes with output values.
List<RiotNodeEntry> parseRiotNodeInfo(List<String> lines) {
  final clean = cleanLines(lines);
  final nodes = <RiotNodeEntry>[];
  int? currentNodeId;
  final outputs = <int, double>{};

  void flush() {
    if (currentNodeId != null) {
      nodes.add(RiotNodeEntry(nodeId: currentNodeId!, outputs: Map.of(outputs)));
    }
    currentNodeId = null; outputs.clear();
  }

  for (final line in clean) {
    final nodeMatch = RegExp(r'\)\s*Node\s+(\d+)').firstMatch(line);
    if (nodeMatch != null) {
      flush();
      currentNodeId = int.tryParse(nodeMatch.group(1)!);
      continue;
    }
    final outMatch = RegExp(r'\+\s*Output\s+(\d+)\s*:\s*(.+)').firstMatch(line);
    if (outMatch != null && currentNodeId != null) {
      final idx = int.tryParse(outMatch.group(1)!);
      final val = double.tryParse(outMatch.group(2)!.trim());
      if (idx != null && val != null) outputs[idx] = val;
    }
  }
  flush();
  return nodes;
}
