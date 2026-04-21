import '../../node.dart';
import '../../port.dart';
import '../../driver_poller.dart';
import 'modbus_codec.dart';
import 'modbus_device_node.dart';
import 'modbus_driver_node.dart';

/// Source node that reads a Modbus register's value.
///
/// Lives inside a `modbus.device`. The device provides the unit ID,
/// the driver (grandparent) provides the socket and poll loop.
/// The point declares what register to read and how to decode it.
///
/// Does NOT poll — registers with the driver's [DriverPoller].
class ModbusPointNode extends SourceNode {
  @override
  String get typeName => 'modbus.point';

  @override
  String get description => 'Modbus point (read register)';

  @override
  String get iconName => 'gauge';

  @override
  String? get requiredParentType => 'modbus.device';

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final regType = settings['registerType'] as String? ?? 'holding';
    final addr = settings['address'];
    final dataType = settings['dataType'] as String? ?? 'uint16';
    if (addr != null) {
      return '${_shortRegName(regType)}[$addr] ($dataType)';
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
        'required': ['registerType', 'address'],
        'properties': {
          'registerType': {
            'type': 'string',
            'title': 'Register Type',
            'enum': ['holding', 'input', 'coil', 'discrete'],
            'x-enum-labels': [
              'Holding Register (FC03)',
              'Input Register (FC04)',
              'Coil (FC01)',
              'Discrete Input (FC02)',
            ],
            'default': 'holding',
          },
          'address': {
            'type': 'integer',
            'title': 'Register Address',
            'default': 0,
            'minimum': 0,
            'maximum': 65535,
          },
          'dataType': {
            'type': 'string',
            'title': 'Data Type',
            'enum': [
              'uint16', 'int16', 'uint32', 'int32',
              'float32', 'float64', 'bool',
            ],
            'x-enum-labels': [
              'Unsigned 16-bit', 'Signed 16-bit',
              'Unsigned 32-bit', 'Signed 32-bit',
              'Float 32-bit', 'Float 64-bit', 'Boolean',
            ],
            'default': 'uint16',
          },
          'byteOrder': {
            'type': 'string',
            'title': 'Byte Order',
            'enum': ['big', 'little', 'big-swap', 'little-swap'],
            'x-enum-labels': [
              'Big Endian (AB CD)',
              'Little Endian (CD AB)',
              'Big Endian Swap (CD AB)',
              'Little Endian Swap (BA DC)',
            ],
            'default': 'big',
          },
          'scale': {
            'type': 'number',
            'title': 'Scale Factor',
            'description': 'Multiply raw value by this',
            'default': 1.0,
          },
          'offset': {
            'type': 'number',
            'title': 'Offset',
            'description': 'Add this after scaling',
            'default': 0.0,
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
    final registerType = settings['registerType'] as String? ?? 'holding';
    final address = settings['address'] as int? ?? 0;
    final dataType = settings['dataType'] as String? ?? 'uint16';
    final byteOrder = settings['byteOrder'] as String? ?? 'big';
    final scale = (settings['scale'] as num?)?.toDouble() ?? 1.0;
    final offset = (settings['offset'] as num?)?.toDouble() ?? 0.0;

    if (parentId == null) {
      print('modbus.point[$nodeId]: no parent device');
      onOutput({'value': null, 'status': 'error', 'error': 'No parent device'});
      return;
    }

    // Look up connection info from parent device
    final host = ModbusDeviceNode.deviceHosts[parentId];
    final port = ModbusDeviceNode.devicePorts[parentId];
    final unitId = ModbusDeviceNode.deviceUnitIds[parentId];
    final driverId = ModbusDeviceNode.deviceDrivers[parentId];

    if (host == null || port == null || unitId == null || driverId == null) {
      print('modbus.point[$nodeId]: parent device $parentId not ready');
      onOutput({'value': null, 'status': 'error', 'error': 'Device not ready'});
      return;
    }

    _callbacks[nodeId] = onOutput;
    onOutput({'value': null, 'status': 'waiting', 'error': null});

    // Register with the driver's common poller
    final poller = ModbusDriverNode.pollers[driverId];
    if (poller == null) {
      print('modbus.point[$nodeId]: driver $driverId not found');
      onOutput({'value': null, 'status': 'error', 'error': 'Driver not found'});
      return;
    }

    final count = ModbusCodec.registerCount(dataType);

    poller.addPoint((
      key: nodeId,
      context: (
        host: host,
        port: port,
        unitId: unitId,
        registerType: registerType,
        address: address,
        count: count,
        dataType: dataType,
        byteOrder: byteOrder,
        scale: scale,
        offset: offset,
      ),
      onValue: (value, status, error) {
        _callbacks[nodeId]
            ?.call({'value': value, 'status': status, 'error': error});
      },
    ));

    print('modbus.point[$nodeId]: registered '
        '${_shortRegName(registerType)}[$address] ($dataType) on unit $unitId');
  }

  @override
  Future<void> stop(String nodeId) async {
    _callbacks.remove(nodeId);
    for (final poller in ModbusDriverNode.pollers.values) {
      poller.removePoint(nodeId);
    }
  }

  static String _shortRegName(String registerType) {
    return switch (registerType) {
      'holding' => 'HR',
      'input' => 'IR',
      'coil' => 'CO',
      'discrete' => 'DI',
      _ => registerType.toUpperCase(),
    };
  }
}
