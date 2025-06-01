import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
// import 'package:vuet_app/services/task_service.dart'; // Old import for taskServiceProvider
import 'package:vuet_app/providers/task_providers.dart'; // New import for taskServiceProvider
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart'; 
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';

// Filter, Sort, and Search State Providers
enum TaskSortOption { dueDate, priority, title, createdAt }
final taskFilterStatusProvider = StateProvider<String?>((ref) => null); // null means all statuses
final taskSortOptionProvider = StateProvider<TaskSortOption>((ref) => TaskSortOption.createdAt);
final taskSortAscendingProvider = StateProvider<bool>((ref) => false); // Default to descending for createdAt
final taskSearchQueryProvider = StateProvider<String>((ref) => '');

// Provider to stream the list of tasks with filtering, sorting, and searching
final tasksStreamProvider = StreamProvider.autoDispose<List<TaskModel>>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  final filterStatus = ref.watch(taskFilterStatusProvider);
  final sortOption = ref.watch(taskSortOptionProvider);
  final sortAscending = ref.watch(taskSortAscendingProvider);
  final searchQuery = ref.watch(taskSearchQueryProvider).toLowerCase();

  // Base stream of all tasks
  final baseStream = taskService.taskUpdates(); // Assuming this gives all user's tasks

  return baseStream.map((tasks) {
    List<TaskModel> processedTasks = tasks;

    // Apply status filter
    if (filterStatus != null) {
      processedTasks = processedTasks.where((task) => task.status == filterStatus).toList();
    }

    // Apply search query filter (client-side on title and description)
    if (searchQuery.isNotEmpty) {
      processedTasks = processedTasks.where((task) {
        final titleMatch = task.title.toLowerCase().contains(searchQuery);
        final descriptionMatch = task.description?.toLowerCase().contains(searchQuery) ?? false;
        return titleMatch || descriptionMatch;
      }).toList();
    }

    // Apply sorting
    processedTasks.sort((a, b) {
      int comparison;
      switch (sortOption) {
        case TaskSortOption.dueDate:
          // Handle null due dates, maybe sort them to the end
          final aDueDate = a.dueDate ?? DateTime(2999); // Far future for nulls
          final bDueDate = b.dueDate ?? DateTime(2999);
          comparison = aDueDate.compareTo(bDueDate);
          break;
        case TaskSortOption.priority:
          // Define order for priority: high > medium > low
          const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          comparison = (priorityOrder[a.priority] ?? 3).compareTo(priorityOrder[b.priority] ?? 3);
          break;
        case TaskSortOption.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case TaskSortOption.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return sortAscending ? comparison : -comparison;
    });
    return processedTasks;
  });
});



/// Screen that displays a list of tasks using Riverpod and TaskService with real-time updates
class TaskListScreen extends ConsumerWidget {
  /// Constructor
  const TaskListScreen({super.key});

