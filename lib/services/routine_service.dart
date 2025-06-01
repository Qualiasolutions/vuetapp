import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/repositories/routine_repository.dart';

/// Service for managing routines and their task templates
class RoutineService {
  final RoutineRepository _routineRepository;

  RoutineService(this._routineRepository);

  /// Get all routines
  Future<List<RoutineModel>> getAllRoutines() async {
    return await _routineRepository.getAllRoutines();
  }

  /// Get a specific routine by ID
  Future<RoutineModel?> getRoutine(String routineId) async {
    return await _routineRepository.getRoutineById(routineId);
  }

  /// Create a new routine
  Future<void> createRoutine(RoutineModel routine) async {
    // Potentially add validation or business logic here
    return await _routineRepository.createRoutine(routine);
  }

  /// Update an existing routine
  Future<void> updateRoutine(RoutineModel routine) async {
    // Potentially add validation or business logic here
    return await _routineRepository.updateRoutine(routine);
  }

  /// Delete a routine by ID
  Future<void> deleteRoutine(String routineId) async {
    return await _routineRepository.deleteRoutine(routineId);
  }

  /// Get all task templates for a specific routine
  Future<List<RoutineTaskTemplateModel>> getTaskTemplatesForRoutine(String routineId) async {
    return await _routineRepository.getTaskTemplatesForRoutine(routineId);
  }

  /// Add a task template to a routine
  Future<void> createTaskTemplate(RoutineTaskTemplateModel taskTemplate) async {
    // Business logic, e.g., ensure routine exists
    return await _routineRepository.createTaskTemplate(taskTemplate);
  }

  /// Update a task template within a routine
  Future<void> updateTaskTemplate(RoutineTaskTemplateModel taskTemplate) async {
    // Business logic
    return await _routineRepository.updateTaskTemplate(taskTemplate);
  }

  /// Remove a task template from a routine
  Future<void> deleteTaskTemplate(String taskTemplateId) async {
    return await _routineRepository.deleteTaskTemplate(taskTemplateId);
  }

  /// Generate tasks from a routine for a specific date
  Future<List<TaskModel>> generateTasksFromRoutine(String routineId, DateTime date) async {
    // Use the repository's implementation which handles all the logic
    return await _routineRepository.generateTasksForRoutine(routineId, date);
  }

  /// Generate tasks for all due routines on a specific date
  Future<List<TaskModel>> generateTasksForAllDueRoutines(DateTime date) async {
    return await _routineRepository.generateTasksForAllDueRoutines(date);
  }
}
