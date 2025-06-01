import 'package:vuet_app/models/task_model.dart';

/// Repository interface for task operations
abstract class TaskRepository {
  /// Get all tasks
  Future<List<TaskModel>> getTasks();
  
  /// Get task by ID
  Future<TaskModel?> getTaskById(String id);
  
  /// Create a new task
  Future<String> createTask(TaskModel task);
  
  /// Update an existing task
  Future<void> updateTask(TaskModel task);
  
  /// Delete a task
  Future<void> deleteTask(String id);
  
  /// Complete a task
  Future<void> completeTask(String id);
  
  /// Get tasks by category ID
  Future<List<TaskModel>> getTasksByCategoryId(String categoryId);
  
  /// Get tasks by entity ID
  Future<List<TaskModel>> getTasksByEntityId(String entityId);
  
  /// Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(String status);
  
  /// Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(String priority);
  
  /// Search tasks
  Future<List<TaskModel>> searchTasks(String query);
  
  /// Get filtered tasks
  Future<List<TaskModel>> getFilteredTasks({
    String? categoryId,
    String? status,
    String? priority,
    String? searchQuery,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
  });
  
  /// Share a task with another user
  Future<void> shareTaskWithUser(String taskId, String userId);
  
  /// Remove task sharing with a user
  Future<void> removeTaskShare(String taskId, String userId);
  
  /// Get tasks shared with the current user
  Future<List<TaskModel>> getTasksSharedWithMe();
  
  /// Get tasks that the current user has shared with others
  Future<List<TaskModel>> getTasksIShared();
  
  /// Get the list of user IDs that a task is shared with
  Future<List<String>> getSharedUserIdsForTask(String taskId);
  
  /// Get subtasks for a parent task
  Future<List<TaskModel>> getSubtasks(String parentTaskId);
}
