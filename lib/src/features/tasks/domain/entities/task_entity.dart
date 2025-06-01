import 'package:equatable/equatable.dart';

// It might be beneficial to define enums for priority and status here
// enum TaskPriority { low, medium, high }
// enum TaskStatus { pending, inProgress, completed, cancelled }

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final String? priority; // Or TaskPriority enum
  final String? status;   // Or TaskStatus enum
  final bool? isRecurring;
  // For simplicity in the domain entity, recurrencePattern might be omitted
  // or represented differently if detailed recurrence logic is handled.
  // final Map<String, dynamic>? recurrencePattern; 
  final String? categoryId; // Could be mapped to a CategoryEntity later
  final String? createdBy;  // Could be mapped to a UserEntityLite later
  final String? assignedTo; // Could be mapped to a UserEntityLite later
  final DateTime? createdAt;
  final DateTime? completedAt;
  final bool isCompleted;

  const TaskEntity({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.description,
    this.dueDate,
    this.priority,
    this.status,
    this.isRecurring,
    this.categoryId,
    this.createdBy,
    this.assignedTo,
    this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        priority,
        status,
        isRecurring,
        categoryId,
        createdBy,
        assignedTo,
        createdAt,
        completedAt,
        isCompleted,
      ];

  // Optional: Add a factory constructor or method in TaskSupabaseModel 
  // to convert from TaskSupabaseModel to TaskEntity if needed,
  // or handle this mapping in the repository implementation.
}
