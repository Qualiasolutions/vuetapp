import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/repositories/calendar_event_repository.dart';

/// Implementation of CalendarEventRepository using Supabase
class SupabaseCalendarEventRepository implements CalendarEventRepository {
  // Supabase client instance
  final SupabaseClient _supabaseClient;
  
  // Table name for calendar events
  static const String _tableName = 'calendar_events';
  
  // Stream controllers cache for optimizing streams
  final Map<String, Stream<List<CalendarEventModel>>> _streamsCache = {};
  
  /// Constructor for SupabaseCalendarEventRepository
  SupabaseCalendarEventRepository({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  @override
  Future<List<CalendarEventModel>> getUserEvents(String userId) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('start_time', ascending: true);

      return response
          .map<CalendarEventModel>((json) => CalendarEventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw _handleError(error, 'Failed to get user events');
    }
  }

  @override
  Future<List<CalendarEventModel>> getEventsByDateRange(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .gte('start_time', startDate.toIso8601String())
          .lte('end_time', endDate.toIso8601String())
          .order('start_time', ascending: true);

      return response
          .map<CalendarEventModel>((json) => CalendarEventModel.fromJson(json))
          .toList();
    } catch (error) {
      throw _handleError(error, 'Failed to get events by date range');
    }
  }

  @override
  Future<CalendarEventModel> createEvent(CalendarEventModel event) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .insert(event.toJson())
          .select()
          .single();

      return CalendarEventModel.fromJson(response);
    } catch (error) {
      throw _handleError(error, 'Failed to create event');
    }
  }

  @override
  Future<CalendarEventModel> updateEvent(CalendarEventModel event) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .update(event.toJson())
          .eq('id', event.id)
          .select()
          .single();

      return CalendarEventModel.fromJson(response);
    } catch (error) {
      throw _handleError(error, 'Failed to update event');
    }
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await _supabaseClient
          .from(_tableName)
          .delete()
          .eq('id', eventId);
    } catch (error) {
      throw _handleError(error, 'Failed to delete event');
    }
  }

  @override
  Future<CalendarEventModel?> getEventById(String eventId) async {
    try {
      final response = await _supabaseClient
          .from(_tableName)
          .select()
          .eq('id', eventId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return CalendarEventModel.fromJson(response);
    } catch (error) {
      throw _handleError(error, 'Failed to get event by ID');
    }
  }

  @override
  Stream<List<CalendarEventModel>> streamUserEvents(String userId) {
    final cacheKey = 'user_events_$userId';
    
    if (_streamsCache.containsKey(cacheKey)) {
      return _streamsCache[cacheKey]!;
    }
    
    try {
      final stream = _supabaseClient
          .from(_tableName)
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .order('start_time')
          .map((events) => events
              .map((json) => CalendarEventModel.fromJson(json))
              .toList());
      
      _streamsCache[cacheKey] = stream;
      return stream;
    } catch (error) {
      throw _handleError(error, 'Failed to stream user events');
    }
  }

  @override
  Stream<List<CalendarEventModel>> streamEventsByDateRange(
      String userId, DateTime startDate, DateTime endDate) {
    final cacheKey = 'date_range_${userId}_${startDate.toIso8601String()}_${endDate.toIso8601String()}';
    
    if (_streamsCache.containsKey(cacheKey)) {
      return _streamsCache[cacheKey]!;
    }
    
    try {
      // Supabase stream filtering has limitations, so we'll get all events for the user
      // and filter them in Dart
      final stream = _supabaseClient
          .from(_tableName)
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .map((events) => events
              .map((json) => CalendarEventModel.fromJson(json))
              .where((event) => 
                  (event.startTime.isAfter(startDate) || 
                   event.startTime.isAtSameMomentAs(startDate)) && 
                  (event.endTime.isBefore(endDate) || 
                   event.endTime.isAtSameMomentAs(endDate)))
              .toList());
      
      _streamsCache[cacheKey] = stream;
      return stream;
    } catch (error) {
      throw _handleError(error, 'Failed to stream events by date range');
    }
  }
  
  // Helper method to format errors
  Exception _handleError(dynamic error, String message) {
    // Log error for debugging
    debugPrint('$message: $error');
    
    if (error is PostgrestException) {
      return Exception('$message: ${error.message}');
    }
    
    return Exception('$message: ${error.toString()}');
  }
}
