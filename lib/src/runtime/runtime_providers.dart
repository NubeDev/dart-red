import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dart_red/src/client/runtime_client.dart';

import 'disabled_runtime_service.dart';
import 'runtime_service.dart';

// =============================================================================
// Flow UI build gate
// =============================================================================

/// Whether the flow editor UI is compiled in.
/// Controlled via `--dart-define=FLOW_UI=true` at build time.
const flowUiEnabled = bool.fromEnvironment('FLOW_UI', defaultValue: false);

// =============================================================================
// Runtime mode — embedded (in-process) vs remote (HTTP to daemon)
// =============================================================================

enum RuntimeMode { embedded, remote, none }

/// The runtime mode. Override in ProviderScope or via settings.
/// Default: none (UI only, no runtime).
final runtimeModeProvider = Provider<RuntimeMode>((ref) {
  return RuntimeMode.none;
});

// =============================================================================
// RuntimeService — the single abstraction the UI should use
// =============================================================================

/// The main provider for runtime operations.
///
/// Dashboard, settings, and every feature should use this — never
/// [RuntimeApiClient] or [MicroBmsRuntime] directly.
///
/// In practice this is overridden in main.dart's ProviderScope.
/// The fallback here uses [createRuntimeService] which handles
/// platform differences (embedded is native-only).
final runtimeServiceProvider = Provider<RuntimeService>((ref) {
  return DisabledRuntimeService();
});

// =============================================================================
// Legacy HTTP providers — kept for flowui / external tools
// =============================================================================

/// Base URL for the runtime daemon.
/// Override this in ProviderScope for remote gateways.
final runtimeBaseUrlProvider = Provider<String>((ref) {
  return 'http://localhost:8080';
});

/// Top-level API client — use this or the individual resource providers below.
final runtimeApiClientProvider = Provider<RuntimeApiClient>((ref) {
  final baseUrl = ref.watch(runtimeBaseUrlProvider);
  return RuntimeApiClient(baseUrl: baseUrl);
});

// --- Resource clients (for when you only need one) ---

final runtimeFlowClientProvider = Provider<FlowClient>((ref) {
  return ref.watch(runtimeApiClientProvider).flow;
});

final runtimeNodeClientProvider = Provider<NodeClient>((ref) {
  return ref.watch(runtimeApiClientProvider).nodes;
});

final runtimeEdgeClientProvider = Provider<EdgeClient>((ref) {
  return ref.watch(runtimeApiClientProvider).edges;
});

final runtimePageClientProvider = Provider<PageClient>((ref) {
  return ref.watch(runtimeApiClientProvider).pages;
});

final runtimePaletteClientProvider = Provider<PaletteClient>((ref) {
  return ref.watch(runtimeApiClientProvider).palette;
});
