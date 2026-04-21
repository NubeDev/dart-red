import 'dart:async';

import '../../../devices/acbm/client/client.dart';
import '../../../devices/common/connection_state.dart';
import '../../../devices/common/device_models.dart' as models;
import '../../node.dart';
import '../../port.dart';

/// Source node that manages an ACBM device connection in the runtime graph.
///
/// Connects to an ACBM controller over TCP, polls device info periodically,
/// and exposes connection status + device metadata as outputs.
///
/// This does NOT replace direct phone-to-device setup — it bridges the
/// existing [AcbmClient] into the dataflow engine so devices are visible
/// in the runtime graph.
class DeviceAcbmNode extends SourceNode {
  @override
  String get typeName => 'device.acbm';

  @override
  String get description => 'ACBM device connection';

  @override
  String get iconName => 'box';

  @override
  List<String> get allowedChildTypes => const ['device.acbm.command'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final host = settings['host'] as String?;
    final port = settings['port'];
    if (host != null && host.isNotEmpty) {
      return port != null ? '$host:$port' : host;
    }
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
        Port(name: 'firmwareVersion', type: 'text'),
        Port(name: 'deviceInfo', type: 'dynamic'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['host'],
        'properties': {
          'host': {
            'type': 'string',
            'title': 'Device Host',
            'x-placeholder': 'e.g. 192.168.1.50',
          },
          'port': {
            'type': 'integer',
            'title': 'TCP Port',
            'default': 56789,
            'minimum': 1,
            'maximum': 65535,
          },
          'pollSeconds': {
            'type': 'integer',
            'title': 'Poll Interval (s)',
            'default': 30,
            'minimum': 5,
            'maximum': 3600,
          },
          'deviceRowId': {
            'type': 'string',
            'title': 'Device Row ID',
            'description': 'Optional link to existing device in DB',
          },
          'locationId': {
            'type': 'string',
            'title': 'Location ID',
            'description': 'Optional link to a location',
          },
        },
      };

  // ── Per-instance state ──────────────────────────────────────────────────

  /// nodeId → active client
  static final clients = <String, AcbmClient>{};

  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _generation = <String, int>{};
  final _pollTimers = <String, Timer>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final host = settings['host'] as String? ?? 'localhost';
    final port = settings['port'] as int? ?? 56789;
    final pollSeconds = settings['pollSeconds'] as int? ?? 30;

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    _emit(nodeId, {'status': 'connecting'});

    final client = AcbmClient.tcp(host: host, port: port);
    clients[nodeId] = client;

    _connectAndPoll(nodeId, client, gen, pollSeconds);
  }

  Future<void> _connectAndPoll(
    String nodeId,
    AcbmClient client,
    int gen,
    int pollSeconds,
  ) async {
    try {
      await client.connect();
    } catch (e) {
      print('device.acbm[$nodeId]: connect failed: $e');
      _emit(nodeId, {'status': 'error', 'firmwareVersion': '', 'deviceInfo': {}});
      return;
    }

    if (_generation[nodeId] != gen) {
      await client.dispose();
      return;
    }

    if (!client.status.isConnected) {
      _emit(nodeId, {'status': 'error', 'firmwareVersion': '', 'deviceInfo': {}});
      return;
    }

    _emit(nodeId, {'status': 'connected'});
    print('device.acbm[$nodeId]: connected to ${client.transport}');

    // Initial poll
    await _pollDeviceInfo(nodeId, client, gen);

    // Periodic poll
    _pollTimers[nodeId]?.cancel();
    _pollTimers[nodeId] = Timer.periodic(
      Duration(seconds: pollSeconds),
      (_) => _pollDeviceInfo(nodeId, client, gen),
    );
  }

  Future<void> _pollDeviceInfo(
    String nodeId,
    AcbmClient client,
    int gen,
  ) async {
    if (_generation[nodeId] != gen) return;
    try {
      final info = await client.getDeviceInfo();
      if (_generation[nodeId] != gen) return;
      _emit(nodeId, {
        'status': 'connected',
        'firmwareVersion': info.fwVersion ?? '',
        'deviceInfo': _deviceInfoToMap(info),
      });
    } catch (e) {
      if (_generation[nodeId] != gen) return;
      _emit(nodeId, {'status': 'error'});
    }
  }

  void _emit(String nodeId, Map<String, dynamic> outputs) {
    _callbacks[nodeId]?.call(outputs);
  }

  static Map<String, dynamic> _deviceInfoToMap(models.DeviceInfo info) => {
        'deviceNote': info.deviceNote,
        'hwVersion': info.hwVersion,
        'fwVersion': info.fwVersion,
        'fwReleaseTime': info.fwReleaseTime,
        'modbusAddress': info.modbusAddress,
        'bacnetIPDatalink': info.bacnetIPDatalink,
      };

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    _pollTimers[nodeId]?.cancel();
    _pollTimers.remove(nodeId);
    final client = clients.remove(nodeId);
    if (client != null) {
      await client.dispose();
    }
    _callbacks.remove(nodeId);
  }
}
