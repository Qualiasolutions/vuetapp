import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/providers/integrated_task_providers.dart';

/// Provider for task type filter state
final selectedTaskTypeFilterProvider = StateProvider<TaskType?>((ref) => null);

/// Provider for showing/hiding completed tasks in calendar
final showCompletedTasksProvider = StateProvider<bool>((ref) => true);

/// Provider for tasks grouped by date (for calendar highlighting)
final tasksByDateProvider = Provider<Map<DateTime, List<TaskModel>>>((ref) {
  final tasks = ref.watch(integratedTasksProvider);
  final showCompleted = ref.watch(showCompletedTasksProvider);
  final taskTypeFilter = ref.watch(selectedTaskTypeFilterProvider);

  return tasks.when(
    data: (taskList) {
      // Filter tasks based on completion status and task type
      var filteredTasks = taskList.where((task) {
        // Filter by completion status
        if (!showCompleted && task.status == 'completed') {
          return false;
        }

        // Filter by task type
        if (taskTypeFilter != null && task.taskType != taskTypeFilter) {
          return false;
        }

        return true;
      }).toList();

      // Group tasks by date
      final Map<DateTime, List<TaskModel>> tasksByDate = {};

      for (final task in filteredTasks) {
        DateTime? taskDate;

        // Determine the primary date for the task
        if (task.startDateTime != null) {
          taskDate = DateTime(
            task.startDateTime!.year,
            task.startDateTime!.month,
            task.startDateTime!.day,
          );
        } else if (task.dueDate != null) {
          taskDate = DateTime(
            task.dueDate!.year,
            task.dueDate!.month,
            task.dueDate!.day,
          );
        }

        if (taskDate != null) {
          tasksByDate.putIfAbsent(taskDate, () => []).add(task);
        }
      }

      return tasksByDate;
    },
    loading: () => <DateTime, List<TaskModel>>{},
    error: (_, __) => <DateTime, List<TaskModel>>{},
  );
});

/// Provider for getting tasks for a specific date
final tasksForDateProvider =
    FutureProvider.family<List<TaskModel>, DateTime>((ref, date) async {
  final tasksByDate = ref.watch(tasksByDateProvider);
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return tasksByDate[normalizedDate] ?? [];
});

/// Provider for task type counts (for statistics)
final taskTypeCountsProvider = Provider<Map<TaskType, int>>((ref) {
  final tasks = ref.watch(integratedTasksProvider);

  return tasks.when(
    data: (taskList) {
      final Map<TaskType, int> counts = {};

      for (final task in taskList) {
        if (task.taskType != null && task.status != 'completed') {
          counts[task.taskType!] = (counts[task.taskType!] ?? 0) + 1;
        }
      }

      return counts;
    },
    loading: () => <TaskType, int>{},
    error: (_, __) => <TaskType, int>{},
  );
});

/// Provider for upcoming tasks (next 7 days)
final upcomingTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(integratedTasksProvider);
  final now = DateTime.now();
  final nextWeek = now.add(const Duration(days: 7));

  return tasks.when(
    data: (taskList) {
      return taskList.where((task) {
        if (task.status == 'completed') return false;

        DateTime? taskDate = task.startDateTime ?? task.dueDate;
        if (taskDate == null) return false;

        return taskDate.isAfter(now) && taskDate.isBefore(nextWeek);
      }).toList()
        ..sort((a, b) {
          final aDate = a.startDateTime ?? a.dueDate ?? DateTime.now();
          final bDate = b.startDateTime ?? b.dueDate ?? DateTime.now();
          return aDate.compareTo(bDate);
        });
    },
    loading: () => <TaskModel>[],
    error: (_, __) => <TaskModel>[],
  );
});

/// Provider for overdue tasks
final overdueTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(integratedTasksProvider);
  final now = DateTime.now();

  return tasks.when(
    data: (taskList) {
      return taskList.where((task) {
        if (task.status == 'completed') return false;

        DateTime? taskDate = task.dueDate;
        if (taskDate == null) return false;

        // Task is overdue if due date is before today
        final today = DateTime(now.year, now.month, now.day);
        final dueDay = DateTime(taskDate.year, taskDate.month, taskDate.day);

        return dueDay.isBefore(today);
      }).toList()
        ..sort((a, b) {
          final aDate = a.dueDate ?? DateTime.now();
          final bDate = b.dueDate ?? DateTime.now();
          return aDate.compareTo(bDate);
        });
    },
    loading: () => <TaskModel>[],
    error: (_, __) => <TaskModel>[],
  );
});

/// Provider for tasks happening today
final todayTasksProvider = Provider<List<TaskModel>>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tasksForToday = ref.watch(tasksForDateProvider(today));

  return tasksForToday.when(
    data: (tasks) => tasks,
    loading: () => <TaskModel>[],
    error: (_, __) => <TaskModel>[],
  );
});

/// Provider for task type distribution (for charts/analytics)
final taskTypeDistributionProvider = Provider<Map<TaskType, double>>((ref) {
  final taskTypeCounts = ref.watch(taskTypeCountsProvider);

  if (taskTypeCounts.isEmpty) return {};

  final total = taskTypeCounts.values.fold<int>(0, (sum, count) => sum + count);
  if (total == 0) return {};

  return taskTypeCounts
      .map((type, count) => MapEntry(type, count / total * 100));
});

/// Provider for calendar events (days that have tasks)
final calendarEventsProvider = Provider<Map<DateTime, List<TaskType>>>((ref) {
  final tasksByDate = ref.watch(tasksByDateProvider);

  return tasksByDate.map((date, tasks) {
    final taskTypes = tasks
        .where((task) => task.taskType != null)
        .map((task) => task.taskType!)
        .toSet()
        .toList();
    return MapEntry(date, taskTypes);
  });
});

/// Helper function to check if a date has tasks
bool hasTasksOnDate(DateTime date, Map<DateTime, List<TaskModel>> tasksByDate) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return tasksByDate.containsKey(normalizedDate) &&
      tasksByDate[normalizedDate]!.isNotEmpty;
}

/// Helper function to get task types for a date
List<TaskType> getTaskTypesForDate(
    DateTime date, Map<DateTime, List<TaskModel>> tasksByDate) {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final tasks = tasksByDate[normalizedDate] ?? [];
  return tasks
      .where((task) => task.taskType != null)
      .map((task) => task.taskType!)
      .toSet()
      .toList();
}

/// Provider for monthly task summary
final monthlyTaskSummaryProvider =
    FutureProvider.family<Map<String, int>, DateTime>((ref, month) async {
  final firstDay = DateTime(month.year, month.month, 1);
  final lastDay = DateTime(month.year, month.month + 1, 0);

  final tasks = await ref.watch(integratedTasksProvider.future);

  final monthTasks = tasks.where((task) {
    final taskDate = task.startDateTime ?? task.dueDate;
    if (taskDate == null) return false;

    return taskDate.isAfter(firstDay.subtract(const Duration(days: 1))) &&
        taskDate.isBefore(lastDay.add(const Duration(days: 1)));
  }).toList();

  return {
    'total': monthTasks.length,
    'completed': monthTasks.where((t) => t.status == 'completed').length,
    'pending': monthTasks.where((t) => t.status == 'pending').length,
    'in_progress': monthTasks.where((t) => t.status == 'in_progress').length,
    'overdue': monthTasks.where((t) {
      final dueDate = t.dueDate;
      if (dueDate == null || t.status == 'completed') return false;
      return dueDate.isBefore(DateTime.now());
    }).length,
  };
});
