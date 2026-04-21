import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import 'client_base.dart';

/// Time commands: time_get, time_set, rtc_get.
mixin ClientTimeMixin on AcbmClientBase {
  Future<models.DeviceTime> getTime() async {
    final lines = await transport.execute('time_get');
    final parsed = parseTime(lines);
    if (parsed == null) throw StateError('Failed to parse time response');
    return models.DeviceTime(
      year: parsed.year, month: parsed.month, day: parsed.day,
      hour: parsed.hour, minute: parsed.minute, second: parsed.second,
      raw: parsed.raw,
    );
  }

  Future<void> setTime(DateTime time) async {
    final epoch = time.millisecondsSinceEpoch ~/ 1000;
    await transport.execute('time_set $epoch');
  }

  Future<models.DeviceTime?> getRtcTime() async {
    final lines = await transport.execute('rtc_get');
    final parsed = parseRtcGet(lines);
    if (parsed == null) return null;
    return models.DeviceTime(
      year: parsed.year, month: parsed.month, day: parsed.day,
      hour: parsed.hour, minute: parsed.minute, second: parsed.second,
      raw: parsed.raw,
    );
  }
}
