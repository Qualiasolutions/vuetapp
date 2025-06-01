import 'package:vuet_app/models/timeblock_model.dart';

abstract class TimeblockRepository {
  // Timeblocks CRUD
  Future<List<TimeblockModel>> fetchTimeblocks({
    required String userId,
    int? dayOfWeek,
  });
  
  Future<TimeblockModel?> fetchTimeblockById(String timeblockId);
  
  Future<TimeblockModel> createTimeblock(TimeblockModel timeblock);
  
  Future<TimeblockModel> updateTimeblock(TimeblockModel timeblock);
  
  Future<void> deleteTimeblock(String timeblockId);
  
  // Weekly operations
  Future<List<TimeblockModel>> fetchWeeklyTimeblocks(String userId);
  
  Future<List<TimeblockModel>> fetchTimeblocksByDay(String userId, int dayOfWeek);
  
  // Bulk operations
  Future<void> createMultipleTimeblocks(List<TimeblockModel> timeblocks);
  
  Future<void> deleteTimeblocksByDay(String userId, int dayOfWeek);
}
