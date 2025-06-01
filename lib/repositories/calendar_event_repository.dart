import 'package:vuet_app/models/calendar_event_model.dart';

/// Repository interface for calendar events
abstract class CalendarEventRepository {
  /// Get all events for a user
  Future<List<CalendarEventModel>> getUserEvents(String userId);
  
  /// Get events for a user within a date range
  /// Used for efficient calendar view loading
  Future<List<CalendarEventModel>> getEventsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  );
  
  /// Create a new calendar event
  Future<CalendarEventModel> createEvent(CalendarEventModel event);
  
  /// Update an existing calendar event
  Future<CalendarEventModel> updateEvent(CalendarEventModel event);
  
  /// Delete a calendar event
  Future<void> deleteEvent(String eventId);
  
  /// Get a calendar event by ID
  Future<CalendarEventModel?> getEventById(String eventId);
  
  /// Get a stream of calendar events for real-time updates
  Stream<List<CalendarEventModel>> streamUserEvents(String userId);
  
  /// Get a stream of calendar events within a date range for real-time updates
  Stream<List<CalendarEventModel>> streamEventsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  );
}
