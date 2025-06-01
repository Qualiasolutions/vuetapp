import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeblock_model.freezed.dart';
part 'timeblock_model.g.dart';

@freezed
class TimeblockModel with _$TimeblockModel {
  const factory TimeblockModel({
    required String id,
    required String userId,
    String? title,
    required int dayOfWeek, // 1 for Monday, 7 for Sunday
    required String startTime, // HH:mm:ss format
    required String endTime, // HH:mm:ss format
    String? color, // Hex color code e.g., #RRGGBB
    String? description,
    /// Activity type for categorization (work, exercise, personal, etc.)
    String? activityType,
    /// ID of the routine this timeblock is linked to (if applicable)
    String? linkedRoutineId,
    /// ID of the task this timeblock is linked to (if applicable)
    String? linkedTaskId,
    /// Whether this timeblock should sync with external calendar
    @Default(false) bool syncWithCalendar,
    /// External calendar event ID (for bidirectional sync)
    String? externalCalendarEventId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TimeblockModel;

  factory TimeblockModel.fromJson(Map<String, dynamic> json) =>
      _$TimeblockModelFromJson(json);
}
