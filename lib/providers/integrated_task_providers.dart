import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/repositories/task_repository.dart'; // Import the abstract TaskRepository
import 'package:vuet_app/repositories/implementations/supabase_task_repository.dart'; // Import the concrete implementation
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:uuid/uuid.dart';

// Provider for integrated task operations
final integratedTaskRepositoryProvider = Provider<TaskRepository>((ref) {
  return ref.watch(supabaseTaskRepositoryProvider);
});

// Provider to get tasks generated from a specific routine
final tasksFromRoutineProvider = FutureProvider.family<List<TaskModel>, String>((ref, routineId) async {
  final repository = ref.watch(integratedTaskRepositoryProvider);
  try {
    final tasks = await repository.getTasks();
    return tasks.where((task) => task.routineId == routineId).toList();
  } catch (e) {
    return [];
  }
});

// Provider to get tasks generated from a specific routine instance
// Note: Since routineInstanceId was removed from TaskModel, we'll filter by routineId and date range
final tasksFromRoutineInstanceProvider = FutureProvider.family<List<TaskModel>, String>((ref, routineId) async {
  final repository = ref.watch(integratedTaskRepositoryProvider);
  try {
    final tasks = await repository.getTasks();
    return tasks.where((task) => task.routineId == routineId).toList();
  } catch (e) {
    return [];
  }
});

// Provider to get tasks linked to a specific list item
final tasksFromListItemProvider = FutureProvider.family<List<TaskModel>, String>((ref, listItemId) async {
  try {
    // This would need a linkedListItemId field in TaskModel, or we can use a different approach
    // For now, we'll return empty list and implement this when we add the field
    return [];
  } catch (e) {
    return [];
  }
});

// StateNotifier for integrated task operations
class IntegratedTaskNotifier extends StateNotifier<AsyncValue<void>> {
  final TaskRepository _taskRepository; // Changed type to TaskRepository
  final Ref _ref;

  IntegratedTaskNotifier(this._taskRepository, this._ref) 
      : super(const AsyncValue.data(null));

  /// Create a task from a routine template
  Future<TaskModel> createTaskFromRoutine(
    RoutineModel routine,
    RoutineTaskTemplateModel template,
    DateTime scheduledDate,
    String routineInstanceId, // Keep parameter for compatibility but don't use it in TaskModel
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      final task = TaskModel(
        id: const Uuid().v4(),
        title: template.title,
        description: template.description,
        dueDate: scheduledDate,
        priority: template.priority?.name ?? 'medium',
        status: 'pending',
        isRecurring: false,
        categoryId: template.categoryId,
        createdById: user.id,
        assignedToId: user.id,
        routineId: routine.id,
        isGeneratedFromRoutine: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _taskRepository.createTask(task);
      
      // Refresh related providers
      _ref.invalidate(tasksFromRoutineProvider(routine.id));
      _ref.invalidate(tasksFromRoutineInstanceProvider(routine.id));
      
      state = const AsyncValue.data(null);
      return task;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Create a task from a list item
  Future<TaskModel> createTaskFromListItem(ListItemModel listItem) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) throw Exception('User not authenticated');

      final task = TaskModel(
        id: const Uuid().v4(),
        title: listItem.name,
        description: listItem.description,
        dueDate: DateTime.now().add(const Duration(days: 1)), // Default to tomorrow
        priority: 'medium',
        status: 'pending',
        isRecurring: false,
        createdById: user.id,
        assignedToId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _taskRepository.createTask(task);

      // Update the list item to link it to the task
      // This would need to be implemented in the list repository
      // final updatedListItem = listItem.copyWith(
      //   linkedTaskId: task.id,
      //   isConvertedFromTask: true,
      //   updatedAt: DateTime.now(),
      // );
      // await _listRepository.updateListItem(updatedListItem);

      // Refresh related providers
      _ref.invalidate(tasksFromListItemProvider(listItem.id));
      
      state = const AsyncValue.data(null);
      return task;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update task completion and sync with linked list item
  Future<void> completeTaskAndSyncListItem(String taskId) async {
    state = const AsyncValue.loading();
    try {
      // Complete the task
      await _taskRepository.completeTask(taskId);

      // Get the task to check if it's linked to a list item
      final task = await _taskRepository.getTaskById(taskId);
      if (task != null) {
        // If we had a linkedListItemId field, we would update the list item here
        // For now, this is a placeholder for future implementation
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Generate multiple tasks from routine templates
  Future<List<TaskModel>> generateTasksFromRoutineTemplates(
    RoutineModel routine,
    List<RoutineTaskTemplateModel> templates,
    DateTime scheduledDate,
  ) async {
    state = const AsyncValue.loading();
    try {
      final routineInstanceId = '${routine.id}_${scheduledDate.millisecondsSinceEpoch}';
      final tasks = <TaskModel>[];

      for (final template in templates) {
        final task = await createTaskFromRoutine(
          routine,
          template,
          scheduledDate,
          routineInstanceId,
        );
        tasks.add(task);
      }

      state = const AsyncValue.data(null);
      return tasks;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Get analytics data for routine-generated tasks
  Future<Map<String, dynamic>> getRoutineTaskAnalytics(String routineId) async {
    try {
      final tasks = await _ref.read(tasksFromRoutineProvider(routineId).future);
      
      final totalTasks = tasks.length;
      final completedTasks = tasks.where((task) => task.status == 'completed').length;
      final pendingTasks = tasks.where((task) => task.status == 'pending').length;
      final overdueTasks = tasks.where((task) => 
        task.dueDate != null && 
        task.dueDate!.isBefore(DateTime.now()) && 
        task.status != 'completed'
      ).length;

      return {
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
        'pendingTasks': pendingTasks,
        'overdueTasks': overdueTasks,
        'completionRate': totalTasks > 0 ? (completedTasks / totalTasks) : 0.0,
      };
    } catch (e) {
      return {
        'totalTasks': 0,
        'completedTasks': 0,
        'pendingTasks': 0,
        'overdueTasks': 0,
        'completionRate': 0.0,
      };
    }
  }
}

final integratedTaskNotifierProvider = StateNotifierProvider<IntegratedTaskNotifier, AsyncValue<void>>((ref) {
  final taskRepository = ref.watch(integratedTaskRepositoryProvider);
  return IntegratedTaskNotifier(taskRepository, ref);
});

// Provider for routine task analytics
final routineTaskAnalyticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, routineId) async {
  final notifier = ref.read(integratedTaskNotifierProvider.notifier);
  return notifier.getRoutineTaskAnalytics(routineId);
});

// Provider to get all tasks with integration context
final integratedTasksProvider = FutureProvider<List<TaskModel>>((ref) async {
  final repository = ref.watch(integratedTaskRepositoryProvider);
  return repository.getTasks();
});

// Provider to get tasks by integration type
final tasksByIntegrationTypeProvider = FutureProvider.family<List<TaskModel>, String>((ref, integrationType) async {
  final allTasks = await ref.watch(integratedTasksProvider.future);
  
  switch (integrationType) {
    case 'routine':
      return allTasks.where((task) => task.isGeneratedFromRoutine).toList();
    case 'manual':
      return allTasks.where((task) => !task.isGeneratedFromRoutine).toList();
    case 'overdue':
      return allTasks.where((task) => 
        task.dueDate != null && 
        task.dueDate!.isBefore(DateTime.now()) && 
        task.status != 'completed'
      ).toList();
    case 'completed':
      return allTasks.where((task) => task.status == 'completed').toList();
    default:
      return allTasks;
  }
});
