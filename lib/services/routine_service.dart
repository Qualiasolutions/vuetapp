import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/task_service.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/utils/error_handler.dart';
import 'dart:async';

/// Model for routine templates
class RoutineModel {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String scheduleType; // 'daily', 'weekly', 'monthly_date', 'monthly_day'
  final int interval;
  final List<int>? daysOfWeek; // 0=Sunday, 1=Monday, etc.
  final int? dayOfMonth; // For monthly_date schedule
  final int? weekOfMonth; // For monthly_day schedule (1-4, or -1 for last)
  final DateTime startDate;
  final DateTime? endDate;
  final String? timeOfDay; // Time as string like "09:30"
  final List<String>? members; // User IDs who can see this routine
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoutineModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.scheduleType,
    this.interval = 1,
    this.daysOfWeek,
    this.dayOfMonth,
    this.weekOfMonth,
    required this.startDate,
    this.endDate,
    this.timeOfDay,
    this.members,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      scheduleType: json['schedule_type'],
      interval: json['interval'] ?? 1,
      daysOfWeek: json['days_of_week'] != null ? 
        List<int>.from(json['days_of_week']) : null,
      dayOfMonth: json['day_of_month'],
      weekOfMonth: json['week_of_month'],
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      timeOfDay: json['time_of_day'],
      members: json['members'] != null ? List<String>.from(json['members']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'schedule_type': scheduleType,
      'interval': interval,
      'days_of_week': daysOfWeek,
      'day_of_month': dayOfMonth,
      'week_of_month': weekOfMonth,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate?.toIso8601String().split('T')[0],
      'time_of_day': timeOfDay,
      'members': members,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Model for routine task templates
class RoutineTaskTemplateModel {
  final String id;
  final String routineId;
  final String userId;
  final String title;
  final String? description;
  final int? estimatedDurationMinutes;
  final String? categoryId;
  final String priority; // 'low', 'medium', 'high'
  final int orderInRoutine;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoutineTaskTemplateModel({
    required this.id,
    required this.routineId,
    required this.userId,
    required this.title,
    this.description,
    this.estimatedDurationMinutes,
    this.categoryId,
    this.priority = 'medium',
    this.orderInRoutine = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineTaskTemplateModel.fromJson(Map<String, dynamic> json) {
    return RoutineTaskTemplateModel(
      id: json['id'],
      routineId: json['routine_id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      estimatedDurationMinutes: json['estimated_duration_minutes'],
      categoryId: json['category_id'],
      priority: json['priority'] ?? 'medium',
      orderInRoutine: json['order_in_routine'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routine_id': routineId,
      'user_id': userId,
      'title': title,
      'description': description,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'category_id': categoryId,
      'priority': priority,
      'order_in_routine': orderInRoutine,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Service for managing routines and generating scheduled tasks
class RoutineService extends ChangeNotifier {
  final AuthService _authService;
  final TaskService _taskService;
  
  List<RoutineModel> _routines = [];
  List<RoutineTaskTemplateModel> _templates = [];
  
  List<RoutineModel> get routines => _routines;
  List<RoutineTaskTemplateModel> get templates => _templates;

  RoutineService({
    required AuthService authService,
    required TaskService taskService,
  }) : _authService = authService,
       _taskService = taskService {
    _loadRoutines();
  }
  
  String? get _userId => _authService.currentUser?.id;
  bool get _isAuthenticated => _userId != null;

  /// Load all routines for the current user
  Future<void> _loadRoutines() async {
    if (!_isAuthenticated) return;
    
    try {
      // Note: In a real implementation, this would use Supabase client
      // For now, we'll simulate the data structure
      _routines = [];
      _templates = [];
      notifyListeners();
    } catch (e) {
      ErrorHandler.handleError('Failed to load routines', e);
    }
  }

  /// Create a new routine
  Future<String?> createRoutine({
    required String name,
    String? description,
    required String scheduleType,
    int interval = 1,
    List<int>? daysOfWeek,
    int? dayOfMonth,
    int? weekOfMonth,
    required DateTime startDate,
    DateTime? endDate,
    String? timeOfDay,
    List<String>? members,
  }) async {
    if (!_isAuthenticated) return null;
    
    try {
      final routine = RoutineModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _userId!,
        name: name,
        description: description,
        scheduleType: scheduleType,
        interval: interval,
        daysOfWeek: daysOfWeek,
        dayOfMonth: dayOfMonth,
        weekOfMonth: weekOfMonth,
        startDate: startDate,
        endDate: endDate,
        timeOfDay: timeOfDay,
        members: members,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Note: In real implementation, this would insert into Supabase
      _routines.add(routine);
      notifyListeners();
      
      return routine.id;
    } catch (e) {
      ErrorHandler.handleError('Failed to create routine', e);
      return null;
    }
  }

  /// Add a task template to a routine
  Future<String?> addTaskTemplate({
    required String routineId,
    required String title,
    String? description,
    int? estimatedDurationMinutes,
    String? categoryId,
    String priority = 'medium',
    int? orderInRoutine,
  }) async {
    if (!_isAuthenticated) return null;
    
    try {
      final template = RoutineTaskTemplateModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        routineId: routineId,
        userId: _userId!,
        title: title,
        description: description,
        estimatedDurationMinutes: estimatedDurationMinutes,
        categoryId: categoryId,
        priority: priority,
        orderInRoutine: orderInRoutine ?? _templates.where((t) => t.routineId == routineId).length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Note: In real implementation, this would insert into Supabase
      _templates.add(template);
      notifyListeners();
      
      return template.id;
    } catch (e) {
      ErrorHandler.handleError('Failed to add task template', e);
      return null;
    }
  }

  /// Generate tasks for a specific date based on routine schedules
  Future<void> generateTasksForDate(DateTime date) async {
    if (!_isAuthenticated) return;
    
    try {
      for (final routine in _routines) {
        if (_shouldGenerateTasksForDate(routine, date)) {
          await _generateTasksFromRoutine(routine, date);
        }
      }
    } catch (e) {
      ErrorHandler.handleError('Failed to generate tasks for date', e);
    }
  }

  /// Check if tasks should be generated for this routine on the given date
  bool _shouldGenerateTasksForDate(RoutineModel routine, DateTime date) {
    // Check if date is within routine's active period
    if (date.isBefore(routine.startDate)) return false;
    if (routine.endDate != null && date.isAfter(routine.endDate!)) return false;
    
    final daysSinceStart = date.difference(routine.startDate).inDays;
    
    switch (routine.scheduleType) {
      case 'daily':
        return daysSinceStart % routine.interval == 0;
        
      case 'weekly':
        final weeksSinceStart = daysSinceStart ~/ 7;
        if (weeksSinceStart % routine.interval != 0) return false;
        
        if (routine.daysOfWeek != null) {
          final weekday = date.weekday % 7; // Convert to 0=Sunday, 1=Monday format
          return routine.daysOfWeek!.contains(weekday);
        }
        return true;
        
      case 'monthly_date':
        if (routine.dayOfMonth != null && date.day == routine.dayOfMonth) {
          final monthsSinceStart = _monthsDifference(routine.startDate, date);
          return monthsSinceStart % routine.interval == 0;
        }
        return false;
        
      case 'monthly_day':
        // More complex logic for "first Monday of month" etc.
        if (routine.daysOfWeek != null && routine.weekOfMonth != null) {
          final weekday = date.weekday % 7;
          if (!routine.daysOfWeek!.contains(weekday)) return false;
          
          final weekOfMonth = _getWeekOfMonth(date);
          if (routine.weekOfMonth == -1) {
            // Last occurrence of the day in the month
            return _isLastOccurrenceOfDayInMonth(date);
          } else {
            return weekOfMonth == routine.weekOfMonth;
          }
        }
        return false;
        
      default:
        return false;
    }
  }

  /// Generate tasks from a routine for a specific date
  Future<void> _generateTasksFromRoutine(RoutineModel routine, DateTime date) async {
    final templates = _templates.where((t) => t.routineId == routine.id).toList();
    
    for (final template in templates) {
      DateTime? scheduledDateTime;
      DateTime? endDateTime;
      
      if (routine.timeOfDay != null) {
        final timeParts = routine.timeOfDay!.split(':');
        if (timeParts.length >= 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          
          scheduledDateTime = DateTime(date.year, date.month, date.day, hour, minute);
          
          if (template.estimatedDurationMinutes != null) {
            endDateTime = scheduledDateTime.add(Duration(minutes: template.estimatedDurationMinutes!));
          }
        }
      }
      
      await _taskService.createTask(
        title: template.title,
        description: template.description,
        priority: template.priority,
        categoryId: template.categoryId,
        startDateTime: scheduledDateTime,
        endDateTime: endDateTime,
        dueDate: scheduledDateTime ?? date,
        taskType: TaskType.task,
        typeSpecificData: {
          'routineId': routine.id,
          'routineInstanceId': '${routine.id}_${date.toIso8601String().split('T')[0]}',
          'isGeneratedFromRoutine': true,
          'routineName': routine.name,
        },
      );
    }
  }

  /// Calculate the difference in months between two dates
  int _monthsDifference(DateTime start, DateTime end) {
    return (end.year - start.year) * 12 + (end.month - start.month);
  }

  /// Get which week of the month a date falls in (1-5)
  int _getWeekOfMonth(DateTime date) {
    final firstOfMonth = DateTime(date.year, date.month, 1);
    final firstWeekday = firstOfMonth.weekday % 7; // 0=Sunday format
    return ((date.day + firstWeekday - 1) / 7).ceil();
  }

  /// Check if this is the last occurrence of this weekday in the month
  bool _isLastOccurrenceOfDayInMonth(DateTime date) {
    final nextWeek = date.add(const Duration(days: 7));
    return nextWeek.month != date.month;
  }

  /// Get routines for a specific date
  List<RoutineModel> getRoutinesForDate(DateTime date) {
    return _routines.where((routine) => _shouldGenerateTasksForDate(routine, date)).toList();
  }

  /// Get templates for a routine
  List<RoutineTaskTemplateModel> getTemplatesForRoutine(String routineId) {
    return _templates.where((t) => t.routineId == routineId).toList();
  }

  /// Delete a routine and all its templates
  Future<bool> deleteRoutine(String routineId) async {
    if (!_isAuthenticated) return false;
    
    try {
      _routines.removeWhere((r) => r.id == routineId);
      _templates.removeWhere((t) => t.routineId == routineId);
      notifyListeners();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to delete routine', e);
      return false;
    }
  }

  /// Update a routine
  Future<bool> updateRoutine(String routineId, Map<String, dynamic> updates) async {
    if (!_isAuthenticated) return false;
    
    try {
      final index = _routines.indexWhere((r) => r.id == routineId);
      if (index == -1) return false;
      
      // Note: In real implementation, this would update in Supabase
      // For now, we'll just simulate the update
      notifyListeners();
      return true;
    } catch (e) {
      ErrorHandler.handleError('Failed to update routine', e);
      return false;
    }
  }
}

/// Provider for RoutineService
final routineServiceProvider = ChangeNotifierProvider<RoutineService>((ref) {
  final authService = ref.watch(authServiceProvider);
  final taskService = ref.watch(taskServiceProvider);
  
  return RoutineService(
    authService: authService,
    taskService: taskService,
  );
});
