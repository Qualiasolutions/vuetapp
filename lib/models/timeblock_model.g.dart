// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeblock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimeblockModelImpl _$$TimeblockModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeblockModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String?,
      dayOfWeek: (json['dayOfWeek'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      color: json['color'] as String?,
      description: json['description'] as String?,
      activityType: json['activityType'] as String?,
      linkedRoutineId: json['linkedRoutineId'] as String?,
      linkedTaskId: json['linkedTaskId'] as String?,
      syncWithCalendar: json['syncWithCalendar'] as bool? ?? false,
      externalCalendarEventId: json['externalCalendarEventId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TimeblockModelImplToJson(
        _$TimeblockModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'color': instance.color,
      'description': instance.description,
      'activityType': instance.activityType,
      'linkedRoutineId': instance.linkedRoutineId,
      'linkedTaskId': instance.linkedTaskId,
      'syncWithCalendar': instance.syncWithCalendar,
      'externalCalendarEventId': instance.externalCalendarEventId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
