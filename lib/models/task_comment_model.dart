import 'package:uuid/uuid.dart';

/// Model representing a comment on a task
class TaskCommentModel {
  /// The unique identifier of the comment
  final String id;
  
  /// The ID of the task this comment belongs to
  final String taskId;
  
  /// The ID of the user who created the comment
  final String userId;
  
  /// The display name of the user who created the comment (for UI purposes)
  final String? userDisplayName;
  
  /// The content of the comment
  final String text;
  
  /// The timestamp when the comment was created
  final DateTime createdAt;
  
  /// The timestamp when the comment was last updated, if applicable
  final DateTime? updatedAt;
  
  /// Additional metadata about the comment
  final Map<String, dynamic> metadata;

  /// Constructor
  TaskCommentModel({
    String? id,
    required this.taskId,
    required this.userId,
    this.userDisplayName,
    required this.text,
    DateTime? createdAt,
    this.updatedAt,
    Map<String, dynamic>? metadata,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        metadata = metadata ?? {};

  /// Creates a copy of this model with given fields replaced with the new values
  TaskCommentModel copyWith({
    String? id,
    String? taskId,
    String? userId,
    String? userDisplayName,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return TaskCommentModel(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'user_display_name': userDisplayName,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Creates a model from a JSON map
  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      id: json['id'],
      taskId: json['task_id'],
      userId: json['user_id'],
      userDisplayName: json['user_display_name'],
      text: json['text'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      metadata: json['metadata'] ?? {},
    );
  }
  
  /// Returns a formatted relative time string (e.g. "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Returns true if the comment has been edited
  bool get isEdited => updatedAt != null;
  
  /// Gets the first letter of the user's display name for avatar
  String get userInitial => 
      (userDisplayName?.isNotEmpty ?? false) 
          ? userDisplayName!.substring(0, 1).toUpperCase() 
          : 'U';
}
