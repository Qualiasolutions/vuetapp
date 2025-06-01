import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/repositories/timeblock_repository.dart';
import 'package:vuet_app/repositories/supabase_timeblock_repository.dart';
import 'package:vuet_app/providers/auth_providers.dart';

// Provider for TimeblockRepository
final timeblockRepositoryProvider = supabaseTimeblockRepositoryProvider;

// Provider to get all timeblocks for the current user
final userTimeblocksProvider = FutureProvider<List<TimeblockModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  
  final repository = ref.watch(timeblockRepositoryProvider);
  return repository.fetchWeeklyTimeblocks(userId);
});

// Parameter class for fetching timeblocks for a user and a specific day of the week
class UserTimeblocksForDayParams {
  final String userId;
  final int dayOfWeek; // 1 for Monday, 7 for Sunday

  UserTimeblocksForDayParams({required this.userId, required this.dayOfWeek});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserTimeblocksForDayParams &&
        other.userId == userId &&
        other.dayOfWeek == dayOfWeek;
  }

  @override
  int get hashCode => userId.hashCode ^ dayOfWeek.hashCode;
}

// Provider to get timeblocks for a user and a specific day of the week
final userTimeblocksForDayProvider = FutureProvider.family<List<TimeblockModel>, UserTimeblocksForDayParams>((ref, params) {
  final repository = ref.watch(timeblockRepositoryProvider);
  return repository.fetchTimeblocksByDay(params.userId, params.dayOfWeek);
});

// Provider to get a single timeblock by its ID
final timeblockByIdProvider = FutureProvider.family<TimeblockModel?, String>((ref, timeblockId) {
  final repository = ref.watch(timeblockRepositoryProvider);
  return repository.fetchTimeblockById(timeblockId);
});

// Provider for the current user's ID
final currentUserIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});

// Provider for the current user's timeblocks
final currentUserTimeblocksProvider = FutureProvider<List<TimeblockModel>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    // Return empty list if user is not logged in
    return [];
  }
  final repository = ref.watch(timeblockRepositoryProvider);
  return repository.fetchWeeklyTimeblocks(userId);
});

// Provider to get timeblocks linked to a specific routine
final timeblocksByRoutineProvider = FutureProvider.family<List<TimeblockModel>, String>((ref, routineId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  
  final repository = ref.watch(timeblockRepositoryProvider);
  final allTimeblocks = await repository.fetchWeeklyTimeblocks(userId);
  
  // Filter timeblocks linked to the specific routine
  return allTimeblocks.where((timeblock) => timeblock.linkedRoutineId == routineId).toList();
});

// Provider to get timeblocks linked to a specific task
final timeblocksByTaskProvider = FutureProvider.family<List<TimeblockModel>, String>((ref, taskId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  
  final repository = ref.watch(timeblockRepositoryProvider);
  final allTimeblocks = await repository.fetchWeeklyTimeblocks(userId);
  
  // Filter timeblocks linked to the specific task
  return allTimeblocks.where((timeblock) => timeblock.linkedTaskId == taskId).toList();
});

// Timeblock notifier for state management
class TimeblockNotifier extends StateNotifier<AsyncValue<void>> {
  final TimeblockRepository _repository;
  final Ref _ref;

  TimeblockNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createTimeblock(TimeblockModel timeblock) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createTimeblock(timeblock);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTimeblock(TimeblockModel timeblock) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateTimeblock(timeblock);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTimeblock(String timeblockId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTimeblock(timeblockId);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createMultipleTimeblocks(List<TimeblockModel> timeblocks) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createMultipleTimeblocks(timeblocks);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTimeblocksByDay(String userId, int dayOfWeek) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteTimeblocksByDay(userId, dayOfWeek);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Link a timeblock to a routine or task
  Future<void> linkTimeblockToRoutineOrTask(String timeblockId, {String? routineId, String? taskId}) async {
    state = const AsyncValue.loading();
    try {
      // Get the existing timeblock
      final existingTimeblock = await _repository.fetchTimeblockById(timeblockId);
      if (existingTimeblock == null) {
        throw Exception('Timeblock not found');
      }
      
      // Update with new links
      final updatedTimeblock = existingTimeblock.copyWith(
        linkedRoutineId: routineId,
        linkedTaskId: taskId,
      );
      
      await _repository.updateTimeblock(updatedTimeblock);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Create timeblocks from routine schedule
  Future<void> createTimeblockFromRoutine(String routineId, String userId, String title, int dayOfWeek, String startTime, String endTime) async {
    state = const AsyncValue.loading();
    try {
      final timeblock = TimeblockModel(
        id: '${routineId}_${dayOfWeek}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        title: title,
        dayOfWeek: dayOfWeek,
        startTime: startTime,
        endTime: endTime,
        linkedRoutineId: routineId,
        activityType: 'routine',
        color: '#4CAF50', // Green for routine-generated timeblocks
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _repository.createTimeblock(timeblock);
      _refreshTimeblocks();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  void _refreshTimeblocks() {
    _ref.invalidate(userTimeblocksProvider);
    _ref.invalidate(currentUserTimeblocksProvider);
    _ref.invalidate(timeblocksByRoutineProvider);
    _ref.invalidate(timeblocksByTaskProvider);
    // Note: We can't invalidate family providers easily, so we refresh the container
    _ref.container.refresh(userTimeblocksProvider);
  }
}

final timeblockNotifierProvider = StateNotifierProvider<TimeblockNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(timeblockRepositoryProvider);
  return TimeblockNotifier(repository, ref);
});
