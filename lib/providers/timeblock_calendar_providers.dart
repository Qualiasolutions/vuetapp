import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/providers/timeblock_providers.dart';

/// Helper function to convert a TimeblockModel to a CalendarEventModel for a specific date
CalendarEventModel _timeblockToCalendarEvent(TimeblockModel timeblock, DateTime date) {
  // Parse the time strings (HH:mm:ss) to get hour and minute
  final startTimeParts = timeblock.startTime.split(':');
  final endTimeParts = timeblock.endTime.split(':');
  
  final startHour = int.parse(startTimeParts[0]);
  final startMinute = int.parse(startTimeParts[1]);
  
  final endHour = int.parse(endTimeParts[0]);
  final endMinute = int.parse(endTimeParts[1]);
  
  // Create DateTime objects for the specific date with the timeblock's time
  final startDateTime = DateTime(
    date.year, 
    date.month, 
    date.day, 
    startHour, 
    startMinute,
  );
  
  final endDateTime = DateTime(
    date.year, 
    date.month, 
    date.day, 
    endHour, 
    endMinute,
  );
  
  // Add timeblock's color to the title if available for visual distinction in calendar
  final title = timeblock.title != null && timeblock.title!.isNotEmpty 
      ? timeblock.title! 
      : 'Timeblock';
  final description = timeblock.description != null && timeblock.description!.isNotEmpty
      ? '${timeblock.description!}\nColor: ${timeblock.color ?? "#FFFFFF"}' 
      : 'Color: ${timeblock.color ?? "#FFFFFF"}';
      
  return CalendarEventModel(
    id: 'timeblock-${timeblock.id}-${date.year}${date.month}${date.day}',
    ownerId: timeblock.userId,
    title: title,
    description: description,
    startTime: startDateTime,
    endTime: endDateTime,
    allDay: false,
    createdAt: timeblock.createdAt,
    updatedAt: timeblock.updatedAt,
  );
}

/// Provider for getting timeblock-derived calendar events for a specific day
final timeblockEventsForDayProvider = FutureProvider.family<List<CalendarEventModel>, DateTime>((ref, date) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return [];
  }
  
  // Get the day of the week (1 for Monday, 7 for Sunday)
  int dayOfWeek = date.weekday;
  // TableCalendar uses ISO 8601 (1 = Monday, 7 = Sunday)
  
  // Get all timeblocks for the user for this day of the week
  // Fixed: Use ref.read instead of ref.watch inside async function to prevent dependency change errors
  final timeblocks = await ref.read(
    userTimeblocksForDayProvider(
      UserTimeblocksForDayParams(userId: userId, dayOfWeek: dayOfWeek)
    ).future
  );
  
  // Convert each timeblock to a calendar event for this specific date
  return timeblocks.map((timeblock) => _timeblockToCalendarEvent(timeblock, date)).toList();
});

/// Provider that combines a StreamController for different types of calendar events
final combinedTimeblockEventsForDayProvider = StreamProvider.family<List<CalendarEventModel>, DateTime>((ref, date) {
  final controller = StreamController<List<CalendarEventModel>>();
  
  Future<void> fetchAndCombine() async {
    try {
      // Fixed: Use ref.read instead of ref.watch inside async function to prevent dependency change errors
      final timeblockEvents = await ref.read(timeblockEventsForDayProvider(date).future);
      
      if (!controller.isClosed) {
        controller.add(timeblockEvents);
      }
    } catch (e, stack) {
      if (!controller.isClosed) {
        controller.addError(e, stack);
      }
    }
  }
  
  fetchAndCombine();
  
  ref.onDispose(() {
    controller.close();
  });
  
  return controller.stream;
});
