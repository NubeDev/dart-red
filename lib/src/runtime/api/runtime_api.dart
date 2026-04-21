import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../runtime.dart';

/// Full CRUD REST API for the Micro-BMS runtime.
class RuntimeApi {
  final MicroBmsRuntime _runtime;
  HttpServer? _server;

  RuntimeApi(this._runtime);

  Router get _router {
    final router = Router();

    // Palette
    router.get('/api/v1/palette', _getPalette);

    // Flow
    router.get('/api/v1/flow', _getFlow);
    router.put('/api/v1/flow', _updateFlow);
    router.post('/api/v1/flow/enable', _enableFlow);
    router.post('/api/v1/flow/disable', _disableFlow);

    // Nodes — CRUD
    router.get('/api/v1/nodes', _listNodes);
    router.post('/api/v1/nodes', _createNode);
    router.get('/api/v1/nodes/<id>', _getNode);
    router.get('/api/v1/nodes/<id>/children', _getNodeChildren);
    router.put('/api/v1/nodes/<id>', _updateNode);
    router.put('/api/v1/nodes/<id>/position', _updateNodePosition);
    router.delete('/api/v1/nodes/<id>', _deleteNode);

    // Nodes — value
    router.get('/api/v1/nodes/<id>/value', _getNodeValue);
    router.put('/api/v1/nodes/<id>/value', _setNodeValue);

    // Nodes — settings
    router.get('/api/v1/nodes/<id>/settings', _getNodeSettings);
    router.get('/api/v1/nodes/<id>/settings/schema', _getNodeSettingsSchema);
    router.put('/api/v1/nodes/<id>/settings', _updateNodeSettings);

    // Edges — CRUD
    router.get('/api/v1/edges', _listEdges);
    router.post('/api/v1/edges', _createEdge);
    router.get('/api/v1/edges/<id>', _getEdge);
    router.delete('/api/v1/edges/<id>', _deleteEdge);

    // Links — hidden (portless) edges
    router.get('/api/v1/links', _listLinks);

    // Pages (dashboard)
    router.get('/api/v1/pages', _getPages);

    // History
    router.get('/api/v1/nodes/<id>/history', _getNodeHistory);
    router.delete('/api/v1/nodes/<id>/history', _deleteNodeHistory);

    return router;
  }

  Future<void> serve({int port = 8080}) async {
    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(_router.call);

    _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port,
        shared: true);
    print('RuntimeApi: listening on http://0.0.0.0:$port');
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  // ---------------------------------------------------------------------------
  // Palette
  // ---------------------------------------------------------------------------

  Response _getPalette(Request request) {
    return _json({'nodes': _runtime.getPalette()});
  }

  // ---------------------------------------------------------------------------
  // Flow
  // ---------------------------------------------------------------------------

  Future<Response> _getFlow(Request request) async {
    return _json(await _runtime.getFlowState());
  }

