import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_comment_model.dart';
import 'package:vuet_app/services/task_comment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added Riverpod
import 'package:vuet_app/ui/theme/app_theme.dart';

/// Widget to display a single task comment
class TaskCommentItem extends ConsumerStatefulWidget {
  /// The comment to display
  final TaskCommentModel comment;
  
  /// Callback when the comment is deleted
  final Function()? onDeleted;
  
  /// Callback when the comment is edited
  final Function()? onEdited;

  /// Constructor
  const TaskCommentItem({
    super.key,
    required this.comment,
    this.onDeleted,
    this.onEdited,
  });

  @override
  ConsumerState<TaskCommentItem> createState() => _TaskCommentItemState();
}

class _TaskCommentItemState extends ConsumerState<TaskCommentItem> {
  final TextEditingController _editController = TextEditingController();
  bool _isEditing = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _editController.text = widget.comment.text;
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteComment();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Use Riverpod provider for TaskCommentService
  // final TaskCommentService _commentService = TaskCommentService(); // Removed

  Future<void> _deleteComment() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    // Access the service via Riverpod
    final commentService = ref.read(taskCommentServiceProvider);
    final success = await commentService.deleteComment(widget.comment.id);

    if (mounted) {
      setState(() {
        _isDeleting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted')),
        );

        if (widget.onDeleted != null) {
          widget.onDeleted!();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete comment')),
        );
      }
    }
  }

  Future<void> _saveEditedComment() async {
    if (_editController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }
    
    final newText = _editController.text.trim();
    if (newText == widget.comment.text) {
      setState(() {
        _isEditing = false;
      });
      return;
    }

    // Access the service via Riverpod
    final commentService = ref.read(taskCommentServiceProvider);
    final updatedComment = await commentService.updateComment(
      widget.comment.id,
      newText,
    );

    if (mounted) {
      setState(() {
        _isEditing = false;
      });

      if (updatedComment != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment updated')),
        );

        if (widget.onEdited != null) {
          widget.onEdited!();
        }
      } else {
        // Reset text controller to original comment
        _editController.text = widget.comment.text;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update comment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the service via Riverpod
    final commentService = ref.watch(taskCommentServiceProvider);
    final canModify = commentService.canModifyComment(widget.comment);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment header with user info and timestamp
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primary,
                  child: Text(
                    widget.comment.userInitial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // User name and timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.userDisplayName ?? 'User',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.comment.timeAgo,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          if (widget.comment.isEdited) ...[
                            const SizedBox(width: 4),
                            const Text(
                              '(edited)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions menu (edit, delete)
                if (canModify)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        setState(() {
                          _isEditing = true;
                          _editController.text = widget.comment.text;
                        });
                      } else if (value == 'delete') {
                        _showDeleteConfirmation();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Comment content
            if (_isEditing) 
              // Edit mode
              Column(
                children: [
                  TextField(
                    controller: _editController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _editController.text = widget.comment.text;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveEditedComment,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              )
            else
              // Display mode
              Text(
                widget.comment.text,
                style: const TextStyle(fontSize: 16),
              ),
              
            // Loading indicator when deleting
            if (_isDeleting)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
