import 'parse_utils.dart';
import 'types.dart';

/// Port of Go `parseParamList` — table with │ separators.
List<ParamValue> parseParamList(List<String> lines) {
  final params = <ParamValue>[];
  var inDataRows = false;
  var hasAccessColumn = false;

  for (final line in lines) {
    if (line.contains('├') || line.contains('┌') || line.contains('└')) continue;

    if (line.contains('PUC') && line.contains('Alias')) {
      inDataRows = true;
      hasAccessColumn = line.contains('Access');
      continue;
    }
    if (!inDataRows) continue;

    final parts = line.split('│');
    final minParts = hasAccessColumn ? 6 : 5;
    if (parts.length < minParts) continue;

    final puc = parts[1].trim();
    if (puc.isEmpty) continue;

    final alias = parts[2].trim();
    final dataType = parts[3].trim();
    final access = hasAccessColumn ? parts[4].trim() : '';
    final value = hasAccessColumn ? parts[5].trim() : parts[4].trim();

    params.add(ParamValue(
      puc: puc, alias: alias, dataType: dataType,
      access: access, value: value, raw: line,
    ));
  }
  return params;
}

/// Port of Go `parseParamGet` — "+ Key : Value" lines.
ParamValue? parseParamGet(List<String> lines) {
  final clean = cleanLines(lines);
  String puc = '', alias = '', dataType = '', value = '';
  int size = 0;

  for (final line in clean) {
    if (!line.startsWith('+ ')) continue;
    final content = line.substring(2);
    final colonIdx = content.indexOf(':');
    if (colonIdx == -1) continue;
    final fieldName = content.substring(0, colonIdx).trim();
    final fieldValue = content.substring(colonIdx + 1).trim();

    switch (fieldName) {
      case 'PUC':   puc = fieldValue;
      case 'Alias': alias = fieldValue;
      case 'Data type':
        final parenIdx = fieldValue.indexOf(' (');
        if (parenIdx != -1) {
          dataType = fieldValue.substring(0, parenIdx).trim();
          final sizeStr = fieldValue.substring(parenIdx + 2);
          final spaceIdx = sizeStr.indexOf(' ');
          if (spaceIdx != -1) size = int.tryParse(sizeStr.substring(0, spaceIdx)) ?? 0;
        } else {
          dataType = fieldValue;
        }
      case 'Value': value = fieldValue;
    }
  }

  if (puc.isEmpty && value.isEmpty) return null;
  return ParamValue(puc: puc, alias: alias, dataType: dataType, value: value, size: size);
}
