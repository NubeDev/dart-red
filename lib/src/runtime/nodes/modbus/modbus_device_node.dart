import '../../node.dart';
import '../../port.dart';
import 'modbus_driver_node.dart';

/// Modbus device — represents a slave device on the Modbus network.
///
/// Lives inside a `modbus.driver`. Child `modbus.point` nodes inherit
/// the unit ID from this node. The device node itself doesn't poll —
/// the driver handles all polling via the common [DriverPoller].
///
/// For TCP transport: each device specifies host + port + unit ID.
/// For RTU transport: all devices share the serial bus, only unit ID is needed.
class ModbusDeviceNode extends SourceNode {
  @override
  String get typeName => 'modbus.device';

  @override
  String get description => 'Modbus device (slave)';

  @override
  String get iconName => 'hard-drive';

  @override
  String? get requiredParentType => 'modbus.driver';

  @override
  List<String> get allowedChildTypes => const ['modbus.point', 'modbus.write'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final host = settings['host'] as String?;
    final port = settings['port'];
    final unitId = settings['unitId'];
    final name = settings['name'] as String?;
    if (name != null && name.isNotEmpty) {
      return unitId != null ? '$name (unit $unitId)' : name;
    }
    final parts = <String>[];
    if (host != null && host.isNotEmpty) {
      parts.add(port != null ? '$host:$port' : host);
    }
    if (unitId != null) parts.add('unit $unitId');
    if (parts.isNotEmpty) return parts.join(' · ');
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
        Port(name: 'error', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['unitId'],
        'properties': {
          'host': {
            'type': 'string',
            'title': 'Host',
            'x-placeholder': 'e.g. 192.168.1.50',
            'description': 'IP address of the Modbus TCP device',
            'x-hide-if-parent-setting': {'key': 'transport', 'value': 'rtu'},
          },
          'port': {
            'type': 'integer',
            'title': 'Port',
            'default': 502,
            'x-hide-if-parent-setting': {'key': 'transport', 'value': 'rtu'},
          },
          'unitId': {
            'type': 'integer',
            'title': 'Unit ID (Slave Address)',
            'description': 'Modbus slave address (1–247)',
            'default': 1,
            'minimum': 1,
            'maximum': 247,
          },
          'name': {
            'type': 'string',
            'title': 'Device Name',
            'description': 'Friendly name for this device',
          },
        },
      };

  /// deviceNodeId → unitId (so child points can look up their device)
  static final deviceUnitIds = <String, int>{};

  /// deviceNodeId → host (so child points can look up connection target, TCP only)
  static final deviceHosts = <String, String>{};

  /// deviceNodeId → port (TCP only)
  static final devicePorts = <String, int>{};

  /// deviceNodeId → driverNodeId (so points can find the driver)
  static final deviceDrivers = <String, String>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final host = settings['host'] as String? ?? '';
    final port = settings['port'] as int? ?? 502;
    final unitId = settings['unitId'] as int?;

    // Look up parent driver's transport type
    final transport = parentId != null
        ? (ModbusDriverNode.transports[parentId] ?? 'tcp')
        : 'tcp';

    if (transport == 'tcp' && host.isEmpty) {
      print('modbus.device[$nodeId]: no host configured (required for TCP)');
      onOutput({'status': 'error', 'error': 'No host (required for TCP)'});
      return;
    }
    if (unitId == null) {
      print('modbus.device[$nodeId]: no unitId configured');
      onOutput({'status': 'error', 'error': 'No unit ID'});
      return;
    }

    deviceHosts[nodeId] = host;
    devicePorts[nodeId] = port;
    deviceUnitIds[nodeId] = unitId;
    if (parentId != null) {
      deviceDrivers[nodeId] = parentId;
    }

    final label = transport == 'tcp' ? '$host:$port unit $unitId' : 'unit $unitId';
    onOutput({'status': 'ok', 'error': null});
    print('modbus.device[$nodeId]: $label ready');
  }

  @override
  Future<void> stop(String nodeId) async {
    deviceUnitIds.remove(nodeId);
    deviceHosts.remove(nodeId);
    devicePorts.remove(nodeId);
    deviceDrivers.remove(nodeId);
  }
}
