// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_reference_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntityReferenceModelImpl _$$EntityReferenceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EntityReferenceModelImpl(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      referenceId: json['referenceId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$EntityReferenceModelImplToJson(
        _$EntityReferenceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'referenceId': instance.referenceId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
