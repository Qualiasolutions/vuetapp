import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:vuet_app/models/task_comment_model.dart';
import 'package:vuet_app/repositories/task_comment_repository.dart';
import 'package:vuet_app/repositories/supabase_task_comment_repository.dart'; // For its provider
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/notification_service.dart';
// import 'package:vuet_app/services/task_service.dart'; // Old import for taskServiceProvider
import 'package:vuet_app/providers/task_providers.dart'; // New import for taskServiceProvider
import 'package:vuet_app/services/task_service.dart' show TaskService; // For TaskService class if needed by constructor type

/// Service for managing task comments
class TaskCommentService extends ChangeNotifier {
  /// Repository for task comment operations
  final TaskCommentRepository _repository;

  /// Task service to retrieve task information
  final TaskService _taskService;

  /// Notification service for comment notifications
  final NotificationService _notificationService;

  /// AuthService instance
  final AuthService _authService;

  /// Current comments for active tasks
  final Map<String, List<TaskCommentModel>> _comments = {};

  /// Stream subscriptions for real-time comments
  final Map<String, StreamSubscription<List<TaskCommentModel>>> _subscriptions = {};

  /// Constructor
  TaskCommentService._({
    required TaskCommentRepository repository,
    required TaskService taskService,
    required NotificationService notificationService,
    required AuthService authService,
  })  : _repository = repository,
        _taskService = taskService,
        _notificationService = notificationService,
        _authService = authService;

  /// Get comments for a specific task
  List<TaskCommentModel> getCommentsForTask(String taskId) {
    return _comments[taskId] ?? [];
  }

  /// Load comments for a specific task
  Future<List<TaskCommentModel>> loadComments(String taskId) async {
    try {
      final comments = await _repository.getComments(taskId);
      _comments[taskId] = comments;
      notifyListeners();
      return comments;
    } catch (e) {
      // TODO: Implement logging framework
      // print('Error loading comments: $e');
      return [];
    }
  }

  /// Subscribe to real-time updates for a task's comments
  void subscribeToComments(String taskId) {
    // Cancel existing subscription if any
    _subscriptions[taskId]?.cancel();

    // Create a new subscription
    _subscriptions[taskId] = _repository.getCommentsStream(taskId).listen(
      (comments) {
        _comments[taskId] = comments;
        notifyListeners();
      },
      onError: (error) {
        // TODO: Implement logging framework
        // print('Error in comment stream: $error');
      },
    );
  }

  /// Unsubscribe from real-time updates for a task's comments
  void unsubscribeFromComments(String taskId) {
    _subscriptions[taskId]?.cancel();
    _subscriptions.remove(taskId);
  }

  /// Add a new comment to a task
  Future<TaskCommentModel?> addComment(String taskId, String text) async {
    try {
      // Get current user's ID
      final userId = _authService.currentUser?.id;
      if (userId == null) {
        // TODO: Implement logging framework
        // print('Cannot add comment: No authenticated user');
        return null;
      }

      // Create the comment model
      final comment = TaskCommentModel(
        taskId: taskId,
        userId: userId,
        text: text,
      );

      // Save to repository
      final savedComment = await _repository.addComment(comment);

      // Get task details for notifications
      final task = await _taskService.getTask(taskId);

      if (task != null) {
        // Send notifications to task owner and collaborators (except current user)
        final notificationRecipients = <String>{};

        // Add task owner
        if (task.createdById != userId) {
          notificationRecipients.add(task.createdById!);
        }

        // Add task collaborators
        // TODO: Re-implement comment notifications for shared users.
        // This will require fetching shared user IDs from the task_shares table via TaskRepository.
        // For now, this part is commented out to fix compilation.
        // final List<String> sharedUserIds = await _taskService.getSharedUserIdsForTask(taskId); // Example
        // if (sharedUserIds.isNotEmpty) {
        //   for (final collaboratorId in sharedUserIds) {
        //     if (collaboratorId != userId) {
        //       notificationRecipients.add(collaboratorId);
        //     }
        //   }
        // }

        // Send notifications
        for (final recipientId in notificationRecipients) {
          await _notificationService.createTaskCommentNotification(
            taskId: taskId,
            taskTitle: task.title,
            commentedByUserId: userId,
            commentText: text,
            userId: recipientId,
          );
        }
      }

      // Update local cache
      _comments[taskId] = [...(_comments[taskId] ?? []), savedComment];
      notifyListeners();

      return savedComment;
    } catch (e) {
      // TODO: Implement logging framework
      // print('Error adding comment: $e');
      return null;
    }
  }

