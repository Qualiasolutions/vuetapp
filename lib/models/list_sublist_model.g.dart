// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_sublist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListSublistImpl _$$ListSublistImplFromJson(Map<String, dynamic> json) =>
    _$ListSublistImpl(
      id: json['id'] as String,
      listId: json['listId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completionPercentage:
          (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      completedItems: (json['completedItems'] as num?)?.toInt() ?? 0,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ListItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ListSublistImplToJson(_$ListSublistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'title': instance.title,
      'description': instance.description,
      'sortOrder': instance.sortOrder,
      'isCompleted': instance.isCompleted,
      'completionPercentage': instance.completionPercentage,
      'totalItems': instance.totalItems,
      'completedItems': instance.completedItems,
      'color': instance.color,
      'icon': instance.icon,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'items': instance.items,
      'metadata': instance.metadata,
    };
