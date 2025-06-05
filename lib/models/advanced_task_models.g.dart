// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseTaskImpl _$$BaseTaskImplFromJson(Map<String, dynamic> json) =>
    _$BaseTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      assignedTo: json['assignedTo'] as String?,
      categoryId: json['categoryId'] as String?,
      entityId: json['entityId'] as String?,
      parentTaskId: json['parentTaskId'] as String?,
      routineId: json['routineId'] as String?,
      routineInstanceId: json['routineInstanceId'] as String?,
      isGeneratedFromRoutine: json['isGeneratedFromRoutine'] as bool? ?? false,
      taskType: $enumDecodeNullable(_$TaskTypeEnumMap, json['taskType']),
      taskSubtype: json['taskSubtype'] as String?,
      location: json['location'] as String?,
      typeSpecificData: json['typeSpecificData'] as Map<String, dynamic>?,
      schedulingType:
          $enumDecode(_$TaskSchedulingTypeEnumMap, json['schedulingType']),
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$$BaseTaskImplToJson(_$BaseTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'assignedTo': instance.assignedTo,
      'categoryId': instance.categoryId,
      'entityId': instance.entityId,
      'parentTaskId': instance.parentTaskId,
      'routineId': instance.routineId,
      'routineInstanceId': instance.routineInstanceId,
      'isGeneratedFromRoutine': instance.isGeneratedFromRoutine,
      'taskType': _$TaskTypeEnumMap[instance.taskType],
      'taskSubtype': instance.taskSubtype,
      'location': instance.location,
      'typeSpecificData': instance.typeSpecificData,
      'schedulingType': _$TaskSchedulingTypeEnumMap[instance.schedulingType]!,
      'priority': instance.priority,
      'status': instance.status,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };

const _$TaskTypeEnumMap = {
  TaskType.task: 'task',
  TaskType.appointment: 'appointment',
  TaskType.dueDate: 'dueDate',
  TaskType.activity: 'activity',
  TaskType.transport: 'transport',
  TaskType.accommodation: 'accommodation',
  TaskType.anniversary: 'anniversary',
};

const _$TaskSchedulingTypeEnumMap = {
  TaskSchedulingType.flexible: 'FLEXIBLE',
  TaskSchedulingType.fixed: 'FIXED',
};

