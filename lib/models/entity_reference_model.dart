import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity_reference_model.freezed.dart';
part 'entity_reference_model.g.dart';

@freezed
class EntityReferenceModel with _$EntityReferenceModel {
  const factory EntityReferenceModel({
    required String id,
    required String entityId,
    required String referenceId,
    DateTime? createdAt,
  }) = _EntityReferenceModel;

  factory EntityReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$EntityReferenceModelFromJson(json);
} 