// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationImpl _$$LocationImplFromJson(Map<String, dynamic> json) =>
    _$LocationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      orgId: json['orgId'] as String,
      isActive: json['isActive'] as bool? ?? false,
      lastUsed: json['lastUsed'] == null
          ? null
          : DateTime.parse(json['lastUsed'] as String),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LocationImplToJson(_$LocationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'orgId': instance.orgId,
      'isActive': instance.isActive,
      'lastUsed': instance.lastUsed?.toIso8601String(),
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
