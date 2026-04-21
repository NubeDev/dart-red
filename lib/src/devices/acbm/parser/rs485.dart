import 'types.dart';

/// Port of Go `ParseRS485Settings` — "115200-8-N-1".
RS485SettingsParsed? parseRS485Settings(String value) {
  final parts = value.split('-');
  if (parts.length != 4) return null;
  final baud = int.tryParse(parts[0]);
  final dataBits = int.tryParse(parts[1]);
  final parity = parts[2];
  final stopBits = int.tryParse(parts[3]);
  if (baud == null || dataBits == null || stopBits == null) return null;
  return RS485SettingsParsed(baudRate: baud, dataBits: dataBits, parity: parity, stopBits: stopBits);
}
