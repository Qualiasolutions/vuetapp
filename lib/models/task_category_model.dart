/// Model representing a task category
class TaskCategoryModel {
  /// Category's unique ID
  final String id;
  
  /// Category name
  final String name;
  
  /// Category color as a hex string
  final String color;
  
  /// Icon code (optional)
  final String? icon;
  
  /// User ID of the creator (nullable for system categories)
  final String? createdById;
  
  /// When the category was created
  final DateTime createdAt;
  
  /// When the category was last updated
  final DateTime updatedAt;
  
  /// Constructor
  TaskCategoryModel({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    this.createdById,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Create a model from JSON data
  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final name = json['name'] as String?;
    final color = json['color'] as String?;
    final createdByValue = json['created_by'] as String?; // Changed from created_by_id
    final createdAtString = json['created_at'] as String?;
    final updatedAtString = json['updated_at'] as String?;

    if (id == null) throw FormatException("Missing 'id' in TaskCategoryModel JSON for entry: $json");
    if (name == null) throw FormatException("Missing 'name' in TaskCategoryModel JSON for entry: $json");
    if (color == null) throw FormatException("Missing 'color' in TaskCategoryModel JSON for entry: $json");
    if (createdAtString == null) throw FormatException("Missing 'created_at' in TaskCategoryModel JSON for entry: $json");

    return TaskCategoryModel(
      id: id,
      name: name,
      color: color,
      icon: json['icon'] as String?,
      createdById: createdByValue, // Assign corrected value
      createdAt: DateTime.parse(createdAtString),
      updatedAt: updatedAtString != null
          ? DateTime.parse(updatedAtString)
          : DateTime.parse(createdAtString), // Fallback for updatedAt
    );
  }
  
  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
      'created_by_id': createdById,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Create a copy of this model with updated fields
  TaskCategoryModel copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    String? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,  // Special handling for nullable field
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is TaskCategoryModel &&
      other.id == id &&
      other.name == name &&
      other.color == color &&
      other.icon == icon &&
      other.createdById == createdById &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }
  
  @override
  int get hashCode => id.hashCode;
}
