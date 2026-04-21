import 'dart:async';

import 'package:bacnet_dart/bacnet_dart.dart';

import '../../node.dart';
import '../../port.dart';
import 'bacnet_driver_node.dart';

/// BACnet device — represents a physical BACnet device on the network.
///
/// Lives inside a `bacnet.driver`. Child `bacnet.point` nodes inherit
/// the device instance from this node, so they don't need to specify it.
///
/// The device node itself doesn't poll — the driver handles all polling.
class BacnetDeviceNode extends SourceNode {
  @override
  String get typeName => 'bacnet.device';

  @override
  String get description => 'BACnet device';

  @override
  String get iconName => 'hard-drive';

  @override
  String? get requiredParentType => 'bacnet.driver';

  @override
  List<String> get allowedChildTypes => const ['bacnet.point', 'bacnet.write'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final devId = settings['deviceInstance'];
    final name = settings['name'] as String?;
    if (name != null && name.isNotEmpty) {
      return devId != null ? '$name ($devId)' : name;
    }
    if (devId != null) return 'Device $devId';
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
        Port(name: 'error', type: 'text'),
        Port(name: 'deviceName', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['deviceInstance'],
        'properties': {
          'deviceInstance': {
            'type': 'integer',
            'title': 'Device Instance',
            'description': 'BACnet device instance number',
            'x-placeholder': 'e.g. 1001',
          },
          'name': {
            'type': 'string',
            'title': 'Device Name',
            'description': 'Friendly name for this device',
          },
          'ip': {
            'type': 'string',
            'title': 'IP Address',
            'description':
                'Device IP (optional — leave empty for Who-Is discovery)',
            'x-placeholder': 'e.g. 192.168.1.100',
          },
          'macPort': {
            'type': 'integer',
            'title': 'BACnet Port',
            'description': 'Device BACnet port (default 47808)',
            'default': 47808,
          },
        },
      };

  /// deviceNodeId → deviceInstance (so child points can look up their device)
  static final deviceInstances = <String, int>{};

  /// deviceNodeId → driverNodeId (so points can find the driver)
  static final deviceDrivers = <String, String>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final deviceInstance = settings['deviceInstance'] as int?;
    if (deviceInstance == null) {
      print('bacnet.device[$nodeId]: no deviceInstance configured');
      onOutput({'status': 'error'});
      return;
    }

    deviceInstances[nodeId] = deviceInstance;
    if (parentId != null) {
      deviceDrivers[nodeId] = parentId;
    }

    // If IP is provided, register the device binding on the driver's client
    if (parentId != null) {
      final ip = settings['ip'] as String?;
      final macPort = settings['macPort'] as int? ?? 47808;

      if (ip != null && ip.isNotEmpty) {
        final client = BacnetDriverNode.clients[parentId];
        if (client != null) {
          client.addDeviceBinding(deviceInstance, ip, port: macPort);
          print('bacnet.device[$nodeId]: bound device $deviceInstance → $ip:$macPort');
        }
      }
    }

    onOutput({'status': 'connecting', 'error': null, 'deviceName': null});

    // Verify the device is reachable by reading its object name
    final client = BacnetDriverNode.clients[parentId];
    if (client == null) {
      print('bacnet.device[$nodeId]: no driver client available');
      onOutput({
        'status': 'error',
        'error': 'Driver not connected',
        'deviceName': null,
      });
      return;
    }

    try {
      final name = await client.readProperty(
        deviceInstance,
        BacnetObjectType.device,
        deviceInstance,
        BacnetPropertyId.objectName,
      );
      print('bacnet.device[$nodeId]: device $deviceInstance online — "$name"');
      onOutput({'status': 'ok', 'error': null, 'deviceName': name});
    } on TimeoutException {
      print('bacnet.device[$nodeId]: device $deviceInstance timeout');
      onOutput({
        'status': 'stale',
        'error': 'Device $deviceInstance not responding',
        'deviceName': null,
      });
    } on BacnetException catch (e) {
      final friendly = formatBacnetError(e.errorClass, e.errorCode);
      print('bacnet.device[$nodeId]: device $deviceInstance — $friendly');
      onOutput({
        'status': 'error',
        'error': '${e.friendlyName}${e.hint != null ? "\n${e.hint}" : ""}',
        'deviceName': null,
      });
    } catch (e) {
      print('bacnet.device[$nodeId]: device $deviceInstance error: $e');
      onOutput({'status': 'error', 'error': e.toString(), 'deviceName': null});
    }
  }

  @override
  Future<void> stop(String nodeId) async {
    deviceInstances.remove(nodeId);
    deviceDrivers.remove(nodeId);
  }
}
