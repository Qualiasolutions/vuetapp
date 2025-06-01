import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'list_item_model.dart';

part 'list_sublist_model.freezed.dart';
part 'list_sublist_model.g.dart';

@freezed
class ListSublist with _$ListSublist {
  const factory ListSublist({
    required String id,
    required String listId,
    required String title,
    String? description,
    @Default(0) int sortOrder,
    @Default(false) bool isCompleted,
    @Default(0.0) double completionPercentage, // Auto-calculated in DB
    @Default(0) int totalItems,
    @Default(0) int completedItems,
    String? color,
    String? icon,
    required DateTime createdAt,
    required DateTime updatedAt,
    
    // Note: items are not stored in the sublists table in DB, they reference sublist_id
    // This field is for convenience when working with the model in the app
    @Default([]) List<ListItemModel> items,
    
    // Legacy fields for backward compatibility
    @Default({}) Map<String, dynamic> metadata,
  }) = _ListSublist;

  factory ListSublist.fromJson(Map<String, dynamic> json) => _$ListSublistFromJson(json);

  // Factory constructor for creating a new sublist
  factory ListSublist.create({
    required String listId,
    required String title,
    String? description,
    int sortOrder = 0,
    String? color,
    String? icon,
  }) {
    final now = DateTime.now();
    return ListSublist(
      id: const Uuid().v4(),
      listId: listId,
      title: title,
      description: description,
      sortOrder: sortOrder,
      color: color,
      icon: icon,
      createdAt: now,
      updatedAt: now,
    );
  }

  // Factory constructor for creating from Supabase JSON response
  factory ListSublist.fromSupabase(Map<String, dynamic> json) {
    return ListSublist(
      id: json['id'] as String,
      listId: json['list_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      completionPercentage: (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      totalItems: json['total_items'] as int? ?? 0,
      completedItems: json['completed_items'] as int? ?? 0,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      
      // Items will be loaded separately and added to this model
      items: [],
      
      // Legacy fields
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

}

// Extension methods for convenience
extension ListSublistX on ListSublist {
  // Convert to Supabase insert/update format
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'list_id': listId,
      'title': title,
      'description': description,
      'sort_order': sortOrder,
      'is_completed': isCompleted,
      'completion_percentage': completionPercentage,
      'total_items': totalItems,
      'completed_items': completedItems,
      'color': color,
      'icon': icon,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  // Calculate completion percentage (fallback if not set from DB)
  double get calculatedCompletionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  // Use DB completion percentage if available, otherwise calculate
  double get displayCompletionPercentage {
    return completionPercentage > 0 ? completionPercentage : calculatedCompletionPercentage;
  }

  // Check if sublist is fully completed (either explicitly marked or all items completed)
  bool get isFullyCompleted => isCompleted || (totalItems > 0 && completedItems == totalItems);

  // Check if sublist is empty
  bool get isEmpty => totalItems == 0;

  // Add an item to the sublist (for in-memory operations)
  ListSublist addItem(ListItemModel item) {
    final updatedItems = [...items, item];
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Remove an item from the sublist (for in-memory operations)
  ListSublist removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Update an item in the sublist (for in-memory operations)
  ListSublist updateItem(ListItemModel updatedItem) {
    final updatedItems = items.map((item) => 
      item.id == updatedItem.id ? updatedItem : item
    ).toList();
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Update counters based on items (for in-memory operations)
  ListSublist updateCounters() {
    final total = items.length;
    final completed = items.where((item) => item.isCompleted).length;
    final newCompletionPercentage = total > 0 ? (completed / total) * 100 : 0.0;
    
    return copyWith(
      totalItems: total,
      completedItems: completed,
      completionPercentage: newCompletionPercentage,
      updatedAt: DateTime.now(),
    );
  }

  // Update counters with provided values (typically from database)
  ListSublist updateCountersWithValues({
    required int totalItems,
    required int completedItems,
    double? completionPercentage,
  }) {
    final calculatedPercentage = totalItems > 0 ? (completedItems / totalItems) * 100 : 0.0;
    
    return copyWith(
      totalItems: totalItems,
      completedItems: completedItems,
      completionPercentage: completionPercentage ?? calculatedPercentage,
      updatedAt: DateTime.now(),
    );
  }

  // Toggle completion status of the entire sublist
  ListSublist toggleCompletion() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  // Mark sublist as completed
  ListSublist markCompleted() {
    return copyWith(
      isCompleted: true,
      completionPercentage: 100.0,
      updatedAt: DateTime.now(),
    );
  }

  // Mark sublist as not completed
  ListSublist markNotCompleted() {
    return copyWith(
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }

  // Toggle all items completion status (for in-memory operations)
  ListSublist toggleAllItems() {
    final allCompleted = items.every((item) => item.isCompleted);
    final updatedItems = items.map((item) => 
      item.copyWith(
        isCompleted: !allCompleted,
        updatedAt: DateTime.now(),
      )
    ).toList();
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Clear all completed items (for in-memory operations)
  ListSublist clearCompletedItems() {
    final updatedItems = items.where((item) => !item.isCompleted).toList();
    return copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    ).updateCounters();
  }

  // Reorder items (for in-memory operations)
  ListSublist reorderItems(List<ListItemModel> reorderedItems) {
    return copyWith(
      items: reorderedItems,
      updatedAt: DateTime.now(),
    );
  }

  // Update visual properties
  ListSublist updateVisuals({String? color, String? icon}) {
    return copyWith(
      color: color ?? this.color,
      icon: icon ?? this.icon,
      updatedAt: DateTime.now(),
    );
  }

  // Update sort order
  ListSublist updateSortOrder(int newSortOrder) {
    return copyWith(
      sortOrder: newSortOrder,
      updatedAt: DateTime.now(),
    );
  }

  // Load items into this sublist (typically called after fetching from database)
  ListSublist withItems(List<ListItemModel> loadedItems) {
    return copyWith(
      items: loadedItems,
    ).updateCounters();
  }
}
