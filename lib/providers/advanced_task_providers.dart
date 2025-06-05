import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/repositories/advanced_task_repository.dart';
import 'package:vuet_app/models/advanced_task_models.dart';
import 'package:vuet_app/services/auth_service.dart';

// Provider for AdvancedTaskRepository
final advancedTaskRepositoryProvider = Provider<AdvancedTaskRepository>((ref) {
  return AdvancedTaskRepository();
});

// Provider for creating FlexibleTask
final createFlexibleTaskProvider = FutureProvider.family<FlexibleTask, FlexibleTask>((ref, task) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  return await repository.createFlexibleTask(task);
});

// Provider for creating FixedTask
final createFixedTaskProvider = FutureProvider.family<FixedTask, FixedTask>((ref, task) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  return await repository.createFixedTask(task);
});

// Provider for getting flexible tasks by urgency
final flexibleTasksByUrgencyProvider = FutureProvider.family<List<FlexibleTask>, TaskUrgency>((ref, urgency) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) throw Exception('User not authenticated');
  
  return await repository.getFlexibleTasksByUrgency(user.id, urgency);
});

// Provider for getting unscheduled flexible tasks
final unscheduledFlexibleTasksProvider = FutureProvider<List<FlexibleTask>>((ref) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) throw Exception('User not authenticated');
  
  return await repository.getUnscheduledFlexibleTasks(user.id);
});

// Provider for getting fixed tasks in date range
final fixedTasksInRangeProvider = FutureProvider.family<List<FixedTask>, DateRange>((ref, dateRange) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) throw Exception('User not authenticated');
  
  return await repository.getFixedTasksInRange(user.id, dateRange.start, dateRange.end);
});

// Provider for detecting scheduling conflicts
final schedulingConflictsProvider = FutureProvider.family<List<FixedTask>, ConflictCheck>((ref, conflictCheck) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) throw Exception('User not authenticated');
  
  return await repository.getConflictingTasks(
    user.id,
    conflictCheck.startDateTime,
    conflictCheck.endDateTime,
    excludeTaskId: conflictCheck.excludeTaskId,
  );
});

// Provider for scheduling flexible tasks
final scheduleFlexibleTaskProvider = FutureProvider.family<FlexibleTask, SmartScheduleRequest>((ref, request) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  return await repository.scheduleFlexibleTask(
    request.taskId,
    request.scheduledStartTime,
    request.scheduledEndTime,
  );
});

// Provider for getting all advanced tasks for user
final allAdvancedTasksProvider = FutureProvider<List<AdvancedTask>>((ref) async {
  final repository = ref.watch(advancedTaskRepositoryProvider);
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) throw Exception('User not authenticated');
  
  final flexibleTasks = await repository.getFlexibleTasks(user.id);
  final fixedTasks = await repository.getFixedTasks(user.id);
  
  List<AdvancedTask> allTasks = [];
  allTasks.addAll(flexibleTasks.map((task) => AdvancedTask.flexible(task)));
  allTasks.addAll(fixedTasks.map((task) => AdvancedTask.fixed(task)));
  
  return allTasks;
});

// Helper classes for provider parameters
class DateRange {
  final DateTime start;
  final DateTime end;
  
  const DateRange({required this.start, required this.end});
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateRange && other.start == start && other.end == end;
  }
  
  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

class ConflictCheck {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? excludeTaskId;
  
  const ConflictCheck({
    required this.startDateTime,
    required this.endDateTime,
    this.excludeTaskId,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConflictCheck &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.excludeTaskId == excludeTaskId;
  }
  
  @override
  int get hashCode => startDateTime.hashCode ^ endDateTime.hashCode ^ excludeTaskId.hashCode;
}

class SmartScheduleRequest {
  final String taskId;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  
  const SmartScheduleRequest({
    required this.taskId,
    required this.scheduledStartTime,
    required this.scheduledEndTime,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmartScheduleRequest &&
        other.taskId == taskId &&
        other.scheduledStartTime == scheduledStartTime &&
        other.scheduledEndTime == scheduledEndTime;
  }
  
  @override
  int get hashCode => taskId.hashCode ^ scheduledStartTime.hashCode ^ scheduledEndTime.hashCode;
}
