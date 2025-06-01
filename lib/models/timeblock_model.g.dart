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

_$RoutineModelImpl _$$RoutineModelImplFromJson(Map<String, dynamic> json) =>
    _$RoutineModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
      monday: json['monday'] as bool? ?? false,
      tuesday: json['tuesday'] as bool? ?? false,
      wednesday: json['wednesday'] as bool? ?? false,
      thursday: json['thursday'] as bool? ?? false,
      friday: json['friday'] as bool? ?? false,
      saturday: json['saturday'] as bool? ?? false,
      sunday: json['sunday'] as bool? ?? false,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RoutineModelImplToJson(_$RoutineModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'color': instance.color,
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
