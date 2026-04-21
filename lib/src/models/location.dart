import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  const Location._();

  const factory Location({
    required String id,
    required String name,
    required String url,
    required String orgId,
    @Default(false) bool isActive,
    DateTime? lastUsed,
    String? address,
    double? latitude,
    double? longitude,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  factory Location.create({
    required String name,
    required String url,
    required String orgId,
  }) {
    return Location(
      id: const Uuid().v4(),
      name: name,
      url: url,
      orgId: orgId,
    );
  }

  Location withLastUsed() {
    return copyWith(lastUsed: DateTime.now());
  }

  Location makeActive() {
    return copyWith(isActive: true, lastUsed: DateTime.now());
  }

  Location makeInactive() {
    return copyWith(isActive: false);
  }
}
