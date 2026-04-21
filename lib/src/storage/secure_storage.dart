import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  // Per-location credential keys
  String _usernameKey(String locationId) => 'location_${locationId}_username';
  String _passwordKey(String locationId) => 'location_${locationId}_password';
  String _jwtKey(String locationId) => 'location_${locationId}_jwt';

  // --- Credentials ---

  Future<void> saveCredentials(String locationId, String username, String password) async {
    await _storage.write(key: _usernameKey(locationId), value: username);
    await _storage.write(key: _passwordKey(locationId), value: password);
  }

  Future<String?> getUsername(String locationId) async {
    return await _storage.read(key: _usernameKey(locationId));
  }

  Future<String?> getPassword(String locationId) async {
    return await _storage.read(key: _passwordKey(locationId));
  }

  Future<bool> hasCredentials(String locationId) async {
    final username = await getUsername(locationId);
    return username != null && username.isNotEmpty;
  }

  // --- JWT ---

  Future<void> saveJwt(String locationId, String token) async {
    await _storage.write(key: _jwtKey(locationId), value: token);
  }

  Future<String?> getJwt(String locationId) async {
    return await _storage.read(key: _jwtKey(locationId));
  }

  Future<void> deleteJwt(String locationId) async {
    await _storage.delete(key: _jwtKey(locationId));
  }

  // --- Cleanup ---

  Future<void> deleteLocationData(String locationId) async {
    await _storage.delete(key: _usernameKey(locationId));
    await _storage.delete(key: _passwordKey(locationId));
    await _storage.delete(key: _jwtKey(locationId));
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
