# Runtime Engine

The Rubix runtime is a reactive dataflow engine. You build a graph of **nodes** connected by **edges**, and the engine evaluates it — sources push values, transforms compute outputs, sinks perform side effects. Think Niagara station or Node-RED, running inside Flutter/Dart.

## Architecture

```
                        ┌──────────────────────────────────────┐
                        │            MicroBmsRuntime            │
                        │                                      │
  RuntimeDao (Drift) <──┤  State Maps (in-memory graph)        │
                        │  ┌─────────────────────────────────┐ │
                        │  │ _nodeTypes    nodeId → NodeType  │ │
                        │  │ _nodeValues   nodeId → outputs   │ │
                        │  │ _nodeStatuses nodeId → ok/stale  │ │
                        │  │ _inputMap     target → source    │ │
                        │  │ _adjacency    source → targets   │ │
                        │  │ _topoOrder    [sorted node IDs]  │ │
                        │  └─────────────────────────────────┘ │
                        │                                      │
  NodeRegistry ────────>│  Lifecycle: start() → evaluate → stop│
                        └──────────────────────────────────────┘
```

## File Structure

The runtime class is split across files using Dart `part` directives:

| File | Responsibility |
|------|---------------|
| `runtime.dart` | Main class, state maps, start/stop lifecycle |
| `runtime_graph.dart` | Load from DB, build graph, topo sort, start sources, inject dependencies |
| `runtime_evaluate.dart` | Reactive evaluation loop — dirty marking, input gathering, transform/sink execution, batch persist |
| `runtime_crud.dart` | Node & edge CRUD, dynamic settings schema resolution, palette |
| `runtime_pages.dart` | Dashboard page assembly, flow state, enable/disable |

Supporting files:

| File | Purpose |
|------|---------|
| `node.dart` | Base classes: `SourceNode`, `TransformNode`, `SinkNode` |
| `port.dart` | `Port` class and `NullPolicy` enum |
| `node_registry.dart` | Factory registry mapping type name to constructor |
| `node_status.dart` | `NodeStatus` enum (ok, stale, error, disabled) with merge logic |
| `node_helpers.dart` | Reusable base classes: `VariadicMathNode`, `UnaryMathNode`, `SingleOutputSource` |
| `graph_solver.dart` | Kahn's algorithm for topological sort + dirty subgraph computation |

## How It Works

### 1. Startup

```
runtime.start()
  │
  ├─ Ensure default flow exists in DB
  ├─ _rebuildGraph()
  │    ├─ Load RuntimeNodes + RuntimeEdges from Drift
  │    ├─ Create NodeType instances via registry
  │    ├─ Restore persisted values for opted-in nodes
  │    ├─ _injectNodeDependencies() (DAO, manager defaults)
  │    ├─ Build edge mappings (_inputMap, _adjacency)
  │    ├─ Topological sort (Kahn's algorithm)
  │    ├─ Start source nodes (parents before children)
  │    └─ Start sink nodes needing init (history flush timers)
  │
  └─ If persisted values exist, full graph evaluation
```

### 2. Reactive Evaluation Loop

This is the core of the engine. When a source emits a value, only the affected downstream subgraph is re-evaluated:

```
Source emits value
  │
  ├─ _onSourceOutput(nodeId, outputs)
  │    ├─ Store value in _nodeValues[nodeId]
  │    ├─ Set status to ok
  │    └─ Add nodeId to _dirtyNodes
  │
  ├─ scheduleMicrotask(_evaluate)     ← batches multiple source changes
  │
  └─ _evaluate()
       ├─ Compute dirty subgraph (dirty nodes + all downstream)
       ├─ Walk in topological order:
       │    ├─ TransformNode → evaluate(inputs)    [sync, pure]
       │    └─ SinkNode      → execute(inputs)     [async, side effects]
       ├─ Batch persist changed values to Drift
       └─ If new dirty nodes appeared, recurse
```

