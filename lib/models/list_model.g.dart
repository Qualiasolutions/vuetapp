// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListModelImpl _$$ListModelImplFromJson(Map<String, dynamic> json) =>
    _$ListModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: json['ownerId'] as String,
      userId: json['userId'] as String,
      familyId: json['familyId'] as String?,
      sharedWith: (json['sharedWith'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sublists: (json['sublists'] as List<dynamic>?)
              ?.map((e) => ListSublist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isTemplate: json['isTemplate'] as bool? ?? false,
      templateCategory: json['templateCategory'] as String?,
      isShoppingList: json['isShoppingList'] as bool? ?? false,
      shoppingStoreId: json['shoppingStoreId'] as String?,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      completedItems: (json['completedItems'] as num?)?.toInt() ?? 0,
      isArchived: json['isArchived'] as bool? ?? false,
      isDelegated: json['isDelegated'] as bool? ?? false,
      delegatedTo: json['delegatedTo'] as String?,
      delegatedAt: json['delegatedAt'] == null
          ? null
          : DateTime.parse(json['delegatedAt'] as String),
      delegationNote: json['delegationNote'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastAccessedAt: json['lastAccessedAt'] == null
          ? null
          : DateTime.parse(json['lastAccessedAt'] as String),
      listCategoryId: json['listCategoryId'] as String?,
      templateId: json['templateId'] as String?,
      createdFromTemplate: json['createdFromTemplate'] as bool? ?? false,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      listType: json['listType'] as String?,
      visibility: json['visibility'] as String? ?? 'private',
      isFavorite: json['isFavorite'] as bool? ?? false,
      reminderSettings:
          json['reminderSettings'] as Map<String, dynamic>? ?? const {},
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      categoryId: json['categoryId'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$ListModelImplToJson(_$ListModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'userId': instance.userId,
      'familyId': instance.familyId,
      'sharedWith': instance.sharedWith,
      'sublists': instance.sublists,
      'isTemplate': instance.isTemplate,
      'templateCategory': instance.templateCategory,
      'isShoppingList': instance.isShoppingList,
      'shoppingStoreId': instance.shoppingStoreId,
      'totalItems': instance.totalItems,
      'completedItems': instance.completedItems,
      'isArchived': instance.isArchived,
      'isDelegated': instance.isDelegated,
      'delegatedTo': instance.delegatedTo,
      'delegatedAt': instance.delegatedAt?.toIso8601String(),
      'delegationNote': instance.delegationNote,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lastAccessedAt': instance.lastAccessedAt?.toIso8601String(),
      'listCategoryId': instance.listCategoryId,
      'templateId': instance.templateId,
      'createdFromTemplate': instance.createdFromTemplate,
      'completionPercentage': instance.completionPercentage,
      'listType': instance.listType,
      'visibility': instance.visibility,
      'isFavorite': instance.isFavorite,
      'reminderSettings': instance.reminderSettings,
      'settings': instance.settings,
      'categoryId': instance.categoryId,
      'type': instance.type,
    };
