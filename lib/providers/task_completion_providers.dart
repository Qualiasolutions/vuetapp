import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_completion_form_model.dart';
import 'package:vuet_app/repositories/task_completion_form_repository.dart';
import 'package:vuet_app/repositories/implementations/supabase_task_completion_form_repository.dart';

part 'task_completion_providers.g.dart';

/// Provider for task completion form repository
@riverpod
TaskCompletionFormRepository taskCompletionFormRepository(Ref ref) {
  return SupabaseTaskCompletionFormRepository();
}

/// Provider for completion forms for a specific task
@riverpod
Future<List<TaskCompletionFormModel>> taskCompletionForms(
  Ref ref,
  String taskId,
) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.getCompletionFormsForTask(taskId);
}

/// Provider for a specific completion form by ID
@riverpod
Future<TaskCompletionFormModel?> completionFormById(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.getCompletionFormById(id);
}

/// Provider for completion form for a specific task occurrence
@riverpod
Future<TaskCompletionFormModel?> taskOccurrenceCompletion(
  Ref ref,
  String taskId,
  int recurrenceIndex,
) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.getCompletionFormForTaskOccurrence(taskId, recurrenceIndex);
}

/// Provider to check if a task is completed
@riverpod
Future<bool> isTaskCompleted(
  Ref ref,
  String taskId, {
  int? recurrenceIndex,
}) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.isTaskCompleted(taskId, recurrenceIndex: recurrenceIndex);
}

/// Provider for all user completion forms
@riverpod
Future<List<TaskCompletionFormModel>> userCompletionForms(Ref ref) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.getUserCompletionForms();
}

/// Provider for completion statistics
@riverpod
Future<Map<String, dynamic>> completionStatistics(Ref ref) async {
  final repository = ref.watch(taskCompletionFormRepositoryProvider);
  return repository.getCompletionStatistics();
}

/// Provider for completing a task
@riverpod
class TaskCompleter extends _$TaskCompleter {
  @override
  AsyncValue<TaskCompletionFormModel?> build() {
    return const AsyncValue.data(null);
  }

  /// Mark task as complete
  Future<void> completeTask(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.markTaskComplete(
        taskId,
        recurrenceIndex: recurrenceIndex,
        notes: notes,
        additionalData: additionalData,
      );
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(isTaskCompletedProvider(taskId, recurrenceIndex: recurrenceIndex));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Mark task as partially complete
  Future<void> partiallyCompleteTask(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    DateTime? rescheduledDate,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.markTaskPartiallyComplete(
        taskId,
        recurrenceIndex: recurrenceIndex,
        notes: notes,
        rescheduledDate: rescheduledDate,
        additionalData: additionalData,
      );
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(isTaskCompletedProvider(taskId, recurrenceIndex: recurrenceIndex));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reschedule a task
  Future<void> rescheduleTask(
    String taskId, {
    int? recurrenceIndex,
    required DateTime newDueDate,
    String? reason,
    bool rescheduleRecurring = false,
    RescheduleType rescheduleType = RescheduleType.singleOccurrence,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.rescheduleTask(
        taskId,
        recurrenceIndex: recurrenceIndex,
        newDueDate: newDueDate,
        reason: reason,
        rescheduleRecurring: rescheduleRecurring,
        rescheduleType: rescheduleType,
        additionalData: additionalData,
      );
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(isTaskCompletedProvider(taskId, recurrenceIndex: recurrenceIndex));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Skip a task
  Future<void> skipTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.skipTask(
        taskId,
        recurrenceIndex: recurrenceIndex,
        reason: reason,
        additionalData: additionalData,
      );
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(isTaskCompletedProvider(taskId, recurrenceIndex: recurrenceIndex));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Cancel a task
  Future<void> cancelTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.cancelTask(
        taskId,
        recurrenceIndex: recurrenceIndex,
        reason: reason,
        additionalData: additionalData,
      );
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(isTaskCompletedProvider(taskId, recurrenceIndex: recurrenceIndex));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider for managing completion form operations
@riverpod
class CompletionFormManager extends _$CompletionFormManager {
  @override
  AsyncValue<TaskCompletionFormModel?> build() {
    return const AsyncValue.data(null);
  }

  /// Create a new completion form
  Future<void> createCompletionForm(TaskCompletionFormModel completionForm) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.createCompletionForm(completionForm);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(completionForm.taskId));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an existing completion form
  Future<void> updateCompletionForm(TaskCompletionFormModel completionForm) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      final result = await repository.updateCompletionForm(completionForm);
      
      state = AsyncValue.data(result);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(completionForm.taskId));
      ref.invalidate(completionFormByIdProvider(completionForm.id));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete a completion form
  Future<void> deleteCompletionForm(String id, String taskId) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(taskCompletionFormRepositoryProvider);
      await repository.deleteCompletionForm(id);
      
      state = const AsyncValue.data(null);
      
      // Invalidate related providers
      ref.invalidate(taskCompletionFormsProvider(taskId));
      ref.invalidate(completionFormByIdProvider(id));
      ref.invalidate(userCompletionFormsProvider);
      ref.invalidate(completionStatisticsProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 