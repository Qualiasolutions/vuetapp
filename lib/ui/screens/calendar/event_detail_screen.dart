import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/providers/calendar_providers.dart';
import 'package:vuet_app/ui/screens/calendar/edit_event_screen.dart';
import 'package:vuet_app/services/calendar_event_service.dart';

/// Screen for displaying calendar event details
class EventDetailScreen extends ConsumerWidget {
  /// ID of the event to display
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(calendarEventProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditEvent(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDeleteEvent(context, ref),
          ),
        ],
      ),
      body: eventAsync.when(
        data: (event) {
          if (event == null) {
            return const Center(
              child: Text('Event not found'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16.0),
                
                // Date and time info
                _buildInfoCard(
                  context: context,
                  title: 'When',
                  icon: Icons.calendar_today,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDateRange(event),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      if (event.isRecurring && event.recurrencePattern != null)
                        Text(
                          'Repeats: ${event.recurrencePattern!.toLowerCase().isNotEmpty ? event.recurrencePattern!.toLowerCase()[0].toUpperCase() + event.recurrencePattern!.toLowerCase().substring(1) : event.recurrencePattern!.toLowerCase()}',
                          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                
                // Location
                if (event.location != null && event.location!.isNotEmpty)
                  _buildInfoCard(
                    context: context,
                    title: 'Where',
                    icon: Icons.location_on,
                    child: Text(
                      event.location!,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                
                // Description
                if (event.description != null && event.description!.isNotEmpty)
                  _buildInfoCard(
                    context: context,
                    title: 'Description',
                    icon: Icons.description,
                    child: Text(
                      event.description!,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                
                // Created/Updated info
                _buildInfoCard(
                  context: context,
                  title: 'Event Info',
                  icon: Icons.info_outline,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Created: ${DateFormat.yMMMd().add_jm().format(event.createdAt)}',
                        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      Text(
                        'Last Updated: ${DateFormat.yMMMd().add_jm().format(event.updatedAt)}',
                        style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Error loading event: $err'),
        ),
      ),
    );
  }

  /// Build a card with title and icon for displaying event info
  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.teal,
                  size: 20.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  /// Format the date range for display
  String _formatDateRange(CalendarEventModel event) {
    final startDate = DateFormat.yMMMd().format(event.startTime);
    final endDate = DateFormat.yMMMd().format(event.endTime);
    
    if (event.allDay) {
      if (startDate == endDate) {
        return '$startDate (All day)';
      } else {
        return '$startDate - $endDate (All day)';
      }
    } else {
      final startTime = DateFormat.jm().format(event.startTime);
      final endTime = DateFormat.jm().format(event.endTime);
      
      if (startDate == endDate) {
        return '$startDate, $startTime - $endTime';
      } else {
        return '$startDate, $startTime - $endDate, $endTime';
      }
    }
  }

  /// Navigate to edit event screen
  void _navigateToEditEvent(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.read(calendarEventProvider(eventId));
    
    // Only navigate if we have a valid event
    if (eventAsync.value != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditEventScreen(event: eventAsync.value!),
        ),
      );
    }
  }

  /// Confirm and handle event deletion
  void _confirmDeleteEvent(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.read(calendarEventProvider(eventId));
    
    // Only show dialog if we have a valid event
    if (eventAsync.value != null) {
      final event = eventAsync.value!;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Event'),
          content: Text('Are you sure you want to delete "${event.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEvent(context, ref, event);
              },
              child: const Text('DELETE'),
            ),
          ],
        ),
      );
    }
  }

  /// Delete the event and navigate back
  void _deleteEvent(BuildContext context, WidgetRef ref, CalendarEventModel event) async {
    final calendarService = ref.read(calendarEventServiceProvider);
    
    try {
      await calendarService.deleteEvent(event.id, event.title);
      if (context.mounted) {
        Navigator.of(context).pop(); // Go back to calendar screen
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: $error')),
        );
      }
    }
  }
}
