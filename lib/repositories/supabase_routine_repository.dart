import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vuet_app/config/supabase_config.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/repositories/routine_repository.dart';
import 'package:vuet_app/repositories/base_supabase_repository.dart';
import 'package:vuet_app/utils/logger.dart';

class SupabaseRoutineRepository extends BaseSupabaseRepository implements RoutineRepository {
  final String? _userId;
  final _uuid = const Uuid();

  SupabaseRoutineRepository(this._userId) : super(SupabaseConfig.client);

  String get currentUserId {
    if (_userId == null) {
      throw Exception("User ID is not available in SupabaseRoutineRepository. Ensure user is logged in.");
    }
    return _userId;
  }

  @override
  Future<void> createRoutine(RoutineModel routine) async {
    return executeQuery('createRoutine', () async {
      final routineData = <String, dynamic>{
        'id': routine.id.isEmpty ? _uuid.v4() : routine.id,
        'user_id': currentUserId,
        'name': routine.name,
        'description': routine.description,
        'monday': routine.monday,
        'tuesday': routine.tuesday,
        'wednesday': routine.wednesday,
        'thursday': routine.thursday,
        'friday': routine.friday,
        'saturday': routine.saturday,
        'sunday': routine.sunday,
        'start_time': routine.startTime,
        'end_time': routine.endTime,
        'members': routine.members,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await from('routines').insert(routineData);
    });
  }

  @override
  Future<void> deleteRoutine(String id) async {
    return executeQuery('deleteRoutine', () async {
      await from('routines')
          .delete()
          .eq('id', id)
          .eq('user_id', currentUserId);
    });
  }

  @override
  Future<List<RoutineModel>> getAllRoutines() async {
    return executeQuery('getAllRoutines', () async {
      final response = await from('routines')
          .select()
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      return response.map((json) => RoutineModel.fromJson(_parseRoutineJson(json))).toList();
    });
  }

  @override
  Future<RoutineModel?> getRoutineById(String id) async {
    return executeQuery('getRoutineById', () async {
      final response = await from('routines')
          .select()
          .eq('id', id)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (response == null) return null;
      return RoutineModel.fromJson(_parseRoutineJson(response));
    });
  }

  @override
  Future<void> updateRoutine(RoutineModel routine) async {
    return executeQuery('updateRoutine', () async {
      final routineData = <String, dynamic>{
        'name': routine.name,
        'description': routine.description,
        'monday': routine.monday,
        'tuesday': routine.tuesday,
        'wednesday': routine.wednesday,
        'thursday': routine.thursday,
        'friday': routine.friday,
        'saturday': routine.saturday,
        'sunday': routine.sunday,
        'start_time': routine.startTime,
        'end_time': routine.endTime,
        'members': routine.members,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await from('routines')
          .update(routineData)
          .eq('id', routine.id)
          .eq('user_id', currentUserId);
    });
  }

  Map<String, dynamic> _parseRoutineJson(Map<String, dynamic> json) {
    final newJson = <String, dynamic>{};

    newJson['id'] = (json['id'] ?? _uuid.v4()) as String;
    newJson['userId'] = (json['user_id'] ?? currentUserId) as String;
    newJson['name'] = (json['name'] ?? 'Untitled Routine') as String;
    newJson['startTime'] = (json['start_time'] ?? '00:00') as String;
    newJson['endTime'] = (json['end_time'] ?? '23:59') as String;

    newJson['monday'] = (json['monday'] ?? false) as bool;
    newJson['tuesday'] = (json['tuesday'] ?? false) as bool;
    newJson['wednesday'] = (json['wednesday'] ?? false) as bool;
    newJson['thursday'] = (json['thursday'] ?? false) as bool;
    newJson['friday'] = (json['friday'] ?? false) as bool;
    newJson['saturday'] = (json['saturday'] ?? false) as bool;
    newJson['sunday'] = (json['sunday'] ?? false) as bool;

    if (json['members'] is List) {
      newJson['members'] = List<String>.from(json['members'].map((e) => e.toString()));
    } else {
      newJson['members'] = <String>[];
    }

    newJson['description'] = json['description'] as String?;

    try {
      newJson['createdAt'] = json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String).toIso8601String()
          : DateTime.now().toIso8601String();
    } catch (e) {
      log('Error parsing createdAt for routine ${json['id']}: ${json['created_at']}. Defaulting to now.', name: 'SupabaseRoutineRepository');
      newJson['createdAt'] = DateTime.now().toIso8601String();
    }

    if (json['updated_at'] != null) {
      try {
        newJson['updatedAt'] = DateTime.parse(json['updated_at'] as String).toIso8601String();
      } catch (e) {
        log('Error parsing updatedAt for routine ${json['id']}: ${json['updated_at']}. Setting to null.', name: 'SupabaseRoutineRepository');
        newJson['updatedAt'] = null;
      }
    } else {
      newJson['updatedAt'] = null;
    }

    return newJson;
  }

  @override
  Future<void> createTaskTemplate(RoutineTaskTemplateModel template) async {
    return executeQuery('createTaskTemplate', () async {
      final templateData = <String, dynamic>{
        'id': template.id.isEmpty ? _uuid.v4() : template.id,
        'routine_id': template.routineId,
        'user_id': currentUserId,
        'title': template.title,
        'description': template.description,
        'estimated_duration_minutes': template.estimatedDurationMinutes,
        'priority': template.priority?.name,
        'category_id': template.categoryId,
        'order_in_routine': template.orderInRoutine,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await from('routine_task_templates').insert(templateData);
    });
  }

  @override
  Future<void> deleteTaskTemplate(String templateId) async {
    return executeQuery('deleteTaskTemplate', () async {
      final template = await from('routine_task_templates')
          .select('routine_id')
          .eq('id', templateId)
          .maybeSingle();
          
      if (template == null) {
        throw Exception('Task template not found');
      }
      
      final routineCheck = await from('routines')
          .select('id')
          .eq('id', template['routine_id'])
          .eq('user_id', currentUserId)
          .maybeSingle();
      
      if (routineCheck == null) {
        throw Exception('User does not own the routine for this template');
      }
      
      await from('routine_task_templates').delete().eq('id', templateId);
    });
  }

  @override
  Future<List<RoutineTaskTemplateModel>> getTaskTemplatesForRoutine(String routineId) async {
    return executeQuery('getTaskTemplatesForRoutine', () async {
      final routineCheck = await from('routines')
          .select('id')
          .eq('id', routineId)
          .eq('user_id', currentUserId)
          .maybeSingle();
          
      if (routineCheck == null) {
        throw Exception('User does not own this routine');
      }
      
      final response = await from('routine_task_templates')
          .select()
          .eq('routine_id', routineId)
          .order('order_in_routine', ascending: true);

      return response.map((json) => RoutineTaskTemplateModel.fromJson(_parseTemplateJson(json))).toList();
    });
  }

  @override
  Future<void> updateTaskTemplate(RoutineTaskTemplateModel template) async {
    return executeQuery('updateTaskTemplate', () async {
      final routineCheck = await from('routines')
          .select('id')
          .eq('id', template.routineId)
          .eq('user_id', currentUserId)
          .maybeSingle();
          
      if (routineCheck == null) {
        throw Exception('User does not own the routine for this template');
      }
      
      final templateData = <String, dynamic>{
        'title': template.title,
        'description': template.description,
        'estimated_duration_minutes': template.estimatedDurationMinutes,
        'priority': template.priority?.name,
        'category_id': template.categoryId,
        'order_in_routine': template.orderInRoutine,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await from('routine_task_templates')
          .update(templateData)
          .eq('id', template.id);
    });
  }

  @override
  Future<void> updateTaskTemplateOrder(List<RoutineTaskTemplateModel> templates) async {
    if (templates.isEmpty) return;

    return executeQuery('updateTaskTemplateOrder', () async {
      final firstTemplate = templates.first;
      final routineCheck = await from('routines')
          .select('id')
          .eq('id', firstTemplate.routineId)
          .eq('user_id', currentUserId)
          .maybeSingle();

      if (routineCheck == null) {
        throw Exception("User does not own the routine for these templates.");
      }

      final updates = templates.map((template) => {
        'id': template.id,
        'routine_id': template.routineId,
        'user_id': currentUserId,
        'title': template.title,
        'description': template.description,
        'estimated_duration_minutes': template.estimatedDurationMinutes,
        'priority': template.priority?.name,
        'category_id': template.categoryId,
        'order_in_routine': template.orderInRoutine,
        'updated_at': DateTime.now().toIso8601String(),
      }).toList();

      await from('routine_task_templates').upsert(updates);
    });
  }
  
  bool _isRoutineDue(RoutineModel routine, DateTime forDate) {
    if (routine.createdAt == null) {
      return false;
    }

    final checkDate = DateTime(forDate.year, forDate.month, forDate.day);
    final routineCreationDate = DateTime(routine.createdAt!.year, routine.createdAt!.month, routine.createdAt!.day);
    
    if (checkDate.isBefore(routineCreationDate)) {
      return false;
    }

    final weekday = checkDate.weekday;
    switch (weekday) {
      case DateTime.monday: return routine.monday;
      case DateTime.tuesday: return routine.tuesday;
      case DateTime.wednesday: return routine.wednesday;
      case DateTime.thursday: return routine.thursday;
      case DateTime.friday: return routine.friday;
      case DateTime.saturday: return routine.saturday;
      case DateTime.sunday: return routine.sunday;
      default: return false;
    }
  }

  @override
  Future<List<TaskModel>> generateTasksForAllDueRoutines(DateTime forDate) async {
    return executeQuery('generateTasksForAllDueRoutines', () async {
      final allUserRoutines = await getAllRoutines();
      List<TaskModel> allGeneratedTasks = [];

      for (var routine in allUserRoutines) {
        if (_isRoutineDue(routine, forDate)) {
          final generatedTasks = await generateTasksForRoutine(routine.id, forDate);
          allGeneratedTasks.addAll(generatedTasks);
        }
      }
      return allGeneratedTasks;
    });
  }

  @override
  Future<List<TaskModel>> generateTasksForRoutine(String routineId, DateTime forDate) async {
    return executeQuery('generateTasksForRoutine', () async {
      final routine = await getRoutineById(routineId);
      if (routine == null) {
        return [];
      }

      final templates = await getTaskTemplatesForRoutine(routineId);
      if (templates.isEmpty) {
        return [];
      }

      List<TaskModel> generatedTasks = [];
      List<Map<String, dynamic>> tasksToInsert = [];

      for (var template in templates) {
        final newTaskId = _uuid.v4();
        DateTime taskDueDate;
        
        try {
          final timeParts = routine.startTime.split(':');
          taskDueDate = DateTime(
            forDate.year,
            forDate.month,
            forDate.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
        } catch (e) {
          taskDueDate = DateTime(forDate.year, forDate.month, forDate.day, 12, 0);
        }

        final taskData = {
          'id': newTaskId,
          'title': template.title,
          'description': template.description,
          'due_date': taskDueDate.toIso8601String(),
          'priority': template.priority?.name ?? 'medium',
          'status': 'pending',
          'is_recurring': false,
          'category_id': template.categoryId,
          'created_by': currentUserId,
          'assigned_to': currentUserId,
          'routine_id': routineId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        tasksToInsert.add(taskData);
        generatedTasks.add(TaskModel.fromJson(taskData));
      }

      if (tasksToInsert.isNotEmpty) {
        await from('tasks').insert(tasksToInsert);
      }

      return generatedTasks;
    });
  }

  Map<String, dynamic> _parseTemplateJson(Map<String, dynamic> json) {
    final newJson = <String, dynamic>{...json};
    
    newJson['routineId'] = json['routine_id'] ?? '';
    newJson['userId'] = json['user_id'] ?? currentUserId;
    newJson['estimatedDurationMinutes'] = json['estimated_duration_minutes'];
    newJson['categoryId'] = json['category_id'];
    newJson['orderInRoutine'] = json['order_in_routine'] ?? 0;
    
    if (json['priority'] is String && json['priority'] != null) {
      newJson['priority'] = TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ).name;
    } else {
      newJson['priority'] = TaskPriority.medium.name;
    }

    try {
      newJson['createdAt'] = json['created_at'] != null
          ? DateTime.parse(json['created_at']).toIso8601String()
          : DateTime.now().toIso8601String(); 
    } catch (e) {
        newJson['createdAt'] = DateTime.now().toIso8601String();
    }
    
    if (json['updated_at'] != null) {
      try {
        newJson['updatedAt'] = DateTime.parse(json['updated_at']).toIso8601String();
      } catch (e) {
        newJson['updatedAt'] = null;
      }
    } else {
      newJson['updatedAt'] = null;
    }
    
    return newJson;
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  
  if (userId == null) {
    log('User not authenticated, RoutineRepository cannot be created with a null userId.', name: 'routineRepositoryProvider');
    throw Exception('User not authenticated, cannot create RoutineRepository');
  }
  
  return SupabaseRoutineRepository(userId);
});
