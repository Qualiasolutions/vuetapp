import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
// Removed duplicate imports of material, riverpod, and intl
import 'package:vuet_app/models/task_comment_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/entity_model.dart'; // Provides BaseEntityModel, EntitySubtype
import 'package:vuet_app/models/user_model.dart'; // Explicitly import UserModel for UserModelX extension
import 'package:vuet_app/providers/task_providers.dart'; // New import for taskServiceProvider
import 'package:vuet_app/providers/user_providers.dart'; // Added for userProfileProviderFamily
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/entity_service.dart'; // Added for entityServiceProvider
import 'package:vuet_app/services/task_comment_service.dart';
import 'package:vuet_app/ui/screens/tasks/edit_task_screen.dart';

/// Brand color palette constants
/// Duplicated from main_categories_screen.dart for consistency
class VuetColors {
  // Primary brand colors
  static const primaryDark = Color(0xFF1C2827); // Dark Jungle Green
  static const secondary = Color(0xFF55C6D4); // Medium Turquoise
  static const accent = Color(0xFFE49F30); // Orange
  static const neutral = Color(0xFF79858D); // Steel
}


// Provider to fetch a single task's details
// Using .family to pass the taskId
final taskDetailProviderFamily = FutureProvider.autoDispose.family<TaskModel?, String>((ref, taskId) async {
  final taskService = ref.watch(taskServiceProvider);
  return await taskService.getTaskById(taskId);
});

// Provider to fetch subtasks for a parent task
final subtasksProviderFamily = FutureProvider.autoDispose.family<List<TaskModel>, String>((ref, taskId) async {
  final taskService = ref.watch(taskServiceProvider);
  return await taskService.getSubtasks(taskId);
});

// Provider to fetch comments for a task
final taskCommentsProviderFamily = FutureProvider.autoDispose.family<List<TaskCommentModel>, String>((ref, taskId) async {
  final commentService = ref.watch(taskCommentServiceProvider);
  await commentService.loadComments(taskId);
  commentService.subscribeToComments(taskId);
  return commentService.getCommentsForTask(taskId);
});

