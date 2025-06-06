import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vuet_app/models/advanced_task_models.dart';
import 'package:vuet_app/models/task_type_enums.dart' as enums;

/// Repository for advanced task scheduling operations
class AdvancedTaskRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // MARK: - FlexibleTask Operations

  /// Create a new flexible task
  Future<FlexibleTask> createFlexibleTask(FlexibleTask task) async {
    final taskData = _flexibleTaskToDatabase(task);

    final response =
        await _supabase.from('tasks').insert(taskData).select().single();

    return _databaseToFlexibleTask(response);
  }

  /// Update an existing flexible task
  Future<FlexibleTask> updateFlexibleTask(FlexibleTask task) async {
    final taskData = _flexibleTaskToDatabase(task);
    taskData['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase
        .from('tasks')
        .update(taskData)
        .eq('id', task.id)
        .select()
        .single();

    return _databaseToFlexibleTask(response);
  }

  /// Get flexible tasks for a user
  Future<List<FlexibleTask>> getFlexibleTasks(String userId) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FLEXIBLE')
        .order('earliest_action_date', ascending: true);

    return response
        .map<FlexibleTask>((json) => _databaseToFlexibleTask(json))
        .toList();
  }

  /// Get unscheduled flexible tasks
  Future<List<FlexibleTask>> getUnscheduledFlexibleTasks(String userId) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FLEXIBLE')
        .eq('is_scheduled', false)
        .eq('is_completed', false)
        .order('task_urgency', ascending: false)
        .order('due_date', ascending: true);

    return response
        .map<FlexibleTask>((json) => _databaseToFlexibleTask(json))
        .toList();
  }

  /// Convert from task_type_enums.TaskUrgency to advanced_task_models.TaskUrgency
  TaskUrgency _convertTaskUrgency(enums.TaskUrgency urgency) {
    switch (urgency) {
      case enums.TaskUrgency.low:
        return TaskUrgency.low;
      case enums.TaskUrgency.medium:
        return TaskUrgency.medium;
      case enums.TaskUrgency.high:
        return TaskUrgency.high;
      case enums.TaskUrgency.urgent:
        return TaskUrgency.urgent;
    }
  }

  /// Get flexible tasks by urgency
  Future<List<FlexibleTask>> getFlexibleTasksByUrgency(
      String userId, enums.TaskUrgency urgency) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FLEXIBLE')
        .eq('task_urgency', urgency.value.toUpperCase())
        .eq('is_completed', false)
        .order('due_date', ascending: true);

    return response
        .map<FlexibleTask>((json) => _databaseToFlexibleTask(json))
        .toList();
  }

  /// Schedule a flexible task
  Future<FlexibleTask> scheduleFlexibleTask(
    String taskId,
    DateTime scheduledStartTime,
    DateTime scheduledEndTime,
  ) async {
    final response = await _supabase
        .from('tasks')
        .update({
          'scheduled_start_time': scheduledStartTime.toIso8601String(),
          'scheduled_end_time': scheduledEndTime.toIso8601String(),
          'is_scheduled': true,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', taskId)
        .select()
        .single();

    return _databaseToFlexibleTask(response);
  }

  // MARK: - FixedTask Operations

  /// Create a new fixed task
  Future<FixedTask> createFixedTask(FixedTask task) async {
    final taskData = _fixedTaskToDatabase(task);

    final response =
        await _supabase.from('tasks').insert(taskData).select().single();

    return _databaseToFixedTask(response);
  }

  /// Update an existing fixed task
  Future<FixedTask> updateFixedTask(FixedTask task) async {
    final taskData = _fixedTaskToDatabase(task);
    taskData['updated_at'] = DateTime.now().toIso8601String();

    final response = await _supabase
        .from('tasks')
        .update(taskData)
        .eq('id', task.id)
        .select()
        .single();

    return _databaseToFixedTask(response);
  }

  /// Get fixed tasks for a user
  Future<List<FixedTask>> getFixedTasks(String userId) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FIXED')
        .order('start_datetime', ascending: true);

    return response
        .map<FixedTask>((json) => _databaseToFixedTask(json))
        .toList();
  }

  /// Get fixed tasks in a date range
  Future<List<FixedTask>> getFixedTasksInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FIXED')
        .gte('start_datetime', startDate.toIso8601String())
        .lte('start_datetime', endDate.toIso8601String())
        .order('start_datetime', ascending: true);

    return response
        .map<FixedTask>((json) => _databaseToFixedTask(json))
        .toList();
  }

  /// Check for task conflicts in a time range
  Future<List<FixedTask>> getConflictingTasks(
    String userId,
    DateTime startTime,
    DateTime endTime, {
    String? excludeTaskId,
  }) async {
    var query = _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .eq('scheduling_type', 'FIXED')
        .lt('start_datetime', endTime.toIso8601String())
        .gt('end_datetime', startTime.toIso8601String());

    if (excludeTaskId != null) {
      query = query.neq('id', excludeTaskId);
    }

    final response = await query.order('start_datetime', ascending: true);
    return response
        .map<FixedTask>((json) => _databaseToFixedTask(json))
        .toList();
  }

  // MARK: - Recurrence Operations

  /// Create a recurrence pattern
  Future<Recurrence> createRecurrence(Recurrence recurrence) async {
    final data = {
      'id': recurrence.id,
      'task_id': recurrence.taskId,
      'recurrence_type': recurrence.recurrenceType.name.toUpperCase(),
      'interval_length': recurrence.intervalLength,
      'earliest_occurrence': recurrence.earliestOccurrence?.toIso8601String(),
      'latest_occurrence': recurrence.latestOccurrence?.toIso8601String(),
      'recurrence_data': recurrence.recurrenceData ?? {},
      'is_active': recurrence.isActive,
    };

    final response =
        await _supabase.from('recurrences').insert(data).select().single();

    return _databaseToRecurrence(response);
  }

  /// Get recurrences for a task
  Future<List<Recurrence>> getTaskRecurrences(String taskId) async {
    final response = await _supabase
        .from('recurrences')
        .select()
        .eq('task_id', taskId)
        .eq('is_active', true)
        .order('created_at', ascending: true);

    return response
        .map<Recurrence>((json) => _databaseToRecurrence(json))
        .toList();
  }

  /// Update recurrence pattern
  Future<Recurrence> updateRecurrence(Recurrence recurrence) async {
    final data = {
      'recurrence_type': recurrence.recurrenceType.name.toUpperCase(),
      'interval_length': recurrence.intervalLength,
      'earliest_occurrence': recurrence.earliestOccurrence?.toIso8601String(),
      'latest_occurrence': recurrence.latestOccurrence?.toIso8601String(),
      'recurrence_data': recurrence.recurrenceData ?? {},
      'is_active': recurrence.isActive,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _supabase
        .from('recurrences')
        .update(data)
        .eq('id', recurrence.id)
        .select()
        .single();

    return _databaseToRecurrence(response);
  }

  // MARK: - Task Actions Operations

  /// Create a task action
  Future<TaskAction> createTaskAction(TaskAction action) async {
    final data = {
      'id': action.id,
      'task_id': action.taskId,
      'action_timedelta': _durationToInterval(action.actionTimedelta),
      'description': action.description,
      'action_type': action.actionType,
      'action_data': action.actionData ?? {},
      'is_enabled': action.isEnabled,
    };

    final response =
        await _supabase.from('task_actions').insert(data).select().single();

    return _databaseToTaskAction(response);
  }

  /// Get actions for a task
  Future<List<TaskAction>> getTaskActions(String taskId) async {
    final response = await _supabase
        .from('task_actions')
        .select()
        .eq('task_id', taskId)
        .eq('is_enabled', true)
        .order('action_timedelta', ascending: false);

    return response
        .map<TaskAction>((json) => _databaseToTaskAction(json))
        .toList();
  }

  // MARK: - Task Reminders Operations

  /// Create a task reminder
  Future<TaskReminder> createTaskReminder(TaskReminder reminder) async {
    final data = {
      'id': reminder.id,
      'task_id': reminder.taskId,
      'timedelta': _durationToInterval(reminder.timedelta),
      'reminder_type': reminder.reminderType,
      'message': reminder.message,
      'is_enabled': reminder.isEnabled,
    };

    final response =
        await _supabase.from('task_reminders').insert(data).select().single();

    return _databaseToTaskReminder(response);
  }

  /// Get reminders for a task
  Future<List<TaskReminder>> getTaskReminders(String taskId) async {
    final response = await _supabase
        .from('task_reminders')
        .select()
        .eq('task_id', taskId)
        .eq('is_enabled', true)
        .order('timedelta', ascending: false);

    return response
        .map<TaskReminder>((json) => _databaseToTaskReminder(json))
        .toList();
  }

  // MARK: - Task-Entity Relationships

  /// Link a task to entities
  Future<void> linkTaskToEntities(String taskId, List<String> entityIds,
      {String relationshipType = 'primary'}) async {
    final data = entityIds
        .map((entityId) => {
              'task_id': taskId,
              'entity_id': entityId,
              'relationship_type': relationshipType,
            })
        .toList();

    await _supabase.from('task_entities').insert(data);
  }

  /// Get entities linked to a task
  Future<List<TaskEntity>> getTaskEntities(String taskId) async {
    final response = await _supabase
        .from('task_entities')
        .select()
        .eq('task_id', taskId)
        .order('created_at', ascending: true);

    return response
        .map<TaskEntity>((json) => _databaseToTaskEntity(json))
        .toList();
  }

  /// Get tasks linked to an entity
  Future<List<String>> getEntityTasks(String entityId) async {
    final response = await _supabase
        .from('task_entities')
        .select('task_id')
        .eq('entity_id', entityId);

    return response.map<String>((json) => json['task_id'] as String).toList();
  }

  // MARK: - General Operations

  /// Delete a task and all related data
  Future<void> deleteTask(String taskId) async {
    // Delete related data first (foreign key constraints)
    await _supabase.from('task_entities').delete().eq('task_id', taskId);
    await _supabase.from('task_reminders').delete().eq('task_id', taskId);
    await _supabase.from('task_actions').delete().eq('task_id', taskId);
    await _supabase.from('recurrences').delete().eq('task_id', taskId);

    // Finally delete the task
    await _supabase.from('tasks').delete().eq('id', taskId);
  }

  /// Mark task as completed
  Future<void> markTaskCompleted(String taskId) async {
    await _supabase.from('tasks').update({
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
      'status': 'completed',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', taskId);
  }

  // MARK: - Private Helper Methods

  Map<String, dynamic> _flexibleTaskToDatabase(FlexibleTask task) {
    return {
      'id': task.id,
      'user_id': task.userId,
      'title': task.title,
      'description': task.description,
      'scheduling_type': 'FLEXIBLE',
      'earliest_action_date':
          task.earliestActionDate?.toIso8601String().split('T')[0],
      'due_date': task.dueDate?.toIso8601String(),
      'duration_minutes': task.duration,
      'task_urgency': task.urgency.name.toUpperCase(),
      'scheduled_start_time': task.scheduledStartTime?.toIso8601String(),
      'scheduled_end_time': task.scheduledEndTime?.toIso8601String(),
      'is_scheduled': task.isScheduled,
      'assigned_to': task.assignedTo,
      'category_id': task.categoryId,
      'entity_id': task.entityId,
      'parent_task_id': task.parentTaskId,
      'routine_id': task.routineId,
      'routine_instance_id': task.routineInstanceId,
      'is_generated_from_routine': task.isGeneratedFromRoutine,
      'task_type': task.taskType?.toString().split('.').last,
      'task_subtype': task.taskSubtype,
      'location': task.location,
      'type_specific_data': task.typeSpecificData,
      'priority': task.priority,
      'status': task.status,
      'is_completed': task.isCompleted,
      'completed_at': task.completedAt?.toIso8601String(),
      'is_recurring': task.isRecurring,
      'tags': task.tags,
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
      'deleted_at': task.deletedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _fixedTaskToDatabase(FixedTask task) {
    return {
      'id': task.id,
      'user_id': task.userId,
      'title': task.title,
      'description': task.description,
      'scheduling_type': 'FIXED',
      'start_datetime': task.startDateTime?.toIso8601String(),
      'end_datetime': task.endDateTime?.toIso8601String(),
      'start_timezone': task.startTimezone,
      'end_timezone': task.endTimezone,
      'start_date': task.startDate?.toIso8601String().split('T')[0],
      'end_date': task.endDate?.toIso8601String().split('T')[0],
      'task_date': task.date?.toIso8601String().split('T')[0],
      'duration_minutes': task.duration,
      'assigned_to': task.assignedTo,
      'category_id': task.categoryId,
      'entity_id': task.entityId,
      'parent_task_id': task.parentTaskId,
      'routine_id': task.routineId,
      'routine_instance_id': task.routineInstanceId,
      'is_generated_from_routine': task.isGeneratedFromRoutine,
      'task_type': task.taskType?.toString().split('.').last,
      'task_subtype': task.taskSubtype,
      'location': task.location,
      'type_specific_data': task.typeSpecificData,
      'priority': task.priority,
      'status': task.status,
      'is_completed': task.isCompleted,
      'completed_at': task.completedAt?.toIso8601String(),
      'is_recurring': task.isRecurring,
      'tags': task.tags,
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
      'deleted_at': task.deletedAt?.toIso8601String(),
    };
  }

  FlexibleTask _databaseToFlexibleTask(Map<String, dynamic> json) {
    enums.TaskUrgency taskUrgency = json['task_urgency'] != null
        ? enums.TaskUrgency.values.firstWhere(
            (e) => e.value.toUpperCase() == json['task_urgency'],
            orElse: () => enums.TaskUrgency.medium)
        : enums.TaskUrgency.medium;

    return FlexibleTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      assignedTo: json['assigned_to'],
      categoryId: json['category_id'],
      entityId: json['entity_id'],
      parentTaskId: json['parent_task_id'],
      routineId: json['routine_id'],
      routineInstanceId: json['routine_instance_id'],
      isGeneratedFromRoutine: json['is_generated_from_routine'] ?? false,
      taskType: json['task_type'] != null
          ? enums.TaskType.values.firstWhere(
              (e) => e.toString().split('.').last == json['task_type'])
          : null,
      taskSubtype: json['task_subtype'],
      location: json['location'],
      typeSpecificData: json['type_specific_data'],
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      isCompleted: json['is_completed'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      isRecurring: json['is_recurring'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      earliestActionDate: json['earliest_action_date'] != null
          ? DateTime.parse(json['earliest_action_date'])
          : null,
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      duration: json['duration_minutes'] ?? 30,
      urgency: _convertTaskUrgency(taskUrgency),
      scheduledStartTime: json['scheduled_start_time'] != null
          ? DateTime.parse(json['scheduled_start_time'])
          : null,
      scheduledEndTime: json['scheduled_end_time'] != null
          ? DateTime.parse(json['scheduled_end_time'])
          : null,
      isScheduled: json['is_scheduled'] ?? false,
    );
  }

  FixedTask _databaseToFixedTask(Map<String, dynamic> json) {
    return FixedTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      assignedTo: json['assigned_to'],
      categoryId: json['category_id'],
      entityId: json['entity_id'],
      parentTaskId: json['parent_task_id'],
      routineId: json['routine_id'],
      routineInstanceId: json['routine_instance_id'],
      isGeneratedFromRoutine: json['is_generated_from_routine'] ?? false,
      taskType: json['task_type'] != null
          ? enums.TaskType.values.firstWhere(
              (e) => e.toString().split('.').last == json['task_type'])
          : null,
      taskSubtype: json['task_subtype'],
      location: json['location'],
      typeSpecificData: json['type_specific_data'],
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      isCompleted: json['is_completed'] ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      isRecurring: json['is_recurring'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      startDateTime: json['start_datetime'] != null
          ? DateTime.parse(json['start_datetime'])
          : null,
      endDateTime: json['end_datetime'] != null
          ? DateTime.parse(json['end_datetime'])
          : null,
      startTimezone: json['start_timezone'],
      endTimezone: json['end_timezone'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      date:
          json['task_date'] != null ? DateTime.parse(json['task_date']) : null,
      duration: json['duration_minutes'],
    );
  }

  Recurrence _databaseToRecurrence(Map<String, dynamic> json) {
    return Recurrence(
      id: json['id'],
      taskId: json['task_id'],
      recurrenceType: RecurrenceType.values
          .firstWhere((e) => e.name.toUpperCase() == json['recurrence_type']),
      intervalLength: json['interval_length'] ?? 1,
      earliestOccurrence: json['earliest_occurrence'] != null
          ? DateTime.parse(json['earliest_occurrence'])
          : null,
      latestOccurrence: json['latest_occurrence'] != null
          ? DateTime.parse(json['latest_occurrence'])
          : null,
      recurrenceData: json['recurrence_data'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  TaskAction _databaseToTaskAction(Map<String, dynamic> json) {
    return TaskAction(
      id: json['id'],
      taskId: json['task_id'],
      actionTimedelta: _intervalToDuration(json['action_timedelta']),
      description: json['description'],
      actionType: json['action_type'],
      actionData: json['action_data'],
      isEnabled: json['is_enabled'] ?? true,
      lastExecuted: json['last_executed'] != null
          ? DateTime.parse(json['last_executed'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  TaskReminder _databaseToTaskReminder(Map<String, dynamic> json) {
    return TaskReminder(
      id: json['id'],
      taskId: json['task_id'],
      timedelta: _intervalToDuration(json['timedelta']),
      reminderType: json['reminder_type'] ?? 'default',
      message: json['message'],
      isEnabled: json['is_enabled'] ?? true,
      lastSent:
          json['last_sent'] != null ? DateTime.parse(json['last_sent']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  TaskEntity _databaseToTaskEntity(Map<String, dynamic> json) {
    return TaskEntity(
      taskId: json['task_id'],
      entityId: json['entity_id'],
      relationshipType: json['relationship_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String _durationToInterval(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    return '$hours:$minutes:$seconds';
  }

  Duration _intervalToDuration(String interval) {
    final parts = interval.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
