import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/repositories/task_repository.dart';
import 'package:vuet_app/repositories/implementations/supabase_task_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/notification_service.dart';
import 'package:vuet_app/utils/error_handler.dart';
import 'dart:async';
import 'dart:convert';

/// Service for managing tasks in the application
class TaskService extends ChangeNotifier {
  /// Repository for task operations
  final TaskRepository _repository;
  
  /// Notification service for task notifications
  final NotificationService _notificationService;
  
  /// Auth service for user authentication
  final AuthService _authService;
  
  /// Current tasks list
  List<TaskModel> _tasks = [];
  
  /// Getter for tasks
  List<TaskModel> get tasks => _tasks;

  /// Stream controller for task updates
  final StreamController<List<TaskModel>> _taskUpdatesController = StreamController<List<TaskModel>>.broadcast();
  
  bool _isDisposed = false; // Add this line

  /// Constructor
  TaskService({
    required TaskRepository repository,
    required NotificationService notificationService,
    required AuthService authService,
    required SupabaseClient supabase,
  })  : _repository = repository,
        _notificationService = notificationService,
        _authService = authService {
    // Initialize tasks
    _loadTasks();
  }
  
  /// Get the current user ID
  String? get _userId => _authService.currentUser?.id;
  
  /// Check if user is authenticated
  bool get _isAuthenticated => _userId != null;
  
  /// Load tasks from repository
  Future<void> _loadTasks() async {
    if (!_isAuthenticated) return;
    if (_isDisposed) return; // Add this check early
    
    try {
      _tasks = await _repository.getTasks();
      if (_isDisposed) return; // Add this check after await
      notifyListeners();
      _taskUpdatesController.add(_tasks);
    } catch (e) {
      if (_isDisposed) return; 
      ErrorHandler.handleError('Failed to load tasks', e);
    }
  }
  
  /// Refresh tasks from repository
  Future<void> refreshTasks() async {
    await _loadTasks();
  }
  
  /// Get a task by ID
  Future<TaskModel?> getTask(String id) async {
    try {
      return await _repository.getTaskById(id);
    } catch (e) {
      ErrorHandler.handleError('Failed to get task', e);
      return null;
    }
  }

  /// Alias for getTask - returns a task by ID
  Future<TaskModel?> getTaskById(String id) async {
    return getTask(id);
  }

  /// Get all tasks
  Future<List<TaskModel>> getTasks() async {
    if (!_isAuthenticated) return [];
    
    try {
      return _tasks;
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks', e);
      return [];
    }
  }

