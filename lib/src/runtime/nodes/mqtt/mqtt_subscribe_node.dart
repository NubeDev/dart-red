import 'dart:async';

import 'package:mqtt5_client/mqtt5_client.dart' as mqtt5;

import '../../node.dart';
import '../../port.dart';
import 'mqtt_broker_node.dart';

/// Source node that subscribes to an MQTT topic via a broker node.
///
/// The broker connection is managed by an `mqtt.broker` node — this node
/// just subscribes and forwards messages. Select the broker in settings.
///
/// Outputs:
///   - `value`: latest message payload (parsed as num or string)
///   - `status`: subscription status ("subscribed", "waiting", "error")
class MqttSubscribeNode extends SourceNode {
  @override
  String get typeName => 'mqtt.subscribe';

  @override
  String get description => 'Subscribe to an MQTT topic';

  @override
  String get iconName => 'mail';

  // No requiredParentType — can live inside a broker OR standalone with
  // brokerNodeId in settings. The start() method checks parent first.

  @override
  String displayLabel(String nodeId, Map<String, dynamic> settings) {
    final topic = settings['topic'] as String?;
    if (topic != null && topic.isNotEmpty) return topic;
    return super.displayLabel(nodeId, settings);
  }

  @override
  List<Port> get outputPorts => const [
        Port(name: 'value', type: 'dynamic'),
        Port(name: 'status', type: 'text'),
      ];

  @override
  Map<String, dynamic> get settingsSchema => {
        'type': 'object',
        'required': ['topic'],
        'properties': {
          'brokerNodeId': {
            'type': 'string',
            'title': 'Broker',
            'description': 'Select an mqtt.broker node (not needed if inside a broker)',
            'x-widget': 'node-picker',
            'x-node-type': 'mqtt.broker',
            'x-hide-if-parent': 'mqtt.broker',
          },
          'topic': {
            'type': 'string',
            'title': 'MQTT Topic',
            'description': 'Topic to subscribe to',
            'x-placeholder': 'sensor/temperature',
          },
          'qos': {
            'type': 'integer',
            'title': 'QoS Level',
            'default': 1,
            'enum': [0, 1, 2],
            'x-enum-labels': [
              '0 - At most once',
              '1 - At least once',
              '2 - Exactly once',
            ],
          },
        },
      };

  // Per-instance state
  final _subscriptions = <String, StreamSubscription>{};
  final _callbacks = <String, void Function(Map<String, dynamic>)>{};
  final _generation = <String, int>{};
  final _retryTimers = <String, Timer>{};

  @override
  Future<void> start(
    String nodeId,
    Map<String, dynamic> settings,
    void Function(Map<String, dynamic> outputs) onOutput, {
    String? parentId,
  }) async {
    // Resolve broker: parent first (containment), then settings (standalone)
    final brokerNodeId = parentId ?? settings['brokerNodeId'] as String?;
    final topic = settings['topic'] as String?;

    if (brokerNodeId == null || brokerNodeId.isEmpty) {
      print('mqtt.subscribe[$nodeId]: no broker configured');
      onOutput({'value': null, 'status': 'error'});
      return;
    }
    if (topic == null || topic.isEmpty) {
      print('mqtt.subscribe[$nodeId]: no topic configured');
      onOutput({'value': null, 'status': 'error'});
      return;
    }

    _callbacks[nodeId] = onOutput;
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    final gen = _generation[nodeId]!;

    onOutput({'value': null, 'status': 'waiting'});

    // Try to subscribe — broker may not be connected yet
    _trySubscribe(nodeId, brokerNodeId, topic, settings, gen);
  }

  void _trySubscribe(
    String nodeId,
    String brokerNodeId,
    String topic,
    Map<String, dynamic> settings,
    int gen,
  ) {
    if (_generation[nodeId] != gen) return;

    final client = MqttBrokerNode.clients[brokerNodeId];
    if (client == null ||
        client.connectionStatus?.state !=
            mqtt5.MqttConnectionState.connected) {
      // Broker not ready yet — retry in 1s
      _retryTimers[nodeId]?.cancel();
      _retryTimers[nodeId] = Timer(
        const Duration(seconds: 1),
        () => _trySubscribe(nodeId, brokerNodeId, topic, settings, gen),
      );
      return;
    }

    final qosValue = settings['qos'] as int? ?? 1;
    final qos = switch (qosValue) {
      0 => mqtt5.MqttQos.atMostOnce,
      2 => mqtt5.MqttQos.exactlyOnce,
      _ => mqtt5.MqttQos.atLeastOnce,
    };

    client.subscribe(topic, qos);
    print('mqtt.subscribe[$nodeId]: subscribed to "$topic"');

    _callbacks[nodeId]?.call({'value': null, 'status': 'subscribed'});

    _subscriptions[nodeId] = client.updates.listen((messages) {
      if (_generation[nodeId] != gen) return;

      for (final msg in messages) {
        if (msg.topic != topic) continue;
        final pubMsg = msg.payload as mqtt5.MqttPublishMessage;
        final payloadStr = mqtt5.MqttPublishPayload.bytesToStringAsString(
            pubMsg.payload.message!);

        // Try to parse as number, fall back to string
        dynamic value;
        final asNum = num.tryParse(payloadStr.trim());
        if (asNum != null) {
          value = asNum;
        } else {
          value = payloadStr;
        }

        print('mqtt.subscribe[$nodeId]: received $value on "$topic"');
        _callbacks[nodeId]?.call({'value': value, 'status': 'subscribed'});
      }
    });
  }

  @override
  Future<void> stop(String nodeId) async {
    _generation[nodeId] = (_generation[nodeId] ?? 0) + 1;
    _retryTimers[nodeId]?.cancel();
    _retryTimers.remove(nodeId);
    await _subscriptions[nodeId]?.cancel();
    _subscriptions.remove(nodeId);
    _callbacks.remove(nodeId);
  }
}
