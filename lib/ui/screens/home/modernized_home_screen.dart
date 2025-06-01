import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/providers/calendar_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

// Filter, Sort, and Search State Providers
enum TaskSortOption { dueDate, priority, title, createdAt }

final taskFilterStatusProvider = StateProvider<String?>((ref) => null);
final taskSortOptionProvider =
    StateProvider<TaskSortOption>((ref) => TaskSortOption.dueDate);
final taskSortAscendingProvider = StateProvider<bool>((ref) => true);
final taskSearchQueryProvider = StateProvider<String>((ref) => '');

// State provider for the selected day in the calendar
final _selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Provider for the list of events and tasks for the selected day
final selectedDayEventsProvider =
    FutureProvider.autoDispose<List<CalendarEventModel>>((ref) async {
  final selectedDay = ref.watch(_selectedDayProvider);
  final searchQuery = ref.watch(taskSearchQueryProvider).toLowerCase();

  final events = await ref.watch(dayEventsProvider(selectedDay).future);

  if (searchQuery.isNotEmpty) {
    return events.where((event) {
      final titleMatch = event.title.toLowerCase().contains(searchQuery);
      final descriptionMatch =
          event.description?.toLowerCase().contains(searchQuery) ?? false;
      return titleMatch || descriptionMatch;
    }).toList();
  }

  return events;
});

class ModernizedHomeScreen extends ConsumerStatefulWidget {
  const ModernizedHomeScreen({super.key});

  @override
  ConsumerState<ModernizedHomeScreen> createState() =>
      _ModernizedHomeScreenState();
}

