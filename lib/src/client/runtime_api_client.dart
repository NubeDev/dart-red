import 'runtime_http.dart';
import 'flow_client.dart';
import 'node_client.dart';
import 'edge_client.dart';
import 'link_client.dart';
import 'page_client.dart';
import 'palette_client.dart';

/// Facade for the Micro-BMS runtime REST API.
///
/// Composes resource-specific clients that can also be used independently.
/// The runtime runs as a separate daemon process — this is how the Flutter
/// UI talks to it over HTTP.
///
/// Usage:
/// ```dart
/// final api = RuntimeApiClient(baseUrl: 'http://192.168.1.50:8080');
///
/// // Via facade
/// final pages = await api.pages.getAll();
/// await api.nodes.setValue(id, 42);
///
/// // Or grab a resource client directly
/// final nodeClient = api.nodes;
/// ```
class RuntimeApiClient {
  final RuntimeHttp _http;

  late final FlowClient flow;
  late final NodeClient nodes;
  late final EdgeClient edges;
  late final LinkClient links;
  late final PageClient pages;
  late final PaletteClient palette;

  RuntimeApiClient({String baseUrl = 'http://localhost:8080'})
      : _http = RuntimeHttp(baseUrl: baseUrl) {
    _init();
  }

  RuntimeApiClient.withHttp(this._http) {
    _init();
  }

  void _init() {
    final dio = _http.dio;
    flow = FlowClient(dio);
    nodes = NodeClient(dio);
    edges = EdgeClient(dio);
    links = LinkClient(dio);
    pages = PageClient(dio);
    palette = PaletteClient(dio);
  }

  /// Check if the runtime daemon is reachable.
  Future<bool> isAlive() => _http.isAlive();
}
