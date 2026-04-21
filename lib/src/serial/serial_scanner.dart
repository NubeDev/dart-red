import 'dart:async';
import 'dart:io';

import 'serial_models.dart';
import 'serial_platform.dart';

export 'serial_models.dart';

/// Cross-platform serial port scanner.
///
/// Discovers USB-to-serial devices (ESP32, Arduino, etc.) on:
/// - **Linux/Windows:** via `flutter_libserialport`
/// - **Android:** via `usb_serial`
/// - **iOS:** Not supported (Apple MFi restriction on USB accessories)
///
/// Usage:
/// ```dart
/// final scanner = SerialScanner();
/// final ports = await scanner.listPorts();
/// for (final port in ports) {
///   print('${port.displayName} [${port.vidPid}]');
/// }
/// ```
class SerialScanner {
  final SerialPlatform _platform;

  SerialScanner() : _platform = SerialPlatform();

  /// Whether the current platform supports serial port scanning.
  bool get isPlatformSupported =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS || Platform.isAndroid;

  /// Lists all serial ports currently available on the system.
  ///
  /// On Android this lists USB devices that present as serial ports.
  /// On desktop this lists all system serial ports.
  Future<List<SerialPortInfo>> listPorts() async {
    if (!isPlatformSupported) return [];
    return _platform.listPorts();
  }

  /// Lists only ports that look like USB-to-serial adapters.
  ///
  /// Filters to devices with a VID/PID — excludes built-in serial
  /// ports and Bluetooth COM ports.
  Future<List<SerialPortInfo>> listUsbPorts() async {
    final all = await listPorts();
    return all.where((p) => p.isUsbSerial).toList();
  }

  /// Watches for USB serial device attach/detach events.
  ///
  /// On Android, this uses system USB broadcast receivers.
  /// On desktop, this polls at the given interval since
  /// `libserialport` doesn't provide native hotplug events.
  Stream<List<SerialPortInfo>> watchPorts({
    Duration pollInterval = const Duration(seconds: 2),
  }) {
    return _platform.watchPorts(pollInterval: pollInterval);
  }
}