  /// Update an existing comment
  Future<TaskCommentModel?> updateComment(
      String commentId, String newText) async {
    try {
      // Get the existing comment
      final existingComment = await _repository.getComment(commentId);
      if (existingComment == null) {
        // TODO: Implement logging framework
        // print('Comment not found: $commentId');
        return null;
      }

      // Ensure the current user is the author
      final userId = _authService.currentUser?.id;
      if (userId != existingComment.userId) {
        // TODO: Implement logging framework
        // print('Cannot update comment: User is not the author');
        return null;
      }

      // Create updated comment model
      final updatedComment = existingComment.copyWith(
        text: newText,
      );

      // Save to repository
      final savedComment = await _repository.updateComment(updatedComment);

      // Update local cache
      final taskId = savedComment.taskId;
      final index = _comments[taskId]?.indexWhere((c) => c.id == commentId) ?? -1;

      if (index >= 0 && _comments[taskId] != null) {
        _comments[taskId]![index] = savedComment;
        notifyListeners();
      }

      return savedComment;
    } catch (e) {
      // TODO: Implement logging framework
      // print('Error updating comment: $e');
      return null;
    }
  }

  /// Delete a comment
  Future<bool> deleteComment(String commentId) async {
    try {
      // Get the existing comment
      final existingComment = await _repository.getComment(commentId);
      if (existingComment == null) {
        // TODO: Implement logging framework
        // print('Comment not found: $commentId');
        return false;
      }

      // Ensure the current user is the author
      final userId = _authService.currentUser?.id;
      if (userId != existingComment.userId) {
        // TODO: Implement logging framework
        // print('Cannot delete comment: User is not the author');
        return false;
      }

      // Delete from repository
      final success = await _repository.deleteComment(commentId);

      if (success) {
        // Update local cache
        final taskId = existingComment.taskId;
        _comments[taskId]?.removeWhere((c) => c.id == commentId);
        notifyListeners();
      }

      return success;
    } catch (e) {
      // TODO: Implement logging framework
      // print('Error deleting comment: $e');
      return false;
    }
  }

  /// Get the comment count for a task
  Future<int> getCommentCount(String taskId) async {
    try {
      return await _repository.getCommentsCount(taskId);
    } catch (e) {
      // TODO: Implement logging framework
      // print('Error getting comment count: $e');
      return 0;
    }
  }

  /// Check if a user can edit or delete a comment
  bool canModifyComment(TaskCommentModel comment) {
    final userId = _authService.currentUser?.id;
    return userId == comment.userId;
  }

  /// Get the current user ID for testing or utility purposes
  String? getCurrentUserId() {
    return _authService.currentUser?.id;
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  /// Reset the service (mainly for testing Riverpod providers)
  /// Note: This method is primarily for testing scenarios where provider state needs to be reset.
  static void reset() {
    // Riverpod providers handle disposal and state management.
    // Direct singleton reset is not needed with Riverpod.
    // If specific state cleanup is required for testing, it should be handled
    // within the service's dispose method or by overriding the provider in tests.
  }
}

// Riverpod provider for TaskCommentService
final taskCommentServiceProvider = ChangeNotifierProvider<TaskCommentService>((ref) {
  final authService = ref.watch(authServiceProvider);
  final taskService = ref.watch(taskServiceProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  final taskCommentRepository = ref.watch(supabaseTaskCommentRepositoryProvider);
  return TaskCommentService._(
    repository: taskCommentRepository,
    authService: authService,
    taskService: taskService,
    notificationService: notificationService,
  );
});
