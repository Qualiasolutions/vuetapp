import 'package:vuet_app/models/task_completion_form_model.dart';

/// Abstract repository interface for task completion forms
abstract class TaskCompletionFormRepository {
  /// Create a new task completion form
  Future<TaskCompletionFormModel> createCompletionForm(TaskCompletionFormModel completionForm);
  
  /// Get completion form by ID
  Future<TaskCompletionFormModel?> getCompletionFormById(String id);
  
  /// Get completion forms for a specific task
  Future<List<TaskCompletionFormModel>> getCompletionFormsForTask(String taskId);
  
  /// Get completion forms for a specific task occurrence (for recurring tasks)
  Future<TaskCompletionFormModel?> getCompletionFormForTaskOccurrence(
    String taskId, 
    int recurrenceIndex,
  );
  
  /// Update an existing completion form
  Future<TaskCompletionFormModel> updateCompletionForm(TaskCompletionFormModel completionForm);
  
  /// Delete a completion form
  Future<void> deleteCompletionForm(String id);
  
  /// Check if a task is completed
  Future<bool> isTaskCompleted(String taskId, {int? recurrenceIndex});
  
  /// Get all completion forms for a user
  Future<List<TaskCompletionFormModel>> getUserCompletionForms();
  
  /// Mark task as complete with basic completion
  Future<TaskCompletionFormModel> markTaskComplete(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    Map<String, dynamic>? additionalData,
  });
  
  /// Mark task as partially complete
  Future<TaskCompletionFormModel> markTaskPartiallyComplete(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    DateTime? rescheduledDate,
    Map<String, dynamic>? additionalData,
  });
  
  /// Reschedule a task
  Future<TaskCompletionFormModel> rescheduleTask(
    String taskId, {
    int? recurrenceIndex,
    required DateTime newDueDate,
    String? reason,
    bool rescheduleRecurring = false,
    RescheduleType rescheduleType = RescheduleType.singleOccurrence,
    Map<String, dynamic>? additionalData,
  });
  
  /// Skip/ignore a task occurrence
  Future<TaskCompletionFormModel> skipTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  });
  
  /// Cancel a task
  Future<TaskCompletionFormModel> cancelTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  });
  
  /// Get completion statistics for analytics
  Future<Map<String, dynamic>> getCompletionStatistics();
} 