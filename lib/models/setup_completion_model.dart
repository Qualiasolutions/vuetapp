// Simple setup completion models without Freezed for immediate functionality
// TODO: Convert to Freezed models after build_runner is working properly

class CategorySetupCompletion {
  final String id;
  final String userId;
  final String categoryId;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategorySetupCompletion({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.isCompleted,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CategorySetupCompletion.fromJson(Map<String, dynamic> json) {
    return CategorySetupCompletion(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      isCompleted: json['is_completed'] as bool? ?? true,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class EntityTypeSetupCompletion {
  final String id;
  final String userId;
  final String entityType;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EntityTypeSetupCompletion({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.isCompleted,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory EntityTypeSetupCompletion.fromJson(Map<String, dynamic> json) {
    return EntityTypeSetupCompletion(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      entityType: json['entity_type'] as String,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'entity_type': entityType,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
