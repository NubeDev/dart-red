import '../parser/parser.dart';
import 'client_base.dart';

/// Parameter read/write: param_list, param_get, param_set.
mixin ClientParamsMixin on AcbmClientBase {
  Future<List<ParamValue>> paramList() async {
    final lines = await transport.execute('param_list');
    return parseParamList(lines);
  }

  Future<ParamValue?> paramGet(String pucOrAlias) async {
    final lines = await transport.execute('param_get $pucOrAlias');
    return parseParamGet(lines);
  }

  Future<List<String>> paramSet(String pucOrAlias, Object value) async {
    final formatted = formatParamValue(value);
    return transport.execute('param_set $pucOrAlias $formatted');
  }
}
