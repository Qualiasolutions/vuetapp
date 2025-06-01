import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/task_comment_model.dart';
import 'package:vuet_app/repositories/task_comment_repository.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/realtime_subscription_manager.dart';

/// Supabase implementation of the TaskCommentRepository
class SupabaseTaskCommentRepository implements TaskCommentRepository {
  static const String _table = 'task_comments';
  final SupabaseClient _client = SupabaseConfig.client;
  final AuthService _authService;
  final RealtimeSubscriptionManager _subscriptionManager;

  SupabaseTaskCommentRepository({
    required AuthService authService,
    required RealtimeSubscriptionManager subscriptionManager,
  }) : _authService = authService,
       _subscriptionManager = subscriptionManager;

  @override
  Future<TaskCommentModel> addComment(TaskCommentModel comment) async {
    // Get current user's display name to store with the comment
    final currentUser = _authService.currentUser;
    final userDisplayName = currentUser?.userMetadata?['name'] as String? ?? 
        currentUser?.email?.split('@').first ?? 'User';
    
    // Prepare the data with the display name
    final data = {
      ...comment.toJson(),
      'user_display_name': userDisplayName,
    };
    
    final response = await _client
        .from(_table)
        .insert(data)
        .select()
        .single();
    
    return TaskCommentModel.fromJson(response);
  }

  @override
  Future<bool> deleteComment(String commentId) async {
    await _client
        .from(_table)
        .delete()
        .eq('id', commentId);
    
    return true;
  }

  @override
  Future<TaskCommentModel?> getComment(String commentId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', commentId)
        .maybeSingle();
    
    if (response == null) {
      return null;
    }
    
    return TaskCommentModel.fromJson(response);
  }

  @override
  Future<List<TaskCommentModel>> getComments(String taskId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('task_id', taskId)
        .order('created_at');
    
    return response
        .map<TaskCommentModel>((comment) => TaskCommentModel.fromJson(comment))
        .toList();
  }

  @override
  Stream<List<TaskCommentModel>> getCommentsStream(String taskId) {
    // Use centralized subscription manager
    return _subscriptionManager
        .getTableStream(
          _table,
          filter: 'task_id',
          filterValue: taskId,
        )
        .map((response) => response
            .map<TaskCommentModel>(
                (comment) => TaskCommentModel.fromJson(comment))
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));
  }

  @override
  Future<int> getCommentsCount(String taskId) async {
    try {
      final response = await _client
          .from(_table)
          .select('id')
          .eq('task_id', taskId)
          .count(CountOption.exact);
      return response.count;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Map<String, List<TaskCommentModel>>> getCommentsForTasks(
      List<String> taskIds) async {
    if (taskIds.isEmpty) {
      return {};
    }
    
    final response = await _client
        .from(_table)
        .select()
        .filter('task_id', 'in', '(${taskIds.join(',')})')
        .order('created_at');
    
    final result = <String, List<TaskCommentModel>>{};
    
    for (final taskId in taskIds) {
      result[taskId] = [];
    }
    
    for (final comment in response) {
      final commentModel = TaskCommentModel.fromJson(comment);
      result[commentModel.taskId]?.add(commentModel);
    }
    
    return result;
  }

  @override
  Future<TaskCommentModel> updateComment(TaskCommentModel comment) async {
    // Add updated timestamp
    final updatedComment = comment.copyWith(
      updatedAt: DateTime.now(),
    );
    
    final response = await _client
        .from(_table)
        .update(updatedComment.toJson())
        .eq('id', comment.id)
        .select()
        .single();
    
    return TaskCommentModel.fromJson(response);
  }
}

final supabaseTaskCommentRepositoryProvider = Provider<SupabaseTaskCommentRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  final subscriptionManager = ref.watch(realtimeSubscriptionManagerProvider);
  return SupabaseTaskCommentRepository(
    authService: authService,
    subscriptionManager: subscriptionManager,
  );
});
