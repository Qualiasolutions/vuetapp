// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReferenceGroupModelImpl _$$ReferenceGroupModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReferenceGroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReferenceGroupModelImplToJson(
        _$ReferenceGroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
