import 'package:freezed_annotation/freezed_annotation.dart';

part 'reference_model.freezed.dart';
part 'reference_model.g.dart';

@freezed
class ReferenceModel with _$ReferenceModel {
  const factory ReferenceModel({
    required String id,
    required String name,
    String? groupId,
    String? value,
    String? type,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReferenceModel;

  factory ReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$ReferenceModelFromJson(json);
}
