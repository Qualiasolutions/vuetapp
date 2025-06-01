import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/services/calendar_event_service.dart';
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/providers/timeblock_calendar_providers.dart';

// Helper function to convert TaskModel to CalendarEventModel
CalendarEventModel _taskToCalendarEvent(TaskModel task) {
  // Determine display prefix based on task type
  String displayPrefix;
  switch (task.taskType) {
    case TaskType.appointment:
      displayPrefix = 'Appointment';
      break;
    case TaskType.activity:
      displayPrefix = 'Activity';
      break;
    case TaskType.transport:
      displayPrefix = 'Transport';
      break;
    case TaskType.accommodation:
      displayPrefix = 'Accommodation';
      break;
    case TaskType.anniversary:
      displayPrefix = 'Anniversary';
      break;
    case TaskType.dueDate:
      displayPrefix = 'Due Date';
      break;
    default:
      displayPrefix = 'Task';
      break;
  }

  return CalendarEventModel(
    // Assuming CalendarEventModel has an 'id' that can accommodate task IDs,
    // or we generate a unique one if tasks and events can have overlapping IDs.
    // For simplicity, prefixing task ID. This might need a more robust solution
    // if CalendarEventModel's ID has specific format or uniqueness constraints
    // across both actual events and task-derived events.
    id: 'task-${task.id}', 
    userId: task.createdById ?? '', // Or assignedToId, depending on context
    title: '$displayPrefix: ${task.title}',
    description: task.description,
    startTime: task.dueDate!, // Task due date becomes start time
    endTime: task.dueDate!,   // Task due date also becomes end time (all-day event)
    allDay: true,
    // categoryId: task.categoryId, // If CalendarEventModel has categoryId
    // color: some_default_task_color, // If you want to color tasks differently
    // recurringRule: task.isRecurring ? task.recurrencePattern.toString() : null, // Simplified
    // location: null, // Tasks don't typically have locations in this model
    createdAt: task.createdAt,
    updatedAt: task.updatedAt,
    // Add a field to distinguish it, or handle in UI based on ID prefix or title
    // For example, could add `String? eventType;` to CalendarEventModel
  );
}

/// Provider for getting all calendar events for the current user
final userEventsProvider = StreamProvider<List<CalendarEventModel>>((ref) {
  final calendarService = ref.watch(calendarEventServiceProvider);
final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;
  
  if (userId == null) {
    // Return empty list if not logged in
    return Stream.value([]);
  }
  
  return calendarService.getUserEventsStream(userId);
});