**Why microtask?** If three sources fire in the same event loop turn, they batch into one evaluation pass instead of three.

### 3. Input Resolution

For each node's input port, the engine resolves values in this order:

```
1. Is there an edge feeding this port?
   YES → use upstream node's output value for that port
   NO  → use port.defaultValue (if defined)

2. Is the resolved value null?
   Port has NullPolicy.deny  → block evaluation, output stays stale
   Port has NullPolicy.allow → pass null through, node decides
```

### 4. Status Propagation

Status flows downstream through the graph:

```
error > stale > ok

If ANY upstream input is error → this node is error
If ANY upstream input is stale → this node is stale
Otherwise → this node is ok (or whatever evaluate/execute sets)
```

### 5. Persistence

Nodes opt into persistence via `settings['persist']` (bool) or by category (sources persist by default). Persisted nodes survive restarts — their last output is restored from `RuntimeNodes.value` on graph rebuild.

All changed values are batch-written in a single Drift transaction after each evaluation cycle.

## Node Types

Three base classes, each with a different contract:

### SourceNode

Produces values from external events. No inputs — only outputs.

```dart
class MySource extends SourceNode {
  String get typeName => 'my.source';
  String get description => 'Example source';
  List<Port> get outputPorts => [Port(name: 'value', type: 'num')];

  Future<void> start(nodeId, settings, onOutput, {parentId}) async {
    // Subscribe, poll, connect — then call onOutput when value changes
    onOutput({'value': 42});
  }
}
```

Examples: MQTT subscribe, BACnet point, schedule, system constant, UI source

### TransformNode

Pure synchronous computation. Inputs in, outputs out. No side effects.

```dart
class MyTransform extends TransformNode {
  String get typeName => 'my.transform';
  String get description => 'Example transform';
  List<Port> get inputPorts => [Port(name: 'a', type: 'num', nullPolicy: NullPolicy.deny)];
  List<Port> get outputPorts => [Port(name: 'out', type: 'num')];

  Map<String, dynamic>? evaluate(Map<String, dynamic> inputs) {
    final a = inputs['a'] as num?;
    if (a == null) return null;  // propagates stale
    return {'out': a * 2};
  }
}
```

Examples: math.add

### SinkNode

Performs async side effects. Can optionally return outputs for downstream wiring.

```dart
class MySink extends SinkNode {
  String get typeName => 'my.sink';
  String get description => 'Example sink';
  List<Port> get inputPorts => [Port(name: 'value', type: 'dynamic')];

  Future<Map<String, dynamic>?> execute(nodeId, inputs, settings, {parentId}) async {
    await writeToDatabase(inputs['value']);
    return {'success': true};  // optional: wirable outputs
  }
}
```

Examples: history.log, insight.alarm, UI display, BACnet write

## Ports & Null Policy

```dart
const Port({
  required this.name,          // "value", "temperature", etc.
  this.type = 'dynamic',       // "num", "bool", "text", "dynamic"
  this.nullPolicy = NullPolicy.allow,
  this.defaultValue,
});
```

| NullPolicy | Behavior |
|-----------|----------|
| `allow` (default) | Null flows through — the node's evaluate/execute receives null and decides |
| `deny` | Null blocks evaluation — output stays at previous value (stale) |

Use `deny` for required inputs (e.g. the `value` port on math nodes). Use `allow` for optional inputs with fallback logic (e.g. the `enable` port on insight.alarm defaults to `true`).

## Containment (Parent-Child Hierarchy)

Nodes can contain other nodes. This models real-world relationships:

```
mqtt.broker
  └─ mqtt.subscribe    (gets broker client from parent)
  └─ mqtt.subscribe

bacnet.driver
  └─ bacnet.device
       └─ bacnet.point  (gets driver client from grandparent)
       └─ bacnet.point
       └─ bacnet.write
```

Controlled by two properties on `NodeType`:
- `allowedChildTypes` — which node types can go inside this node
- `requiredParentType` — what the parent must be (null = can be root)

