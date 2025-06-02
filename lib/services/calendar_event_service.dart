import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/repositories/calendar_event_repository.dart';
import 'package:vuet_app/repositories/supabase_calendar_event_repository.dart';
import 'package:vuet_app/utils/logger.dart';

/// Provider for the CalendarEventService
final calendarEventServiceProvider = Provider<CalendarEventService>((ref) {
  final supabase = Supabase.instance.client;
  final repository = SupabaseCalendarEventRepository(supabaseClient: supabase);
  // final notificationService = ref.watch(notificationServiceProvider); // Removed
  return CalendarEventService(
    repository: repository
    // notificationService: notificationService // Removed
  );
});

/// Service class for calendar event operations
class CalendarEventService {
  final CalendarEventRepository _repository;
  // final NotificationService _notificationService; // Removed

  /// Constructor for CalendarEventService
  CalendarEventService({
    required CalendarEventRepository repository,
    // required NotificationService notificationService, // Removed
  })  : _repository = repository;
        // _notificationService = notificationService; // Removed

  /// Get all events for the current user
  Future<List<CalendarEventModel>> getUserEvents(String userId) async {
    try {
      return await _repository.getUserEvents(userId);
    } catch (e) {
      _handleError('Failed to get user events', e);
      rethrow;
    }
  }

  /// Get events for a user within a date range
  Future<List<CalendarEventModel>> getEventsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      return await _repository.getEventsByDateRange(userId, startDate, endDate);
    } catch (e) {
      _handleError('Failed to get events by date range', e);
      rethrow;
    }
  }

  /// Create a new calendar event
  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    try {
      final createdEvent = await _repository.createEvent(event);
      // We don't handle UI notifications from the service layer
      // The UI layer (screens) should handle success notifications
      return createdEvent;
    } catch (e) {
      _handleError('Failed to create event', e);
      rethrow;
    }
  }

  /// Update an existing calendar event
  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    try {
      final updatedEvent = await _repository.updateEvent(event);
      // We don't handle UI notifications from the service layer
      // The UI layer (screens) should handle success notifications
      return updatedEvent;
    } catch (e) {
      _handleError('Failed to update event', e);
      rethrow;
    }
  }

  /// Delete a calendar event
  Future<void> deleteEvent(String eventId, String eventTitle) async {
    try {
      await _repository.deleteEvent(eventId);
      // We don't handle UI notifications from the service layer
      // The UI layer (screens) should handle success notifications
    } catch (e) {
      _handleError('Failed to delete event', e);
      rethrow;
    }
  }

  /// Get a calendar event by ID
  Future<CalendarEventModel?> getEventById(String eventId) async {
    try {
      return await _repository.getEventById(eventId);
    } catch (e) {
      _handleError('Failed to get event by ID', e);
      rethrow;
    }
  }

  /// Get a stream of calendar events for real-time updates
  Stream<List<CalendarEventModel>> streamUserEvents(String userId) {
    try {
      return _repository.streamUserEvents(userId);
    } catch (e) {
      _handleError('Failed to stream user events', e);
      rethrow;
    }
  }

  /// Get user events as a stream (alias for streamUserEvents for API consistency)
  Stream<List<CalendarEventModel>> getUserEventsStream(String userId) {
    return streamUserEvents(userId);
  }

  /// Get a stream of calendar events within a date range for real-time updates
  Stream<List<CalendarEventModel>> streamEventsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) {
    try {
      return _repository.streamEventsByDateRange(userId, startDate, endDate);
    } catch (e) {
      _handleError('Failed to stream events by date range', e);
      rethrow;
    }
  }

  /// Get events for date range as a stream (alias for streamEventsByDateRange for API consistency)
  Stream<List<CalendarEventModel>> getEventsForDateRangeStream({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return streamEventsByDateRange(userId, startDate, endDate);
  }

  /// Create a calendar event from an entity
  Future<CalendarEventModel> createEventFromEntity(BaseEntityModel entity, {
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? description,
  }) async {
    if (entity.userId.isEmpty) {
      throw Exception('Entity must have a user ID');
    }
    
    final eventType = _getEventTypeFromEntitySubtype(entity.subtype);
    
    final event = CalendarEventModel.fromEntity(
      entityId: entity.id!,
      title: entity.name,
      userId: entity.userId,
      description: description ?? entity.description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      eventType: eventType,
    );
    
    return await createEvent(event);
  }
  
  /// Get the event type based on entity subtype
  String _getEventTypeFromEntitySubtype(EntitySubtype subtype) {
    switch (subtype) {
      case EntitySubtype.event:
        return 'social_event';
      case EntitySubtype.anniversary:
      case EntitySubtype.birthday:
        return 'celebration';
      case EntitySubtype.doctor:
      case EntitySubtype.dentist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return 'appointment';
      case EntitySubtype.trip:
        return 'travel';
      case EntitySubtype.restaurant:
        return 'dining';
      default:
        return 'entity_event';
    }
  }

  // Private method to handle and log errors
  void _handleError(String message, dynamic error) {
    final errorMessage = '$message: ${error.toString()}';
    log(errorMessage, error: error); // Log to console
    // Error is already logged, we don't have access to show UI notifications from this service
  }
}
