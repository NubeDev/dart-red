import 'parse_utils.dart';
import 'types.dart';

/// Port of Go `parseListResponse`.
List<CommandInfo> parseCommandList(List<String> lines) {
  final clean = cleanLines(lines);
  final commands = <CommandInfo>[];
  for (final line in clean) {
    final match = RegExp(r'^(\S+)\s+(.+)$').firstMatch(line);
    if (match != null) {
      commands.add(CommandInfo(name: match.group(1)!, description: match.group(2)!.trim()));
    }
  }
  return commands;
}
