import 'node.dart';
import 'nodes/bacnet/bacnet_device_node.dart';
import 'nodes/bacnet/bacnet_driver_node.dart';
import 'nodes/bacnet/bacnet_point_node.dart';
import 'nodes/bacnet/bacnet_write_node.dart';
import 'nodes/modbus/modbus_device_node.dart';
import 'nodes/modbus/modbus_driver_node.dart';
import 'nodes/modbus/modbus_point_node.dart';
import 'nodes/modbus/modbus_write_node.dart';
import 'nodes/mqtt/mqtt_broker_node.dart';
import 'nodes/mqtt/mqtt_server_node.dart';
import 'nodes/mqtt/mqtt_subscribe_node.dart';
import 'nodes/math/math_add_node.dart';
import 'nodes/system/folder_node.dart';
import 'nodes/system/folder_input_node.dart';
import 'nodes/system/folder_output_node.dart';
import 'nodes/system/system_constant_node.dart';
import 'nodes/system/trigger_node.dart';
import 'nodes/ui/page_node.dart';
import 'nodes/ui/source_node.dart';
import 'nodes/ui/display_node.dart';
import 'nodes/schedule/schedule_display_node.dart';
import 'nodes/schedule/schedule_source_node.dart';
import 'nodes/history/history_display_node.dart';
import 'nodes/history/history_log_node.dart';
import 'nodes/history/history_manager_node.dart';

/// Factory registry for creating node type instances by name.
class NodeRegistry {
  final _factories = <String, NodeType Function()>{};

  /// Empty registry — use with [RuntimeBuilder] to selectively add nodes.
  NodeRegistry.empty();

  /// Default registry with all built-in nodes.
  NodeRegistry() {
    // Register built-in node types
    register('bacnet.driver', BacnetDriverNode.new);
    register('bacnet.device', BacnetDeviceNode.new);
    register('bacnet.point', BacnetPointNode.new);
    register('bacnet.write', BacnetWriteNode.new);
    register('modbus.driver', ModbusDriverNode.new);
    register('modbus.device', ModbusDeviceNode.new);
    register('modbus.point', ModbusPointNode.new);
    register('modbus.write', ModbusWriteNode.new);
    register('mqtt.broker', MqttBrokerNode.new);
    register('mqtt.server', MqttServerNode.new);
    register('mqtt.subscribe', MqttSubscribeNode.new);
    register('math.add', MathAddNode.new);
    register('system.constant', SystemConstantNode.new);
    register('system.trigger', TriggerNode.new);
    register('system.folder', SystemFolderNode.new);
    register('folder.input', FolderInputNode.new);
    register('folder.output', FolderOutputNode.new);
    register('ui.page', UiPageNode.new);
    register('ui.source', UiSourceNode.new);
    register('ui.display', UiDisplayNode.new);
    register('schedule.source', ScheduleSourceNode.new);
    register('schedule.display', ScheduleDisplayNode.new);
    register('history.manager', HistoryManagerNode.new);
    register('history.log', HistoryLogNode.new);
    register('history.display', HistoryDisplayNode.new);
  }

  void register(String typeName, NodeType Function() factory) {
    _factories[typeName] = factory;
  }

  NodeType? create(String typeName) {
    final factory = _factories[typeName];
    return factory?.call();
  }

  List<String> get registeredTypes => _factories.keys.toList();

  /// Returns the full palette: every registered node type with its
  /// category, description, and port definitions. The UI uses this
  /// to render a node picker / palette.
  List<Map<String, dynamic>> getPalette() {
    final palette = <Map<String, dynamic>>[];
    for (final typeName in _factories.keys) {
      final node = create(typeName)!;
      final domain = typeName.split('.').first; // "mqtt", "math", "system", "ui"
      palette.add({
        'type': typeName,
        'domain': domain,
        'category': node.category,
        'description': node.description,
        'icon': node.iconName,
        'inputs': node.inputPorts.map((p) => p.toJson()).toList(),
        'outputs': node.outputPorts.map((p) => p.toJson()).toList(),
        'settingsSchema': node.settingsSchema,
      });
    }
    return palette;
  }
}
