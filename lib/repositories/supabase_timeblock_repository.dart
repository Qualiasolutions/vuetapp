import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; // Added for ID generation
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/repositories/timeblock_repository.dart';
import 'package:vuet_app/utils/logger.dart'; // Import logger

// Provider for the SupabaseTimeblockRepository
final supabaseTimeblockRepositoryProvider = Provider<SupabaseTimeblockRepository>((ref) {
  return SupabaseTimeblockRepository();
});

class SupabaseTimeblockRepository implements TimeblockRepository {
  late final SupabaseClient _client;
  final _uuid = const Uuid(); // For generating IDs if needed

  SupabaseTimeblockRepository() {
    _client = SupabaseConfig.client;
  }

  Map<String, dynamic> _parseTimeblockJson(Map<String, dynamic> json, String? userId) {
    final newJson = <String, dynamic>{...json};

    newJson['id'] = json['id'] ?? _uuid.v4();
    newJson['userId'] = json['user_id'] ?? userId ?? _uuid.v4(); // Fallback for userId if needed
    newJson['title'] = json['title']; // Nullable
    newJson['dayOfWeek'] = json['day_of_week'] ?? 0; // Default to Monday if null, or handle as error
    newJson['startTime'] = json['start_time'] ?? '00:00:00'; // Default start time
    newJson['endTime'] = json['end_time'] ?? '00:00:00'; // Default end time
    newJson['color'] = json['color']; // Nullable
    newJson['description'] = json['description']; // Nullable
    newJson['activityType'] = json['activity_type']; // Nullable
    newJson['linkedRoutineId'] = json['linked_routine_id']; // Nullable
    newJson['linkedTaskId'] = json['linked_task_id']; // Nullable
    newJson['syncWithCalendar'] = json['sync_with_calendar'] ?? false;
    newJson['externalCalendarEventId'] = json['external_calendar_event_id']; // Nullable
    
    try {
        newJson['createdAt'] = json['created_at'] != null
            ? DateTime.parse(json['created_at']).toIso8601String()
            : DateTime.now().toIso8601String(); 
    } catch (e) {
        log('Error parsing createdAt for timeblock ${json['id']}: ${json['created_at']}. Defaulting to now.', name: 'SupabaseTimeblockRepository');
        newJson['createdAt'] = DateTime.now().toIso8601String();
    }

    try {
        newJson['updatedAt'] = json['updated_at'] != null
            ? DateTime.parse(json['updated_at']).toIso8601String()
            : DateTime.now().toIso8601String();
    } catch (e) {
        log('Error parsing updatedAt for timeblock ${json['id']}: ${json['updated_at']}. Defaulting to now.', name: 'SupabaseTimeblockRepository');
        newJson['updatedAt'] = DateTime.now().toIso8601String();
    }
    return newJson;
  }

  @override
  Future<TimeblockModel> createTimeblock(TimeblockModel timeblock) async {
    try {
      final response = await _client
          .from('timeblocks')
          .insert({
            'id': timeblock.id.isEmpty ? _uuid.v4() : timeblock.id, // Ensure ID is present
            'user_id': timeblock.userId,
            'title': timeblock.title,
            'day_of_week': timeblock.dayOfWeek,
            'start_time': timeblock.startTime,
            'end_time': timeblock.endTime,
            'color': timeblock.color,
            'description': timeblock.description,
            'activity_type': timeblock.activityType,
            'linked_routine_id': timeblock.linkedRoutineId,
            'linked_task_id': timeblock.linkedTaskId,
            'sync_with_calendar': timeblock.syncWithCalendar,
            'external_calendar_event_id': timeblock.externalCalendarEventId,
            // createdAt and updatedAt are handled by Supabase defaults or triggers ideally
          })
          .select()
          .single();

      return TimeblockModel.fromJson(_parseTimeblockJson(response, timeblock.userId));
    } on PostgrestException catch (e) {
      throw Exception('Failed to create timeblock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create timeblock: $e');
    }
  }

