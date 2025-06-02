import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_subcategory_model.freezed.dart';
part 'entity_subcategory_model.g.dart';

@freezed
class EntitySubcategoryModel with _$EntitySubcategoryModel {
  const factory EntitySubcategoryModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    @JsonKey(name: 'display_name') required String displayName,
    String? icon,
    @JsonKey(name: 'tag_name') String? tagName,
    String? color,
    @JsonKey(name: 'entity_types') required List<String> entityTypeIds,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _EntitySubcategoryModel;

  factory EntitySubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$EntitySubcategoryModelFromJson(json);
} 