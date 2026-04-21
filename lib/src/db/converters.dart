import 'dart:convert';

import 'package:drift/drift.dart';

import '../schedules/schedule.dart';

/// Stores a `List<String>` as a JSON-encoded text column.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return (jsonDecode(fromDb) as List).cast<String>();
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

/// Stores a [Schedule] as a JSON-encoded text column.
class ScheduleConverter extends TypeConverter<Schedule, String> {
  const ScheduleConverter();

  @override
  Schedule fromSql(String fromDb) =>
      Schedule.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);

  @override
  String toSql(Schedule value) => jsonEncode(value.toJson());
}

/// Stores a `Map<String, dynamic>` as a JSON-encoded text column.
/// Used for widget config and other unstructured JSON blobs.
class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    if (fromDb.isEmpty) return {};
    return jsonDecode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);
}
