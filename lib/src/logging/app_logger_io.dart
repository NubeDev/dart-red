import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

IOSink? _sink;
bool _ready = false;

Future<void> initLogger() async {
  try {
    final dir = await getApplicationSupportDirectory();
    var logFile = File('${dir.path}/rubix.log');

    // Rotate if > 1 MB.
    if (logFile.existsSync() && logFile.lengthSync() > 1024 * 1024) {
      final old = File('${dir.path}/rubix.log.old');
      if (old.existsSync()) old.deleteSync();
      logFile.renameSync(old.path);
      logFile = File('${dir.path}/rubix.log');
    }

    _sink = logFile.openWrite(mode: FileMode.append);
    _ready = true;
    debugPrint('AppLogger: initialized — ${logFile.path}');
  } catch (e) {
    debugPrint('AppLogger: failed to init — $e');
  }
}

void writeLine(String line) {
  if (_ready) {
    _sink?.writeln(line);
    _sink?.flush();
  }
}
