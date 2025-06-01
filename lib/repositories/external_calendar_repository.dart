import 'package:vuet_app/constants/external_calendar_enums.dart';
import 'package:vuet_app/models/external_calendar/ical_event.dart';
import 'package:vuet_app/models/external_calendar/ical_integration.dart';

abstract class ExternalCalendarRepository {
  Future<List<ICalIntegration>> getICalIntegrations();

  Future<ICalIntegration> createICalIntegration({
    required String icalUrl,
    required String userId,
  });

  Future<ICalIntegration> updateICalIntegration({
    required String integrationId,
    ICalShareType? shareType,
  });

  Future<void> deleteICalIntegration(String integrationId);

  Future<void> syncICalIntegration(String integrationId);

  // Optional: Fetch events. This might also live in a separate ICalEventRepository
  // or be part of a more general TaskRepository if ICalEvents become tasks.
  Future<List<ICalEvent>> getICalEvents({
    String? integrationId, // Filter by a specific integration
    DateTime? startDate,   // Filter by date range
    DateTime? endDate,
  });
} 