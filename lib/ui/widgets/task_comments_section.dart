import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vuet_app/services/task_comment_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/widgets/task_comment_item.dart';

/// Widget to display and manage comments for a task
class TaskCommentsSection extends StatefulWidget {
  /// The ID of the task
  final String taskId;

  /// Constructor
  const TaskCommentsSection({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskCommentsSection> createState() => _TaskCommentsSectionState();
}

class _TaskCommentsSectionState extends State<TaskCommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  bool _isSubmitting = false;
  bool _isExpanded = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    // Unsubscribe from real-time updates
    final commentService = Provider.of<TaskCommentService>(context, listen: false);
    commentService.unsubscribeFromComments(widget.taskId);
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    final commentService = Provider.of<TaskCommentService>(context, listen: false);
    
    // Load initial comments
    await commentService.loadComments(widget.taskId);
    
    // Subscribe to real-time updates
    commentService.subscribeToComments(widget.taskId);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    final commentService = Provider.of<TaskCommentService>(context, listen: false);
    final result = await commentService.addComment(widget.taskId, text);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (result != null) {
        _commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add comment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskCommentService>(
      builder: (context, commentService, child) {
        final comments = commentService.getCommentsForTask(widget.taskId);
        final commentCount = comments.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with expand/collapse
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Comments ($commentCount)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            const Divider(),

            // Comments section (expandable)
            if (_isExpanded) ...[
              // Loading indicator
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              // Comments list
              else if (comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      'No comments yet.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return TaskCommentItem(
                      key: Key(comment.id),
                      comment: comment,
                      onDeleted: () {
                        // Will be handled by the stream subscription
                      },
                      onEdited: () {
                        // Will be handled by the stream subscription
                      },
                    );
                  },
                ),

              const SizedBox(height: 16),

              // Add comment form
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      focusNode: _commentFocus,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitComment,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
