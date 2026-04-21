import 'parse_utils.dart';
import 'types.dart';

/// Port of Go `parseTimeGetResponse`.
RTCTime? parseTime(List<String> lines) {
  final clean = cleanLines(lines);
  if (clean.isEmpty) return null;

  final firstLine = clean[0];
  final friendly = clean.length > 1 ? clean[1] : firstLine;

  // Try "YYYY-MM-DD HH:MM:SS"
  final match = RegExp(r'(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})')
      .firstMatch(firstLine);
  if (match != null) {
    return RTCTime(
      year: int.parse(match.group(1)!), month: int.parse(match.group(2)!),
      day: int.parse(match.group(3)!), hour: int.parse(match.group(4)!),
      minute: int.parse(match.group(5)!), second: int.parse(match.group(6)!),
      raw: firstLine, friendly: friendly,
    );
  }

  // Fallback: 2-digit year "YY-MM-DD HH:MM:SS"
  final match2 = RegExp(r'(\d{2})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})')
      .firstMatch(firstLine);
  if (match2 != null) {
    return RTCTime(
      year: int.parse(match2.group(1)!), month: int.parse(match2.group(2)!),
      day: int.parse(match2.group(3)!), hour: int.parse(match2.group(4)!),
      minute: int.parse(match2.group(5)!), second: int.parse(match2.group(6)!),
      raw: firstLine, friendly: friendly,
    );
  }

  return RTCTime(raw: firstLine, friendly: friendly);
}

/// Port of Go `parseRTCGetResponse` — "Current date and time: YY-MM-DD HH:MM:SS".
RTCTime? parseRtcGet(List<String> lines) {
  final clean = cleanLines(lines);
  if (clean.isEmpty) return null;

  final text = clean.join(' ');
  final match = RegExp(r'(\d{2})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})')
      .firstMatch(text);
  if (match == null) return RTCTime(raw: text, friendly: text);

  return RTCTime(
    year: int.parse(match.group(1)!), month: int.parse(match.group(2)!),
    day: int.parse(match.group(3)!), hour: int.parse(match.group(4)!),
    minute: int.parse(match.group(5)!), second: int.parse(match.group(6)!),
    raw: text, friendly: text,
  );
}
