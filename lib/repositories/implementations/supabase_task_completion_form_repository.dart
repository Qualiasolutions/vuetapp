import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/task_completion_form_model.dart';
import 'package:vuet_app/repositories/task_completion_form_repository.dart';

part 'supabase_task_completion_form_repository.g.dart';

@riverpod
TaskCompletionFormRepository taskCompletionFormRepository(Ref ref) {
  return SupabaseTaskCompletionFormRepository();
}

/// Supabase implementation of TaskCompletionFormRepository
class SupabaseTaskCompletionFormRepository implements TaskCompletionFormRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  static const String _tableName = 'task_completion_forms';

  /// Get current user ID
  String get _currentUserId {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  @override
  Future<TaskCompletionFormModel> createCompletionForm(TaskCompletionFormModel form) async {
    try {
      final data = form.toJson()
        ..remove('id')
        ..['completed_by_user_id'] = _currentUserId;
      
      final response = await _supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      
      return TaskCompletionFormModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create completion form: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating completion form: $e');
    }
  }

  @override
  Future<List<TaskCompletionFormModel>> getCompletionFormsForTask(String taskId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('task_id', taskId)
          .eq('completed_by_user_id', _currentUserId)
          .order('completion_datetime', ascending: false);
      
      return response.map((json) => TaskCompletionFormModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch completion forms for task: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching completion forms for task: $e');
    }
  }

  @override
  Future<TaskCompletionFormModel?> getCompletionFormById(String id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('completed_by_user_id', _currentUserId)
          .maybeSingle();
      
      return response != null ? TaskCompletionFormModel.fromJson(response) : null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch completion form: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching completion form: $e');
    }
  }

  @override
  Future<TaskCompletionFormModel?> getCompletionFormForTaskOccurrence(
    String taskId, 
    int recurrenceIndex,
  ) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('task_id', taskId)
          .eq('recurrence_index', recurrenceIndex)
          .eq('completed_by_user_id', _currentUserId)
          .maybeSingle();
      
      return response != null ? TaskCompletionFormModel.fromJson(response) : null;
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch completion form for task occurrence: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching completion form for task occurrence: $e');
    }
  }

  @override
  Future<TaskCompletionFormModel> updateCompletionForm(TaskCompletionFormModel form) async {
    try {
      final updateData = form.toJson()
        ..remove('id')
        ..remove('created_at')
        ..remove('completed_by_user_id'); // Don't allow changing user
      
      final response = await _supabase
          .from(_tableName)
          .update(updateData)
          .eq('id', form.id)
          .eq('completed_by_user_id', _currentUserId)
          .select()
          .single();
      
      return TaskCompletionFormModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update completion form: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating completion form: $e');
    }
  }

  @override
  Future<void> deleteCompletionForm(String id) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('completed_by_user_id', _currentUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete completion form: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting completion form: $e');
    }
  }

  @override
  Future<List<TaskCompletionFormModel>> getUserCompletionForms() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('completed_by_user_id', _currentUserId)
          .order('completion_datetime', ascending: false);
      
      return response.map((json) => TaskCompletionFormModel.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch user completion forms: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching user completion forms: $e');
    }
  }

  @override
  Future<bool> isTaskCompleted(String taskId, {int? recurrenceIndex}) async {
    try {
      var query = _supabase
          .from(_tableName)
          .select('id')
          .eq('task_id', taskId)
          .eq('completed_by_user_id', _currentUserId)
          .eq('ignore', false); // Don't count ignored completions
      
      if (recurrenceIndex != null) {
        query = query.eq('recurrence_index', recurrenceIndex);
      }
      
      final response = await query.limit(1);
      return response.isNotEmpty;
    } on PostgrestException catch (e) {
      throw Exception('Failed to check task completion: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error checking task completion: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCompletionStatistics() async {
    try {
      // Get completion counts by type
      final completionCounts = await _supabase
          .from(_tableName)
          .select('completion_type')
          .eq('completed_by_user_id', _currentUserId)
          .gte('completion_datetime', DateTime.now().subtract(const Duration(days: 30)).toIso8601String());
      
      // Calculate statistics
      final stats = <String, int>{};
      for (final completion in completionCounts) {
        final type = completion['completion_type'] as String;
        stats[type] = (stats[type] ?? 0) + 1;
      }
      
      // Get total tasks completed today
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      
      final todayCompletions = await _supabase
          .from(_tableName)
          .select('id')
          .eq('completed_by_user_id', _currentUserId)
          .eq('complete', true)
          .gte('completion_datetime', todayStart.toIso8601String())
          .lt('completion_datetime', todayEnd.toIso8601String());
      
      return {
        'completion_counts': stats,
        'total_completed_today': todayCompletions.length,
        'total_completed_month': stats.values.fold(0, (sum, count) => sum + count),
      };
    } on PostgrestException catch (e) {
      throw Exception('Failed to get completion statistics: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error getting completion statistics: $e');
    }
  }

  @override
  Future<TaskCompletionFormModel> markTaskComplete(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    Map<String, dynamic>? additionalData,
  }) async {
    final completionForm = TaskCompletionFormModel(
      id: '', // Will be generated by database
      taskId: taskId,
      completionDateTime: DateTime.now(),
      recurrenceIndex: recurrenceIndex,
      ignore: false,
      complete: true,
      partial: false,
      completedByUserId: _currentUserId,
      notes: notes,
      rescheduledDate: null,
      completionType: TaskCompletionType.complete,
      additionalData: additionalData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return createCompletionForm(completionForm);
  }

  @override
  Future<TaskCompletionFormModel> markTaskPartiallyComplete(
    String taskId, {
    int? recurrenceIndex,
    String? notes,
    DateTime? rescheduledDate,
    Map<String, dynamic>? additionalData,
  }) async {
    final completionForm = TaskCompletionFormModel(
      id: '', // Will be generated by database
      taskId: taskId,
      completionDateTime: DateTime.now(),
      recurrenceIndex: recurrenceIndex,
      ignore: false,
      complete: false,
      partial: true,
      completedByUserId: _currentUserId,
      notes: notes,
      rescheduledDate: rescheduledDate,
      completionType: TaskCompletionType.partial,
      additionalData: additionalData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return createCompletionForm(completionForm);
  }

  @override
  Future<TaskCompletionFormModel> rescheduleTask(
    String taskId, {
    int? recurrenceIndex,
    required DateTime newDueDate,
    String? reason,
    bool rescheduleRecurring = false,
    RescheduleType rescheduleType = RescheduleType.singleOccurrence,
    Map<String, dynamic>? additionalData,
  }) async {
    final rescheduleData = <String, dynamic>{
      'new_due_date': newDueDate.toIso8601String(),
      'reason': reason,
      'reschedule_recurring': rescheduleRecurring,
      'reschedule_type': rescheduleType.name,
      ...?additionalData,
    };
    
    final completionForm = TaskCompletionFormModel(
      id: '', // Will be generated by database
      taskId: taskId,
      completionDateTime: DateTime.now(),
      recurrenceIndex: recurrenceIndex,
      ignore: true, // Reschedule is treated as ignore for the original
      complete: false,
      partial: false,
      completedByUserId: _currentUserId,
      notes: reason,
      rescheduledDate: newDueDate,
      completionType: TaskCompletionType.reschedule,
      additionalData: rescheduleData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return createCompletionForm(completionForm);
  }

  @override
  Future<TaskCompletionFormModel> skipTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    final completionForm = TaskCompletionFormModel(
      id: '', // Will be generated by database
      taskId: taskId,
      completionDateTime: DateTime.now(),
      recurrenceIndex: recurrenceIndex,
      ignore: true,
      complete: false,
      partial: false,
      completedByUserId: _currentUserId,
      notes: reason,
      rescheduledDate: null,
      completionType: TaskCompletionType.skip,
      additionalData: additionalData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return createCompletionForm(completionForm);
  }

  @override
  Future<TaskCompletionFormModel> cancelTask(
    String taskId, {
    int? recurrenceIndex,
    String? reason,
    Map<String, dynamic>? additionalData,
  }) async {
    final completionForm = TaskCompletionFormModel(
      id: '', // Will be generated by database
      taskId: taskId,
      completionDateTime: DateTime.now(),
      recurrenceIndex: recurrenceIndex,
      ignore: true,
      complete: false,
      partial: false,
      completedByUserId: _currentUserId,
      notes: reason,
      rescheduledDate: null,
      completionType: TaskCompletionType.cancel,
      additionalData: additionalData,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    return createCompletionForm(completionForm);
  }
} 