/// Provider for calendar events within a specified date range
final dateRangeEventsProvider = StreamProvider.family<List<CalendarEventModel>, DateTimeRange>((ref, dateRange) {
  final calendarService = ref.watch(calendarEventServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;
  
  if (userId == null) {
    // Return empty list if not logged in
    return Stream.value([]);
  }
  
  return calendarService.getEventsForDateRangeStream(
    userId: userId,
    startDate: dateRange.start,
    endDate: dateRange.end,
  );
});

/// Provider for calendar events for a specific day, combining regular events, tasks, and timeblocks
final dayEventsProvider = StreamProvider.family<List<CalendarEventModel>, DateTime>((ref, date) {
  final calendarService = ref.watch(calendarEventServiceProvider);
  final taskService = ref.watch(taskServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;

  if (userId == null) {
    return Stream.value([]);
  }

  final startDate = DateTime(date.year, date.month, date.day, 0, 0, 0);
  final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

  final eventsStream = calendarService.getEventsForDateRangeStream(
    userId: userId,
    startDate: startDate,
    endDate: endDate,
  );
  
  // Create a controller for the combined stream
  final controller = StreamController<List<CalendarEventModel>>();

  // Function to fetch and combine all event types
  Future<void> fetchDataAndCombine() async {
    try {
      // Get regular calendar events
      final List<CalendarEventModel> calendarEvents = await eventsStream.first;
      
      // Get tasks with due dates
      final List<TaskModel> tasks = await taskService.getFilteredTasks(
        dueDateFrom: startDate,
        dueDateTo: endDate,
      );
      
      final List<CalendarEventModel> taskEvents = tasks
          .where((task) => task.dueDate != null)
          .map(_taskToCalendarEvent)
          .toList();
      
      // Get timeblocks for this day
      List<CalendarEventModel> timeblockEvents = [];
      
      // Try to get the timeblock events directly from the provider
      try {
        timeblockEvents = await ref.watch(timeblockEventsForDayProvider(date).future);
      } catch (e) {
        debugPrint('Error fetching timeblock events: $e');
      }
      
      // Combine all event types
      final combinedEvents = <CalendarEventModel>[
        ...calendarEvents, 
        ...taskEvents,
        ...timeblockEvents
      ];
      
      // Sort by start time
      combinedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
      
      if (!controller.isClosed) {
        controller.add(combinedEvents);
      }
    } catch (e, stack) {
      if (!controller.isClosed) {
        controller.addError(e, stack);
      }
    }
  }

  fetchDataAndCombine(); // Initial fetch

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});

/// Provider for calendar events for the current week
final weekEventsProvider = StreamProvider.family<List<CalendarEventModel>, DateTime>((ref, date) {
  final calendarService = ref.watch(calendarEventServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;
  
  if (userId == null) {
    // Return empty list if not logged in
    return Stream.value([]);
  }
  
  // Calculate start of week (Sunday) and end of week (Saturday)
  final startDate = date.subtract(Duration(days: date.weekday % 7));
  final startOfWeek = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
  
  final endDate = startOfWeek.add(const Duration(days: 6));
  final endOfWeek = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
  
  return calendarService.getEventsForDateRangeStream(
    userId: userId,
    startDate: startOfWeek,
    endDate: endOfWeek,
  );
});

/// Provider for calendar events for the current month, including timeblocks
final monthEventsProvider = StreamProvider.family<List<CalendarEventModel>, DateTime>((ref, date) {
  final calendarService = ref.watch(calendarEventServiceProvider);
  final taskService = ref.watch(taskServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final userId = authService.currentUser?.id;

  if (userId == null) {
    return Stream.value([]);
  }

  final startOfMonth = DateTime(date.year, date.month, 1, 0, 0, 0);
  final lastDay = _getLastDayOfMonth(date.year, date.month);
  final endOfMonth = DateTime(date.year, date.month, lastDay, 23, 59, 59);

  final eventsStream = calendarService.getEventsForDateRangeStream(
    userId: userId,
    startDate: startOfMonth,
    endDate: endOfMonth,
  );

  final controller = StreamController<List<CalendarEventModel>>();

  Future<void> fetchDataAndCombine() async {
    try {
      // Get regular calendar events
      final List<CalendarEventModel> calendarEvents = await eventsStream.first;
      
      // Get tasks with due dates
      final List<TaskModel> tasks = await taskService.getFilteredTasks(
        dueDateFrom: startOfMonth,
        dueDateTo: endOfMonth,
      );
      
      final List<CalendarEventModel> taskEvents = tasks
          .where((task) => task.dueDate != null)
          .map(_taskToCalendarEvent)
          .toList();
      
      // Get timeblocks for each day in the month
      List<CalendarEventModel> allTimeblockEvents = [];
      
      // Loop through each day in the month and fetch timeblocks
      for (int day = 1; day <= lastDay; day++) {
        final currentDate = DateTime(date.year, date.month, day);
        
        try {
          final timeblockEvents = await ref.watch(timeblockEventsForDayProvider(currentDate).future);
          allTimeblockEvents.addAll(timeblockEvents);
        } catch (e) {
          // Handle each day's errors separately to continue with other days
          debugPrint('Error fetching timeblock events for $currentDate: $e');
        }
      }
          
      // Combine all event types
      final combinedEvents = <CalendarEventModel>[
        ...calendarEvents,
        ...taskEvents,
        ...allTimeblockEvents
      ];
      
      // Sort by start time
      combinedEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

      if (!controller.isClosed) {
        controller.add(combinedEvents);
      }
    } catch (e, stack) {
      if (!controller.isClosed) {
        controller.addError(e, stack);
      }
    }
  }
  
  fetchDataAndCombine();

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});

/// Provider for a specific calendar event by ID
final calendarEventProvider = FutureProvider.family<CalendarEventModel?, String>((ref, eventId) async {
  final calendarService = ref.watch(calendarEventServiceProvider);
  return await calendarService.getEventById(eventId);
});

/// Helper class for date range parameters
class DateTimeRange {
  final DateTime start;
  final DateTime end;
  
  const DateTimeRange({
    required this.start,
    required this.end,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DateTimeRange &&
        other.start == start &&
        other.end == end;
  }
  
  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

/// Helper function to get the last day of a month
int _getLastDayOfMonth(int year, int month) {
  // Handle month 12 by using year+1 and month 1
  final nextMonth = month < 12 ? month + 1 : 1;
  final nextMonthYear = month < 12 ? year : year + 1;
  
  // First day of next month minus one day
  final lastDay = DateTime(nextMonthYear, nextMonth, 1)
      .subtract(const Duration(days: 1))
      .day;
      
  return lastDay;
}
