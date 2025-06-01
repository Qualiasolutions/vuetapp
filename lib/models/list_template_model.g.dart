// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListTemplateModelImpl _$$ListTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ListTemplateModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      sublists: (json['sublists'] as List<dynamic>?)
              ?.map((e) => ListSublist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      popularity: (json['popularity'] as num?)?.toInt() ?? 0,
      isPremium: json['isPremium'] as bool? ?? false,
      isSystemTemplate: json['isSystemTemplate'] as bool? ?? false,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ListTemplateModelImplToJson(
        _$ListTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'icon': instance.icon,
      'color': instance.color,
      'sublists': instance.sublists,
      'tags': instance.tags,
      'popularity': instance.popularity,
      'isPremium': instance.isPremium,
      'isSystemTemplate': instance.isSystemTemplate,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
