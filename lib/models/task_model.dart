import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:vuet_app/models/task_type_enums.dart';

/// Task model representing a task in the Vuet app
class TaskModel {
  /// Unique identifier for the task
  final String id;
  
  /// Task title
  final String title;
  
  /// Optional task description
  final String? description;
  
  /// Due date for the task
  final DateTime? dueDate;
  
  /// Priority level: 'low', 'medium', 'high'
  final String priority;
  
  /// Status: 'pending', 'in_progress', 'completed', 'cancelled'
  final String status;
  
  /// Whether the task is recurring
  final bool isRecurring;
  
  /// Recurrence pattern (if recurring)
  final Map<String, dynamic>? recurrencePattern;
  
  /// Category ID this task belongs to
  final String? categoryId;
  
  /// User ID who created the task
  final String? createdById;
  
  /// User ID the task is assigned to
  final String? assignedToId;
  
  /// Parent task ID if this is a subtask
  final String? parentTaskId;

  /// Optional ID of the entity this task is linked to
  final String? entityId;

  /// ID of the routine this task was generated from (if applicable)
  final String? routineId;

  /// ID of the specific routine instance this task was generated from (if applicable)
  final String? routineInstanceId;

  /// Whether this task was generated from a routine template
  final bool isGeneratedFromRoutine;

  /// Type of task (task, appointment, activity, etc.)
  final TaskType? taskType;

  /// Subtype for specific task types (activity subtype, transport subtype, etc.)
  /// Stored as string to allow different enum types
  final String? taskSubtype;

  /// Start date and time (for appointment, transport, etc.)
  final DateTime? startDateTime;

  /// End date and time (for appointment, transport, etc.)
  final DateTime? endDateTime;

  /// Location information
  final String? location;

  /// Type-specific additional data
  final Map<String, dynamic>? typeSpecificData;
  
  // /// List of user IDs this task is shared with - This will be handled by separate sharing tables
  // final List<String>? sharedWithIds; 
  
  /// Creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;
  
  /// When the task was completed
  final DateTime? completedAt;

  /// Urgency level: 'low', 'medium', 'high', 'urgent'
  final String? urgency;

  /// Task behavior pattern
  final String? taskBehavior;

  /// List of tags associated with this task
  final List<String>? tags;