// Provider to fetch a linked entity's details
final linkedEntityProviderFamily = FutureProvider.autoDispose.family<BaseEntityModel?, String?>((ref, entityId) async {
  if (entityId == null || entityId.isEmpty) {
    return null;
  }
  final entityService = ref.watch(entityServiceProvider);
  return await entityService.getEntityById(entityId);
});

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });
  
  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmittingComment = false;
  
  @override
  void dispose() {
    // Unsubscribe from comment updates
    final commentService = ref.read(taskCommentServiceProvider);
    commentService.unsubscribeFromComments(widget.taskId);
    _commentController.dispose();
    super.dispose();
  }

  void _navigateToEditTask(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    ).then((result) {
      if (result == true) {
        // If task was updated, refresh the details
        ref.invalidate(taskDetailProviderFamily(widget.taskId));
      }
    });
  }
  
  // Method to submit a new comment
  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) return;
    
    if (!mounted) return;
    setState(() {
      _isSubmittingComment = true;
    });
    
    try {
      final commentService = ref.read(taskCommentServiceProvider);
      await commentService.addComment(
        widget.taskId,
        _commentController.text.trim(),
      );
      if (!mounted) return;
      _commentController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingComment = false;
        });
      }
    }
  }
  
  // Method to handle task completion
  Future<void> _completeTask(TaskModel task) async {
    try {
      final taskService = ref.read(taskServiceProvider);
      await taskService.completeTask(task.id);
      if (!mounted) return;
      
      ref.invalidate(taskDetailProviderFamily(widget.taskId));
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete task: $e')),
      );
    }
  }
  
  // Method to handle task deletion with confirmation
  void _deleteTaskWithConfirmation(TaskModel task) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog( // Use dialogContext for clarity
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () => Navigator.pop(dialogContext),
          ),
          TextButton(
            child: const Text('DELETE'),
            onPressed: () async {
              Navigator.pop(dialogContext); // Close dialog
              try {
                final taskService = ref.read(taskServiceProvider);
                await taskService.deleteTask(task.id);
                // Pop back to task list after successful deletion
                if (!mounted) return;
                Navigator.pop(context);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete task: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
  
  // Build priority indicator with appropriate color
  Widget _buildPriorityIndicator(String priority) {
    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: priorityColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: priorityColor),
      ),
      child: Text(
        priority.toUpperCase(),
        style: TextStyle(
          color: priorityColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Build status indicator with appropriate color
  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    String displayStatus;
    
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.blue;
        displayStatus = 'PENDING';
        break;
      case 'in_progress':
        statusColor = Colors.orange;
        displayStatus = 'IN PROGRESS';
        break;
      case 'completed':
        statusColor = Colors.green;
        displayStatus = 'COMPLETED';
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        displayStatus = 'CANCELLED';
        break;
      default:
        statusColor = Colors.grey;
        displayStatus = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskAsyncValue = ref.watch(taskDetailProviderFamily(widget.taskId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: VuetColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(taskAsyncValue.when(
          data: (task) => task?.title ?? 'Task Details',
          loading: () => 'Loading...',
          error: (_, __) => 'Error',
        )),
        actions: [
          taskAsyncValue.when(
            data: (task) {
              if (task != null) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Task',
                      onPressed: () => _navigateToEditTask(context, task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'More Options',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (task.status != 'completed')
                                ListTile(
                                  leading: const Icon(Icons.check_circle),
                                  title: const Text('Mark as Complete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _completeTask(task);
                                  },
                                ),
                              ListTile(
                                leading: const Icon(Icons.share),
                                title: const Text('Share Task'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showShareTaskDialog(context, ref, task);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete, color: Colors.red),
                                title: const Text('Delete Task', 
                                  style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  Navigator.pop(context);
                                  _deleteTaskWithConfirmation(task);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: taskAsyncValue.when(
        data: (task) {
          if (task == null) {
            return const Center(child: Text('Task not found.'));
          }
          
          final subtasksAsync = ref.watch(subtasksProviderFamily(widget.taskId));
          final commentsAsync = ref.watch(taskCommentsProviderFamily(widget.taskId));
          final linkedEntityAsync = ref.watch(linkedEntityProviderFamily(task.entityId));
          // final taskCategoryId = task.categoryId; // Store nullable categoryId
          // Conditionally watch the provider only if taskCategoryId is not null.
          // The type of taskCategoryAsync will be AsyncValue<TaskCategoryModel?>?
          // final taskCategoryAsync = taskCategoryId != null
          //     ? ref.watch(taskCategoryDetailProviderFamily(taskCategoryId))
          //     : null;
          final createdByProfileAsync = ref.watch(userProfileProviderFamily(task.createdById)); // Added
          final assignedToProfileAsync = ref.watch(userProfileProviderFamily(task.assignedToId)); // Added
          
          return RefreshIndicator(
            color: VuetColors.accent,
            onRefresh: () async {
              ref.invalidate(taskDetailProviderFamily(widget.taskId));
              ref.invalidate(subtasksProviderFamily(widget.taskId));
              ref.invalidate(taskCommentsProviderFamily(widget.taskId));
            },
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                // Task Header with Status
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: VuetColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Status and Priority indicators
                      Row(
                        children: [
                          _buildStatusIndicator(task.status),
                          const SizedBox(width: 8),
                          _buildPriorityIndicator(task.priority),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description with styled box
                      if (task.description != null && task.description!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: VuetColors.primaryDark,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                task.description!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Task Details Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: VuetColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Due date with icon
                      _buildIconDetailRow(
                        Icons.calendar_today,
                        'Due Date:',
                        task.dueDate != null 
                            ? DateFormat.yMMMd().format(task.dueDate!) 
                            : 'None',
                      ),
                      
                      // Category with icon (Temporarily commented out)
                      // if (taskCategoryId != null && taskCategoryAsync != null)
                      //   taskCategoryAsync.when(
                      //     data: (category) => _buildIconDetailRow(
                      //       Icons.category,
                      //       'Category:',
                      //       category?.name ?? taskCategoryId ?? 'Uncategorized', // Use the stored taskCategoryId
                      //     ),
                      //     loading: () => _buildIconDetailRow(
                      //       Icons.category,
                      //       'Category:',
                      //       'Loading category...',
                      //     ),
                      //     error: (err, stack) => _buildIconDetailRow(
                      //       Icons.category,
                      //       'Category:',
                      //       'Error loading category',
                      //     ),
                      //   )
                      // else
                      //   _buildIconDetailRow( // Display if categoryId was null or provider not watched
                      //     Icons.category,
                      //     'Category:',
                      //     taskCategoryId ?? 'Uncategorized',
                      //   ),
                      _buildIconDetailRow( // Placeholder if category display is removed
                        Icons.category,
                        'Category:',
                        task.categoryId ?? 'Uncategorized',
                      ),
                      
                      // Created date with icon
                      _buildIconDetailRow(
                        Icons.access_time,
                        'Created:',
                        DateFormat.yMMMd().add_jm().format(task.createdAt),
                      ),
                      
                      // Updated date with icon
                      _buildIconDetailRow(
                        Icons.update,
                        'Updated:',
                        DateFormat.yMMMd().add_jm().format(task.updatedAt),
                      ),
                      
                      // Completed date with icon (if applicable)
                      if (task.completedAt != null)
                        _buildIconDetailRow(
                          Icons.check_circle,
                          'Completed:',
                          DateFormat.yMMMd().add_jm().format(task.completedAt!),
                        ),
                      
                      // Created by user (if available)
                      if (task.createdById != null)
                        createdByProfileAsync.when(
                          data: (profile) => _buildIconDetailRow(
                            Icons.person,
                            'Created by:',
                            profile?.displayName ?? task.createdById!,
                          ),
                          loading: () => _buildIconDetailRow(Icons.person, 'Created by:', 'Loading...'),
                          error: (e, s) => _buildIconDetailRow(Icons.person, 'Created by:', 'Error'),
                        ),
                      
                      // Assigned to user (if applicable)
                      if (task.assignedToId != null)
                        assignedToProfileAsync.when(
                          data: (profile) => _buildIconDetailRow(
                            Icons.assignment_ind,
                            'Assigned to:',
                            profile?.displayName ?? task.assignedToId!,
                          ),
                          loading: () => _buildIconDetailRow(Icons.assignment_ind, 'Assigned to:', 'Loading...'),
                          error: (e, s) => _buildIconDetailRow(Icons.assignment_ind, 'Assigned to:', 'Error'),
                        ),
                      
                      // Linked Entity
                      linkedEntityAsync.when(
                        data: (entity) {
                          if (entity != null) {
                            return _buildIconDetailRow(
                              Icons.link, // Or a more specific icon for entities
                              'Linked Entity:',
                              entity.name,
                            );
                          }
                          return const SizedBox.shrink(); // No linked entity or not loaded
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(children: [Icon(Icons.link, size: 18, color: Colors.grey), SizedBox(width: 8), Text("Loading entity...")]),
                        ),
                        error: (err, stack) => _buildIconDetailRow(
                          Icons.error_outline,
                          'Linked Entity:',
                          'Error loading',
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Subtasks Section
                subtasksAsync.when(
                  data: (subtasks) {
                    if (subtasks.isEmpty) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtasks',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: VuetColors.primaryDark,
                                  ),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('ADD'),
                                  onPressed: () => _showAddSubtaskDialog(context, ref, widget.taskId),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('No subtasks yet.'),
                          ],
                        ),
                      );
                    }
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subtasks (${subtasks.length})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: VuetColors.primaryDark,
                                ),
                              ),
                              TextButton.icon(
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('ADD'),
                                onPressed: () => _showAddSubtaskDialog(context, ref, widget.taskId),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...subtasks.map((subtask) => _buildSubtaskItem(subtask)),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading subtasks: $err'),
                ),
                
                const SizedBox(height: 20),
                
                // Comments Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: VuetColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Comment input field
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: VuetColors.secondary,
                            radius: 16,
                            child: Text(
                              ref.watch(authServiceProvider).currentUser?.email?[0].toUpperCase() ?? 'U',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _isSubmittingComment ? null : _submitComment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VuetColors.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: _isSubmittingComment 
                                ? const SizedBox(
                                    width: 20, 
                                    height: 20, 
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    )
                                  )
                                : const Text('Post'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Comments list
                      commentsAsync.when(
                        data: (comments) {
                          if (comments.isEmpty) {
                            return const Center(
                              child: Text('No comments yet.'),
                            );
                          }
                          
                          return Column(
                            children: comments.map((comment) => _buildCommentItem(comment)).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Text('Error loading comments: $err'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: VuetColors.accent),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load task details: $err', 
                  style: const TextStyle(color: Colors.red), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(taskDetailProviderFamily(widget.taskId)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: VuetColors.secondary,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build a detail row with an icon
  Widget _buildIconDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build a subtask list item
  Widget _buildSubtaskItem(TaskModel subtask) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Checkbox(
          value: subtask.status == 'completed',
          activeColor: VuetColors.secondary,
          onChanged: (value) {
            if (value == true) {
              _completeTask(subtask);
            } else {
              // Update task to not completed - would need a method for this
              // _uncompleteTask(subtask);
            }
          },
        ),
        title: Text(
          subtask.title,
          style: TextStyle(
            decoration: subtask.status == 'completed' 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: subtask.status == 'completed' 
                ? Colors.grey[600] 
                : Colors.black,
          ),
        ),
        subtitle: subtask.dueDate != null 
            ? Text(
                'Due: ${DateFormat.yMMMd().format(subtask.dueDate!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              )
            : null,
        trailing: _buildPriorityIndicator(subtask.priority),
        onTap: () {
          // Navigate to subtask detail
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: subtask.id),
            ),
          );
        },
      ),
    );
  }
  
  // Build a comment list item
  Widget _buildCommentItem(TaskCommentModel comment) {
    // Determine if the current user is the author of the comment
    final commentService = ref.read(taskCommentServiceProvider);
    final bool isAuthor = commentService.canModifyComment(comment);
    final String authorInitial = 
        ref.watch(authServiceProvider).currentUser?.email?[0].toUpperCase() ?? 'U'; // Changed

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: VuetColors.neutral,
          radius: 16,
          child: Text(
            authorInitial,
            style: const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          comment.userDisplayName ?? 'User',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          comment.timeAgo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, size: 18, color: Colors.grey[600]),
          itemBuilder: (context) => [
            if (isAuthor)
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              // Show edit dialog
              final commentController = TextEditingController(text: comment.text);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Comment'),
                  content: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your comment...',
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                  actions: [
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton( // Added missing TextButton for SAVE
                      child: const Text('SAVE'),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        navigator.pop(); // Close dialog
                        try {
                          // final commentService = ref.read(taskCommentServiceProvider); // Already defined above
                          await commentService.updateComment(
                            comment.id,
                            commentController.text.trim(),
                          );
                          // Comment list will auto-refresh via the provider
                        } catch (e) {
                          // Guard BuildContext use
                          if (mounted) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Failed to update comment: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            } else if (value == 'delete') {
              // Show delete confirmation
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Comment'),
                  content: const Text('Are you sure you want to delete this comment? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      child: const Text('CANCEL'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        navigator.pop(); 
                        try {
                          // final commentService = ref.read(taskCommentServiceProvider); // Already defined above
                          await commentService.deleteComment(comment.id);
                          // Comment list will auto-refresh via the provider
                        } catch (e) {
                          // Guard BuildContext use
                          if (mounted) { 
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text('Failed to delete comment: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Method to show dialog for adding a new subtask
  void _showAddSubtaskDialog(BuildContext context, WidgetRef ref, String parentTaskId) {
    final subtaskTitleController = TextEditingController();
    String selectedPriority = 'medium'; // Default priority

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Subtask'),
          content: StatefulBuilder( // Use StatefulBuilder to update priority dropdown within dialog
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: subtaskTitleController,
                    decoration: const InputDecoration(hintText: 'Subtask title'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Priority'),
                    value: selectedPriority,
                    items: ['low', 'medium', 'high'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPriority = newValue;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('ADD'),
              onPressed: () async {
                if (subtaskTitleController.text.trim().isEmpty) return;
                
                Navigator.pop(context); // Close dialog
                try {
                  final taskService = ref.read(taskServiceProvider);
                  await taskService.createTask(
                    title: subtaskTitleController.text.trim(),
                    priority: selectedPriority,
                    parentTaskId: parentTaskId,
                    // categoryId and entityId could be inherited from parent or set explicitly if needed
                  );
                  // Guard ref.invalidate if it indirectly uses context
                  if (!mounted) return;
                     
                  ref.invalidate(subtasksProviderFamily(parentTaskId)); // Refresh subtask list
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add subtask: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Method to show dialog for sharing a task
  void _showShareTaskDialog(BuildContext context, WidgetRef ref, TaskModel task) {
    final userIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share Task'),
          content: TextField(
            controller: userIdController,
            decoration: const InputDecoration(hintText: 'Enter User ID or Email to share with'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('SHARE'),
              onPressed: () async {
                if (userIdController.text.trim().isEmpty) return;
                
                final String userIdToShareWith = userIdController.text.trim();
                Navigator.pop(context); // Close dialog
                
                try {
                  final taskService = ref.read(taskServiceProvider);
                  // Note: TaskService.shareTaskWithUser expects a user ID.
                  // If an email is entered, it needs to be resolved to a user ID first.
                  // This is a simplification for now. A real implementation would search users.
                  // For now, assuming direct User ID is entered.
                  await taskService.shareTaskWithUser(task.id, userIdToShareWith);
                  
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Task shared with $userIdToShareWith')),
                  );
                  // Optionally, refresh task details if shared status is displayed
                  // ref.invalidate(taskDetailProviderFamily(task.id));
                } catch (e) {
                  // Guard BuildContext use
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to share task: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
