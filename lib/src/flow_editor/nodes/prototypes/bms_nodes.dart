import 'package:fl_nodes/fl_nodes.dart';

import 'package:dart_red/src/client/runtime_client.dart';
import '../styles/editor_theme.dart';
import '../styles/headers.dart' show headerStyleForDomain;
import '../styles/ports.dart';

/// Dynamically register fl_nodes prototypes from palette entries fetched
/// via the runtime REST API (`GET /api/v1/palette`).
///
/// The editor has NO hardcoded knowledge of node types — everything comes
/// from the backend.
void registerFromPalette(
  FlNodeEditorController controller,
  List<PaletteEntry> entries,
) {
  for (final entry in entries) {
    controller.registerNodePrototype(_buildPrototype(entry));
  }
}

// =============================================================================
// Build a single fl_nodes prototype from a PaletteEntry
// =============================================================================

/// Returns a header style builder for the given domain and icon.
///
/// Colour is derived from the domain string — no hardcoded mapping.
/// Icon is resolved from the icon name string.
FlNodeHeaderStyle Function(FlNodeState) _headerForDomain(
  String domain, {
  String? iconName,
}) {
  return headerStyleForDomain(domain, iconName: iconName);
}

/// Build an fl_nodes FlNodePrototype from a runtime PaletteEntry.
///
/// All ports are `dynamic` — the editor doesn't care about types, it just
/// visualises structure. The runtime validates types on edge creation.
FlNodePrototype _buildPrototype(PaletteEntry entry) {
  return _buildPrototypeFromPorts(
    type: entry.type,
    domain: entry.domain,
    description: entry.description,
    iconName: entry.icon,
    inputs: entry.inputs.map((p) => p.name).toList(),
    outputs: entry.outputs.map((p) => p.name).toList(),
  );
}

/// Build a prototype with custom ports — used for node instances that
/// have variadic port counts different from the palette default, or
/// instances with a user-set label.
///
/// The [instanceId] suffix ensures a unique prototype name per instance.
FlNodePrototype buildInstancePrototype({
  required String type,
  required String domain,
  required List<String> inputs,
  required List<String> outputs,
  required String instanceId,
  String? iconName,
  String? label,
}) {
  return _buildPrototypeFromPorts(
    type: type,
    domain: domain,
    description: type,
    iconName: iconName,
    label: label,
    inputs: inputs,
    outputs: outputs,
    idSuffix: instanceId,
  );
}

FlNodePrototype _buildPrototypeFromPorts({
  required String type,
  required String domain,
  required String description,
  required List<String> inputs,
  required List<String> outputs,
  String? idSuffix,
  String? iconName,
  String? label,
}) {
  final List<FlPortPrototype> ports = [];

  for (final name in inputs) {
    ports.add(FlDataInputPortPrototype<dynamic>(
      idName: name,
      displayName: (_) => name,
      styleBuilder: PortStyles.dataInput,
    ));
  }

  for (final name in outputs) {
    ports.add(FlDataOutputPortPrototype<dynamic>(
      idName: name,
      displayName: (_) => name,
      styleBuilder: PortStyles.dataOutput,
    ));
  }

  final protoId = idSuffix != null ? '$type#$idSuffix' : type;
  final displayText = label != null && label.isNotEmpty ? '$label ($type)' : type;

  return FlNodePrototype(
    idName: protoId,
    displayName: (_) => displayText,
    description: (_) => description,
    styleBuilder: rubixNodeStyleBuilder,
    headerStyleBuilder: _headerForDomain(domain, iconName: iconName),
    ports: ports,
    fields: [],
    onExecute: (ports, fields, state, f, p) async {},
  );
}
