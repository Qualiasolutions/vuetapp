import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/theme_config.dart';
import '../../../ui/shared/widgets.dart';
import '../../../models/social_interests_entities.dart';
import 'package:go_router/go_router.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  // Sample data for now - will be replaced with Supabase MCP integration
  List<Event> _events = [
    Event(
      id: 1,
      name: 'Annual Book Fair',
      eventType: 'Conference',
      description: 'Local authors and publishers showcase',
      date: DateTime.now().add(const Duration(days: 15)),
      time: '10:00 AM',
      location: 'Convention Center',
      organizer: 'City Library',
    ),
    Event(
      id: 2,
      name: 'Photography Workshop',
      eventType: 'Workshop',
      description: 'Learn advanced photography techniques',
      date: DateTime.now().add(const Duration(days: 7)),
      time: '2:00 PM',
      location: 'Art Studio Downtown',
      organizer: 'Photo Society',
      notes: 'Bring your own camera',
    ),
    Event(
      id: 3,
      name: 'Community BBQ',
      eventType: 'Party',
      description: 'Annual neighborhood gathering',
      date: DateTime.now().add(const Duration(days: 30)),
      time: '5:00 PM',
      location: 'Central Park',
      organizer: 'Neighborhood Association',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Events'),
      floatingActionButton: VuetFAB(
        onPressed: () => context.go('/categories/social-interests/events/create'),
        tooltip: 'Add Event',
      ),
      body: _events.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _events.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildEventCard(_events[index]),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event,
            size: 64,
            color: AppColors.steel,
          ),
          const SizedBox(height: 16),
          Text(
            'No events yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.steel,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first event',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.steel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    final daysUntil = event.date.difference(DateTime.now()).inDays;
    // final isUpcoming = daysUntil >= 0; // Unused variable
    final isPast = daysUntil < 0;
    
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPast 
              ? AppColors.steel.withValues(alpha: 0.3)
              : AppColors.steel.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name and actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isPast 
                                ? AppColors.steel 
                                : AppColors.darkJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.eventType,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.steel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Date badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDateBadgeColor(daysUntil),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getDateBadgeText(daysUntil),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Event type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mediumTurquoise.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getEventTypeIcon(event.eventType),
                      color: isPast 
                          ? AppColors.steel 
                          : AppColors.mediumTurquoise,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(value, event),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Event details
              if (event.description != null && event.description!.isNotEmpty) ...[
                Text(
                  event.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isPast 
                        ? AppColors.steel 
                        : AppColors.darkJungleGreen,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],
              
              // Date and time
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.steel,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatEventDate(event.date),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.steel,
                    ),
                  ),
                  if (event.time != null && event.time!.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.steel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.time!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.steel,
                      ),
                    ),
                  ],
                ],
              ),
              
              if (event.location != null && event.location!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.steel,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.steel,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              if (event.organizer != null && event.organizer!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: AppColors.steel,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Organized by ${event.organizer!}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.steel,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getDateBadgeColor(int daysUntil) {
    if (daysUntil < 0) return AppColors.steel;
    if (daysUntil == 0) return Colors.red;
    if (daysUntil <= 7) return AppColors.orange;
    return AppColors.mediumTurquoise;
  }

  String _getDateBadgeText(int daysUntil) {
    if (daysUntil < 0) return 'Past';
    if (daysUntil == 0) return 'Today';
    if (daysUntil == 1) return 'Tomorrow';
    if (daysUntil <= 7) return '${daysUntil}d';
    return '${daysUntil}d';
  }

  String _formatEventDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _getEventTypeIcon(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'party':
        return Icons.celebration;
      case 'meeting':
        return Icons.business_center;
      case 'conference':
        return Icons.groups;
      case 'workshop':
        return Icons.build;
      case 'seminar':
        return Icons.school;
      case 'networking':
        return Icons.handshake;
      case 'social':
        return Icons.people;
      case 'fundraiser':
        return Icons.volunteer_activism;
      case 'competition':
        return Icons.emoji_events;
      case 'exhibition':
        return Icons.museum;
      case 'performance':
        return Icons.theater_comedy;
      case 'sports':
        return Icons.sports;
      default:
        return Icons.event;
    }
  }

  void _showEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.steel,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title with icon
              Row(
                children: [
                  Icon(
                    _getEventTypeIcon(event.eventType),
                    color: AppColors.mediumTurquoise,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Details
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Event Type', event.eventType),
                    if (event.description != null && event.description!.isNotEmpty)
                      _buildDetailRow('Description', event.description!),
                    _buildDetailRow('Date', _formatEventDate(event.date)),
                    if (event.time != null && event.time!.isNotEmpty)
                      _buildDetailRow('Time', event.time!),
                    if (event.location != null && event.location!.isNotEmpty)
                      _buildDetailRow('Location', event.location!),
                    if (event.organizer != null && event.organizer!.isNotEmpty)
                      _buildDetailRow('Organizer', event.organizer!),
                    if (event.attendees != null && event.attendees!.isNotEmpty)
                      _buildDetailRow('Attendees', event.attendees!),
                    if (event.notes != null && event.notes!.isNotEmpty)
                      _buildDetailRow('Notes', event.notes!),
                  ],
                ),
              ),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/categories/social-interests/events/edit/${event.id}');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.mediumTurquoise),
                      ),
                      child: const Text('Edit', style: TextStyle(color: AppColors.mediumTurquoise)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VuetSaveButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.steel,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkJungleGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Event event) {
    switch (action) {
      case 'edit':
        context.go('/categories/social-interests/events/edit/${event.id}');
        break;
      case 'delete':
        _showDeleteConfirmation(event);
        break;
    }
  }

  void _showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEvent(event);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteEvent(Event event) {
    setState(() {
      _events.removeWhere((e) => e.id == event.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${event.name} deleted'),
        backgroundColor: AppColors.mediumTurquoise,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppColors.white,
          onPressed: () {
            setState(() {
              _events.add(event);
            });
          },
        ),
      ),
    );
  }
}
