// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_subcategory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntitySubcategoryModelImpl _$$EntitySubcategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EntitySubcategoryModelImpl(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      displayName: json['display_name'] as String,
      icon: json['icon'] as String?,
      tagName: json['tag_name'] as String?,
      color: json['color'] as String?,
      entityTypeIds: (json['entity_types'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$EntitySubcategoryModelImplToJson(
        _$EntitySubcategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'display_name': instance.displayName,
      'icon': instance.icon,
      'tag_name': instance.tagName,
      'color': instance.color,
      'entity_types': instance.entityTypeIds,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
