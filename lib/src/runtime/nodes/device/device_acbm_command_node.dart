import 'dart:async';

import '../../node.dart';
import '../../port.dart';
import 'device_acbm_node.dart';

/// Sink node that sends commands to a parent `device.acbm` node's client.
///
/// Must be a child of a `device.acbm` node. Looks up the parent's
/// [AcbmClient] from [DeviceAcbmNode.clients] and executes raw commands.
class DeviceAcbmCommandNode extends SinkNode {
  @override
  String get typeName => 'device.acbm.command';

  @override
  String get description => 'Send command to ACBM device';

  @override
  String get iconName => 'terminal';

  @override
  String? get requiredParentType => 'device.acbm';

  @override
  List<Port> get inputPorts => const [
        Port(name: 'command', type: 'text', nullPolicy: NullPolicy.deny),
      ];

  @override
  List<Port> get outputPorts => const [
        Port(name: 'result', type: 'text'),
        Port(name: 'error', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'defaultCommand': {
            'type': 'string',
            'title': 'Default Command',
            'description': 'Command to run if no input wired',
            'x-placeholder': 'e.g. dev_info, param_list',
          },
        },
      };

  @override
  Future<Map<String, dynamic>?> execute(
    String nodeId,
    Map<String, dynamic> inputs,
    Map<String, dynamic> settings, {
    String? parentId,
  }) async {
    final command = inputs['command'] as String? ??
        settings['defaultCommand'] as String? ??
        '';
    if (command.isEmpty) {
      return {'result': '', 'error': 'No command provided'};
    }

    if (parentId == null) {
      return {'result': '', 'error': 'No parent device.acbm node'};
    }

    final client = DeviceAcbmNode.clients[parentId];
    if (client == null) {
      return {'result': '', 'error': 'Parent device not connected'};
    }

    try {
      final lines = await client.rawCommand(command);
      return {'result': lines.join('\n'), 'error': ''};
    } catch (e) {
      return {'result': '', 'error': e.toString()};
    }
  }
}
