import 'package:freezed_annotation/freezed_annotation.dart';

part 'ical_event.freezed.dart';
part 'ical_event.g.dart';

@freezed
class ICalEvent with _$ICalEvent {
  const factory ICalEvent({
    required String id,
    required String userId,
    required String icalIntegrationId,
    required String title,
    required DateTime startDateTime,
    required DateTime endDateTime,
    String? rrule, // iCalendar RRULE string for recurrence
    String? originalEventId, // UID from the iCal event, for updates/deletions
    DateTime? originalEventStartTime, // DTSTART from the iCal event, for updates of recurring events
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ICalEvent;

  factory ICalEvent.fromJson(Map<String, dynamic> json) =>
      _$ICalEventFromJson(json);
} 