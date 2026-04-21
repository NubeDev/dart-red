import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@freezed
class Tag with _$Tag {
  const Tag._();

  const factory Tag({
    required String id,
    required String name,
    String? color,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  factory Tag.create({
    required String name,
    String? color,
  }) {
    return Tag(
      id: const Uuid().v4(),
      name: name,
      color: color,
    );
  }
}