Startup order is tree-order: parents start before children (so the MQTT client exists before subscribers try to use it). On delete, all children cascade-delete with their history and insights.

## Settings Schema

Each node declares a `settingsSchema` — a JSON Schema object. The UI auto-generates a form from it. Features:

- Standard types: string, number, integer, boolean
- Enums → rendered as dropdowns
- **Cascading fields** via `allOf` with `if/then/else` — show different fields based on a mode selection (e.g. history.log shows `covThreshold` when mode=cov, `cronInterval` when mode=cron)
- Custom widgets via `x-widget` extension: `node-picker`, `interface-picker`, `datetime`

At read time, `getNodeSettingsSchema()` enriches the raw schema:
- Hides fields satisfied by parent containment (e.g. `brokerNodeId` hidden when node is child of mqtt.broker)
- Resolves `node-picker` fields into live enum dropdowns from the current graph
- Resolves `interface-picker` into available network interfaces
- Injects validation warnings (duplicate widget orders, missing page selections)

## Edge Creation & Cycle Detection

When creating an edge, the runtime:

1. Validates both nodes and ports exist
2. Tests for cycles by running topo-sort on the hypothetical graph — throws `CycleDetectedException` if invalid
3. Persists to Drift
4. **Incrementally** updates `_adjacency` and `_inputMap` (no full rebuild needed)
5. Re-runs topo-sort
6. Marks target dirty and evaluates

Edge deletion is the same — incremental update, re-sort, re-evaluate.

## Graph Solver

`graph_solver.dart` provides two algorithms:

**`topologicalSort(nodeIds, adjacency)`** — Kahn's algorithm. Returns nodes in evaluation order (sources first, sinks last). Throws `CycleDetectedException` if the graph has a cycle.

**`dirtySubgraph(dirtyIds, topoOrder, adjacency)`** — Given a set of dirty nodes, returns only the affected downstream subgraph in topo order. This is the key to efficient evaluation: when one source changes, only its downstream chain re-evaluates, not the entire graph.

## Database Tables

| Table | Purpose |
|-------|---------|
| `RuntimeFlows` | Flow metadata (id, name, enabled) |
| `RuntimeNodes` | Node instances (type, settings, value, status, position, parentId) |
| `RuntimeEdges` | Wires (sourceNodeId/port → targetNodeId/port) |
| `RuntimeHistory` | Time-series samples (num/bool/str + timestamp) |
| `RuntimeInsights` | Alarm/alert events (type, severity, state, lifecycle timestamps) |

## Built-In Node Catalog

### Protocol / IO

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `bacnet.driver` | source | — | BACnet/IP connection + periodic poll loop |
| `bacnet.device` | source | bacnet.driver | BACnet device container |
| `bacnet.point` | source | bacnet.device | Single BACnet property (read, polled) |
| `bacnet.write` | sink | — | Write value to BACnet property |
| `mqtt.broker` | source | — | MQTT 5 connection, static client registry |
| `mqtt.subscribe` | source | mqtt.broker | Subscribe to MQTT topic, emit on message |

### Logic / Math

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `math.add` | transform | — | Variadic numeric addition (2–16 inputs) |
| `system.constant` | source | — | Fixed value from settings |
| `system.trigger` | source | — | External trigger (API, CLI) |

### Scheduling

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `schedule.source` | source | — | Weekly + exception time scheduling |
| `schedule.display` | sink | — | Show schedule state on dashboard |

### UI / Dashboard

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `ui.page` | source | — | Dashboard page container (metadata) |
| `ui.source` | source | — | Interactive widget (slider, toggle, button) |
| `ui.display` | sink | — | Show value on dashboard (gauge, label, LED, sparkline) |

### History

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `history.manager` | source | — | Global history config (max samples, flush interval, value type) |
| `history.log` | sink | — | Buffered time-series logging (COV or cron mode) |
| `history.display` | sink | — | History chart widget on dashboard |

