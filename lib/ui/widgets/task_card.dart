import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:intl/intl.dart';

/// A card widget that displays a task
class TaskCard extends StatefulWidget {
  /// The task to display
  final TaskModel task;
  
  /// Callback when the task is tapped
  final VoidCallback? onTap;
  
  /// Callback when the task completion status is changed
  final Function(bool)? onCompletionChanged;

  /// Constructor
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onCompletionChanged,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  TaskCategoryModel? _category;
  bool _isLoadingCategory = false;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.categoryId != widget.task.categoryId) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    if (widget.task.categoryId == null) return;
    
    setState(() {
      _isLoadingCategory = true;
    });
    
    try {
      final category = await TaskCategoryService().getCategoryById(widget.task.categoryId!);
      setState(() {
        _category = category;
        _isLoadingCategory = false;
      });
    } catch (e) {
      // Silent failure, just don't show category
      setState(() {
        _isLoadingCategory = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.task.status == 'completed';
    final priorityColor = AppTheme.getPriorityColor(widget.task.priority);
    final statusColor = AppTheme.getStatusColor(widget.task.status);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Color.fromRGBO(
            (priorityColor.r * 255.0).round(),
            (priorityColor.g * 255.0).round(),
            (priorityColor.b * 255.0).round(),
            0.3,
          ),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: priorityColor,
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? AppTheme.textLight : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: isCompleted,
                      activeColor: AppTheme.completedColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: widget.onCompletionChanged != null 
                          ? (value) => widget.onCompletionChanged!(value ?? false)
                          : null,
                    ),
                  ],
                ),
                if (widget.task.description != null && widget.task.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.task.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isCompleted ? AppTheme.textLight : AppTheme.textSecondary,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                
                // Category chip
                if (_category != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Color.fromRGBO(
                            (_getCategoryColor(_category!.color).r * 255.0).round(),
                            (_getCategoryColor(_category!.color).g * 255.0).round(),
                            (_getCategoryColor(_category!.color).b * 255.0).round(),
                            0.2,
                          ),
                          avatar: _category!.icon != null 
                              ? Icon(
                                  _getCategoryIcon(_category!.icon!),
                                  size: 14,
                                  color: _getCategoryColor(_category!.color),
                                )
                              : null,
                          label: Text(
                            _category!.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getCategoryColor(_category!.color),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        ),
                      ],
                    ),
                  ),
                ] else if (_isLoadingCategory) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: const Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Colors.grey,
                      avatar: SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      label: Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    ),
                  ),
                ],
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.task.dueDate != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: _getDueDateColor(widget.task.dueDate!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, y').format(widget.task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getDueDateColor(widget.task.dueDate!),
                            ),
                          ),
                        ],
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(
                          (statusColor.r * 255.0).round(),
                          (statusColor.g * 255.0).round(),
                          (statusColor.b * 255.0).round(),
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(widget.task.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.task.isRecurring) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.repeat,
                        size: 14,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Recurring',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format the status for display
  String _formatStatus(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      default:
        return status.substring(0, 1).toUpperCase() + status.substring(1);
    }
  }

  /// Get color for due date based on how close it is
  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
    
    final difference = dueDay.difference(today).inDays;
    
    if (difference < 0) {
      return Colors.red; // Overdue
    } else if (difference == 0) {
      return Colors.orange; // Due today
    } else if (difference <= 3) {
      return Colors.amber; // Due soon
    } else {
      return AppTheme.textLight; // Due later
    }
  }
  
  /// Convert hex color string to Color
  Color _getCategoryColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      return Color(int.parse('FF${hexColor.substring(1)}', radix: 16));
    }
    return Colors.grey;
  }
  
  /// Get constant IconData for category icons (fixes tree shaking issue)
  IconData _getCategoryIcon(String iconString) {
    // Convert common icon codes to constant IconData
    switch (iconString) {
      case '57421': // work
        return Icons.work;
      case '58136': // home
        return Icons.home;
      case '58717': // school
        return Icons.school;
      case '59574': // shopping_cart
        return Icons.shopping_cart;
      case '57415': // fitness_center
        return Icons.fitness_center;
      case '57846': // restaurant
        return Icons.restaurant;
      case '58717': // book
        return Icons.book;
      case '58648': // flight
        return Icons.flight;
      case '58276': // local_hospital
        return Icons.local_hospital;
      case '58291': // directions_car
        return Icons.directions_car;
      default:
        // Fallback to a default icon for unrecognized codes
        return Icons.category;
    }
  }
}
