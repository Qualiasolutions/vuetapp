// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ListItemModelImpl _$$ListItemModelImplFromJson(Map<String, dynamic> json) =>
    _$ListItemModelImpl(
      id: json['id'] as String,
      listId: json['listId'] as String,
      sublistId: json['sublistId'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      linkedTaskId: json['linkedTaskId'] as String?,
      isConvertedFromTask: json['isConvertedFromTask'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble(),
      storeId: json['storeId'] as String?,
      brand: json['brand'] as String?,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ListItemModelImplToJson(_$ListItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'listId': instance.listId,
      'sublistId': instance.sublistId,
      'name': instance.name,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'quantity': instance.quantity,
      'sortOrder': instance.sortOrder,
      'linkedTaskId': instance.linkedTaskId,
      'isConvertedFromTask': instance.isConvertedFromTask,
      'price': instance.price,
      'storeId': instance.storeId,
      'brand': instance.brand,
      'notes': instance.notes,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
