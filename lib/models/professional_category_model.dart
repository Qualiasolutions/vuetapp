/// Model representing a professional category
class ProfessionalCategoryModel {
  /// Category's unique ID
  final String id;

  /// Category name
  final String name;

  /// User ID of the creator
  final String userId;

  /// When the category was created
  final DateTime createdAt;

  /// When the category was last updated
  final DateTime updatedAt;

  /// Constructor
  ProfessionalCategoryModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a model from JSON data
  factory ProfessionalCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalCategoryModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of this model with updated fields
  ProfessionalCategoryModel copyWith({
    String? id,
    String? name,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfessionalCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfessionalCategoryModel &&
        other.id == id &&
        other.name == name &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => id.hashCode;
}
