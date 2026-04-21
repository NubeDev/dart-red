import '../db/daos/runtime_dao.dart';
import 'node.dart';
import 'node_registry.dart';
import 'runtime.dart';

// Default node imports — all built-in nodes
import 'nodes/bacnet/bacnet_device_node.dart';
import 'nodes/bacnet/bacnet_driver_node.dart';
import 'nodes/bacnet/bacnet_point_node.dart';
import 'nodes/bacnet/bacnet_write_node.dart';
import 'nodes/modbus/modbus_device_node.dart';
import 'nodes/modbus/modbus_driver_node.dart';
import 'nodes/modbus/modbus_point_node.dart';
import 'nodes/modbus/modbus_write_node.dart';
import 'nodes/mqtt/mqtt_broker_node.dart';
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
import 'nodes/insight/insight_alarm_node.dart';
import 'nodes/insight/insight_manager_node.dart';
import 'nodes/device/device_acbm_node.dart';
import 'nodes/device/device_acbm_command_node.dart';

/// Builds a [MicroBmsRuntime] with configurable node registrations.
///
/// Use this instead of manually creating `NodeRegistry` + `MicroBmsRuntime`.
/// Works in both standalone daemon and embedded Flutter app modes.
///
/// ```dart
/// // Embedded in Flutter app — full node set
/// final runtime = RuntimeBuilder(dao: db.runtimeDao)
///     .withAllNodes()
///     .build();
/// await runtime.start();
///
/// // Lightweight — only math + system nodes (no BACnet, no MQTT)
/// final runtime = RuntimeBuilder(dao: db.runtimeDao)
///     .withSystemNodes()
///     .withMathNodes()
///     .build();
///
/// // Custom — register your own nodes
/// final runtime = RuntimeBuilder(dao: db.runtimeDao)
///     .withNode('custom.sensor', CustomSensorNode.new)
///     .withAllNodes()
///     .build();
/// ```
class RuntimeBuilder {
  final RuntimeDao _dao;
  final NodeRegistry _registry = NodeRegistry.empty();

  RuntimeBuilder({required RuntimeDao dao}) : _dao = dao;

  /// Register a single custom node type.
  RuntimeBuilder withNode(String typeName, NodeType Function() factory) {
    _registry.register(typeName, factory);
    return this;
  }

  /// Register all built-in nodes (BACnet, MQTT, math, system, UI, schedule, history, device).
  RuntimeBuilder withAllNodes() {
    withBacnetNodes();
    withModbusNodes();
    withMqttNodes();
    withMathNodes();
    withSystemNodes();
    withUiNodes();
    withScheduleNodes();
    withHistoryNodes();
    withInsightNodes();
    withDeviceNodes();
    return this;
  }

  /// BACnet driver, device, point, write.
  RuntimeBuilder withBacnetNodes() {
    _registry.register('bacnet.driver', BacnetDriverNode.new);
    _registry.register('bacnet.device', BacnetDeviceNode.new);
    _registry.register('bacnet.point', BacnetPointNode.new);
    _registry.register('bacnet.write', BacnetWriteNode.new);
    return this;
  }

  /// Modbus driver, device, point, write.
  RuntimeBuilder withModbusNodes() {
    _registry.register('modbus.driver', ModbusDriverNode.new);
    _registry.register('modbus.device', ModbusDeviceNode.new);
    _registry.register('modbus.point', ModbusPointNode.new);
    _registry.register('modbus.write', ModbusWriteNode.new);
    return this;
  }

  /// MQTT broker, subscribe.
  RuntimeBuilder withMqttNodes() {
    _registry.register('mqtt.broker', MqttBrokerNode.new);
    _registry.register('mqtt.subscribe', MqttSubscribeNode.new);
    return this;
  }

  /// Math nodes (add, etc).
  RuntimeBuilder withMathNodes() {
    _registry.register('math.add', MathAddNode.new);
    return this;
  }

  /// System nodes (constant, trigger, folder, etc).
  RuntimeBuilder withSystemNodes() {
    _registry.register('system.constant', SystemConstantNode.new);
    _registry.register('system.trigger', TriggerNode.new);
    _registry.register('system.folder', SystemFolderNode.new);
    _registry.register('folder.input', FolderInputNode.new);
    _registry.register('folder.output', FolderOutputNode.new);
    return this;
  }

  /// UI nodes (page, source, display).
  RuntimeBuilder withUiNodes() {
    _registry.register('ui.page', UiPageNode.new);
    _registry.register('ui.source', UiSourceNode.new);
    _registry.register('ui.display', UiDisplayNode.new);
    return this;
  }

  /// Schedule nodes.
  RuntimeBuilder withScheduleNodes() {
    _registry.register('schedule.source', ScheduleSourceNode.new);
    _registry.register('schedule.display', ScheduleDisplayNode.new);
    return this;
  }

  /// History nodes.
  RuntimeBuilder withHistoryNodes() {
    _registry.register('history.log', HistoryLogNode.new);
    _registry.register('history.display', HistoryDisplayNode.new);
    _registry.register('history.manager', HistoryManagerNode.new);
    return this;
  }

  /// Insight nodes (alarm, manager).
  RuntimeBuilder withInsightNodes() {
    _registry.register('insight.manager', InsightManagerNode.new);
    _registry.register('insight.alarm', InsightAlarmNode.new);
    return this;
  }

  /// Device nodes (ACBM).
  RuntimeBuilder withDeviceNodes() {
    _registry.register('device.acbm', DeviceAcbmNode.new);
    _registry.register('device.acbm.command', DeviceAcbmCommandNode.new);
    return this;
  }

  /// Build the runtime. Call [MicroBmsRuntime.start] after to begin.
  MicroBmsRuntime build() {
    return MicroBmsRuntime(dao: _dao, registry: _registry);
  }
}
