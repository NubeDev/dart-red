/// Connection lifecycle for any device transport.
enum DeviceConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Authentication state — some transports (TCP) require login.
enum DeviceAuthState {
  unauthenticated,
  authenticated,
  notRequired, // REST with token header, no interactive login
}

/// Snapshot of a live connection.
class ConnectionStatus {
  final DeviceConnectionState state;
  final DeviceAuthState authState;
  final String? authenticatedUser;
  final DateTime? connectedAt;
  final DateTime? lastCommandAt;
  final int commandCount;
  final int errorCount;
  final int bytesSent;
  final int bytesReceived;
  final int reconnectCount;
  final String? lastError;

  const ConnectionStatus({
    this.state = DeviceConnectionState.disconnected,
    this.authState = DeviceAuthState.unauthenticated,
    this.authenticatedUser,
    this.connectedAt,
    this.lastCommandAt,
    this.commandCount = 0,
    this.errorCount = 0,
    this.bytesSent = 0,
    this.bytesReceived = 0,
    this.reconnectCount = 0,
    this.lastError,
  });

  bool get isConnected => state == DeviceConnectionState.connected;
  bool get isAuthenticated =>
      authState == DeviceAuthState.authenticated ||
      authState == DeviceAuthState.notRequired;

  ConnectionStatus copyWith({
    DeviceConnectionState? state,
    DeviceAuthState? authState,
    String? Function()? authenticatedUser,
    DateTime? connectedAt,
    DateTime? lastCommandAt,
    int? commandCount,
    int? errorCount,
    int? bytesSent,
    int? bytesReceived,
    int? reconnectCount,
    String? Function()? lastError,
  }) {
    return ConnectionStatus(
      state: state ?? this.state,
      authState: authState ?? this.authState,
      authenticatedUser: authenticatedUser != null
          ? authenticatedUser()
          : this.authenticatedUser,
      connectedAt: connectedAt ?? this.connectedAt,
      lastCommandAt: lastCommandAt ?? this.lastCommandAt,
      commandCount: commandCount ?? this.commandCount,
      errorCount: errorCount ?? this.errorCount,
      bytesSent: bytesSent ?? this.bytesSent,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      reconnectCount: reconnectCount ?? this.reconnectCount,
      lastError: lastError != null ? lastError() : this.lastError,
    );
  }
}