  @override
  Future<List<TimeblockModel>> fetchTimeblocks({
    required String userId,
    int? dayOfWeek,
  }) async {
    try {
      var query = _client
          .from('timeblocks')
          .select()
          .eq('user_id', userId);

      if (dayOfWeek != null) {
        query = query.eq('day_of_week', dayOfWeek);
      }

      final response = await query
          .order('day_of_week', ascending: true)
          .order('start_time', ascending: true);

      return response.map((json) => TimeblockModel.fromJson(_parseTimeblockJson(json, userId))).toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch timeblocks: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch timeblocks: $e');
    }
  }

  @override
  Future<List<TimeblockModel>> fetchWeeklyTimeblocks(String userId) async {
    return fetchTimeblocks(userId: userId);
  }

  @override
  Future<List<TimeblockModel>> fetchTimeblocksByDay(String userId, int dayOfWeek) async {
    return fetchTimeblocks(userId: userId, dayOfWeek: dayOfWeek);
  }

  @override
  Future<TimeblockModel?> fetchTimeblockById(String timeblockId) async {
    try {
      final response = await _client
          .from('timeblocks')
          .select()
          .eq('id', timeblockId)
          .maybeSingle();

      if (response == null) return null;
      // Assuming userId is not strictly needed just for parsing if fetched by ID, but can be added if available contextually
      return TimeblockModel.fromJson(_parseTimeblockJson(response, null)); 
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch timeblock by id: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch timeblock by id: $e');
    }
  }

  @override
  Future<TimeblockModel> updateTimeblock(TimeblockModel timeblock) async {
    try {
      final response = await _client
          .from('timeblocks')
          .update({
            'title': timeblock.title,
            'day_of_week': timeblock.dayOfWeek,
            'start_time': timeblock.startTime,
            'end_time': timeblock.endTime,
            'color': timeblock.color,
            'description': timeblock.description,
            'activity_type': timeblock.activityType,
            'linked_routine_id': timeblock.linkedRoutineId,
            'linked_task_id': timeblock.linkedTaskId,
            'sync_with_calendar': timeblock.syncWithCalendar,
            'external_calendar_event_id': timeblock.externalCalendarEventId,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', timeblock.id)
          .select()
          .single();

      return TimeblockModel.fromJson(_parseTimeblockJson(response, timeblock.userId));
    } on PostgrestException catch (e) {
      throw Exception('Failed to update timeblock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update timeblock: $e');
    }
  }

  @override
  Future<void> deleteTimeblock(String timeblockId) async {
    try {
      await _client
          .from('timeblocks')
          .delete()
          .eq('id', timeblockId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete timeblock: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete timeblock: $e');
    }
  }

  @override
  Future<void> createMultipleTimeblocks(List<TimeblockModel> timeblocks) async {
    try {
      final insertData = timeblocks.map((timeblock) => {
        'id': timeblock.id.isEmpty ? _uuid.v4() : timeblock.id, // Ensure ID is present
        'user_id': timeblock.userId,
        'title': timeblock.title,
        'day_of_week': timeblock.dayOfWeek,
        'start_time': timeblock.startTime,
        'end_time': timeblock.endTime,
        'color': timeblock.color,
        'description': timeblock.description,
        'activity_type': timeblock.activityType,
        'linked_routine_id': timeblock.linkedRoutineId,
        'linked_task_id': timeblock.linkedTaskId,
        'sync_with_calendar': timeblock.syncWithCalendar,
        'external_calendar_event_id': timeblock.externalCalendarEventId,
      }).toList();

      await _client
          .from('timeblocks')
          .insert(insertData);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create multiple timeblocks: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create multiple timeblocks: $e');
    }
  }

  @override
  Future<void> deleteTimeblocksByDay(String userId, int dayOfWeek) async {
    try {
      await _client
          .from('timeblocks')
          .delete()
          .eq('user_id', userId)
          .eq('day_of_week', dayOfWeek);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete timeblocks by day: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete timeblocks by day: $e');
    }
  }
}
