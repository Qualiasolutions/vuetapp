import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_model.freezed.dart';
part 'routine_model.g.dart';

@freezed
abstract class RoutineModel with _$RoutineModel {
  const factory RoutineModel({
    required String id,
    required String userId,
    required String name,
    // Simple day-of-week pattern like React app
    @Default(false) bool monday,
    @Default(false) bool tuesday,
    @Default(false) bool wednesday,
    @Default(false) bool thursday,
    @Default(false) bool friday,
    @Default(false) bool saturday,
    @Default(false) bool sunday,
    // Simple start/end times
    required String startTime, // "HH:mm" format
    required String endTime,   // "HH:mm" format
    // Family members (like React app)
    @Default([]) List<String> members, // User IDs of family members
    // Optional fields
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoutineModel;

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);
}
