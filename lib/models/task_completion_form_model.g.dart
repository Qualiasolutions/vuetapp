// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_completion_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskCompletionFormModelImpl _$$TaskCompletionFormModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskCompletionFormModelImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      completionDateTime: DateTime.parse(json['completionDateTime'] as String),
      recurrenceIndex: (json['recurrenceIndex'] as num?)?.toInt(),
      ignore: json['ignore'] as bool? ?? false,
      complete: json['complete'] as bool? ?? true,
      partial: json['partial'] as bool? ?? false,
      completedByUserId: json['completedByUserId'] as String,
      notes: json['notes'] as String?,
      rescheduledDate: json['rescheduledDate'] == null
          ? null
          : DateTime.parse(json['rescheduledDate'] as String),
      completionType: $enumDecodeNullable(
              _$TaskCompletionTypeEnumMap, json['completionType']) ??
          TaskCompletionType.complete,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskCompletionFormModelImplToJson(
        _$TaskCompletionFormModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'completionDateTime': instance.completionDateTime.toIso8601String(),
      'recurrenceIndex': instance.recurrenceIndex,
      'ignore': instance.ignore,
      'complete': instance.complete,
      'partial': instance.partial,
      'completedByUserId': instance.completedByUserId,
      'notes': instance.notes,
      'rescheduledDate': instance.rescheduledDate?.toIso8601String(),
      'completionType': _$TaskCompletionTypeEnumMap[instance.completionType]!,
      'additionalData': instance.additionalData,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskCompletionTypeEnumMap = {
  TaskCompletionType.complete: 'complete',
  TaskCompletionType.reschedule: 'reschedule',
  TaskCompletionType.partial: 'partial',
  TaskCompletionType.skip: 'skip',
  TaskCompletionType.cancel: 'cancel',
};

_$TaskRescheduleModelImpl _$$TaskRescheduleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskRescheduleModelImpl(
      originalDueDate: DateTime.parse(json['originalDueDate'] as String),
      newDueDate: DateTime.parse(json['newDueDate'] as String),
      reason: json['reason'] as String?,
      rescheduleRecurring: json['rescheduleRecurring'] as bool? ?? false,
      rescheduleType: $enumDecodeNullable(
              _$RescheduleTypeEnumMap, json['rescheduleType']) ??
          RescheduleType.singleOccurrence,
    );

Map<String, dynamic> _$$TaskRescheduleModelImplToJson(
        _$TaskRescheduleModelImpl instance) =>
    <String, dynamic>{
      'originalDueDate': instance.originalDueDate.toIso8601String(),
      'newDueDate': instance.newDueDate.toIso8601String(),
      'reason': instance.reason,
      'rescheduleRecurring': instance.rescheduleRecurring,
      'rescheduleType': _$RescheduleTypeEnumMap[instance.rescheduleType]!,
    };

const _$RescheduleTypeEnumMap = {
  RescheduleType.singleOccurrence: 'singleOccurrence',
  RescheduleType.thisAndFuture: 'thisAndFuture',
  RescheduleType.entireSeries: 'entireSeries',
};
