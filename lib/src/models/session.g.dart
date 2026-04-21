// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      token: json['token'] as String,
      userId: json['userId'] as String,
      orgId: json['orgId'] as String,
      deviceId: json['deviceId'] as String?,
      teamId: json['teamId'] as String?,
      role: json['role'] as String,
      logoUrls: (json['logoUrls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'orgId': instance.orgId,
      'deviceId': instance.deviceId,
      'teamId': instance.teamId,
      'role': instance.role,
      'logoUrls': instance.logoUrls,
    };
