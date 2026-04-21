import 'dart:async';

import 'package:bacnet_dart/bacnet_dart.dart';
import 'package:bacnet_dart/src/constants/property_ids.dart';
import 'package:bacnet_dart/src/constants/error_codes.dart';

import '../../node.dart';
import '../../port.dart';
import '../../driver_poller.dart';

/// BACnet poll-point context — carried per registered point.
typedef BacnetPollCtx = ({
  int deviceId,
  int objectType,
  int objectInstance,
});

/// Source node that manages a BACnet/IP connection and poll loop.
///
/// Owns a single [BacnetClient] instance. Child `bacnet.point` nodes
/// register what they need polled — the driver reads them all in a
/// single loop and pushes values down.
///
/// Uses [DriverPoller] for the poll loop (shared with Modbus driver).
///
/// Containment: bacnet.driver → bacnet.device → bacnet.point
class BacnetDriverNode extends SourceNode {
  @override
  String get typeName => 'bacnet.driver';

  @override
  String get description => 'BACnet/IP driver (connection + poller)';

  @override
  String get iconName => 'network';

  @override
  List<String> get allowedChildTypes => const ['bacnet.device'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final iface = settings['interface'] as String?;
    final port = settings['port'];
    if (iface != null && iface.isNotEmpty) {
      return port != null ? '$iface:$port' : iface;
    }
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'interface': {
            'type': 'string',
            'title': 'Network Interface',
            'x-widget': 'interface-picker',
          },
          'port': {
            'type': 'integer',
            'title': 'BACnet Port',
            'default': 47808,
          },
          'pollIntervalSecs': {
            'type': 'integer',
            'title': 'Poll Interval (seconds)',
            'default': 10,
            'minimum': 1,
            'maximum': 300,
          },
          'timeout': {
            'type': 'integer',
            'title': 'Request Timeout (seconds)',
            'default': 5,
            'minimum': 1,
            'maximum': 30,
          },
        },
      };

  // ---------------------------------------------------------------------------
  // Shared client registry — device / point nodes look up clients here
  // ---------------------------------------------------------------------------

  /// driverNodeId → BacnetClient
  static final clients = <String, BacnetClient>{};

  /// driverNodeId → DriverPoller (so point nodes can register)
  static final pollers = <String, DriverPoller<BacnetPollCtx>>{};

  // Per-instance state
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _generation = <String, int>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final iface = settings['interface'] as String?;
    final port = settings['port'] as int? ?? 47808;
    final timeoutSecs = settings['timeout'] as int? ?? 5;
    final pollSecs = settings['pollIntervalSecs'] as int? ?? 10;

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    onOutput({'status': 'starting'});

    // Create and start client
    final client = BacnetClient(
      config: BacnetClientConfig(
        port: port,
        timeout: Duration(seconds: timeoutSecs),
      ),
    );

    try {
      await client.start(
          interface_: (iface != null && iface.isNotEmpty) ? iface : null);
    } catch (e) {
      print('bacnet.driver[$nodeId]: start failed: $e');
      onOutput({'status': 'error'});
      return;
    }

    if (_generation[nodeId] != gen) {
      client.dispose();
      return;
    }

    clients[nodeId] = client;
    onOutput({'status': 'online'});
    print('bacnet.driver[$nodeId]: started on port $port');

    // Create and start the common poller
    final poller = DriverPoller<BacnetPollCtx>(
      driverId: nodeId,
      interval: Duration(seconds: pollSecs),
      reader: (ctx) => _readPoint(nodeId, ctx),
      tag: 'bacnet.driver',
    );
    pollers[nodeId] = poller;
    poller.start();
  }

  /// Protocol-specific read — called by [DriverPoller] for each point.
  Future<PollResult> _readPoint(String nodeId, BacnetPollCtx ctx) async {
    final client = clients[nodeId];
    if (client == null) return const PollResult.error('Driver not connected');

    final objName =
        '${BacnetObjectType.getName(ctx.objectType)}:${ctx.objectInstance}';
    try {
      final value = await client.readProperty(
        ctx.deviceId,
        ctx.objectType,
        ctx.objectInstance,
        BacnetPropertyId.presentValue,
      );
      print('bacnet.driver[$nodeId]: $objName = $value');
      return PollResult.ok(value);
    } on TimeoutException {
      print('bacnet.driver[$nodeId]: $objName timeout');
      return PollResult.stale('Device ${ctx.deviceId} not responding');
    } on BacnetException catch (e) {
      final friendly = formatBacnetError(e.errorClass, e.errorCode);
      print('bacnet.driver[$nodeId]: $objName error — $friendly');
      return PollResult.error(
          '${e.friendlyName}${e.hint != null ? "\n${e.hint}" : ""}');
    }
  }

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    pollers[nodeId]?.stop();
    pollers.remove(nodeId);
    clients[nodeId]?.dispose();
    clients.remove(nodeId);
    _callbacks.remove(nodeId);
  }
}
