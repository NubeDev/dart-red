# Insight Nodes

Insight nodes provide alarm, alert, and notification capabilities for the Rubix runtime — similar to Tridium Niagara's alarm framework. They monitor values from upstream nodes and raise/clear insight events with full lifecycle tracking.

## Node Types

### `insight.manager` (SourceNode)

Global configuration and live statistics. One per flow.

**Outputs:**

| Port               | Type | Description                        |
|---------------------|------|------------------------------------|
| `activeCount`       | num  | Currently active (un-cleared) insights |
| `acknowledgedCount` | num  | Acknowledged but not yet cleared   |
| `clearedCount`      | num  | Cleared insights in retention      |
| `totalCount`        | num  | Total insight rows in database     |

**Settings:**

| Setting                  | Type    | Default  | Description                                      |
|--------------------------|---------|----------|--------------------------------------------------|
| `defaultSeverity`        | string  | `medium` | Default severity for insight.alarm nodes          |
| `defaultInhibitDuration` | integer | `300`    | Default inhibit delay (seconds) after alarm clear |
| `maxRetainedInsights`    | integer | `500`    | Max cleared insights kept per node                |
| `statsInterval`          | integer | `30`     | Seconds between stats refresh                     |

Settings are inherited by `insight.alarm` nodes unless overridden per-node.

---

### `insight.alarm` (SinkNode)

The core alarm engine. Monitors a numeric value, evaluates an alarm condition, and writes insight events to the `RuntimeInsights` table.

**Inputs:**

| Port     | Type | Required | Description                                          |
|----------|------|----------|------------------------------------------------------|
| `value`  | num  | yes      | The monitored value (e.g. room temperature)          |
| `enable` | bool | no       | Suppression input — wire to AC status, schedule, etc. Defaults to `true` |

**Outputs:**

| Port       | Type | Description                                      |
|------------|------|--------------------------------------------------|
| `active`   | bool | `true` while alarm condition is met              |
| `duration` | num  | Seconds the alarm has been active                |

Wire `active` downstream to chain alarms, drive UI indicators, or trigger MQTT publishes.

#### Alarm Types

Selected via the `alarmType` setting. Each type shows different cascading fields in the settings form.

**`threshold`** — fires when value crosses a single limit.

| Setting     | Default  | Description                                                |
|-------------|----------|------------------------------------------------------------|
| `threshold` | `28.0`   | The trigger point                                          |
| `direction` | `above`  | `above` or `below`                                         |
| `deadband`  | `1.0`    | Hysteresis band to prevent flapping (clears at threshold - deadband) |

**`limit`** — fires when value is outside a min/max band.

| Setting     | Default | Description           |
|-------------|---------|----------------------|
| `highLimit` | `30.0`  | Upper bound          |
| `lowLimit`  | `18.0`  | Lower bound          |
| `deadband`  | `1.0`   | Hysteresis on both edges |

**`rateOfChange`** — fires when value changes too fast.

| Setting        | Default | Description                         |
|----------------|---------|-------------------------------------|
| `rateLimit`    | `2.0`   | Max acceptable change (units/min)   |
| `sampleWindow` | `300`   | Seconds of history to measure over  |

**`expression`** — custom Dart expression (dart_eval integration pending).

| Setting      | Default        | Description                               |
|--------------|----------------|-------------------------------------------|
| `expression` | `value > 28`   | Dart expression evaluating to `bool`      |

#### Common Settings

| Setting            | Type    | Default  | Description                                                    |
|--------------------|---------|----------|----------------------------------------------------------------|
| `enabled`          | bool    | `true`   | Master enable — disable to turn off without deleting the node  |
| `title`            | string  | `Alarm`  | Short name in the alarm journal                                |
| `message`          | string  | —        | Optional detail text logged with each event                    |
| `type`             | string  | `alarm`  | Category: `alarm`, `alert`, `notification`, `energy`, `action` |
| `severity`         | string  | `medium` | `critical`, `high`, `medium`, `low`, `info`                    |
| `inhibitDuration`  | integer | `0`      | Seconds after clear before alarm can re-trigger                |
| `autoAcknowledge`  | bool    | `false`  | Auto-acknowledge when alarm clears                             |

#### Alarm Lifecycle

```
             condition met
  CLEARED ─────────────────────> ACTIVE
     ^                              |
     |        condition cleared     |
     |  (applies deadband check)    |
     +──────────────────────────────+
     |                              |
     |   inhibit timer starts       |   user action
     |   (blocks re-trigger)        +──> ACKNOWLEDGED
     |                              |
     +──────────────────────────────+
                condition cleared
```

Each state transition is persisted to `RuntimeInsights` with timestamps.

#### Suppression & Inhibit

Two levels of suppression:

1. **`enable` input port** — wire to external condition (AC running, occupied, schedule).
   When `false`, alarm is suppressed and any active alarm is auto-cleared.

2. **`inhibitDuration` setting** — after an alarm clears, it won't re-trigger for N seconds.
   Use this for startup transients (e.g. "let the AC cool the room for 30 minutes").

## Database

Insight events are stored in the `RuntimeInsights` table (separate from `RuntimeHistory`):

| Column         | Type     | Description                          |
|----------------|----------|--------------------------------------|
| `id`           | text PK  | UUID                                 |
| `nodeId`       | text FK  | The insight node that created it     |
| `type`         | text     | alarm, alert, notification, etc.     |
| `severity`     | text     | critical, high, medium, low, info    |
| `state`        | text     | active, acknowledged, cleared        |
| `title`        | text     | Short label                          |
| `message`      | text?    | Detail text                          |
| `triggerValue`  | real?   | Value that caused the trigger        |
| `thresholdValue`| real?   | Configured threshold                 |
| `triggeredAt`  | datetime | When raised                          |
| `clearedAt`    | datetime?| When cleared                         |
| `acknowledgedAt`| datetime?| When acknowledged                   |
| `metadata`     | text     | Extensible JSON                      |

Cleared insights are trimmed to `maxRetainedInsights` per node on each clear.

## Wiring Example

Temperature alarm that only triggers when AC is running, with 30-minute inhibit:

```
[bacnet.point "Room Temp"] ── value ──> [insight.alarm]
                                         |  alarmType: threshold
[bacnet.point "AC Status"] ── enable ──> |  threshold: 28
                                         |  direction: above
                                         |  deadband: 1.0
                                         |  inhibitDuration: 1800
                                         |
                                         +── active ──> [ui.display "Room Too Hot"]
                                         +── active ──> [mqtt.publish "alarms/room3"]
```

Energy saving insight:

```
[bacnet.point "Power"] ── value ──> [insight.alarm]
                                     |  type: energy
                                     |  alarmType: threshold
                                     |  threshold: 5000
                                     |  severity: low
                                     |  title: "Peak demand warning"
```

## Future

- **dart_eval expressions** — custom alarm conditions via `alarmType: expression`
- **insight.alert** — stateless one-shot events (no active/clear lifecycle)
- **insight.notification** — audit trail logging for user actions
- **Alarm routing** — dedicated node to route insights to email, Slack, MQTT
