import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vuet_app/models/task_type_enums.dart';

part 'advanced_task_models.freezed.dart';
part 'advanced_task_models.g.dart';

/// Task scheduling type to distinguish between flexible and fixed tasks
enum TaskSchedulingType {
  /// FlexibleTask: Duration-based scheduling with earliest/due dates
  @JsonValue('FLEXIBLE')
  flexible,
  
  /// FixedTask: Time-specific scheduling with start/end times
  @JsonValue('FIXED')
  fixed,
}

/// Task urgency levels for flexible task prioritization
enum TaskUrgency {
  @JsonValue('LOW')
  low,
  
  @JsonValue('MEDIUM')
  medium,
  
  @JsonValue('HIGH')
  high,
  
  @JsonValue('URGENT')
  urgent,
}

/// Enhanced recurrence types matching React app implementation
enum RecurrenceType {
  @JsonValue('DAILY')
  daily,
  
  @JsonValue('WEEKDAILY')
  weekdaily,
  
  @JsonValue('WEEKLY')
  weekly,
  
  @JsonValue('MONTHLY')
  monthly,
  
  @JsonValue('YEARLY')
  yearly,
  
  @JsonValue('MONTH_WEEKLY')
  monthWeekly,
  
  @JsonValue('YEAR_MONTH_WEEKLY')
  yearMonthWeekly,
  
  @JsonValue('MONTHLY_LAST_WEEK')
  monthlyLastWeek,
}

