import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required String token,
    required String userId,
    required String orgId,
    String? deviceId,
    String? teamId,
    required String role,
    Map<String, String>? logoUrls,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  factory Session.fromLoginResponse(Map<String, dynamic> data) {
    return Session(
      token: data['token'] as String,
      userId: data['userId'] as String,
      orgId: data['orgId'] as String,
      deviceId: data['deviceId'] as String?,
      teamId: data['teamId'] as String?,
      role: (data['role'] as String?) ?? 'operator',
      logoUrls: data['logoUrls'] != null
          ? Map<String, String>.from(data['logoUrls'] as Map)
          : null,
    );
  }
}
