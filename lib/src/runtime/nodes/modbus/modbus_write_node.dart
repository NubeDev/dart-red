import '../../node.dart';
import '../../port.dart';
import 'modbus_device_node.dart';
import 'modbus_driver_node.dart';

/// Sink node that writes a value to a Modbus register or coil.
///
/// Lives inside a `modbus.device`. Inherits unit ID and driver
/// connection from the containment hierarchy.
///
/// Uses FC06 (single register), FC05 (single coil), or FC16
/// (multiple registers) depending on the data type.
class ModbusWriteNode extends SinkNode {
  @override
  String get typeName => 'modbus.write';

  @override
  String get description => 'Write to a Modbus register/coil';

  @override
  String get iconName => 'pencil';

  @override
  String? get requiredParentType => 'modbus.device';

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final regType = settings['registerType'] as String? ?? 'holding';
    final addr = settings['address'];
    if (addr != null) {
      return '${regType == 'coil' ? 'CO' : 'HR'}[$addr] (write)';
    }
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'dynamic', nullPolicy: NullPolicy.deny),
      ];

  @override
  List<Port> get outputPorts => const [
        Port(name: 'writeStatus', type: 'text'),
        Port(name: 'lastWritten', type: 'dynamic'),
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
            'enum': ['holding', 'coil'],
            'x-enum-labels': ['Holding Register', 'Coil'],
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
              'uint16', 'int16', 'uint32', 'int32', 'float32', 'bool',
            ],
            'x-enum-labels': [
              'Unsigned 16-bit', 'Signed 16-bit',
              'Unsigned 32-bit', 'Signed 32-bit',
              'Float 32-bit', 'Boolean',
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
          'writeMode': {
            'type': 'string',
            'title': 'Write Mode',
            'enum': ['always', 'onChange'],
            'x-enum-labels': ['Always', 'On Change'],
            'default': 'onChange',
          },
        },
      };

  /// Track last written value per node to support onChange mode.
  final _lastWritten = <String, dynamic>{};

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    final value = inputs['value'];
    if (value == null) {
      return {
        'writeStatus': 'skipped',
        'lastWritten': _lastWritten[nodeId],
        'error': null,
      };
    }

    // Check write mode
    final writeMode = settings['writeMode'] as String? ?? 'onChange';
    if (writeMode == 'onChange') {
      if (_lastWritten.containsKey(nodeId) && _lastWritten[nodeId] == value) {
        return {
          'writeStatus': 'skipped',
          'lastWritten': value,
          'error': null,
        };
      }
    }

    final registerType = settings['registerType'] as String? ?? 'holding';
    final address = settings['address'] as int? ?? 0;
    final dataType = settings['dataType'] as String? ?? 'uint16';
    final byteOrder = settings['byteOrder'] as String? ?? 'big';
    final label = '${registerType == 'coil' ? 'CO' : 'HR'}[$address]';

    if (parentId == null) {
      return {
        'writeStatus': 'error',
        'lastWritten': _lastWritten[nodeId],
        'error': 'No parent device — place inside a modbus.device',
      };
    }

    final host = ModbusDeviceNode.deviceHosts[parentId];
    final port = ModbusDeviceNode.devicePorts[parentId];
    final unitId = ModbusDeviceNode.deviceUnitIds[parentId];
    final driverId = ModbusDeviceNode.deviceDrivers[parentId];
    if (host == null || port == null || unitId == null || driverId == null) {
      return {
        'writeStatus': 'error',
        'lastWritten': _lastWritten[nodeId],
        'error': 'Parent device not ready',
      };
    }

    final result = await ModbusDriverNode.writeRegisters(
      driverId: driverId,
      host: host,
      port: port,
      unitId: unitId,
      registerType: registerType,
      address: address,
      dataType: dataType,
      byteOrder: byteOrder,
      value: value,
    );

    if (result.status == 'ok') {
      _lastWritten[nodeId] = value;
      print('modbus.write[$nodeId]: $label = $value (unit $unitId) ✓');
      return {'writeStatus': 'ok', 'lastWritten': value, 'error': null};
    }

    print('modbus.write[$nodeId]: $label ${result.status} — ${result.error}');
    return {
      'writeStatus': result.status,
      'lastWritten': _lastWritten[nodeId],
      'error': result.error,
    };
  }
}
