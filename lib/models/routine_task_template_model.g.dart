// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_task_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoutineTaskTemplateModelImpl _$$RoutineTaskTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RoutineTaskTemplateModelImpl(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt(),
      categoryId: json['categoryId'] as String?,
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      orderInRoutine: (json['orderInRoutine'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RoutineTaskTemplateModelImplToJson(
        _$RoutineTaskTemplateModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routineId': instance.routineId,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'estimatedDurationMinutes': instance.estimatedDurationMinutes,
      'categoryId': instance.categoryId,
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'orderInRoutine': instance.orderInRoutine,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};
