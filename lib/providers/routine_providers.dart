import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/repositories/routine_repository.dart';
import 'package:vuet_app/repositories/supabase_routine_repository.dart';
import 'package:vuet_app/providers/integrated_task_providers.dart';
import 'package:vuet_app/providers/auth_providers.dart';

// Repository provider
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) {
    throw Exception('User not authenticated, cannot create RoutineRepository');
  }
  
  return SupabaseRoutineRepository(userId);
});

// Provider to get all routines for the current user
final routinesProvider = FutureProvider<List<RoutineModel>>((ref) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  return routineRepository.getAllRoutines();
});

// StateNotifier for managing routine operations
final routinesNotifierProvider = StateNotifierProvider<RoutinesNotifier, AsyncValue<List<RoutineModel>>>((ref) {
  return RoutinesNotifier(ref.watch(routineRepositoryProvider));
});

class RoutinesNotifier extends StateNotifier<AsyncValue<List<RoutineModel>>> {
  final RoutineRepository _repository;

  RoutinesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    try {
      final routines = await _repository.getAllRoutines();
      state = AsyncValue.data(routines);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createRoutine(RoutineModel routine) async {
    try {
      await _repository.createRoutine(routine);
      await _loadRoutines(); // Refresh the list
    } catch (e) {
      // Handle error - could emit error state or show snackbar
      rethrow;
    }
  }

  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      await _repository.updateRoutine(routine);
      await _loadRoutines(); // Refresh the list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRoutine(String routineId) async {
    try {
      await _repository.deleteRoutine(routineId);
      await _loadRoutines(); // Refresh the list
    } catch (e) {
      rethrow;
    }
  }

  void refresh() {
    state = const AsyncValue.loading();
    _loadRoutines();
  }
}

// Provider to get a specific routine by its ID
final routineByIdProviderFamily = FutureProvider.family<RoutineModel?, String>((ref, id) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  return routineRepository.getRoutineById(id);
});

// Provider to get all task templates for a specific routine
final routineTaskTemplatesProviderFamily = FutureProvider.family<List<RoutineTaskTemplateModel>, String>((ref, routineId) async {
  final routineRepository = ref.watch(routineRepositoryProvider);
  return routineRepository.getTaskTemplatesForRoutine(routineId);
});

// If we need to manage state for a routine creation/editing form,
// a StateNotifierProvider would be suitable here. For now, we'll focus on data fetching.

// Provider for generating tasks from routines
final routineTaskGeneratorProvider = StateNotifierProvider<RoutineTaskGeneratorNotifier, AsyncValue<List<TaskModel>>>((ref) {
  return RoutineTaskGeneratorNotifier(ref.watch(routineRepositoryProvider));
});

class RoutineTaskGeneratorNotifier extends StateNotifier<AsyncValue<List<TaskModel>>> {
  final RoutineRepository _repository;
  
  RoutineTaskGeneratorNotifier(this._repository) : super(const AsyncValue.data([]));

  /// Generate tasks for a specific routine on a specific date
  Future<List<TaskModel>> generateTasksForRoutine(String routineId, DateTime forDate) async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _repository.generateTasksForRoutine(routineId, forDate);
      state = AsyncValue.data(tasks);
      return tasks;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  /// Generate tasks for all due routines on a specific date
  Future<List<TaskModel>> generateTasksForAllDueRoutines(DateTime forDate) async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _repository.generateTasksForAllDueRoutines(forDate);
      state = AsyncValue.data(tasks);
      return tasks;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      rethrow;
    }
  }

  /// Clear the current state
  void clearState() {
    state = const AsyncValue.data([]);
  }
}

// Provider to get tasks generated from a specific routine
final tasksFromRoutineProviderFamily = FutureProvider.family<List<TaskModel>, String>((ref, routineId) async {
  // Use the new integrated task provider for better functionality
  return ref.watch(tasksFromRoutineProvider(routineId).future);
});
