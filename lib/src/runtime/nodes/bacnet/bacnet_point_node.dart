import '../../node.dart';
import '../../port.dart';
import 'bacnet_device_node.dart';
import 'bacnet_driver_node.dart';

/// Source node that reads a BACnet object's present value.
///
/// Lives inside a `bacnet.device` node. The device provides the device
/// instance, the driver (grandparent) provides the client and poll loop.
/// The point just declares what object to read.
///
/// Settings: objectType (dropdown), objectInstance.
/// deviceId is inherited from the parent device node.
class BacnetPointNode extends SourceNode {
  @override
  String get typeName => 'bacnet.point';

  @override
  String get description => 'BACnet point (read present value)';

  @override
  String get iconName => 'gauge';

  @override
  String? get requiredParentType => 'bacnet.device';

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final objType = settings['objectType'] as int?;
    final objInst = settings['objectInstance'];
    if (objType != null && objInst != null) {
      return '${_shortObjectName(objType)}:$objInst';
    }
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'value', type: 'dynamic'),
        Port(name: 'status', type: 'text'),
        Port(name: 'error', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['objectType', 'objectInstance'],
        'properties': {
          'objectType': {
            'type': 'integer',
            'title': 'Object Type',
            'enum': [0, 1, 2, 3, 4, 5, 13, 14, 19],
            'x-enum-labels': [
              'Analog Input (AI)',
              'Analog Output (AO)',
              'Analog Value (AV)',
              'Binary Input (BI)',
              'Binary Output (BO)',
              'Binary Value (BV)',
              'Multi-State Input (MSI)',
              'Multi-State Output (MSO)',
              'Multi-State Value (MSV)',
            ],
            'default': 0,
          },
          'objectInstance': {
            'type': 'integer',
            'title': 'Object Instance',
            'default': 0,
            'minimum': 0,
          },
        },
      };

  // Per-instance state
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final objectType = settings['objectType'] as int? ?? 0;
    final objectInstance = settings['objectInstance'] as int? ?? 0;

    if (parentId == null) {
      print('bacnet.point[$nodeId]: no parent device');
      onOutput({'value': null, 'status': 'error'});
      return;
    }

    // Look up device instance and driver from parent chain
    final deviceId = BacnetDeviceNode.deviceInstances[parentId];
    final driverId = BacnetDeviceNode.deviceDrivers[parentId];

    if (deviceId == null || driverId == null) {
      print('bacnet.point[$nodeId]: parent device $parentId not ready');
      onOutput({'value': null, 'status': 'error'});
      return;
    }

    _callbacks[nodeId] = onOutput;
    onOutput({'value': null, 'status': 'waiting', 'error': null});

    // Register with the driver's common poller
    final poller = BacnetDriverNode.pollers[driverId];
    if (poller == null) {
      print('bacnet.point[$nodeId]: driver $driverId not found');
      onOutput({'value': null, 'status': 'error'});
      return;
    }

    poller.addPoint((
      key: nodeId,
      context: (
        deviceId: deviceId,
        objectType: objectType,
        objectInstance: objectInstance,
      ),
      onValue: (value, status, error) {
        _callbacks[nodeId]
            ?.call({'value': value, 'status': status, 'error': error});
      },
    ));

    print('bacnet.point[$nodeId]: registered '
        '${_shortObjectName(objectType)}:$objectInstance on device $deviceId');
  }

  @override
  Future<void> stop(String nodeId) async {
    _callbacks.remove(nodeId);
    for (final poller in BacnetDriverNode.pollers.values) {
      poller.removePoint(nodeId);
    }
  }

  static String _shortObjectName(int objectType) {
    return switch (objectType) {
      0 => 'AI',
      1 => 'AO',
      2 => 'AV',
      3 => 'BI',
      4 => 'BO',
      5 => 'BV',
      13 => 'MSI',
      14 => 'MSO',
      19 => 'MSV',
      _ => 'OBJ$objectType',
    };
  }
}
