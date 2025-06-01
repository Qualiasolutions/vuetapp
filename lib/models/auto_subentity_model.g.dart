// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_subentity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AutoSubentityTemplateModelImpl _$$AutoSubentityTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoSubentityTemplateModelImpl(
      id: json['id'] as String,
      parentEntityType: json['parentEntityType'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      priority: (json['priority'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AutoSubentityTemplateModelImplToJson(
        _$AutoSubentityTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentEntityType': instance.parentEntityType,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'color': instance.color,
      'priority': instance.priority,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$AutoSubentityInstanceModelImpl _$$AutoSubentityInstanceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AutoSubentityInstanceModelImpl(
      id: json['id'] as String,
      parentEntityId: json['parentEntityId'] as String,
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      notes: json['notes'] as String?,
      image: json['image'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AutoSubentityInstanceModelImplToJson(
        _$AutoSubentityInstanceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentEntityId': instance.parentEntityId,
      'templateId': instance.templateId,
      'name': instance.name,
      'notes': instance.notes,
      'image': instance.image,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
