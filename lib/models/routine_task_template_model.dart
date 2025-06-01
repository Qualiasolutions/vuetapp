import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_task_template_model.freezed.dart';
part 'routine_task_template_model.g.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

@freezed
abstract class RoutineTaskTemplateModel with _$RoutineTaskTemplateModel {
  const factory RoutineTaskTemplateModel({
    required String id,
    required String routineId,
    required String userId,
    required String title,
    String? description,
    int? estimatedDurationMinutes,
    String? categoryId,
    TaskPriority? priority,
    @Default(0) int orderInRoutine,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoutineTaskTemplateModel;

  factory RoutineTaskTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineTaskTemplateModelFromJson(json);
}