  Future<Response> _updateFlow(Request request) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');
    await _runtime.updateFlow(name: body['name'] as String?);
    return _json({'ok': true});
  }

  Future<Response> _enableFlow(Request request) async {
    await _runtime.enableFlow();
    return _json({'ok': true, 'running': true});
  }

  Future<Response> _disableFlow(Request request) async {
    await _runtime.disableFlow();
    return _json({'ok': true, 'running': false});
  }

  // ---------------------------------------------------------------------------
  // Nodes — CRUD
  // ---------------------------------------------------------------------------

  Response _listNodes(Request request) {
    return _json({'nodes': _runtime.getNodes()});
  }

  Future<Response> _createNode(Request request) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');

    final type = body['type'] as String?;
    if (type == null) return _badRequest('Missing "type" field');

    try {
      final nodeId = await _runtime.createNode(
        type: type,
        settings:
            (body['settings'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        label: body['label'] as String?,
        parentId: body['parentId'] as String?,
        posX: (body['posX'] as num?)?.toDouble() ?? 0.0,
        posY: (body['posY'] as num?)?.toDouble() ?? 0.0,
      );
      return _json({'id': nodeId}, status: 201);
    } on ArgumentError catch (e) {
      return _badRequest(e.message);
    }
  }

  Response _getNode(Request request, String id) {
    final includeChildren =
        request.url.queryParameters['includeChildren'] == 'true';
    final node = _runtime.getNode(id);
    if (node == null) return _notFound('Node not found');

    if (includeChildren) {
      node['childNodes'] = _runtime.getNodeTree(id);
    }
    return _json(node);
  }

  Response _getNodeChildren(Request request, String id) {
    final node = _runtime.getNode(id);
    if (node == null) return _notFound('Node not found');
    return _json({'children': _runtime.getChildNodes(id)});
  }

  Future<Response> _updateNode(Request request, String id) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');

    try {
      await _runtime.updateNode(id, label: body['label'] as String?);
      return _json({'ok': true});
    } on ArgumentError catch (e) {
      return _notFound(e.message);
    }
  }

  Future<Response> _updateNodePosition(Request request, String id) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');

    final posX = (body['posX'] as num?)?.toDouble();
    final posY = (body['posY'] as num?)?.toDouble();
    if (posX == null || posY == null) {
      return _badRequest('Missing "posX" and/or "posY"');
    }

    try {
      await _runtime.updateNodePosition(id, posX, posY);
      return _json({'ok': true});
    } on ArgumentError catch (e) {
      return _notFound(e.message);
    }
  }

  Future<Response> _deleteNode(Request request, String id) async {
    await _runtime.deleteNode(id);
    return Response(204);
  }

  // ---------------------------------------------------------------------------
  // Nodes — value
  // ---------------------------------------------------------------------------

  Response _getNodeValue(Request request, String id) {
    final result = _runtime.getNodeValue(id);
    if (result == null) return _notFound('Node not found');
    return _json({
      'value':
          result.value.length == 1 ? result.value.values.first : result.value,
      'status': result.status.name,
    });
  }

  Future<Response> _setNodeValue(Request request, String id) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');
    if (!body.containsKey('value')) return _badRequest('Missing "value" field');

    try {
      await _runtime.setNodeValue(id, body['value']);
      return _json({'ok': true});
    } on ArgumentError catch (e) {
      return _notFound(e.message);
    }
  }

  // ---------------------------------------------------------------------------
  // Nodes — settings
  // ---------------------------------------------------------------------------

  Response _getNodeSettings(Request request, String id) {
    final settings = _runtime.getNodeSettings(id);
    if (settings == null) return _notFound('Node not found');
    return _json({'settings': settings});
  }

  Future<Response> _getNodeSettingsSchema(Request request, String id) async {
    final schema = await _runtime.getNodeSettingsSchema(id);
    if (schema == null) return _notFound('Node not found');
    return _json({'schema': schema});
  }

  Future<Response> _updateNodeSettings(Request request, String id) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');

    try {
      await _runtime.updateNodeSettings(id, body);
      return _json({'ok': true});
    } on ArgumentError catch (e) {
      return _notFound(e.message);
    }
  }

  // ---------------------------------------------------------------------------
  // Edges — CRUD
  // ---------------------------------------------------------------------------

  Future<Response> _listEdges(Request request) async {
    return _json({'edges': await _runtime.getEdges()});
  }

  Future<Response> _createEdge(Request request) async {
    final body = await _readJson(request);
    if (body == null) return _badRequest('Invalid JSON body');

    final sourceNodeId = body['sourceNodeId'] as String?;
    final sourcePort = body['sourcePort'] as String?;
    final targetNodeId = body['targetNodeId'] as String?;
    final targetPort = body['targetPort'] as String?;

    if (sourceNodeId == null ||
        sourcePort == null ||
        targetNodeId == null ||
        targetPort == null) {
      return _badRequest(
          'Missing: sourceNodeId, sourcePort, targetNodeId, targetPort');
    }

    final hidden = body['hidden'] as bool? ?? false;

    try {
      final edgeId = await _runtime.createEdge(
        sourceNodeId: sourceNodeId,
        sourcePort: sourcePort,
        targetNodeId: targetNodeId,
        targetPort: targetPort,
        hidden: hidden,
      );
      return _json({'id': edgeId}, status: 201);
    } on ArgumentError catch (e) {
      return _badRequest(e.message);
    }
  }

  Future<Response> _getEdge(Request request, String id) async {
    final edge = await _runtime.getEdge(id);
    if (edge == null) return _notFound('Edge not found');
    return _json(edge);
  }

  Future<Response> _deleteEdge(Request request, String id) async {
    await _runtime.deleteEdge(id);
    return Response(204);
  }

  // ---------------------------------------------------------------------------
  // Links (hidden/portless edges)
  // ---------------------------------------------------------------------------

  Future<Response> _listLinks(Request request) async {
    return _json({'links': await _runtime.getLinks()});
  }

  // ---------------------------------------------------------------------------
  // Pages
  // ---------------------------------------------------------------------------

  Response _getPages(Request request) {
    return _json({'pages': _runtime.getPages()});
  }

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  Future<Response> _getNodeHistory(Request request, String id) async {
    final limitStr = request.url.queryParameters['limit'];
    final limit = int.tryParse(limitStr ?? '') ?? 100;

    final history = await _runtime.getHistory(id, limit: limit);
    return _json({'samples': history});
  }

  Future<Response> _deleteNodeHistory(Request request, String id) async {
    await _runtime.deleteHistory(id);
    return Response(204);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> _readJson(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      return jsonDecode(bodyStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Response _json(Map<String, dynamic> data, {int status = 200}) =>
      Response(status,
          body: jsonEncode(data),
          headers: {'content-type': 'application/json'});

  Response _badRequest(String msg) => Response(400,
      body: jsonEncode({'error': msg}),
      headers: {'content-type': 'application/json'});

  Response _notFound(String msg) => Response.notFound(
      jsonEncode({'error': msg}),
      headers: {'content-type': 'application/json'});
}
