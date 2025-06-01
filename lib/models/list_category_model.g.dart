// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListCategoryModelImpl _$$ListCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ListCategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      description: json['description'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      isCustom: json['isCustom'] as bool? ?? false,
      suggestedTemplates: (json['suggestedTemplates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ListCategoryModelImplToJson(
        _$ListCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'color': instance.color,
      'description': instance.description,
      'order': instance.order,
      'isActive': instance.isActive,
      'isCustom': instance.isCustom,
      'suggestedTemplates': instance.suggestedTemplates,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