### Insights / Alarms

| Type | Category | Parent | Description |
|------|----------|--------|-------------|
| `insight.manager` | source | — | Global alarm config + live stats (active/acked/cleared counts) |
| `insight.alarm` | sink | — | Alarm with threshold/limit/rate-of-change/expression, inhibit, deadband |

## Using the RuntimeBuilder

```dart
// Full node set (embedded in Flutter app)
final runtime = RuntimeBuilder(dao: db.runtimeDao)
    .withAllNodes()
    .build();
await runtime.start();

// Lightweight — only math + system (no BACnet, no MQTT)
final runtime = RuntimeBuilder(dao: db.runtimeDao)
    .withSystemNodes()
    .withMathNodes()
    .build();

// Custom — register your own nodes alongside built-ins
final runtime = RuntimeBuilder(dao: db.runtimeDao)
    .withNode('custom.sensor', CustomSensorNode.new)
    .withAllNodes()
    .build();
```

Available builder methods: `withBacnetNodes()`, `withMqttNodes()`, `withMathNodes()`, `withSystemNodes()`, `withUiNodes()`, `withScheduleNodes()`, `withHistoryNodes()`, `withInsightNodes()`, `withAllNodes()`.

## Adding a New Node Type

1. Create a class extending `SourceNode`, `TransformNode`, or `SinkNode` in `nodes/<domain>/`
2. Implement the required getters: `typeName`, `description`, `inputPorts`/`outputPorts`, `settingsSchema`
3. Implement the logic method:
   - **Source:** `start()` — subscribe/poll/connect, call `onOutput()` when value changes
   - **Transform:** `evaluate(inputs)` — pure computation, return output map or null
   - **Sink:** `execute(nodeId, inputs, settings)` — async side effect, optionally return outputs
4. Register in `runtime_builder.dart`:
   ```dart
   RuntimeBuilder withMyNodes() {
     _registry.register('my.node', MyNode.new);
     return this;
   }
   ```
   Add the call to `withAllNodes()` if it should be included by default.
5. If the node needs DAO or shared state, add injection in `_injectNodeDependencies()` in `runtime_graph.dart`

### Helper Base Classes

For common patterns, extend these instead of the raw base classes:

- **`VariadicMathNode`** — N numeric inputs → 1 output. Override `compute(a, b)` for pairwise reduction (e.g. add, multiply). Input count configurable via `inputCount` setting.
- **`UnaryMathNode`** — 1 numeric input → 1 output. Override `compute(value)`.
- **`SingleOutputSource`** — source with a single `value` output port. Just override `start()`.

## Data Flow Example

Temperature alarm that only fires when AC is running, with 30-minute inhibit:

```
[bacnet.point "Room Temp"]                    [bacnet.point "AC Status"]
        │ value=29.5                                  │ value=true
        │                                             │
        ▼                                             ▼
   ┌─────────────────────────────────────────────────────┐
   │  insight.alarm                                      │
   │    alarmType: threshold                             │
   │    threshold: 28, direction: above, deadband: 1     │
   │    inhibitDuration: 1800 (30 min)                   │
   │                                                     │
   │  29.5 > 28 AND enable=true → RAISE alarm            │
   └──────────┬───────────────────────────────────┬──────┘
              │ active=true                       │ active=true
              ▼                                   ▼
     [ui.display "Room Hot"]           [history.log → time-series]
```

1. BACnet points poll sensor values → source nodes emit → mark dirty
2. insight.alarm evaluates: 29.5 > 28 threshold, enable=true → raise alarm
3. Writes `RuntimeInsights` row (state: active, triggerValue: 29.5)
4. Outputs `{active: true}` → downstream display and history evaluate
5. When temp drops below 27 (28 - 1 deadband) → clear alarm, start inhibit
6. For the next 1800 seconds, alarm won't re-trigger even if temp spikes again
