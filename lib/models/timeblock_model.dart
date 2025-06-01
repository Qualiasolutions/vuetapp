import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeblock_model.freezed.dart';
part 'timeblock_model.g.dart';

/// TimeBlocks feature - Premium feature for time management
/// Based on the React app's TimeBlock system
@freezed
class TimeBlockModel with _$TimeBlockModel {
  const factory TimeBlockModel({
    required String id,
    required String userId,
    required String day, // MONDAY, TUESDAY, etc.
    required String startTime, // Format: "HH:mm"
    required String endTime, // Format: "HH:mm"
    required String title,
    String? description,
    String? color,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TimeBlockModel;

  factory TimeBlockModel.fromJson(Map<String, dynamic> json) =>
      _$TimeBlockModelFromJson(json);
}

/// Days of the week enum (matching React app)
enum TimeBlockDay {
  monday('MONDAY'),
  tuesday('TUESDAY'),
  wednesday('WEDNESDAY'),
  thursday('THURSDAY'),
  friday('FRIDAY'),
  saturday('SATURDAY'),
  sunday('SUNDAY');

  const TimeBlockDay(this.value);
  final String value;
}

/// Routine model - Premium feature for recurring time blocks
/// Based on the React app's Routine system
@freezed
class RoutineModel with _$RoutineModel {
  const factory RoutineModel({
    required String id,
    required String userId,
    required String title,
    String? description,
    String? color,
    
    // Days of the week (boolean for each day)
    @Default(false) bool monday,
    @Default(false) bool tuesday,
    @Default(false) bool wednesday,
    @Default(false) bool thursday,
    @Default(false) bool friday,
    @Default(false) bool saturday,
    @Default(false) bool sunday,
    
    required String startTime, // Format: "HH:mm"
    required String endTime, // Format: "HH:mm"
    
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RoutineModel;

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);
}

/// Helper extension for working with routines
extension RoutineModelX on RoutineModel {
  /// Get list of active days for this routine
  List<TimeBlockDay> get activeDays {
    final days = <TimeBlockDay>[];
    if (monday) days.add(TimeBlockDay.monday);
    if (tuesday) days.add(TimeBlockDay.tuesday);
    if (wednesday) days.add(TimeBlockDay.wednesday);
    if (thursday) days.add(TimeBlockDay.thursday);
    if (friday) days.add(TimeBlockDay.friday);
    if (saturday) days.add(TimeBlockDay.saturday);
    if (sunday) days.add(TimeBlockDay.sunday);
    return days;
  }
  
  /// Check if routine is active on a specific day
  bool isActiveOnDay(TimeBlockDay day) {
    switch (day) {
      case TimeBlockDay.monday: return monday;
      case TimeBlockDay.tuesday: return tuesday;
      case TimeBlockDay.wednesday: return wednesday;
      case TimeBlockDay.thursday: return thursday;
      case TimeBlockDay.friday: return friday;
      case TimeBlockDay.saturday: return saturday;
      case TimeBlockDay.sunday: return sunday;
    }
  }
}