_$FlexibleTaskImpl _$$FlexibleTaskImplFromJson(Map<String, dynamic> json) =>
    _$FlexibleTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      assignedTo: json['assignedTo'] as String?,
      categoryId: json['categoryId'] as String?,
      entityId: json['entityId'] as String?,
      parentTaskId: json['parentTaskId'] as String?,
      routineId: json['routineId'] as String?,
      routineInstanceId: json['routineInstanceId'] as String?,
      isGeneratedFromRoutine: json['isGeneratedFromRoutine'] as bool? ?? false,
      taskType: $enumDecodeNullable(_$TaskTypeEnumMap, json['taskType']),
      taskSubtype: json['taskSubtype'] as String?,
      location: json['location'] as String?,
      typeSpecificData: json['typeSpecificData'] as Map<String, dynamic>?,
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      earliestActionDate: json['earliestActionDate'] == null
          ? null
          : DateTime.parse(json['earliestActionDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      duration: (json['duration'] as num).toInt(),
      urgency: $enumDecodeNullable(_$TaskUrgencyEnumMap, json['urgency']) ??
          TaskUrgency.medium,
      scheduledStartTime: json['scheduledStartTime'] == null
          ? null
          : DateTime.parse(json['scheduledStartTime'] as String),
      scheduledEndTime: json['scheduledEndTime'] == null
          ? null
          : DateTime.parse(json['scheduledEndTime'] as String),
      isScheduled: json['isScheduled'] as bool? ?? false,
    );

Map<String, dynamic> _$$FlexibleTaskImplToJson(_$FlexibleTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'assignedTo': instance.assignedTo,
      'categoryId': instance.categoryId,
      'entityId': instance.entityId,
      'parentTaskId': instance.parentTaskId,
      'routineId': instance.routineId,
      'routineInstanceId': instance.routineInstanceId,
      'isGeneratedFromRoutine': instance.isGeneratedFromRoutine,
      'taskType': _$TaskTypeEnumMap[instance.taskType],
      'taskSubtype': instance.taskSubtype,
      'location': instance.location,
      'typeSpecificData': instance.typeSpecificData,
      'priority': instance.priority,
      'status': instance.status,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'earliestActionDate': instance.earliestActionDate?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'duration': instance.duration,
      'urgency': _$TaskUrgencyEnumMap[instance.urgency]!,
      'scheduledStartTime': instance.scheduledStartTime?.toIso8601String(),
      'scheduledEndTime': instance.scheduledEndTime?.toIso8601String(),
      'isScheduled': instance.isScheduled,
    };

const _$TaskUrgencyEnumMap = {
  TaskUrgency.low: 'LOW',
  TaskUrgency.medium: 'MEDIUM',
  TaskUrgency.high: 'HIGH',
  TaskUrgency.urgent: 'URGENT',
};

_$FixedTaskImpl _$$FixedTaskImplFromJson(Map<String, dynamic> json) =>
    _$FixedTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      assignedTo: json['assignedTo'] as String?,
      categoryId: json['categoryId'] as String?,
      entityId: json['entityId'] as String?,
      parentTaskId: json['parentTaskId'] as String?,
      routineId: json['routineId'] as String?,
      routineInstanceId: json['routineInstanceId'] as String?,
      isGeneratedFromRoutine: json['isGeneratedFromRoutine'] as bool? ?? false,
      taskType: $enumDecodeNullable(_$TaskTypeEnumMap, json['taskType']),
      taskSubtype: json['taskSubtype'] as String?,
      location: json['location'] as String?,
      typeSpecificData: json['typeSpecificData'] as Map<String, dynamic>?,
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isRecurring: json['isRecurring'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      startDateTime: json['startDateTime'] == null
          ? null
          : DateTime.parse(json['startDateTime'] as String),
      endDateTime: json['endDateTime'] == null
          ? null
          : DateTime.parse(json['endDateTime'] as String),
      startTimezone: json['startTimezone'] as String?,
      endTimezone: json['endTimezone'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FixedTaskImplToJson(_$FixedTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'userId': instance.userId,
      'assignedTo': instance.assignedTo,
      'categoryId': instance.categoryId,
      'entityId': instance.entityId,
      'parentTaskId': instance.parentTaskId,
      'routineId': instance.routineId,
      'routineInstanceId': instance.routineInstanceId,
      'isGeneratedFromRoutine': instance.isGeneratedFromRoutine,
      'taskType': _$TaskTypeEnumMap[instance.taskType],
      'taskSubtype': instance.taskSubtype,
      'location': instance.location,
      'typeSpecificData': instance.typeSpecificData,
      'priority': instance.priority,
      'status': instance.status,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'isRecurring': instance.isRecurring,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'startDateTime': instance.startDateTime?.toIso8601String(),
      'endDateTime': instance.endDateTime?.toIso8601String(),
      'startTimezone': instance.startTimezone,
      'endTimezone': instance.endTimezone,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration,
    };

_$RecurrenceImpl _$$RecurrenceImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      recurrenceType:
          $enumDecode(_$RecurrenceTypeEnumMap, json['recurrenceType']),
      intervalLength: (json['intervalLength'] as num?)?.toInt() ?? 1,
      earliestOccurrence: json['earliestOccurrence'] == null
          ? null
          : DateTime.parse(json['earliestOccurrence'] as String),
      latestOccurrence: json['latestOccurrence'] == null
          ? null
          : DateTime.parse(json['latestOccurrence'] as String),
      recurrenceData: json['recurrenceData'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RecurrenceImplToJson(_$RecurrenceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'recurrenceType': _$RecurrenceTypeEnumMap[instance.recurrenceType]!,
      'intervalLength': instance.intervalLength,
      'earliestOccurrence': instance.earliestOccurrence?.toIso8601String(),
      'latestOccurrence': instance.latestOccurrence?.toIso8601String(),
      'recurrenceData': instance.recurrenceData,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'DAILY',
  RecurrenceType.weekdaily: 'WEEKDAILY',
  RecurrenceType.weekly: 'WEEKLY',
  RecurrenceType.monthly: 'MONTHLY',
  RecurrenceType.yearly: 'YEARLY',
  RecurrenceType.monthWeekly: 'MONTH_WEEKLY',
  RecurrenceType.yearMonthWeekly: 'YEAR_MONTH_WEEKLY',
  RecurrenceType.monthlyLastWeek: 'MONTHLY_LAST_WEEK',
};

_$TaskActionImpl _$$TaskActionImplFromJson(Map<String, dynamic> json) =>
    _$TaskActionImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      actionTimedelta:
          Duration(microseconds: (json['actionTimedelta'] as num).toInt()),
      description: json['description'] as String?,
      actionType: json['actionType'] as String?,
      actionData: json['actionData'] as Map<String, dynamic>?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      lastExecuted: json['lastExecuted'] == null
          ? null
          : DateTime.parse(json['lastExecuted'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskActionImplToJson(_$TaskActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'actionTimedelta': instance.actionTimedelta.inMicroseconds,
      'description': instance.description,
      'actionType': instance.actionType,
      'actionData': instance.actionData,
      'isEnabled': instance.isEnabled,
      'lastExecuted': instance.lastExecuted?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TaskReminderImpl _$$TaskReminderImplFromJson(Map<String, dynamic> json) =>
    _$TaskReminderImpl(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      timedelta: Duration(microseconds: (json['timedelta'] as num).toInt()),
      reminderType: json['reminderType'] as String? ?? 'default',
      message: json['message'] as String?,
      isEnabled: json['isEnabled'] as bool? ?? true,
      lastSent: json['lastSent'] == null
          ? null
          : DateTime.parse(json['lastSent'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$TaskReminderImplToJson(_$TaskReminderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'timedelta': instance.timedelta.inMicroseconds,
      'reminderType': instance.reminderType,
      'message': instance.message,
      'isEnabled': instance.isEnabled,
      'lastSent': instance.lastSent?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$TaskEntityImpl _$$TaskEntityImplFromJson(Map<String, dynamic> json) =>
    _$TaskEntityImpl(
      taskId: json['taskId'] as String,
      entityId: json['entityId'] as String,
      relationshipType: json['relationshipType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TaskEntityImplToJson(_$TaskEntityImpl instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'entityId': instance.entityId,
      'relationshipType': instance.relationshipType,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$AdvancedFlexibleTaskImpl _$$AdvancedFlexibleTaskImplFromJson(
        Map<String, dynamic> json) =>
    _$AdvancedFlexibleTaskImpl(
      FlexibleTask.fromJson(json['task'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AdvancedFlexibleTaskImplToJson(
        _$AdvancedFlexibleTaskImpl instance) =>
    <String, dynamic>{
      'task': instance.task,
      'runtimeType': instance.$type,
    };

_$AdvancedFixedTaskImpl _$$AdvancedFixedTaskImplFromJson(
        Map<String, dynamic> json) =>
    _$AdvancedFixedTaskImpl(
      FixedTask.fromJson(json['task'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AdvancedFixedTaskImplToJson(
        _$AdvancedFixedTaskImpl instance) =>
    <String, dynamic>{
      'task': instance.task,
      'runtimeType': instance.$type,
    };
