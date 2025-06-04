import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'list_item_model.freezed.dart';
part 'list_item_model.g.dart';

@freezed
class ListItemModel with _$ListItemModel {
  const factory ListItemModel({
    required String id,
    required String listId,
    String? sublistId, // For hierarchy support
    required String name,
    String? description,
    @Default(false) bool isCompleted,
    int? quantity,
    @Default(0) int sortOrder,
    /// ID of the task this list item is linked to (for bidirectional sync)
    String? linkedTaskId,
    /// Whether this list item was converted from a task
    @Default(false) bool isConvertedFromTask,
    /// Shopping-specific fields
    double? price,
    String? storeId,
    String? notes,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ListItemModel;

  factory ListItemModel.fromJson(Map<String, dynamic> json) => _$ListItemModelFromJson(json);

  // Factory constructor for creating a new list item
  factory ListItemModel.create({
    required String listId,
    String? sublistId,
    required String name,
    String? description,
    int? quantity,
    int sortOrder = 0,
    String? linkedTaskId,
    bool isConvertedFromTask = false,
    double? price,
    String? storeId,
    String? notes,
  }) {
    final now = DateTime.now();
    return ListItemModel(
      id: const Uuid().v4(),
      listId: listId,
      sublistId: sublistId,
      name: name,
      description: description,
      quantity: quantity,
      sortOrder: sortOrder,
      linkedTaskId: linkedTaskId,
      isConvertedFromTask: isConvertedFromTask,
      price: price,
      storeId: storeId,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }
}

// Extension methods for convenience
extension ListItemModelX on ListItemModel {
  // Toggle completion status
  ListItemModel toggleCompletion() {
    return copyWith(
      isCompleted: !isCompleted,
      updatedAt: DateTime.now(),
    );
  }

  // Check if item has shopping-specific data
  bool get isShoppingItem => price != null || storeId != null;

  // Get display price
  String get displayPrice {
    if (price == null) return '';
    return '\$${price!.toStringAsFixed(2)}';
  }

  // Get display quantity
  String get displayQuantity {
    if (quantity == null || quantity! <= 1) return '';
    return '$quantity' 'x';
  }

  // Update price
  ListItemModel updatePrice(double? newPrice) {
    return copyWith(
      price: newPrice,
      updatedAt: DateTime.now(),
    );
  }

  // Update quantity
  ListItemModel updateQuantity(int? newQuantity) {
    return copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    );
  }

  // Check if item is linked to a task
  bool get isLinkedToTask => linkedTaskId != null;

  // Check if item is in a sublist
  bool get isInSublist => sublistId != null;
}
