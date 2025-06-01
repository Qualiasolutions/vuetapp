import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_completion_form_model.freezed.dart';
part 'task_completion_form_model.g.dart';

/// Task completion form model based on the Django backend implementation
/// A task is complete if and only if there is an associated TaskCompletionForm
@freezed
class TaskCompletionFormModel with _$TaskCompletionFormModel {
  const factory TaskCompletionFormModel({
    /// Unique identifier for the completion form
    required String id,
    
    /// ID of the task this completion form is for
    required String taskId,
    
    /// When the completion was recorded
    required DateTime completionDateTime,
    
    /// Recurrence index for recurring tasks (null for non-recurring)
    int? recurrenceIndex,
    
    /// Whether to ignore this completion (for rescheduling)
    @Default(false) bool ignore,
    
    /// Whether the task is fully complete
    @Default(true) bool complete,
    
    /// Whether this is a partial completion
    @Default(false) bool partial,
    
    /// User who completed the task
    required String completedByUserId,
    
    /// Optional notes about the completion
    String? notes,
    
    /// Optional rescheduled date (if task was rescheduled instead of completed)
    DateTime? rescheduledDate,
    
    /// Type of completion (complete, reschedule, partial, etc.)
    @Default(TaskCompletionType.complete) TaskCompletionType completionType,
    
    /// Additional completion data (for specialized completion forms)
    Map<String, dynamic>? additionalData,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    required DateTime updatedAt,
  }) = _TaskCompletionFormModel;

  factory TaskCompletionFormModel.fromJson(Map<String, dynamic> json) =>
      _$TaskCompletionFormModelFromJson(json);
}

/// Enum for different types of task completion
enum TaskCompletionType {
  /// Task was fully completed
  complete,
  
  /// Task was rescheduled to a new date
  reschedule,
  
  /// Task was partially completed
  partial,
  
  /// Task was skipped/ignored
  skip,
  
  /// Task was cancelled
  cancel,
}

/// Model for task reschedule data
@freezed
class TaskRescheduleModel with _$TaskRescheduleModel {
  const factory TaskRescheduleModel({
    /// Original due date
    required DateTime originalDueDate,
    
    /// New due date
    required DateTime newDueDate,
    
    /// Reason for rescheduling
    String? reason,
    
    /// Whether to reschedule future recurrences
    @Default(false) bool rescheduleRecurring,
    
    /// Type of reschedule (specific occurrence vs entire task)
    @Default(RescheduleType.singleOccurrence) RescheduleType rescheduleType,
  }) = _TaskRescheduleModel;

  factory TaskRescheduleModel.fromJson(Map<String, dynamic> json) =>
      _$TaskRescheduleModelFromJson(json);
}

/// Enum for different types of rescheduling
enum RescheduleType {
  /// Reschedule only this specific occurrence
  singleOccurrence,
  
  /// Reschedule this and all future occurrences
  thisAndFuture,
  
  /// Reschedule the entire task series
  entireSeries,
} 