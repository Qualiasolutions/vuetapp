// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferenceModelImpl _$$ReferenceModelImplFromJson(Map<String, dynamic> json) =>
    _$ReferenceModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      groupId: json['groupId'] as String?,
      value: json['value'] as String?,
      type: json['type'] as String?,
      icon: json['icon'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReferenceModelImplToJson(
        _$ReferenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'groupId': instance.groupId,
      'value': instance.value,
      'type': instance.type,
      'icon': instance.icon,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
