import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference_group_model.freezed.dart';
part 'reference_group_model.g.dart';

@freezed
class ReferenceGroupModel with _$ReferenceGroupModel {
  const factory ReferenceGroupModel({
    required String id,
    required String name,
    String? description,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReferenceGroupModel;

  factory ReferenceGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ReferenceGroupModelFromJson(json);
}
