import 'dart:async';
import 'dart:math';

import 'package:mqtt5_client/mqtt5_client.dart' as mqtt5;
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:mqtt_server/mqtt_server.dart';

import '../../node.dart';
import '../../port.dart';
import 'mqtt_broker_node.dart';

/// Source node that runs an embedded MQTT broker (server).
///
/// Uses the `mqtt_server` package to bind a TCP listener on the configured
/// port.  After the broker starts, a local [MqttServerClient] is connected
/// and registered in [MqttBrokerNode.clients] so that child
/// `mqtt.subscribe` / `mqtt.publish` nodes work without modification.
///
/// Outputs:
///   - `status`:      "running", "starting", "stopped", "error"
///   - `clientCount`: number of currently connected clients
///   - `port`:        the port the broker is listening on
class MqttServerNode extends SourceNode {
  @override
  String get typeName => 'mqtt.server';

  @override
  String get description => 'Embedded MQTT broker';

  @override
  String get iconName => 'server-cog';

  @override
  List<String> get allowedChildTypes =>
      const ['mqtt.subscribe', 'mqtt.publish'];

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final port = settings['port'] as int? ?? 1883;
    return 'MQTT Server :$port';
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'status', type: 'text'),
        Port(name: 'clientCount', type: 'num'),
        Port(name: 'port', type: 'num'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'properties': {
          'port': {
            'type': 'integer',
            'title': 'Listen Port',
            'default': 1883,
            'minimum': 1,
            'maximum': 65535,
          },
          'persistence': {
            'type': 'boolean',
            'title': 'Enable Persistence',
            'default': true,
            'description': 'Persist sessions to disk',
          },
          'allowAnonymous': {
            'type': 'boolean',
            'title': 'Allow Anonymous',
            'default': true,
            'description': 'Allow connections without credentials',
          },
        },
        'allOf': [
          {
            'if': {
              'properties': {
                'allowAnonymous': {'const': false},
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
        ],
      };

  // -----------------------------------------------------------------------
  // Per-instance state
  // -----------------------------------------------------------------------

  /// nodeId → running MqttBroker instance
  static final brokers = <String, MqttBroker>{};

  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _generation = <String, int>{};
  final _clientCountTimers = <String, Timer>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    final port = settings['port'] as int? ?? 1883;
    final persistence = settings['persistence'] as bool? ?? true;
    final allowAnonymous = settings['allowAnonymous'] as bool? ?? true;

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    _emit(nodeId, 'starting', 0, port);

    // Start the broker asynchronously
    _startAsync(nodeId, port, persistence, allowAnonymous, settings, gen);
  }

  Future<void> _startAsync(
    String nodeId,
    int port,
    bool persistence,
    bool allowAnonymous,
    Map<String, dynamic> settings,
    int gen,
  ) async {
    try {
      final config = MqttBrokerConfig(
        port: port,
        enablePersistence: persistence,
        allowAnonymous: allowAnonymous,
      );

      final broker = MqttBroker(config);

      // Add credentials if auth is required
      if (!allowAnonymous) {
        final username = settings['username'] as String?;
        final password = settings['password'] as String?;
        if (username != null && password != null) {
          broker.addCredentials(username, password);
        }
      }

      await broker.start();

      if (_generation[nodeId] != gen) {
        await broker.stop();
        return;
      }

      brokers[nodeId] = broker;
      print('mqtt.server[$nodeId]: broker running on port $port');

      // Connect a local client so child mqtt.subscribe nodes work via
      // the existing MqttBrokerNode.clients registry.
      await _connectLocalClient(nodeId, port, gen);

      _emit(nodeId, 'running', 0, port);

      // Poll client count every 5 seconds
      _clientCountTimers[nodeId]?.cancel();
      _clientCountTimers[nodeId] = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _emitClientCount(nodeId, port),
      );
    } catch (e) {
      print('mqtt.server[$nodeId]: failed to start: $e');
      if (_generation[nodeId] == gen) {
        _emit(nodeId, 'error', 0, port);
      }
    }
  }

  /// Connects a local [MqttServerClient] to the embedded broker and
  /// registers it in [MqttBrokerNode.clients] so child subscribe nodes
  /// can resolve it via `parentId`.
  Future<void> _connectLocalClient(String nodeId, int port, int gen) async {
    try {
      final clientId =
          'rubix_server_${nodeId.substring(0, 8)}_${Random().nextInt(9999)}';
      final client = MqttServerClient.withPort('localhost', clientId, port);
      client.logging(on: false);
      client.keepAlivePeriod = 60;
      client.autoReconnect = true;

      final connMessage = mqtt5.MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean();
      client.connectionMessage = connMessage;

      await client.connect();

      if (_generation[nodeId] != gen) {
        client.disconnect();
        return;
      }

      if (client.connectionStatus?.state !=
          mqtt5.MqttConnectionState.connected) {
        print('mqtt.server[$nodeId]: local client failed to connect');
        return;
      }

      // Register in the shared client map so subscribe nodes find it
      MqttBrokerNode.clients[nodeId] = client;
      MqttBrokerNode.statuses[nodeId] = 'connected';
      print('mqtt.server[$nodeId]: local client connected');
    } catch (e) {
      print('mqtt.server[$nodeId]: local client error: $e');
    }
  }

  void _emitClientCount(String nodeId, int port) {
    final broker = brokers[nodeId];
    if (broker == null) return;
    final count =
        broker.connectionsManager.getAllSessionIds().length;
    _emit(nodeId, 'running', count, port);
  }

  void _emit(String nodeId, String status, int clientCount, int port) {
    _callbacks[nodeId]?.call({
      'status': status,
      'clientCount': clientCount,
      'port': port,
    });
  }

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;

    _clientCountTimers[nodeId]?.cancel();
    _clientCountTimers.remove(nodeId);

    // Disconnect the local client first
    MqttBrokerNode.clients[nodeId]?.disconnect();
    MqttBrokerNode.clients.remove(nodeId);
    MqttBrokerNode.statuses.remove(nodeId);

    // Stop the broker
    final broker = brokers.remove(nodeId);
    if (broker != null) {
      await broker.stop();
      print('mqtt.server[$nodeId]: broker stopped');
    }

    _callbacks.remove(nodeId);
  }
}