class _ModernizedHomeScreenState extends ConsumerState<ModernizedHomeScreen>
    with TickerProviderStateMixin {
  final searchController = TextEditingController();
  bool _isCalendarExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  DateTime get _selectedDay => ref.watch(_selectedDayProvider);
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsyncValue = ref.watch(selectedDayEventsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // Calendar Section - Make it flexible
              Flexible(
                flex: 0,
                child: _buildModernCalendarSection(),
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ModernComponents.modernSearchBar(
                  hintText: 'Search tasks and events...',
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(taskSearchQueryProvider.notifier).state = value;
                  },
                  onClear: () {
                    searchController.clear();
                    ref.read(taskSearchQueryProvider.notifier).state = '';
                  },
                ),
              ),

              // Current Day Header
              Flexible(
                flex: 0,
                child: _buildCurrentDayHeader(),
              ),

              // Events/Tasks List - Takes remaining space
              Expanded(
                child: _buildEventsList(eventsAsyncValue),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildModernCalendarSection() {
    final monthEvents = ref.watch(monthEventsProvider(_focusedDay));
    
    return ModernComponents.modernCard(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMMd().format(_selectedDay),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  // Settings Menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onSelected: _handleMenuSelection,
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text('Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'account',
                        child: Row(
                          children: [
                            Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text('Account'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            const Text('Settings'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  ModernComponents.modernButton(
                    text: _isCalendarExpanded ? 'Collapse' : 'Expand',
                    onPressed: _toggleCalendar,
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.grey.shade700,
                    icon: _isCalendarExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Calendar Widget
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _isCalendarExpanded ? 400 : 200,
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _isCalendarExpanded ? CalendarFormat.month : CalendarFormat.week,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                eventLoader: (day) {
                  if (monthEvents.hasValue) {
                    // Return events for this day to show dots
                    return monthEvents.value!.where((event) => 
                      isSameDay(event.startTime, day) ||
                      (event.allDay && day.isAfter(event.startTime) && 
                      day.isBefore(event.endTime)) || 
                      isSameDay(event.endTime, day)
                    ).toList();
                  }
                  return [];
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha((0.3 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.grey.shade600),
                  outsideDaysVisible: false,
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                    // Adjust padding to move the dot down
                    // This creates a small dot at the bottom center of the day cell
                    // The size of the dot is controlled by the padding and the circle shape
                  ),
                  markerMargin: const EdgeInsets.only(top: 4, bottom: 4), // Add margin to push it down
                  markerSize: 6.0, // Make the marker a small dot
                  markersAlignment: Alignment.bottomCenter, // Align to bottom center
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentDayHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.today,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSameDay(_selectedDay, DateTime.now()) ? 'Today' : 'Selected Day',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDay),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(AsyncValue<List<CalendarEventModel>> eventsAsyncValue) {
    return eventsAsyncValue.when(
      data: (events) {
        if (events.isEmpty) {
          return _buildEmptyState();
        }

        events.sort((a, b) => a.startTime.compareTo(b.startTime));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: events.length,
          itemBuilder: (context, index) => _buildEventCard(events[index], index),
        );
      },
      loading: () => _buildLoadingState(),
      error: (err, stack) => _buildErrorState(err),
    );
  }

  Widget _buildEventCard(CalendarEventModel event, int index) {
    // Determine event type and display name
    String displayType = 'Event';
    IconData eventIcon = Icons.event;
    Color eventColor = const Color(0xFF2196F3);
    
    if (event.id.startsWith('task-')) {
      // Parse the display type from the title (set by calendar provider)
      if (event.title.startsWith('Appointment:')) {
        displayType = 'Appointment';
        eventIcon = Icons.person;
        eventColor = const Color(0xFF9C27B0);
      } else if (event.title.startsWith('Activity:')) {
        displayType = 'Activity';
        eventIcon = Icons.local_activity;
        eventColor = const Color(0xFFFF9800);
      } else if (event.title.startsWith('Transport:')) {
        displayType = 'Transport';
        eventIcon = Icons.directions_car;
        eventColor = const Color(0xFF2196F3);
      } else if (event.title.startsWith('Accommodation:')) {
        displayType = 'Accommodation';
        eventIcon = Icons.hotel;
        eventColor = const Color(0xFF795548);
      } else if (event.title.startsWith('Anniversary:')) {
        displayType = 'Anniversary';
        eventIcon = Icons.cake;
        eventColor = const Color(0xFFE91E63);
      } else if (event.title.startsWith('Due Date:')) {
        displayType = 'Due Date';
        eventIcon = Icons.schedule;
        eventColor = const Color(0xFFFF5722);
      } else {
        displayType = 'Task';
        eventIcon = Icons.task_alt;
        eventColor = const Color(0xFF4CAF50);
      }
    }

    final String originalTaskId = event.id.startsWith('task-') ? event.id.substring(5) : '';

    return ModernComponents.modernCard(
      onTap: () => _navigateToEventDetail(event.id.startsWith('task-'), originalTaskId),
      child: Row(
        children: [
          // Time indicator
          Container(
            width: 60,
            constraints: const BoxConstraints(minWidth: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.Hm().format(event.startTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormat.Hm().format(event.endTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Divider line
          Container(
            width: 3,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: eventColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Event details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      eventIcon,
                      size: 18,
                      color: eventColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayType,
                      style: TextStyle(
                        color: eventColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Flexible( // Wrap title Text with Flexible
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1, // Add maxLines
                    overflow: TextOverflow.ellipsis, // Add overflow
                  ),
                ),
                if (event.description != null && event.description!.isNotEmpty)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        event.description!, // Positional data argument
                        style: TextStyle(   // Named argument 'style'
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 2,        // Named argument 'maxLines'
                        overflow: TextOverflow.ellipsis, // Named argument 'overflow'
                      ), // End Text()
                    ), // End Padding()
                  ), // End Flexible()
              ],
            ),
          ),

          // Arrow icon
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: ModernComponents.modernCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No events for ${DateFormat.yMMMMd().format(_selectedDay)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new task',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: 3,
      itemBuilder: (context, index) => ModernComponents.cardLoadingSkeleton(),
    );
  }

  Widget _buildErrorState(Object err) {
    return Center(
      child: ModernComponents.modernCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              err.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Trigger a rebuild
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        ref.read(_selectedDayProvider.notifier).state = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      case 'account':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account settings coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Settings coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
    }
  }

  void _navigateToEventDetail(bool isTask, String originalTaskId) {
    if (isTask && originalTaskId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(taskId: originalTaskId),
        ),
      );
    }
  }
}
