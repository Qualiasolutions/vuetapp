import 'package:vuet_app/models/task_comment_model.dart';

/// Repository interface for task comment operations
abstract class TaskCommentRepository {
  /// Get all comments for a specific task
  Future<List<TaskCommentModel>> getComments(String taskId);
  
  /// Get a specific comment by ID
  Future<TaskCommentModel?> getComment(String commentId);
  
  /// Add a new comment to a task
  Future<TaskCommentModel> addComment(TaskCommentModel comment);
  
  /// Update an existing comment
  Future<TaskCommentModel> updateComment(TaskCommentModel comment);
  
  /// Delete a comment
  Future<bool> deleteComment(String commentId);
  
  /// Get a stream of comments for a specific task for real-time updates
  Stream<List<TaskCommentModel>> getCommentsStream(String taskId);
  
  /// Get the comments count for a task
  Future<int> getCommentsCount(String taskId);
  
  /// Get comments for a list of tasks
  Future<Map<String, List<TaskCommentModel>>> getCommentsForTasks(List<String> taskIds);
}