  /// Constructor
  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    this.isRecurring = false,
    this.recurrencePattern,
    this.categoryId,
    this.createdById,
    this.assignedToId,
    this.parentTaskId,
    this.entityId,
    this.routineId,
    this.routineInstanceId,
    this.isGeneratedFromRoutine = false,
    this.taskType,
    this.taskSubtype,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.typeSpecificData,
    // this.sharedWithIds,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.urgency,
    this.taskBehavior,
    this.tags,
  });

  /// Create a model instance from JSON data
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Local variables for DateTime parsing to avoid instance member access in factory
    final DateTime? parsedDueDate = json['due_date'] != null 
        ? DateTime.parse(json['due_date']) 
        : null;
        
    final DateTime? parsedStartDateTime = json['start_datetime'] != null 
        ? DateTime.parse(json['start_datetime']) 
        : null;
        
    final DateTime? parsedEndDateTime = json['end_datetime'] != null 
        ? DateTime.parse(json['end_datetime']) 
        : null;
        
    final DateTime parsedCreatedAt = DateTime.parse(json['created_at']);
    final DateTime parsedUpdatedAt = DateTime.parse(json['updated_at']);
    final DateTime? parsedCompletedAt = json['completed_at'] != null 
        ? DateTime.parse(json['completed_at']) 
        : null;
    
    // Parse task type enum from string
    final TaskType? parsedTaskType = json['task_type'] != null 
        ? TaskType.values.firstWhere(
            (e) => e.toString() == 'TaskType.${json['task_type']}',
            orElse: () => TaskType.task)
        : null;
    
    // Parse tags list
    final List<String>? parsedTags = json['tags'] != null
        ? List<String>.from(json['tags'])
        : null;
    
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: parsedDueDate,
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'pending',
      isRecurring: json['is_recurring'] ?? false,
      recurrencePattern: json['recurrence_pattern'],
      categoryId: json['category_id'],
      createdById: json['created_by'],
      assignedToId: json['assigned_to'],
      parentTaskId: json['parent_task_id'],
      entityId: json['entity_id'],
      routineId: json['routine_id'],
      routineInstanceId: json['routine_instance_id'],
      isGeneratedFromRoutine: json['is_generated_from_routine'] ?? false,
      taskType: parsedTaskType,
      taskSubtype: json['task_subtype'],
      startDateTime: parsedStartDateTime,
      endDateTime: parsedEndDateTime,
      location: json['location'],
      typeSpecificData: json['type_specific_data'],
      createdAt: parsedCreatedAt,
      updatedAt: parsedUpdatedAt,
      completedAt: parsedCompletedAt,
      urgency: json['urgency'],
      taskBehavior: json['task_behavior'],
      tags: parsedTags,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    final String? taskTypeString = taskType?.toString().split('.').last;
    final String? dueDateString = dueDate?.toIso8601String();
    final String? startDateTimeString = startDateTime?.toIso8601String();
    final String? endDateTimeString = endDateTime?.toIso8601String();
    final String createdAtString = createdAt.toIso8601String();
    final String updatedAtString = updatedAt.toIso8601String();
    final String? completedAtString = completedAt?.toIso8601String();

    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDateString,
      'priority': priority,
      'status': status,
      'is_recurring': isRecurring,
      'recurrence_pattern': recurrencePattern,
      'category_id': categoryId,
      'created_by': createdById,
      'assigned_to': assignedToId,
      'parent_task_id': parentTaskId,
      'entity_id': entityId,
      'routine_id': routineId,
      'routine_instance_id': routineInstanceId,
      'is_generated_from_routine': isGeneratedFromRoutine,
      'task_type': taskTypeString,
      'task_subtype': taskSubtype,
      'start_datetime': startDateTimeString,
      'end_datetime': endDateTimeString,
      'location': location,
      'type_specific_data': typeSpecificData,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
      'completed_at': completedAtString,
      'urgency': urgency,
      'task_behavior': taskBehavior,
      'tags': tags,
    };
  }

  /// Create a copy of this model with modified fields
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    String? status,
    bool? isRecurring,
    Map<String, dynamic>? recurrencePattern,
    String? categoryId,
    String? createdById,
    String? assignedToId,
    String? parentTaskId,
    String? entityId,
    String? routineId,
    String? routineInstanceId,
    bool? isGeneratedFromRoutine,
    TaskType? taskType,
    String? taskSubtype,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? location,
    Map<String, dynamic>? typeSpecificData,
    // List<String>? sharedWithIds, // Field removed
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    String? urgency,
    String? taskBehavior,
    List<String>? tags,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      categoryId: categoryId ?? this.categoryId,
      createdById: createdById ?? this.createdById,
      assignedToId: assignedToId ?? this.assignedToId,
      parentTaskId: parentTaskId ?? this.parentTaskId,
      entityId: entityId ?? this.entityId,
      routineId: routineId ?? this.routineId,
      routineInstanceId: routineInstanceId ?? this.routineInstanceId,
      isGeneratedFromRoutine: isGeneratedFromRoutine ?? this.isGeneratedFromRoutine,
      taskType: taskType ?? this.taskType,
      taskSubtype: taskSubtype ?? this.taskSubtype,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      location: location ?? this.location,
      typeSpecificData: typeSpecificData ?? this.typeSpecificData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      urgency: urgency ?? this.urgency,
      taskBehavior: taskBehavior ?? this.taskBehavior,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TaskModel &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.dueDate == dueDate &&
      other.priority == priority &&
      other.status == status &&
      other.isRecurring == isRecurring &&
      mapEquals(other.recurrencePattern, recurrencePattern) &&
      other.categoryId == categoryId &&
      other.createdById == createdById &&
      other.assignedToId == assignedToId &&
      other.parentTaskId == parentTaskId &&
      other.entityId == entityId &&
      other.routineId == routineId &&
      other.isGeneratedFromRoutine == isGeneratedFromRoutine &&
      other.taskType == taskType &&
      other.taskSubtype == taskSubtype &&
      other.startDateTime == startDateTime &&
      other.endDateTime == endDateTime &&
      other.location == location &&
      mapEquals(other.typeSpecificData, typeSpecificData) &&
      // listEquals(other.sharedWithIds, sharedWithIds) && // Field removed
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.completedAt == completedAt &&
      other.urgency == urgency &&
      other.taskBehavior == taskBehavior &&
      listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      dueDate.hashCode ^
      priority.hashCode ^
      status.hashCode ^
      isRecurring.hashCode ^
      recurrencePattern.hashCode ^
      categoryId.hashCode ^
      createdById.hashCode ^
      assignedToId.hashCode ^
      parentTaskId.hashCode ^
      entityId.hashCode ^
      routineId.hashCode ^
      isGeneratedFromRoutine.hashCode ^
      taskType.hashCode ^
      taskSubtype.hashCode ^
      startDateTime.hashCode ^
      endDateTime.hashCode ^
      location.hashCode ^
      typeSpecificData.hashCode ^
      // sharedWithIds.hashCode ^ // Field removed
      createdAt.hashCode ^
      updatedAt.hashCode ^
      completedAt.hashCode ^
      urgency.hashCode ^
      taskBehavior.hashCode ^
      tags.hashCode;
  }
}
