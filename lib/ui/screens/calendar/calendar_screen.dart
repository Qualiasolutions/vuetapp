import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/providers/calendar_providers.dart';
import 'package:vuet_app/ui/screens/calendar/create_event_screen.dart';
import 'package:intl/intl.dart';

/// Unified calendar screen showing events, tasks, and timeblocks
class CalendarScreen extends ConsumerStatefulWidget {
  /// Constructor
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  Widget build(BuildContext context) {
    // Get events for the currently selected day
    final selectedDayEvents = ref.watch(dayEventsProvider(_selectedDay));
    
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Calendar'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () => _navigateToCreateEvent(),
      //       tooltip: 'Create Event',
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          _buildCalendar(),
          const Divider(),
          Expanded(
            child: _buildEventsList(selectedDayEvents),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildCalendar() {
    // Get events for the month to show dots on calendar
    final monthEvents = ref.watch(monthEventsProvider(_focusedDay));
    
    return TableCalendar<CalendarEventModel>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _calendarFormat,
      eventLoader: (day) {
        if (monthEvents.hasValue) {
          // Filter events for this specific day
          return monthEvents.value!.where((event) => 
            isSameDay(event.startTime, day) ||
            (event.allDay && day.isAfter(event.startTime) && 
            day.isBefore(event.endTime)) || 
            isSameDay(event.endTime, day)
          ).toList();
        }
        return [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      // Calendar style
      calendarStyle: CalendarStyle(
        markersMaxCount: 3,
        markersAlignment: Alignment.bottomCenter,
        markerDecoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        markerSize: 5.0, // Smaller marker size
        markerMargin: const EdgeInsets.only(top: 8), // Add more space between day and marker
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha((0.5 * 255).round()),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        cellMargin: const EdgeInsets.all(6), // Add more space between days
        outsideDaysVisible: false, // Hide days from other months
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: const TextStyle(fontSize: 14.0),
        formatButtonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
  
  Widget _buildEventsList(AsyncValue<List<CalendarEventModel>> events) {
    return events.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error loading events: ${err.toString()}'),
      ),
      data: (eventsList) {
        if (eventsList.isEmpty) {
          return const Center(
            child: Text('No events for this day'),
          );
        }
        
        return ListView.builder(
          itemCount: eventsList.length,
          itemBuilder: (context, index) {
            final event = eventsList[index];
            return _buildEventCard(event);
          },
        );
      },
    );
  }
  
  Widget _buildEventCard(CalendarEventModel event) {
    // Identify event type by its ID prefix
    final bool isTask = event.id.startsWith('task-');
    final bool isTimeblock = event.id.startsWith('timeblock-');
    
    // Set different colors for different event types
    Color cardColor;
    IconData eventIcon;
    
    if (isTask) {
      cardColor = Colors.amber.shade100;
      eventIcon = Icons.task_alt;
    } else if (isTimeblock) {
      cardColor = Colors.green.shade100;
      eventIcon = Icons.access_time_filled;
    } else {
      cardColor = Colors.blue.shade100;
      eventIcon = Icons.event;
    }
    
    final startTimeStr = DateFormat('h:mm a').format(event.startTime);
    final endTimeStr = event.allDay ? 'All day' : DateFormat('h:mm a').format(event.endTime);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      color: cardColor,
      child: ListTile(
        leading: Icon(eventIcon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$startTimeStr - $endTimeStr'),
            if (event.description?.isNotEmpty ?? false)
              Text(
                event.description!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _onEventTap(event),
      ),
    );
  }
  
  void _navigateToCreateEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEventScreen(selectedDate: _selectedDay),
      ),
    );
  }
  
  void _onEventTap(CalendarEventModel event) {
    // Handle event tap based on type
    if (event.id.startsWith('task-')) {
      final taskId = event.id.replaceFirst('task-', '');
      // Navigate to task detail
      // Navigator.pushNamed(context, '/tasks/detail', arguments: {'id': taskId});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task: $taskId - Navigation not implemented yet')),
      );
    } else if (event.id.startsWith('timeblock-')) {
      final timeblockParts = event.id.replaceFirst('timeblock-', '').split('-');
      if (timeblockParts.isNotEmpty) {
        final timeblockId = timeblockParts[0];
        // Navigate to timeblock detail
        Navigator.pushNamed(context, '/timeblocks/detail', arguments: {'id': timeblockId});
      }
    } else {
      // Navigate to event detail
      // Navigator.pushNamed(context, '/calendar/detail', arguments: {'id': event.id});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event: ${event.id} - Navigation not implemented yet')),
      );
    }
  }
}