/// Base task model with common fields
@freezed
class BaseTask with _$BaseTask {
  const factory BaseTask({
    required String id,
    required String title,
    String? description,
    required String userId,
    String? assignedTo,
    String? categoryId,
    String? entityId,
    String? parentTaskId,
    String? routineId,
    String? routineInstanceId,
    @Default(false) bool isGeneratedFromRoutine,
    TaskType? taskType,
    String? taskSubtype,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    required TaskSchedulingType schedulingType,
    @Default('medium') String priority,
    @Default('pending') String status,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(false) bool isRecurring,
    List<String>? tags,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _BaseTask;

  factory BaseTask.fromJson(Map<String, dynamic> json) => _$BaseTaskFromJson(json);
}

/// FlexibleTask: Duration-based scheduling with earliest/due dates
@freezed
class FlexibleTask with _$FlexibleTask {
  const factory FlexibleTask({
    /// Base task fields
    required String id,
    required String title,
    String? description,
    required String userId,
    String? assignedTo,
    String? categoryId,
    String? entityId,
    String? parentTaskId,
    String? routineId,
    String? routineInstanceId,
    @Default(false) bool isGeneratedFromRoutine,
    TaskType? taskType,
    String? taskSubtype,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    @Default('medium') String priority,
    @Default('pending') String status,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(false) bool isRecurring,
    List<String>? tags,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    
    /// FlexibleTask-specific fields
    DateTime? earliestActionDate,
    DateTime? dueDate,
    required int duration, // Duration in minutes
    @Default(TaskUrgency.medium) TaskUrgency urgency,
    
    /// Scheduling metadata
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    @Default(false) bool isScheduled,
  }) = _FlexibleTask;

  factory FlexibleTask.fromJson(Map<String, dynamic> json) => _$FlexibleTaskFromJson(json);
}

/// FixedTask: Time-specific scheduling with start/end times
@freezed
class FixedTask with _$FixedTask {
  const factory FixedTask({
    /// Base task fields
    required String id,
    required String title,
    String? description,
    required String userId,
    String? assignedTo,
    String? categoryId,
    String? entityId,
    String? parentTaskId,
    String? routineId,
    String? routineInstanceId,
    @Default(false) bool isGeneratedFromRoutine,
    TaskType? taskType,
    String? taskSubtype,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    @Default('medium') String priority,
    @Default('pending') String status,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    @Default(false) bool isRecurring,
    List<String>? tags,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
    
    /// FixedTask-specific fields
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? startTimezone,
    String? endTimezone,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? date,
    int? duration, // Duration in minutes (calculated or manual)
  }) = _FixedTask;

  factory FixedTask.fromJson(Map<String, dynamic> json) => _$FixedTaskFromJson(json);
}

/// Recurrence pattern model
@freezed
class Recurrence with _$Recurrence {
  const factory Recurrence({
    required String id,
    required String taskId,
    required RecurrenceType recurrenceType,
    @Default(1) int intervalLength,
    DateTime? earliestOccurrence,
    DateTime? latestOccurrence,
    Map<String, dynamic>? recurrenceData, // Additional recurrence configuration
    @Default(true) bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Recurrence;

  factory Recurrence.fromJson(Map<String, dynamic> json) => _$RecurrenceFromJson(json);
}

/// Task action model for automated pre-task actions
@freezed
class TaskAction with _$TaskAction {
  const factory TaskAction({
    required String id,
    required String taskId,
    required Duration actionTimedelta, // Time before task to execute action
    String? description,
    String? actionType, // 'reminder', 'notification', 'preparation', etc.
    Map<String, dynamic>? actionData,
    @Default(true) bool isEnabled,
    DateTime? lastExecuted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskAction;

  factory TaskAction.fromJson(Map<String, dynamic> json) => _$TaskActionFromJson(json);
}

/// Task reminder model
@freezed
class TaskReminder with _$TaskReminder {
  const factory TaskReminder({
    required String id,
    required String taskId,
    required Duration timedelta, // Time before task to send reminder
    @Default('default') String reminderType, // 'default', 'email', 'push', 'sms'
    String? message,
    @Default(true) bool isEnabled,
    DateTime? lastSent,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskReminder;

  factory TaskReminder.fromJson(Map<String, dynamic> json) => _$TaskReminderFromJson(json);
}

/// Task-Entity relationship model
@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String taskId,
    required String entityId,
    String? relationshipType, // 'primary', 'secondary', 'related'
    required DateTime createdAt,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) => _$TaskEntityFromJson(json);
}

/// Union type for handling both flexible and fixed tasks
@freezed
class AdvancedTask with _$AdvancedTask {
  const factory AdvancedTask.flexible(FlexibleTask task) = AdvancedFlexibleTask;
  const factory AdvancedTask.fixed(FixedTask task) = AdvancedFixedTask;

  factory AdvancedTask.fromJson(Map<String, dynamic> json) => _$AdvancedTaskFromJson(json);
}

/// Extensions for convenience
extension FlexibleTaskExtensions on FlexibleTask {
  /// Convert to BaseTask for common operations
  BaseTask toBaseTask() => BaseTask(
    id: id,
    title: title,
    description: description,
    userId: userId,
    assignedTo: assignedTo,
    categoryId: categoryId,
    entityId: entityId,
    parentTaskId: parentTaskId,
    routineId: routineId,
    routineInstanceId: routineInstanceId,
    isGeneratedFromRoutine: isGeneratedFromRoutine,
    taskType: taskType,
    taskSubtype: taskSubtype,
    location: location,
    typeSpecificData: typeSpecificData,
    schedulingType: TaskSchedulingType.flexible,
    priority: priority,
    status: status,
    isCompleted: isCompleted,
    completedAt: completedAt,
    isRecurring: isRecurring,
    tags: tags,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );

  /// Check if task has valid scheduling window
  bool get hasValidSchedulingWindow {
    final now = DateTime.now();
    final earliest = earliestActionDate;
    final due = dueDate;
    
    if (earliest != null && due != null) {
      return earliest.isBefore(due) && due.isAfter(now);
    }
    return true;
  }

  /// Get remaining time until due date
  Duration? get timeUntilDue {
    if (dueDate == null) return null;
    final now = DateTime.now();
    return dueDate!.isAfter(now) ? dueDate!.difference(now) : Duration.zero;
  }

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}

extension FixedTaskExtensions on FixedTask {
  /// Convert to BaseTask for common operations
  BaseTask toBaseTask() => BaseTask(
    id: id,
    title: title,
    description: description,
    userId: userId,
    assignedTo: assignedTo,
    categoryId: categoryId,
    entityId: entityId,
    parentTaskId: parentTaskId,
    routineId: routineId,
    routineInstanceId: routineInstanceId,
    isGeneratedFromRoutine: isGeneratedFromRoutine,
    taskType: taskType,
    taskSubtype: taskSubtype,
    location: location,
    typeSpecificData: typeSpecificData,
    schedulingType: TaskSchedulingType.fixed,
    priority: priority,
    status: status,
    isCompleted: isCompleted,
    completedAt: completedAt,
    isRecurring: isRecurring,
    tags: tags,
    createdAt: createdAt,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );

  /// Get calculated duration from start/end times
  int? get calculatedDuration {
    if (startDateTime != null && endDateTime != null) {
      return endDateTime!.difference(startDateTime!).inMinutes;
    }
    return duration;
  }

  /// Check if task has time conflict with another fixed task
  bool hasConflictWith(FixedTask other) {
    final thisStart = startDateTime;
    final thisEnd = endDateTime;
    final otherStart = other.startDateTime;
    final otherEnd = other.endDateTime;

    if (thisStart == null || thisEnd == null || 
        otherStart == null || otherEnd == null) {
      return false;
    }

    return thisStart.isBefore(otherEnd) && thisEnd.isAfter(otherStart);
  }

  /// Check if task is currently active
  bool get isActive {
    final now = DateTime.now();
    if (startDateTime != null && endDateTime != null) {
      return now.isAfter(startDateTime!) && now.isBefore(endDateTime!);
    }
    return false;
  }

  /// Check if task is upcoming (starts within next hour)
  bool get isUpcoming {
    if (startDateTime == null) return false;
    final now = DateTime.now();
    final oneHourFromNow = now.add(Duration(hours: 1));
    return startDateTime!.isAfter(now) && startDateTime!.isBefore(oneHourFromNow);
  }
}

extension TaskUrgencyExtensions on TaskUrgency {
  /// Get numeric priority value for sorting
  int get priorityValue {
    switch (this) {
      case TaskUrgency.low:
        return 1;
      case TaskUrgency.medium:
        return 2;
      case TaskUrgency.high:
        return 3;
      case TaskUrgency.urgent:
        return 4;
    }
  }

  /// Get color representation for UI
  String get colorCode {
    switch (this) {
      case TaskUrgency.low:
        return '#4CAF50'; // Green
      case TaskUrgency.medium:
        return '#FF9800'; // Orange
      case TaskUrgency.high:
        return '#F44336'; // Red
      case TaskUrgency.urgent:
        return '#9C27B0'; // Purple
    }
  }
}

extension RecurrenceTypeExtensions on RecurrenceType {
  /// Get human-readable description
  String get description {
    switch (this) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekdaily:
        return 'Weekdays (Mon-Fri)';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.yearly:
        return 'Yearly';
      case RecurrenceType.monthWeekly:
        return 'Monthly on same weekday';
      case RecurrenceType.yearMonthWeekly:
        return 'Yearly on same month and weekday';
      case RecurrenceType.monthlyLastWeek:
        return 'Monthly on last week';
    }
  }

  /// Check if recurrence type requires specific day configuration
  bool get requiresDayConfiguration {
    switch (this) {
      case RecurrenceType.weekly:
      case RecurrenceType.monthWeekly:
      case RecurrenceType.yearMonthWeekly:
      case RecurrenceType.monthlyLastWeek:
        return true;
      default:
        return false;
    }
  }
}