  /// Get subtasks for a parent task
  Future<List<TaskModel>> getSubtasks(String parentTaskId) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getSubtasks(parentTaskId);
    } catch (e) {
      ErrorHandler.handleError('Failed to get subtasks', e);
      return [];
    }
  }

  /// Get a stream of task updates
  Stream<List<TaskModel>> taskUpdates() {
    return _taskUpdatesController.stream;
  }
  
  /// Create a new task
  Future<String?> createTask({
    required String title,
    String? description,
    DateTime? dueDate,
    String priority = 'medium',
    String? categoryId,
    String? entityId,
    TaskType? taskType,
    String? taskSubtype,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    String? urgency,
    String? taskBehavior,
    List<String>? tags,
    String? parentTaskId,
  }) async {
    if (!_isAuthenticated) return null;
    
    try {
      final task = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: 'pending',
        categoryId: categoryId,
        createdById: _userId,
        assignedToId: _userId,
        parentTaskId: parentTaskId,
        entityId: entityId,
        taskType: taskType,
        taskSubtype: taskSubtype,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        location: location,
        typeSpecificData: typeSpecificData,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        urgency: urgency,
        taskBehavior: taskBehavior,
        tags: tags,
      );
      
      final taskId = await _repository.createTask(task);
      
      // Schedule notification if due date is set
      if (dueDate != null) {
        await scheduleTaskDueNotification(task.copyWith(id: taskId));
      }
      
      await _loadTasks();
      return taskId;
    } catch (e) {
      ErrorHandler.handleError('Failed to create task', e);
      return null;
    }
  }
  
  /// Update an existing task
  Future<bool> updateTask({
    required String id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    String? categoryId,
    String? entityId,
    TaskType? taskType,
    String? taskSubtype,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    String? urgency,
    String? taskBehavior,
    List<String>? tags,
  }) async {
    if (!_isAuthenticated) return false;
    
    try {
      // Get existing task
      final existingTask = await _repository.getTaskById(id);
      if (existingTask == null) {
        return false;
      }
      
      // Create updated task
      final updatedTask = existingTask.copyWith(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        status: status,
        categoryId: categoryId,
        entityId: entityId,
        taskType: taskType,
        taskSubtype: taskSubtype,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        location: location,
        typeSpecificData: typeSpecificData,
        updatedAt: DateTime.now(),
        completedAt: status == 'completed' && existingTask.completedAt == null
            ? DateTime.now()
            : existingTask.completedAt,
        urgency: urgency,
        taskBehavior: taskBehavior,
        tags: tags,
      );
      
      // Update task
      await _repository.updateTask(updatedTask);
      
      // Handle due date notifications
      if (dueDate != null && dueDate != existingTask.dueDate) {
        // Cancel existing notification
        if (existingTask.dueDate != null) {
          await cancelTaskNotification(id);
        }
        
        // Schedule new notification
        await scheduleTaskDueNotification(updatedTask);
      }
      
      // Notify shared users about the update
      await _notifyTaskUpdate(updatedTask, existingTask);
      
      await _loadTasks();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update task', e);
      return false;
    }
  }
  
  /// Delete a task
  Future<bool> deleteTask(String id) async {
    if (!_isAuthenticated) return false;
    
    try {
      // Cancel notifications
      await cancelTaskNotification(id);
      
      // Delete task
      await _repository.deleteTask(id);
      
      await _loadTasks();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete task', e);
      return false;
    }
  }
  
  /// Complete a task
  Future<bool> completeTask(String id) async {
    if (!_isAuthenticated) return false;
    
    try {
      // Get existing task
      final existingTask = await _repository.getTaskById(id);
      if (existingTask == null) {
        return false;
      }
      
      // Complete task
      await _repository.completeTask(id);
      
      // Cancel notifications
      await cancelTaskNotification(id);
      
      await _loadTasks();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to complete task', e);
      return false;
    }
  }
  
  /// Get tasks by category ID
  Future<List<TaskModel>> getTasksByCategoryId(String categoryId) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksByCategoryId(categoryId);
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks by category', e);
      return [];
    }
  }
  
  /// Get tasks by entity ID
  Future<List<TaskModel>> getTasksByEntityId(String entityId) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksByEntityId(entityId);
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks by entity', e);
      return [];
    }
  }
  
  /// Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksByStatus(status);
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks by status', e);
      return [];
    }
  }
  
  /// Get tasks by priority
  Future<List<TaskModel>> getTasksByPriority(String priority) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksByPriority(priority);
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks by priority', e);
      return [];
    }
  }
  
  /// Search tasks
  Future<List<TaskModel>> searchTasks(String query) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.searchTasks(query);
    } catch (e) {
      ErrorHandler.handleError('Failed to search tasks', e);
      return [];
    }
  }
  
  /// Get filtered tasks
  Future<List<TaskModel>> getFilteredTasks({
    String? categoryId,
    String? status,
    String? priority,
    String? searchQuery,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
  }) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getFilteredTasks(
        categoryId: categoryId,
        status: status,
        priority: priority,
        searchQuery: searchQuery,
        dueDateFrom: dueDateFrom,
        dueDateTo: dueDateTo,
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to get filtered tasks', e);
      return [];
    }
  }
  
  /// Share a task with another user
  Future<bool> shareTaskWithUser(String taskId, String userId) async {
    if (!_isAuthenticated) return false;
    
    try {
      await _repository.shareTaskWithUser(taskId, userId);
      
      // Get task details for notification
      final task = await _repository.getTaskById(taskId);
      if (task != null) {
        // Create notification for shared user
        await _notificationService.createTaskSharedNotification(
          userId: userId,
          taskId: taskId,
          taskTitle: task.title,
        );
      }
      
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to share task with user', e);
      return false;
    }
  }
  
  /// Remove task sharing with a user
  Future<bool> removeTaskSharingFromUser(String taskId, String userId) async {
    if (!_isAuthenticated) return false;
    
    try {
      await _repository.removeTaskShare(taskId, userId);
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to remove task sharing', e);
      return false;
    }
  }

  /// Alias for removeTaskSharingFromUser
  Future<bool> removeTaskShare(String taskId, String userId) async {
    return removeTaskSharingFromUser(taskId, userId);
  }
  
  /// Get tasks shared with the current user
  Future<List<TaskModel>> getTasksSharedWithUser() async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksSharedWithMe();
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks shared with me', e);
      return [];
    }
  }
  
  /// Get tasks that the current user has shared with others
  Future<List<TaskModel>> getTasksSharedByUser() async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getTasksIShared();
    } catch (e) {
      ErrorHandler.handleError('Failed to get tasks I shared', e);
      return [];
    }
  }
  
  /// Get the list of user IDs that a task is shared with
  Future<List<String>> getSharedUserIdsForTask(String taskId) async {
    if (!_isAuthenticated) return [];
    
    try {
      return await _repository.getSharedUserIdsForTask(taskId);
    } catch (e) {
      ErrorHandler.handleError('Failed to get shared user IDs for task', e);
      return [];
    }
  }
  
  /// Schedule a notification for a task due date
  Future<void> scheduleTaskDueNotification(TaskModel task) async {
    if (task.dueDate == null) return;
    
    try {
      // Calculate notification time (1 hour before due date)
      final notificationTime = task.dueDate!.subtract(const Duration(hours: 1));
      
      // Skip if notification time is in the past
      if (notificationTime.isBefore(DateTime.now())) return;
      
      // Schedule notification - using the correct API without the id parameter
      // and converting the payload to a JSON string
      await _notificationService.scheduleNotification(
        title: 'Task Due Soon',
        body: 'Your task "${task.title}" is due in 1 hour',
        scheduledDate: notificationTime,
        payload: jsonEncode({
          'type': 'task_due',
          'taskId': task.id,
        }),
      );
      
      // Create reminder notification in database
      await _notificationService.createTaskReminderNotification(
        userId: _userId!,
        taskId: task.id,
        taskTitle: task.title,
        dueDate: task.dueDate!,
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to schedule task notification', e);
    }
  }
  
  /// Cancel a scheduled notification for a task
  Future<void> cancelTaskNotification(String taskId) async {
    try {
      // Generate the same notification ID used when scheduling
      final notificationId = int.parse(taskId.hashCode.toString().replaceAll('-', '').substring(0, 9));
      
      // Cancel notification
      await _notificationService.cancelNotification(notificationId);
    } catch (e) {
      ErrorHandler.handleError('Failed to cancel task notification', e);
    }
  }
  
  /// Notify shared users about task updates
  Future<void> _notifyTaskUpdate(TaskModel updatedTask, TaskModel oldTask) async {
    try {
      // Get users the task is shared with
      final sharedUserIds = await getSharedUserIdsForTask(updatedTask.id);
      if (sharedUserIds.isEmpty) return;
      
      // Determine what changed
      final List<String> changes = [];
      
      if (updatedTask.title != oldTask.title) {
        changes.add('title changed to "${updatedTask.title}"');
      }
      
      if (updatedTask.status != oldTask.status) {
        changes.add('status changed to ${updatedTask.status}');
      }
      
      if (updatedTask.priority != oldTask.priority) {
        changes.add('priority changed to ${updatedTask.priority}');
      }
      
      if (updatedTask.dueDate != oldTask.dueDate) {
        final dueDateStr = updatedTask.dueDate != null
            ? '${updatedTask.dueDate!.day}/${updatedTask.dueDate!.month}/${updatedTask.dueDate!.year}'
            : 'none';
        changes.add('due date changed to $dueDateStr');
      }
      
      if (updatedTask.description != oldTask.description) {
        changes.add('description was updated');
      }
      
      // Create update message
      String updateDetails = changes.isNotEmpty
          ? changes.join(', ')
          : 'details were updated';
      
      // Send notifications to shared users
      await _notificationService.createTaskUpdatedNotifications(
        taskId: updatedTask.id,
        taskTitle: updatedTask.title,
        updatedByUserId: _userId!,
        sharedWithUserIds: sharedUserIds,
        updateDetails: updateDetails,
      );
    } catch (e) {
      ErrorHandler.handleError('Failed to notify task update', e);
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the flag to true
    _taskUpdatesController.close();
    super.dispose();
  }
}

/// Provider for TaskService
final taskServiceProvider = ChangeNotifierProvider<TaskService>((ref) {
  final repository = ref.watch(supabaseTaskRepositoryProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final supabase = Supabase.instance.client;
  
  return TaskService(
    repository: repository,
    notificationService: notificationService,
    authService: authService,
    supabase: supabase,
  );
});
