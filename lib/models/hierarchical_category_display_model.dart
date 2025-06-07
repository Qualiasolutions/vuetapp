import 'package:freezed_annotation/freezed_annotation.dart';
import './entity_category_model.dart';

part 'hierarchical_category_display_model.freezed.dart';

@freezed
class HierarchicalCategoryDisplayModel with _$HierarchicalCategoryDisplayModel {
  const factory HierarchicalCategoryDisplayModel({
    required EntityCategory category, // Updated from EntityCategoryModel
    required List<HierarchicalCategoryDisplayModel> children,
  }) = _HierarchicalCategoryDisplayModel;
}
