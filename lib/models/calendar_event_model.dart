import 'package:uuid/uuid.dart';

/// Represents a calendar event in the system.
/// 
/// This model maps to the `calendar_events` table in Supabase.
class CalendarEventModel {
  /// Unique identifier for the calendar event
  final String id;
  
  /// Title of the calendar event
  final String title;
  
  /// Optional description of the calendar event
  final String? description;
  
  /// Start time of the calendar event (required)
  final DateTime startTime;
  
  /// End time of the calendar event (required)
  final DateTime endTime;
  
  /// Whether this is an all-day event
  final bool allDay;
  
  /// Optional location of the event
  final String? location;
  
  /// ID of the user who owns this event
  final String userId;
  
  /// Whether this is a recurring event
  final bool isRecurring;
  
  /// Pattern for recurring events (e.g., 'DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY' with optional parameters)
  final String? recurrencePattern;
  
  /// When the event was created
  final DateTime createdAt;
  
  /// When the event was last updated
  final DateTime updatedAt;

  /// Constructor for CalendarEventModel
  CalendarEventModel({
    String? id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.allDay = false,
    this.location,
    required this.userId,
    this.isRecurring = false,
    this.recurrencePattern,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  /// Create a model from a Map (usually from JSON)
  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      allDay: json['all_day'] ?? false,
      location: json['location'],
      userId: json['user_id'],
      isRecurring: json['is_recurring'] ?? false,
      recurrencePattern: json['recurrence_pattern'],
      createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at']) 
        : null,
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at']) 
        : null,
    );
  }

  /// Convert model to a Map (usually for JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'all_day': allDay,
      'location': location,
      'user_id': userId,
      'is_recurring': isRecurring,
      'recurrence_pattern': recurrencePattern,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of this model with some fields replaced
  CalendarEventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    bool? allDay,
    String? location,
    String? userId,
    bool? isRecurring,
    String? recurrencePattern,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      allDay: allDay ?? this.allDay,
      location: location ?? this.location,
      userId: userId ?? this.userId,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CalendarEventModel(id: $id, title: $title, startTime: $startTime, endTime: $endTime)';
  }
}
