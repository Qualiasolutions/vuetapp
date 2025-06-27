import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/repositories/supabase_task_repository.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/config/theme_config.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

/// Provider for tasks filtered by tag
final tagFilteredTasksProvider = FutureProvider.family<List<TaskModel>, String>(
  (ref, tagCode) async {
    final supabase = SupabaseConfig.client;
    final repository = ref.watch(taskRepositoryProvider);
    
    // First get all entity IDs that have this tag
    final entityTagsResponse = await supabase
        .from('entity_tags')
        .select('entity_id')
        .eq('tag_code', tagCode);
    
    if (entityTagsResponse.isEmpty) {
      return [];
    }
    
    // Extract entity IDs
    final entityIds = entityTagsResponse.map((e) => e['entity_id'] as String).toList();
    
    // Get all tasks related to these entities
    return await repository.getTasksByEntityIds(entityIds);
  },
);

/// Provider for refreshing tag-filtered tasks
final tagFilterRefreshProvider = StateProvider.family<bool, String>((ref, _) => false);

/// Screen that displays tasks filtered by a specific tag
class TagFilterTaskScreen extends ConsumerStatefulWidget {
  /// The category name for display purposes
  final String categoryName;
  
  /// The subcategory name for display purposes
  final String subcategoryName;
  
  /// The tag code to filter by (e.g., "PETS__FEEDING")
  final String tagCode;
  
  /// Optional entity ID to return to after task creation
  final String? entityId;

  /// Constructor
  const TagFilterTaskScreen({
    super.key,
    required this.categoryName,
    required this.subcategoryName,
    required this.tagCode,
    this.entityId,
  });

  @override
  ConsumerState<TagFilterTaskScreen> createState() => _TagFilterTaskScreenState();
}

class _TagFilterTaskScreenState extends ConsumerState<TagFilterTaskScreen> {
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshTasks() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    // Toggle refresh state to force provider to refresh
    ref.read(tagFilterRefreshProvider(widget.tagCode).notifier).state = 
      !ref.read(tagFilterRefreshProvider(widget.tagCode));
    
    // Wait for a moment to show the refresh indicator
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the refresh trigger
    ref.watch(tagFilterRefreshProvider(widget.tagCode));
    
    // Get the tasks filtered by tag
    final tasksAsync = ref.watch(tagFilteredTasksProvider(widget.tagCode));
    
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subcategoryName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.categoryName,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.darkJungleGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
            tooltip: 'Refresh tasks',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return _buildEmptyState(context);
          }
          
          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: Column(
              children: [
                // Task count indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(Icons.tag, size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'} with "${widget.subcategoryName}" tag',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Tasks list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _buildTaskCard(context, task);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading tasks',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _refreshTasks,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateTask(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateTask(BuildContext context) {
    // Navigate to create task screen with pre-filled tag
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTaskScreen(
          initialTagCode: widget.tagCode,
          initialCategoryName: widget.categoryName,
          initialSubcategoryName: widget.subcategoryName,
          entityId: widget.entityId,
        ),
      ),
    ).then((created) {
      if (created == true) {
        // Refresh the tasks list if a task was created
        _refreshTasks();
      }
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tag,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'No ${widget.subcategoryName} tasks yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first task with the ${widget.subcategoryName} tag',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateTask(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task) {
    final bool isCompleted = task.status == 'completed';
    final bool isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !isCompleted;
        
    return VuetTaskCard(
      task: task,
      onTap: () => _navigateToTaskDetail(context, task),
      onStatusChanged: (newStatus) => _updateTaskStatus(task, newStatus),
    );
  }

  void _navigateToTaskDetail(BuildContext context, TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    ).then((updated) {
      if (updated == true) {
        // Refresh the tasks list if the task was updated
        _refreshTasks();
      }
    });
  }

  Future<void> _updateTaskStatus(TaskModel task, String newStatus) async {
    try {
      final repository = ref.read(taskRepositoryProvider);
      await repository.updateTask(
        task.id,
        {'status': newStatus},
      );
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'completed'
                  ? 'Task marked as complete'
                  : 'Task marked as incomplete',
            ),
            backgroundColor: newStatus == 'completed'
                ? Colors.green
                : AppColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'UNDO',
              textColor: Colors.white,
              onPressed: () {
                _updateTaskStatus(
                  task,
                  newStatus == 'completed' ? 'pending' : 'completed',
                );
              },
            ),
          ),
        );
      }
      
      // Refresh the tasks list
      _refreshTasks();
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    }
    
    return DateFormat('MMM d, yyyy').format(date);
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
