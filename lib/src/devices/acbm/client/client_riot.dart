import '../../common/device_models.dart' as models;
import '../parser/parser.dart';
import 'client_base.dart';

/// RIOT engine: status, packages, node info.
mixin ClientRiotMixin on AcbmClientBase {
  Future<models.RiotStatus> getRiotStatus() async {
    final lines = await transport.execute('riot_status');
    final parsed = parseRiotStatus(lines);
    final code = switch (parsed.code) {
      0 => models.RiotStatusCode.notStarted,
      1 => models.RiotStatusCode.idle,
      2 => models.RiotStatusCode.running,
      _ => models.RiotStatusCode.notStarted,
    };
    return models.RiotStatus(code: code, message: parsed.message);
  }

  Future<List<models.RiotPackage>> getRiotPackages() async {
    final lines = await transport.execute('riot_package_info');
    final parsed = parseRiotPackageInfo(lines);
    return parsed.map((p) => models.RiotPackage(id: p.id, name: p.name, version: p.version)).toList();
  }

  Future<List<RiotNodeEntry>> getRiotNodeInfo() async {
    final lines = await transport.execute('riot_node_info');
    return parseRiotNodeInfo(lines);
  }
}
