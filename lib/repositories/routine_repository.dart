import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/models/task_model.dart';

abstract class RoutineRepository {
  Future<List<RoutineModel>> getAllRoutines();
  Future<RoutineModel?> getRoutineById(String id);
  Future<void> createRoutine(RoutineModel routine);
  Future<void> updateRoutine(RoutineModel routine);
  Future<void> deleteRoutine(String id);

  Future<List<RoutineTaskTemplateModel>> getTaskTemplatesForRoutine(String routineId);
  Future<void> createTaskTemplate(RoutineTaskTemplateModel template);
  Future<void> updateTaskTemplate(RoutineTaskTemplateModel template);
  Future<void> deleteTaskTemplate(String templateId);
  Future<void> updateTaskTemplateOrder(List<RoutineTaskTemplateModel> templates);

  // Core logic for generating tasks
  Future<List<TaskModel>> generateTasksForRoutine(String routineId, DateTime forDate);
  Future<List<TaskModel>> generateTasksForAllDueRoutines(DateTime forDate);
}
