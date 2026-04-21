import '../../common/connection_state.dart';
import '../../common/device_client.dart';
import '../serial/acbm_serial_transport.dart';
import '../tcp/acbm_tcp_transport.dart';
import '../transport.dart';
import 'client_base.dart';
import 'client_config.dart';
import 'client_network.dart';
import 'client_params.dart';
import 'client_points.dart';
import 'client_riot.dart';
import 'client_system.dart';
import 'client_time.dart';

/// ACBM device client — implements [DeviceClient].
///
/// Transport-agnostic: works over TCP or serial via [AcbmTransport].
/// Composed from domain-specific mixins, each matching a Go `client_*.go` file.
class AcbmClient extends AcbmClientBase
    with
        ClientSystemMixin,
        ClientParamsMixin,
        ClientNetworkMixin,
        ClientConfigMixin,
        ClientPointsMixin,
        ClientRiotMixin,
        ClientTimeMixin
    implements DeviceClient {
  final AcbmTransport _transport;

  AcbmClient(this._transport);

  /// Create a TCP-backed client.
  factory AcbmClient.tcp({
    required String host,
    int port = 56789,
    String? username,
    String? password,
    bool autoLogin = false,
  }) {
    return AcbmClient(AcbmTcpTransport(TcpConfig(
      host: host,
      port: port,
      username: username,
      password: password,
      autoLogin: autoLogin,
    )));
  }

  /// Create a serial-backed client.
  factory AcbmClient.serial({
    required String portName,
    int baudRate = 115200,
    String? username,
    String? password,
    bool autoLogin = false,
  }) {
    return AcbmClient(AcbmSerialTransport(SerialTransportConfig(
      portName: portName,
      baudRate: baudRate,
      username: username,
      password: password,
      autoLogin: autoLogin,
    )));
  }

  @override
  AcbmTransport get transport => _transport;

  @override
  DeviceCapabilities get capabilities => DeviceCapabilities.acbm;

  @override
  Future<void> connect() => _transport.connect();

  @override
  Future<void> disconnect() => _transport.disconnect();

  @override
  Future<void> login(String username, String password) =>
      _transport.login(username, password);

  @override
  ConnectionStatus get status => _transport.status;

  @override
  Stream<ConnectionStatus> get statusStream => _transport.statusStream;

  @override
  Future<List<String>> rawCommand(String command) =>
      _transport.execute(command);

  Future<void> dispose() => _transport.dispose();
}
