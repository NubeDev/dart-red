/// HTTP client for the Micro-BMS runtime REST API.
///
/// Usage:
/// ```dart
/// import 'package:dart_red/src/client/runtime_client.dart';
///
/// final api = RuntimeApiClient(baseUrl: 'http://192.168.1.50:8080');
/// final pages = await api.pages.getAll();
/// await api.nodes.setValue(id, 42);
/// ```
library runtime_client;

export 'runtime_api_client.dart';
export 'runtime_http.dart';
export 'flow_client.dart';
export 'node_client.dart';
export 'edge_client.dart';
export 'link_client.dart';
export 'page_client.dart';
export 'palette_client.dart';
