// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntityCategoryModelImpl _$$EntityCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EntityCategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      ownerId: json['owner_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      color: json['color'] as String?,
      priority: (json['priority'] as num?)?.toInt(),
      lastAccessedAt: json['lastAccessedAt'] == null
          ? null
          : DateTime.parse(json['lastAccessedAt'] as String),
      isProfessional: json['is_professional'] as bool? ?? false,
      parentId: json['parentId'] as String?,
      appCategoryId: (json['appCategoryId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EntityCategoryModelImplToJson(
        _$EntityCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'owner_id': instance.ownerId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'color': instance.color,
      'priority': instance.priority,
      'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
      'is_professional': instance.isProfessional,
      'parentId': instance.parentId,
      'appCategoryId': instance.appCategoryId,
    };
