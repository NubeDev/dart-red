/// ACBM/Riot TCP response parser — barrel export.
///
/// Direct port of Go `parser/*.go`. Each function takes raw response lines
/// and returns typed Dart objects. All parsers are lenient — they skip
/// malformed lines rather than throwing, matching Go behavior.
library;

export 'types.dart';
export 'format.dart';
export 'device_info.dart' show parseDeviceInfo;
export 'params.dart' show parseParamList, parseParamGet;
export 'time.dart' show parseTime, parseRtcGet;
export 'riot.dart' show parseRiotStatus, parseRiotPackageInfo, parseRiotNodeInfo;
export 'command_list.dart' show parseCommandList;
export 'rs485.dart' show parseRS485Settings;

import 'device_info.dart';
import 'params.dart';
import 'time.dart';
import 'riot.dart';
import 'command_list.dart';

/// Dispatcher — route command name to parser (mirrors Go ParseResponse).
dynamic parseResponse(String command, List<String> lines) {
  return switch (command) {
    'dev_info'          => parseDeviceInfo(lines),
    'param_list'        => parseParamList(lines),
    'param_get'         => parseParamGet(lines),
    'time_get'          => parseTime(lines),
    'rtc_get'           => parseRtcGet(lines),
    'riot_status'       => parseRiotStatus(lines),
    'riot_package_info' => parseRiotPackageInfo(lines),
    'riot_node_info'    => parseRiotNodeInfo(lines),
    'list'              => parseCommandList(lines),
    _                   => lines,
  };
}
