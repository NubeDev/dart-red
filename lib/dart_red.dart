/// dart_red — flow-based runtime engine, HTTP client, and flow editor.
library dart_red;

// Runtime engine
// Note: runtime_crud, runtime_evaluate, runtime_graph, runtime_pages
// are 'part of runtime.dart' — exported implicitly via runtime.dart
export 'src/runtime/runtime.dart';
export 'src/runtime/runtime_service.dart';
export 'src/runtime/runtime_builder.dart';
export 'src/runtime/runtime_providers.dart';
export 'src/runtime/node.dart';
export 'src/runtime/node_registry.dart';
export 'src/runtime/node_status.dart';
export 'src/runtime/node_helpers.dart';
export 'src/runtime/port.dart';
export 'src/runtime/graph_solver.dart';
export 'src/runtime/embedded_runtime_service.dart';
export 'src/runtime/remote_runtime_service.dart';
export 'src/runtime/disabled_runtime_service.dart';
export 'src/runtime/create_runtime_service.dart';
export 'src/runtime/api/runtime_api.dart';

// Database
export 'src/db/database_provider.dart';
export 'src/db/flutter_database.dart';
export 'src/db/native_database.dart';

// HTTP client
export 'src/client/runtime_client.dart';

// Flow editor (Flutter)
export 'src/flow_editor/presentation/flow_editor_screen.dart';
export 'src/flow_editor/presentation/dashboard_tab.dart';
export 'src/flow_editor/sync/flow_sync_manager.dart';
