import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vuet_app/constants/external_calendar_enums.dart';

part 'ical_integration.freezed.dart';
part 'ical_integration.g.dart';

@freezed
class ICalIntegration with _$ICalIntegration {
  const factory ICalIntegration({
    required String id,
    required String userId,
    required String icalName,
    required String icalUrl, // URL used for syncing
    required ICalType icalType,
    required ICalShareType shareType,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    String? syncErrorMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ICalIntegration;

  factory ICalIntegration.fromJson(Map<String, dynamic> json) =>
      _$ICalIntegrationFromJson(json);
}

enum SyncStatus {
  pending,
  success,
  failed,
  never,
} 