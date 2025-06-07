import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart'; // For IconData, Color if we convert here

part 'entity_category_model.freezed.dart';
part 'entity_category_model.g.dart';

@freezed
class EntityCategory with _$EntityCategory {
  const factory EntityCategory({
    required String id, // UUID from Supabase
    required String name, // Internal name, e.g., "pets", "social_interests"
    required String displayName, // User-facing name, e.g., "My Pets"
    String? iconName, // String identifier for Flutter Icon
    String? colorHex, // Hex color string, e.g., "#FF5733"
    @Default(0) int sortOrder,
    @Default(true) bool isDisplayedOnGrid,
    int? appCategoryIntId, // Legacy integer ID
    String? parentId, // For hierarchical categories
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _EntityCategory;

  factory EntityCategory.fromJson(Map<String, dynamic> json) =>
      _$EntityCategoryFromJson(json);
}

// Helper extension to convert iconName to IconData if needed in UI
// This might be better placed in a UI helper/util file or within the widget itself.
// For now, keeping it simple.
extension EntityCategoryUIHelpers on EntityCategory {
  // Example: IconData? get iconData => iconName != null ? IconData(int.parse(iconName!), fontFamily: 'MaterialIcons') : null;
  // Color? get displayColor => colorHex != null ? Color(int.parse('0xFF${colorHex!.substring(1)}')) : null;
  // Actual icon/color conversion will depend on how iconName and colorHex are stored and used.
}
