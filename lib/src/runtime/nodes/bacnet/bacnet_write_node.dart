import 'dart:async';

import 'package:bacnet_dart/bacnet_dart.dart';

import '../../node.dart';
import '../../port.dart';
import 'bacnet_device_node.dart';
import 'bacnet_driver_node.dart';

/// Sink node that writes a value to a BACnet object.
///
/// Lives inside a `bacnet.device`. Inherits device instance and driver
/// client from the containment hierarchy.
///
/// Outputs:
///   - `writeStatus`: "ok", "error", "timeout", "skipped"
///   - `lastWritten`: the last successfully written value
///   - `error`: human-readable error message (null when ok)
class BacnetWriteNode extends SinkNode {
  @override
  String get typeName => 'bacnet.write';

  @override
  String get description => 'Write to a BACnet object';

  @override
  String get iconName => 'pencil';

  @override
  String? get requiredParentType => 'bacnet.device';

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final objType = settings['objectType'] as int?;
    final objInst = settings['objectInstance'];
    if (objType != null && objInst != null) {
      return '${_shortObjectName(objType)}:$objInst (write)';
    }
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get inputPorts => const [
        Port(name: 'value', type: 'dynamic', nullPolicy: NullPolicy.deny),
      ];

  // Sinks can have output ports for feedback
  @override
  List<Port> get outputPorts => const [
        Port(name: 'writeStatus', type: 'text'),
        Port(name: 'lastWritten', type: 'dynamic'),
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
            'enum': [1, 2, 4, 5, 14, 19],
            'x-enum-labels': [
              'Analog Output (AO)',
              'Analog Value (AV)',
              'Binary Output (BO)',
              'Binary Value (BV)',
              'Multi-State Output (MSO)',
              'Multi-State Value (MSV)',
            ],
            'default': 2,
          },
          'objectInstance': {
            'type': 'integer',
            'title': 'Object Instance',
            'default': 0,
            'minimum': 0,
          },
          'priority': {
            'type': 'integer',
            'title': 'Write Priority',
            'description': 'BACnet priority (1=highest, 16=lowest)',
            'default': 16,
            'minimum': 1,
            'maximum': 16,
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
      return {'writeStatus': 'skipped', 'lastWritten': _lastWritten[nodeId], 'error': null};
    }

    // Check write mode
    final writeMode = settings['writeMode'] as String? ?? 'onChange';
    if (writeMode == 'onChange') {
      if (_lastWritten.containsKey(nodeId) && _lastWritten[nodeId] == value) {
        return {'writeStatus': 'skipped', 'lastWritten': value, 'error': null};
      }
    }

    final objectType = settings['objectType'] as int? ?? 2;
    final objectInstance = settings['objectInstance'] as int? ?? 0;
    final priority = settings['priority'] as int? ?? 16;
    final objName = '${_shortObjectName(objectType)}:$objectInstance';

    if (parentId == null) {
      return {'writeStatus': 'error', 'lastWritten': _lastWritten[nodeId],
              'error': 'No parent device — place inside a bacnet.device'};
    }

    final deviceId = BacnetDeviceNode.deviceInstances[parentId];
    final driverId = BacnetDeviceNode.deviceDrivers[parentId];
    if (deviceId == null || driverId == null) {
      return {'writeStatus': 'error', 'lastWritten': _lastWritten[nodeId],
              'error': 'Parent device not ready'};
    }

    final client = BacnetDriverNode.clients[driverId];
    if (client == null) {
      return {'writeStatus': 'error', 'lastWritten': _lastWritten[nodeId],
              'error': 'Driver client not available'};
    }

    final tag = _tagForObjectType(objectType);
    // Coerce to the right Dart type for the BACnet application tag:
    //   REAL → double, ENUMERATED/UNSIGNED → int
    final writeValue = _coerceValue(value, tag);
    print('bacnet.write[$nodeId]: input=${value.runtimeType}($value) → coerced=${writeValue.runtimeType}($writeValue) tag=$tag');

    try {
      await client.writeProperty(
        deviceId,
        objectType,
        objectInstance,
        BacnetPropertyId.presentValue,
        writeValue,
        priority: priority,
        tag: tag,
      );
      // BACnet confirmed the write (SimpleAck received)
      _lastWritten[nodeId] = value;
      print('bacnet.write[$nodeId]: $objName = $value (priority $priority) ✓');
      return {'writeStatus': 'ok', 'lastWritten': value, 'error': null};
    } on TimeoutException {
      print('bacnet.write[$nodeId]: $objName timeout');
      return {'writeStatus': 'timeout', 'lastWritten': _lastWritten[nodeId],
              'error': 'Device $deviceId not responding'};
    } on BacnetException catch (e) {
      final friendly = formatBacnetError(e.errorClass, e.errorCode);
      print('bacnet.write[$nodeId]: $objName rejected — $friendly');
      return {'writeStatus': 'error', 'lastWritten': _lastWritten[nodeId],
              'error': '${e.friendlyName}${e.hint != null ? "\n${e.hint}" : ""}'};
    }
  }

  static int _tagForObjectType(int objectType) {
    return switch (objectType) {
      1 || 2 => 4,   // Analog → REAL
      4 || 5 => 9,   // Binary → ENUMERATED
      14 || 19 => 2, // Multi-state → UNSIGNED
      _ => 4,
    };
  }

  /// Coerce the input value to the right Dart type for the BACnet tag.
  /// An int sent with tag=REAL causes "inconsistent-parameters" on many devices.
  static dynamic _coerceValue(dynamic value, int tag) {
    final parsed = value is num ? value : num.tryParse(value.toString());
    if (parsed == null) return value; // non-numeric, pass through
    return switch (tag) {
      AppTag.real || AppTag.double_ => parsed.toDouble(),
      AppTag.unsigned || AppTag.enumerated => parsed.toInt(),
      AppTag.signed => parsed.toInt(),
      _ => parsed,
    };
  }

  static String _shortObjectName(int objectType) {
    return switch (objectType) {
      1 => 'AO', 2 => 'AV', 4 => 'BO', 5 => 'BV',
      14 => 'MSO', 19 => 'MSV',
      _ => 'OBJ$objectType',
    };
  }
}