  void _navigateToCreateTask(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // No need to manually invalidate if using a stream that reflects DB changes
        // ref.invalidate(tasksStreamProvider); 
      }
    });
  }

  // Parameter currentCompletedStatus is a boolean indicating if the task is currently completed
  Future<void> _toggleTaskCompletion(WidgetRef ref, String taskId, bool currentCompletedStatus) async {
    final taskService = ref.read(taskServiceProvider);
    try {
      // If currently completed, new status is 'pending'. Otherwise, it's 'completed'.
      final newStatus = currentCompletedStatus ? 'pending' : 'completed';
      await taskService.updateTask(id: taskId, status: newStatus);
      // StreamProvider should update automatically
    } catch (e) {
      // Handle error, e.g., show a SnackBar
      debugPrint("Error toggling task completion: $e");
      if (ref.context.mounted) { // Check if context is still valid
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(content: Text('Error updating task: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteTask(BuildContext context, WidgetRef ref, String taskId, String taskTitle) async {
    // Optional: Show a confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text('Are you sure you want to delete "$taskTitle"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final taskService = ref.read(taskServiceProvider);
      try {
        await taskService.deleteTask(taskId);
        // StreamProvider should update automatically
        // ref.invalidate(tasksStreamProvider);
      } catch (e) {
        // Handle error
        debugPrint("Error deleting task: $e");
        if (ref.context.mounted) { // Check if context is still valid
          ScaffoldMessenger.of(ref.context).showSnackBar(
            SnackBar(content: Text('Error deleting task: ${e.toString()}')),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksStreamProvider);
    // final currentFilterStatus = ref.watch(taskFilterStatusProvider); // Not directly used in build for now
    // final currentSortOption = ref.watch(taskSortOptionProvider); // Not directly used in build for now
    // final currentSortAscending = ref.watch(taskSortAscendingProvider); // Not directly used in build for now
    final searchQueryController = TextEditingController(text: ref.watch(taskSearchQueryProvider));


    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Search Tasks",
            onPressed: () {
              // Could expand a search bar in AppBar or show a dialog
              // For simplicity, let's use a dialog for now
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search Tasks'),
                  content: TextField(
                    controller: searchQueryController,
                    decoration: const InputDecoration(hintText: 'Enter search term...'),
                    autofocus: true,
                    onChanged: (value) {
                      // Debounce could be added here for performance
                      ref.read(taskSearchQueryProvider.notifier).state = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Clear search when dialog is dismissed this way
                        // ref.read(taskSearchQueryProvider.notifier).state = ''; // Optional: clear on close
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          PopupMenuButton<TaskSortOption>(
            icon: const Icon(Icons.sort),
            tooltip: "Sort by",
            onSelected: (TaskSortOption result) {
              final currentSortOption = ref.read(taskSortOptionProvider);
              final currentSortAscending = ref.read(taskSortAscendingProvider);
              if (result == currentSortOption) {
                ref.read(taskSortAscendingProvider.notifier).state = !currentSortAscending;
              } else {
                ref.read(taskSortOptionProvider.notifier).state = result;
                ref.read(taskSortAscendingProvider.notifier).state = (result == TaskSortOption.createdAt) ? false : true; // Default desc for created, asc for others
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskSortOption>>[
              const PopupMenuItem<TaskSortOption>(
                value: TaskSortOption.createdAt,
                child: Text('Sort by Date Created'),
              ),
              const PopupMenuItem<TaskSortOption>(
                value: TaskSortOption.dueDate,
                child: Text('Sort by Due Date'),
              ),
              const PopupMenuItem<TaskSortOption>(
                value: TaskSortOption.priority,
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem<TaskSortOption>(
                value: TaskSortOption.title,
                child: Text('Sort by Title'),
              ),
            ],
          ),
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: "Filter by status",
            onSelected: (String? result) {
              ref.read(taskFilterStatusProvider.notifier).state = result;
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String?>>[
              const PopupMenuItem<String?>(
                value: null, // Represents 'All'
                child: Text('All Statuses'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String?>(
                value: 'pending',
                child: Text('Pending'),
              ),
              const PopupMenuItem<String?>(
                value: 'in_progress',
                child: Text('In Progress'),
              ),
              const PopupMenuItem<String?>(
                value: 'completed',
                child: Text('Completed'),
              ),
            ],
          ),
        ],
      ),
      body: tasksAsyncValue.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks found. Tap + to create one!',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              // Invalidate to force a re-fetch if pull-to-refresh is desired
              // though StreamProvider should handle live updates.
              ref.invalidate(tasksStreamProvider);
            },
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final TaskModel task = tasks[index];
                final bool isCompleted = task.status == 'completed';
                return ListTile(
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (bool? value) {
                      if (value != null) {
                        // Pass the boolean 'isCompleted'
                        _toggleTaskCompletion(ref, task.id, isCompleted); 
                      }
                    },
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.description ?? 'No description', maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    tooltip: 'Delete Task',
                    onPressed: () => _deleteTask(context, ref, task.id, task.title),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(taskId: task.id),
                      ),
                    ).then((_) {
                       // Stream should auto-update, but explicit invalidate can be used if needed
                       // ref.invalidate(tasksStreamProvider);
                    });
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading tasks: $err',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(tasksStreamProvider), // Changed to tasksStreamProvider
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateTask(context, ref),
        tooltip: 'Create Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
