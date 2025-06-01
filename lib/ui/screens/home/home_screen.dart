import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vuet_app/models/calendar_event_model.dart'; // Import CalendarEventModel
import 'package:vuet_app/providers/calendar_providers.dart'; // Import calendar providers


// Filter, Sort, and Search State Providers
enum TaskSortOption { dueDate, priority, title, createdAt } // Keep task sort options for now, might need to adapt for events
final taskFilterStatusProvider = StateProvider<String?>((ref) => null); // null means all statuses
final taskSortOptionProvider = StateProvider<TaskSortOption>((ref) => TaskSortOption.dueDate);
final taskSortAscendingProvider = StateProvider<bool>((ref) => true); // Default ascending for due date
final taskSearchQueryProvider = StateProvider<String>((ref) => '');

// State provider for the selected day in the calendar
final _selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Provider for the list of events and tasks for the selected day
final selectedDayEventsProvider = FutureProvider.autoDispose<List<CalendarEventModel>>((ref) async {
  final selectedDay = ref.watch(_selectedDayProvider); // Watch the selected day state
  final searchQuery = ref.watch(taskSearchQueryProvider).toLowerCase(); // Use task search query for now

  // Get events for the selected day
  final events = await ref.watch(dayEventsProvider(selectedDay).future);
  
  // Apply search query filter (client-side on title and description)
  if (searchQuery.isNotEmpty) {
    return events.where((event) {
      final titleMatch = event.title.toLowerCase().contains(searchQuery);
      final descriptionMatch = event.description?.toLowerCase().contains(searchQuery) ?? false;
      return titleMatch || descriptionMatch;
    }).toList();
  }
  
  return events;
});


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // For the search functionality
  final searchController = TextEditingController();
  bool _isCalendarExpanded = false;

  // For the calendar
  // Use Riverpod state for selected day
  DateTime get _selectedDay => ref.watch(_selectedDayProvider);
  // set _selectedDay(DateTime date) => ref.read(_selectedDayProvider.notifier).state = date; // Setter removed

  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week; // Start with week view (half closed)

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the combined events and tasks for the selected day
    final eventsAsyncValue = ref.watch(selectedDayEventsProvider);

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
              ),
              onChanged: (value) {
                ref.read(taskSearchQueryProvider.notifier).state = value;
                // setState(() {
                //   _isSearching = value.isNotEmpty; // _isSearching removed
                // });
              },
            ),
          ),

          // Calendar view (collapsible) - Removed fixed height
          Material(
            elevation: 2,
            color: Theme.of(context).colorScheme.surface,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Calendar header with expand/collapse button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calendar',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(_isCalendarExpanded ? Icons.expand_less : Icons.expand_more),
                          label: Text(_isCalendarExpanded ? 'Collapse' : 'Expand'),
                          onPressed: () {
                            setState(() {
                              _isCalendarExpanded = !_isCalendarExpanded;
                              if (_isCalendarExpanded) {
                                _calendarFormat = CalendarFormat.month;
                              } else {
                                _calendarFormat = CalendarFormat.week;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Calendar widget with SingleChildScrollView to handle potential overflow
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      // Update the Riverpod state for selected day
                      ref.read(_selectedDayProvider.notifier).state = selectedDay;
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withAlpha((0.5 * 255).round()),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // New search bar below calendar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks and events...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune),
                    tooltip: 'Filter',
                    onPressed: () {
                      // TODO: Show filter options
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filter functionality coming soon!')),
                      );
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  ref.read(taskSearchQueryProvider.notifier).state = value;
                  // setState(() {
                  //   _isSearching = value.isNotEmpty; // _isSearching removed
                  // });
                },
              ),
            ),
          ),

          // Events/Tasks list for the selected day
          Expanded(
            child: eventsAsyncValue.when(
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks or events scheduled for ${DateFormat.yMMMMd().format(_selectedDay)}.',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // Sort events/tasks by start time (already done in provider, but good to be explicit)
                events.sort((a, b) => a.startTime.compareTo(b.startTime));

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final bool isTask = event.id.startsWith('task-');
                    final String originalTaskId = isTask ? event.id.substring(5) : ''; // Extract original task ID

                    // For tasks, check completion status. For events, there's no completion status in the model.
                    // This assumes tasks derived into CalendarEventModel retain some way to check status,
                    // or we fetch the original task model here if needed.
                    // For now, we'll simplify and assume we can't toggle completion
                    // directly from this combined list without fetching the original task.
                    // A better approach would be to have a union type or interface for list items.
                    // For now, we'll just display them. Toggling completion will need to navigate to task detail.

                    return ListTile(
                      leading: Icon(isTask ? Icons.task : Icons.event), // Icon to differentiate
                      title: Text(
                        event.title,
                        // Add strikethrough for completed tasks if we can determine status
                        // style: isTask && isCompleted ? TextStyle(decoration: TextDecoration.lineThrough) : null,
                      ),
                      subtitle: event.description != null && event.description!.isNotEmpty
                          ? Text(
                              event.description!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          if (isTask) {
                            // Navigate to Task Detail Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(taskId: originalTaskId),
                              ),
                            );
                          } else {
                            // TODO: Navigate to Event Detail Screen (if one exists)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Event detail screen not implemented.')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                         if (isTask) {
                            // Navigate to Task Detail Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(taskId: originalTaskId),
                              ),
                            );
                          } else {
                            // TODO: Navigate to Event Detail Screen (if one exists)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Event detail screen not implemented.')),
                            );
                          }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading events: $err',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(selectedDayEventsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Add Task floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
