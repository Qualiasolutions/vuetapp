import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/repositories/task_repository.dart';
import 'package:vuet_app/services/auth_service.dart';

/// Supabase implementation of the TaskRepository interface
class SupabaseTaskRepository implements TaskRepository {
  /// Supabase client instance
  final SupabaseClient _client;
  final AuthService _authService;
  
  /// Constructor
  SupabaseTaskRepository({SupabaseClient? client, required AuthService authService}) 
    : _client = client ?? SupabaseConfig.client,
      _authService = authService;
  
  /// Table name for tasks
  static const String _tasksTable = 'tasks';
  
  /// Table name for task sharing
  static const String _taskSharingTable = 'task_sharing';
  
  /// Get all tasks
  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks: $e');
      return [];
    }
  }
  
  /// Get task by ID
  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return TaskModel.fromJson(response);
    } catch (e) {
      debugPrint('Failed to get task by ID: $e');
      return null;
    }
  }
  
  /// Create a new task
  @override
  Future<String> createTask(TaskModel task) async {
    try {
      await _client
          .from(_tasksTable)
          .insert(task.toJson());
      
      return task.id;
    } catch (e) {
      debugPrint('Failed to create task: $e');
      rethrow;
    }
  }
  
  /// Update an existing task
  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await _client
          .from(_tasksTable)
          .update(task.toJson())
          .eq('id', task.id);
    } catch (e) {
      debugPrint('Failed to update task: $e');
      rethrow;
    }
  }
  
  /// Delete a task
  @override
  Future<void> deleteTask(String id) async {
    try {
      await _client
          .from(_tasksTable)
          .delete()
          .eq('id', id);
    } catch (e) {
      debugPrint('Failed to delete task: $e');
      rethrow;
    }
  }
  
  /// Complete a task
  @override
  Future<void> completeTask(String id) async {
    try {
      await _client
          .from(_tasksTable)
          .update({
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      debugPrint('Failed to complete task: $e');
      rethrow;
    }
  }
  
  /// Get tasks by category ID
  @override
  Future<List<TaskModel>> getTasksByCategoryId(String categoryId) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('category_id', categoryId)
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks by category: $e');
      return [];
    }
  }
  
  /// Get tasks by entity ID
  @override
  Future<List<TaskModel>> getTasksByEntityId(String entityId) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('entity_id', entityId)
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks by entity: $e');
      return [];
    }
  }
  
  /// Get subtasks for a parent task
  @override
  Future<List<TaskModel>> getSubtasks(String parentTaskId) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('parent_task_id', parentTaskId)
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error getting subtasks: $e');
      return [];
    }
  }
  
  /// Get tasks by status
  @override
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks by status: $e');
      return [];
    }
  }
  
  /// Get tasks by priority
  @override
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .eq('priority', priority)
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks by priority: $e');
      return [];
    }
  }
  
  /// Search tasks
  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      final response = await _client
          .from(_tasksTable)
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to search tasks: $e');
      return [];
    }
  }
  
  /// Get filtered tasks
  @override
  Future<List<TaskModel>> getFilteredTasks({
    String? categoryId,
    String? status,
    String? priority,
    String? searchQuery,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
  }) async {
    try {
      var query = _client
          .from(_tasksTable)
          .select();
      
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      
      if (status != null) {
        query = query.eq('status', status);
      }
      
      if (priority != null) {
        query = query.eq('priority', priority);
      }
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or('title.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
      }
      
      if (dueDateFrom != null) {
        query = query.gte('due_date', dueDateFrom.toIso8601String());
      }
      
      if (dueDateTo != null) {
        query = query.lte('due_date', dueDateTo.toIso8601String());
      }
      
      final response = await query.order('created_at', ascending: false);
      
      return response.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get filtered tasks: $e');
      return [];
    }
  }
  
  /// Share a task with another user
  @override
  Future<void> shareTaskWithUser(String taskId, String userId) async {
    try {
      await _client
          .from(_taskSharingTable)
          .insert({
            'task_id': taskId,
            'user_id': userId,
            'created_at': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      debugPrint('Failed to share task with user: $e');
      rethrow;
    }
  }
  
  /// Remove task sharing with a user
  @override
  Future<void> removeTaskShare(String taskId, String userId) async {
    try {
      await _client
          .from(_taskSharingTable)
          .delete()
          .eq('task_id', taskId)
          .eq('user_id', userId);
    } catch (e) {
      debugPrint('Failed to remove task sharing: $e');
      rethrow;
    }
  }
  
  /// Get tasks shared with the current user
  @override
  Future<List<TaskModel>> getTasksSharedWithMe() async {
    try {
      final userId = _authService.currentUser?.id;
      if (userId == null) {
        return [];
      }
      
      // Get task IDs shared with the user
      final sharingResponse = await _client
          .from(_taskSharingTable)
          .select('task_id')
          .eq('user_id', userId);
      
      if (sharingResponse.isEmpty) {
        return [];
      }
      
      // Extract task IDs
      final List<String> taskIds = sharingResponse
          .map<String>((item) => item['task_id'] as String)
          .toList();
      
      // Get tasks by IDs
      final tasksResponse = await _client
          .from(_tasksTable)
          .select()
          .inFilter('id', taskIds);
      
      return tasksResponse.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks shared with me: $e');
      return [];
    }
  }
  
  /// Get tasks that the current user has shared with others
  @override
  Future<List<TaskModel>> getTasksIShared() async {
    try {
      final userId = _authService.currentUser?.id;
      if (userId == null) {
        return [];
      }
      
      // Get task IDs created by the user and shared with others
      final sharingResponse = await _client
          .from(_taskSharingTable)
          .select('task_id')
          .neq('user_id', userId);
      
      if (sharingResponse.isEmpty) {
        return [];
      }
      
      // Extract task IDs
      final List<String> taskIds = sharingResponse
          .map<String>((item) => item['task_id'] as String)
          .toList();
      
      // Get tasks by IDs that were created by the current user
      final tasksResponse = await _client
          .from(_tasksTable)
          .select()
          .inFilter('id', taskIds)
          .eq('created_by', userId);
      
      return tasksResponse.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get tasks I shared: $e');
      return [];
    }
  }
  
  /// Get the list of user IDs that a task is shared with
  @override
  Future<List<String>> getSharedUserIdsForTask(String taskId) async {
    try {
      final response = await _client
          .from(_taskSharingTable)
          .select('user_id')
          .eq('task_id', taskId);
      
      return response.map<String>((item) => item['user_id'] as String).toList();
    } catch (e) {
      debugPrint('Failed to get shared user IDs for task: $e');
      return [];
    }
  }
}

/// Provider for SupabaseTaskRepository
final supabaseTaskRepositoryProvider = Provider<TaskRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return SupabaseTaskRepository(authService: authService);
});
