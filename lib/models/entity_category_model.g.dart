// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntityCategoryImpl _$$EntityCategoryImplFromJson(Map<String, dynamic> json) =>
    _$EntityCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      iconName: json['iconName'] as String?,
      colorHex: json['colorHex'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isDisplayedOnGrid: json['isDisplayedOnGrid'] as bool? ?? true,
      appCategoryIntId: (json['appCategoryIntId'] as num?)?.toInt(),
      parentId: json['parentId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EntityCategoryImplToJson(
        _$EntityCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'sortOrder': instance.sortOrder,
      'isDisplayedOnGrid': instance.isDisplayedOnGrid,
      'appCategoryIntId': instance.appCategoryIntId,
      'parentId': instance.parentId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
