import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:usb_serial/usb_serial.dart';

import 'serial_models.dart';

/// Platform-specific serial port operations.
///
/// Routes to `flutter_libserialport` on desktop or `usb_serial` on Android.
/// Both packages are imported — native code is only bundled for the target
/// platform at build time.
class SerialPlatform {
  /// Lists available serial ports using the platform-appropriate backend.
  Future<List<SerialPortInfo>> listPorts() async {
    if (Platform.isAndroid) {
      return _listAndroidPorts();
    }
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return _listDesktopPorts();
    }
    return [];
  }

  /// Watches for serial port changes.
  Stream<List<SerialPortInfo>> watchPorts({
    Duration pollInterval = const Duration(seconds: 2),
  }) {
    if (Platform.isAndroid) {
      return _watchAndroidPorts();
    }
    return _pollDesktopPorts(pollInterval);
  }

  // ---------------------------------------------------------------------------
  // Desktop — flutter_libserialport
  // ---------------------------------------------------------------------------

  List<SerialPortInfo> _listDesktopPorts() {
    final List<String> names;
    try {
      names = SerialPort.availablePorts;
    } catch (e) {
      debugPrint('SerialPlatform: availablePorts failed — $e');
      return [];
    }

    final results = <SerialPortInfo>[];
    for (final name in names) {
      final port = SerialPort(name);
      try {
        results.add(SerialPortInfo(
          portName: name,
          description: _tryGetString(() => port.description),
          vendorId: _tryGetInt(() => port.vendorId),
          productId: _tryGetInt(() => port.productId),
          manufacturer: _tryGetString(() => port.manufacturer),
          productName: _tryGetString(() => port.productName),
          serialNumber: _tryGetString(() => port.serialNumber),
        ));
      } catch (e) {
        // If even constructing the info fails, still include the port name
        results.add(SerialPortInfo(portName: name));
      } finally {
        port.dispose();
      }
    }
    return results;
  }

  /// Safely read a string property — some port types (Bluetooth, virtual)
  /// throw on property access.
  static String? _tryGetString(String? Function() getter) {
    try {
      return getter();
    } catch (_) {
      return null;
    }
  }

  static int? _tryGetInt(int? Function() getter) {
    try {
      return getter();
    } catch (_) {
      return null;
    }
  }

  Stream<List<SerialPortInfo>> _pollDesktopPorts(Duration interval) {
    late final StreamController<List<SerialPortInfo>> controller;
    Timer? timer;
    List<String> lastSeen = [];

    controller = StreamController<List<SerialPortInfo>>(
      onListen: () {
        void poll() {
          final ports = _listDesktopPorts();
          final names = ports.map((p) => p.portName).toList()..sort();
          if (!listEquals(names, lastSeen)) {
            lastSeen = names;
            controller.add(ports);
          }
        }

        poll();
        timer = Timer.periodic(interval, (_) => poll());
      },
      onCancel: () => timer?.cancel(),
    );

    return controller.stream;
  }

  // ---------------------------------------------------------------------------
  // Android — usb_serial
  // ---------------------------------------------------------------------------

  Future<List<SerialPortInfo>> _listAndroidPorts() async {
    try {
      final devices = await UsbSerial.listDevices();
      return devices
          .map((d) => SerialPortInfo(
                portName: d.deviceName,
                description: d.productName,
                vendorId: d.vid,
                productId: d.pid,
                manufacturer: d.manufacturerName,
                productName: d.productName,
                serialNumber: d.serial,
              ))
          .toList();
    } catch (e) {
      debugPrint('SerialPlatform: android listPorts failed — $e');
      return [];
    }
  }

  Stream<List<SerialPortInfo>> _watchAndroidPorts() {
    late final StreamController<List<SerialPortInfo>> controller;
    StreamSubscription? usbSub;

    controller = StreamController<List<SerialPortInfo>>(
      onListen: () async {
        // Emit current list immediately
        final initial = await _listAndroidPorts();
        controller.add(initial);

        // Listen for USB attach/detach events
        usbSub = UsbSerial.usbEventStream?.listen((_) async {
          final ports = await _listAndroidPorts();
          controller.add(ports);
        });
      },
      onCancel: () => usbSub?.cancel(),
    );

    return controller.stream;
  }
}
