import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Generic local storage wrapper around SharedPreferences for lists of
/// JSON-serializable objects. Provides CRUD operations matched by a
/// caller-supplied ID extractor.
class LocalCollection<T> {
  final String _key;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;
  final String Function(T) _getId;
  final SharedPreferences _prefs;

  LocalCollection({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
    required String Function(T) getId,
    required SharedPreferences prefs,
  })  : _key = key,
        _fromJson = fromJson,
        _toJson = toJson,
        _getId = getId,
        _prefs = prefs;

  /// Returns all items. Items that fail deserialization are skipped (not nuked).
  List<T> getAll() {
    final String? raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List;
      final List<T> results = [];
      for (final item in decoded) {
        try {
          results.add(_fromJson(item as Map<String, dynamic>));
        } catch (e) {
          debugPrint('LocalCollection[$_key]: skipped corrupt item — $e');
        }
      }
      return results;
    } catch (e) {
      debugPrint('LocalCollection[$_key]: failed to decode list — $e');
      return [];
    }
  }

  /// Returns a single item by ID, or null if not found.
  T? getById(String id) {
    final items = getAll();
    try {
      return items.firstWhere((item) => _getId(item) == id);
    } catch (_) {
      return null;
    }
  }

  /// Insert or update an item (matched by ID).
  Future<void> save(T item) async {
    final items = getAll();
    final id = _getId(item);
    final index = items.indexWhere((existing) => _getId(existing) == id);

    if (index >= 0) {
      items[index] = item;
    } else {
      items.add(item);
    }

    await _persist(items);
  }

  /// Delete an item by ID.
  Future<void> delete(String id) async {
    final items = getAll();
    items.removeWhere((item) => _getId(item) == id);
    await _persist(items);
  }

  /// Bulk-replace the entire collection.
  Future<void> saveAll(List<T> items) async {
    await _persist(items);
  }

  /// Remove all items.
  Future<void> clear() async {
    await _prefs.remove(_key);
  }

  Future<void> _persist(List<T> items) async {
    final encoded = jsonEncode(items.map(_toJson).toList());
    await _prefs.setString(_key, encoded);
  }
}
