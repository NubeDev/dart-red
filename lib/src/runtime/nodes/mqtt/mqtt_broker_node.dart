import 'dart:async';
import 'dart:math';

import 'package:mqtt5_client/mqtt5_client.dart' as mqtt5;
import 'package:mqtt5_client/mqtt5_server_client.dart';

import '../../node.dart';
import '../../port.dart';

/// Source node that manages an MQTT broker connection.
///
/// Holds the client instance in a shared registry so that `mqtt.subscribe`
/// nodes can look up the connection by broker node ID.
///
/// Outputs connection status: "connected", "connecting", "disconnected", "error".
class MqttBrokerNode extends SourceNode {
  @override
  String get typeName => 'mqtt.broker';

  @override
  String get description => 'MQTT broker connection';

  @override
  String get iconName => 'server';

  @override
  List<String> get allowedChildTypes => const ['mqtt.subscribe', 'mqtt.publish'];

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
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['host'],
        'properties': {
          'host': {
            'type': 'string',
            'title': 'Broker Host',
            'default': 'localhost',
            'x-placeholder': 'e.g. 192.168.1.100',
          },
          'port': {
            'type': 'integer',
            'title': 'Broker Port',
            'default': 1883,
            'minimum': 1,
            'maximum': 65535,
          },
          'auth': {
            'type': 'string',
            'title': 'Authentication',
            'default': 'none',
            'enum': ['none', 'credentials', 'certificate'],
          },
        },
        'allOf': [
          {
            'if': {
              'properties': {
                'auth': {'const': 'credentials'},
              },
            },
            'then': {
              'properties': {
                'username': {
                  'type': 'string',
                  'title': 'Username',
                },
                'password': {
                  'type': 'string',
                  'title': 'Password',
                  'x-widget': 'password',
                },
              },
              'required': ['username', 'password'],
            },
          },
          {
            'if': {
              'properties': {
                'auth': {'const': 'certificate'},
              },
            },
            'then': {
              'properties': {
                'certPath': {
                  'type': 'string',
                  'title': 'Certificate Path',
                  'x-widget': 'file',
                },
                'keyPath': {
                  'type': 'string',
                  'title': 'Key Path',
                  'x-widget': 'file',
                },
              },
              'required': ['certPath', 'keyPath'],
            },
          },
        ],
      };

  // ---------------------------------------------------------------------------
  // Shared client registry — subscribe nodes look up clients here
  // ---------------------------------------------------------------------------

  /// brokerNodeId → connected MqttServerClient
  static final clients = <String, MqttServerClient>{};

  /// brokerNodeId → current status string
  static final statuses = <String, String>{};

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
    final host = settings['host'] as String? ?? 'localhost';
    final port = settings['port'] as int? ?? 1883;

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    _emitStatus(nodeId, 'connecting');

    final clientId =
        'rubix_broker_${nodeId.substring(0, 8)}_${Random().nextInt(9999)}';
    final client = MqttServerClient.withPort(host, clientId, port);
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;
    client.onDisconnected = () => _emitStatus(nodeId, 'disconnected');
    client.onAutoReconnected = () => _emitStatus(nodeId, 'connected');

    final connMessage = mqtt5.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean();
    client.connectionMessage = connMessage;

    // Connect in the background
    _connectAsync(nodeId, client, gen);
  }

  Future<void> _connectAsync(
    String nodeId,
    MqttServerClient client,
    int gen,
  ) async {
    try {
      await client.connect();
    } catch (e) {
      print('mqtt.broker[$nodeId]: connect failed: $e');
      _emitStatus(nodeId, 'error');
      return;
    }

    if (_generation[nodeId] != gen) {
      client.disconnect();
      return;
    }

    if (client.connectionStatus?.state !=
        mqtt5.MqttConnectionState.connected) {
      _emitStatus(nodeId, 'error');
      return;
    }

    clients[nodeId] = client;
    _emitStatus(nodeId, 'connected');
    print('mqtt.broker[$nodeId]: connected');
  }

  void _emitStatus(String nodeId, String status) {
    statuses[nodeId] = status;
    _callbacks[nodeId]?.call({'status': status});
  }

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    clients[nodeId]?.disconnect();
    clients.remove(nodeId);
    statuses.remove(nodeId);
    _callbacks.remove(nodeId);
  }
}
