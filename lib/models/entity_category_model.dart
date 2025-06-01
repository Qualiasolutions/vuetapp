import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_category_model.freezed.dart';
part 'entity_category_model.g.dart';

@freezed
class EntityCategoryModel with _$EntityCategoryModel {
  const factory EntityCategoryModel({
    required String id,
    required String name,
    String? description,
    String? icon,
    @JsonKey(name: 'owner_id') String? ownerId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    String? color,
    int? priority,
    DateTime? lastAccessedAt,
    @Default(false) @JsonKey(name: 'is_professional') bool isProfessional,
    String? parentId, // New field for hierarchy
    // Add the integer appCategoryId, assuming it can be fetched from the database
    // If the database column name is different, adjust the @JsonKey accordingly.
    // For example, if the column is 'int_id', use @JsonKey(name: 'int_id') int? appCategoryId,
    int? appCategoryId, 
  }) = _EntityCategoryModel;

  factory EntityCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$EntityCategoryModelFromJson(json);
}
