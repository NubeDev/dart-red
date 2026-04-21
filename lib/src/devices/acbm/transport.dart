import '../common/connection_state.dart';

/// Minimal transport contract for ACBM devices.
///
/// Both TCP ([AcbmTcpTransport]) and serial ([AcbmSerialTransport])
/// implement this, allowing the client layer to be transport-agnostic.
abstract class AcbmTransport {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> login(String username, String password);
  Future<List<String>> execute(String command);
  Future<void> executeNoResponse(String command);
  ConnectionStatus get status;
  Stream<ConnectionStatus> get statusStream;
  bool get isConnected;
  Future<void> dispose();
}
