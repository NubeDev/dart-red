import 'package:flutter/foundation.dart';

import 'app_logger_io.dart' if (dart.library.js_interop) 'app_logger_web.dart'
    as platform;

/// Simple logger for debugging crashes and transport issues.
///
/// On native platforms, writes to `<app-support-dir>/rubix.log` (rotates at 1 MB).
/// On web, falls back to console-only logging (no file I/O).
class AppLogger {
  /// Call once at app startup.
  static Future<void> init() => platform.initLogger();

  /// Log a message with tag and timestamp.
  static void log(String tag, String message) {
    final line = '${DateTime.now().toIso8601String()} [$tag] $message';
    debugPrint(line);
    platform.writeLine(line);
  }

  /// Log an error with optional stack trace.
  static void error(String tag, String message,
      [Object? error, StackTrace? stack]) {
    log(tag, 'ERROR: $message${error != null ? ' — $error' : ''}');
    if (stack != null) {
      log(tag, stack.toString().split('\n').take(5).join('\n'));
    }
  }
}
