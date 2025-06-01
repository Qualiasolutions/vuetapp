// Simple setup completion models without Freezed for immediate functionality
// TODO: Convert to Freezed models after build_runner is working properly

class CategorySetupCompletion {
  final int id;
  final String userId;
  final String categoryId;
  final DateTime completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategorySetupCompletion({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CategorySetupCompletion.fromJson(Map<String, dynamic> json) {
    return CategorySetupCompletion(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
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
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class EntityTypeSetupCompletion {
  final int id;
  final String userId;
  final String entityTypeName;
  final DateTime completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EntityTypeSetupCompletion({
    required this.id,
    required this.userId,
    required this.entityTypeName,
    required this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory EntityTypeSetupCompletion.fromJson(Map<String, dynamic> json) {
    return EntityTypeSetupCompletion(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      entityTypeName: json['entity_type_name'] as String,
      completedAt: DateTime.parse(json['completed_at'] as String),
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
      'entity_type_name': entityTypeName,
      'completed_at': completedAt.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
