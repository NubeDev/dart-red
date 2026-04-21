import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

class LocationStorage {
  static const String _kLocationsKey = 'rubix_locations';
  static const String _kActiveLocationKey = 'rubix_active_location_id';

  final SharedPreferences _prefs;

  LocationStorage(this._prefs);

  Future<List<Location>> getAll() async {
    final String? json = _prefs.getString(_kLocationsKey);
    if (json == null || json.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(json) as List;
      return decoded
          .map((j) => Location.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      await _prefs.remove(_kLocationsKey);
      return [];
    }
  }

  Future<void> save(Location location) async {
    final locations = await getAll();
    final index = locations.indexWhere((l) => l.id == location.id);

    if (index >= 0) {
      locations[index] = location;
    } else {
      locations.add(location);
    }

    await _saveAll(locations);
  }

  Future<void> delete(String locationId) async {
    final locations = await getAll();
    locations.removeWhere((l) => l.id == locationId);
    await _saveAll(locations);

    final activeId = await getActiveLocationId();
    if (activeId == locationId) {
      await _prefs.remove(_kActiveLocationKey);
    }
  }

  Future<Location?> getActiveLocation() async {
    final id = await getActiveLocationId();
    if (id == null) return null;

    final locations = await getAll();
    try {
      return locations.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getActiveLocationId() async {
    return _prefs.getString(_kActiveLocationKey);
  }

  Future<void> setActive(String locationId) async {
    final locations = await getAll();
    final updated = locations.map((l) {
      return l.id == locationId ? l.makeActive() : l.makeInactive();
    }).toList();

    await _saveAll(updated);
    await _prefs.setString(_kActiveLocationKey, locationId);
  }

  Future<void> clear() async {
    await _prefs.remove(_kLocationsKey);
    await _prefs.remove(_kActiveLocationKey);
  }

  Future<void> _saveAll(List<Location> locations) async {
    final encoded = jsonEncode(locations.map((l) => l.toJson()).toList());
    await _prefs.setString(_kLocationsKey, encoded);
  }
}
