import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/ui/screens/tasks/task_detail_screen.dart';
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart';

/// Enhanced Calendar Home Screen with List + Calendar views
/// Matches the React app functionality with dual view modes
class EnhancedCalendarHomeScreen extends ConsumerStatefulWidget {
  const EnhancedCalendarHomeScreen({super.key});

  @override
  ConsumerState<EnhancedCalendarHomeScreen> createState() =>
      _EnhancedCalendarHomeScreenState();
}

class _EnhancedCalendarHomeScreenState
    extends ConsumerState<EnhancedCalendarHomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // View mode toggle
  bool _isListView = true; // Default to list view

  // Filter states
  String? _statusFilter;
  TaskType? _typeFilter;
  String? _entityFilter;
  bool _showProfessionalOnly = false;

  // Search state
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TaskModel> _getEventsForDay(DateTime day, List<TaskModel> allTasks) {
    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return isSameDay(task.dueDate!, day);
    }).toList();
  }

  List<TaskModel> _getFilteredTasks(List<TaskModel> tasks) {
    return tasks.where((task) {
      // Search filter
      if (_searchQuery.isNotEmpty &&
          !task.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Status filter
      if (_statusFilter != null && task.status != _statusFilter) {
        return false;
      }

      // Type filter
      if (_typeFilter != null && task.taskType != _typeFilter) {
        return false;
      }

      // Entity filter (simplified - would need entity data)
      if (_entityFilter != null && task.entityId != _entityFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsyncValue = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          // Search
          if (_isListView)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(),
            ),
          // Filter
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterDialog(),
          ),
          // View toggle
          IconButton(
            icon: Icon(_isListView ? Icons.calendar_month : Icons.list),
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
            tooltip: _isListView ? 'Calendar View' : 'List View',
          ),
          // Add task
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToCreateTask(),
          ),
        ],
      ),
      body: tasksAsyncValue.when(
        data: (tasks) {
          final filteredTasks = _getFilteredTasks(tasks);

          if (_isListView) {
            return _buildListView(filteredTasks);
          } else {
            return _buildCalendarView(filteredTasks);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text('Error loading tasks: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(tasksProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return _buildEmptyState();
    }

    // Group tasks by date
    final Map<String, List<TaskModel>> groupedTasks = {};
    for (final task in tasks) {
      final date = task.dueDate != null
          ? DateFormat('yyyy-MM-dd').format(task.dueDate!)
          : 'No Date';
      groupedTasks.putIfAbsent(date, () => []).add(task);
    }

    final sortedDates = groupedTasks.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final dateKey = sortedDates[index];
        final tasksForDate = groupedTasks[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(dateKey),
            const SizedBox(height: 8),
            ...tasksForDate.map((task) => _buildTaskCard(task)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildCalendarView(List<TaskModel> tasks) {
    return Column(
      children: [
        // Calendar widget
        TableCalendar<TaskModel>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: (day) => _getEventsForDay(day, tasks),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            markerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8),
        // Selected day tasks
        Expanded(
          child: _buildSelectedDayTasks(tasks),
        ),
      ],
    );
  }

  Widget _buildSelectedDayTasks(List<TaskModel> allTasks) {
    final selectedDayTasks = _selectedDay != null
        ? _getEventsForDay(_selectedDay!, allTasks)
        : <TaskModel>[];

    if (selectedDayTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _selectedDay != null
                  ? 'No tasks for ${DateFormat('MMMM d, y').format(_selectedDay!)}'
                  : 'Select a day to view tasks',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: selectedDayTasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(selectedDayTasks[index]);
      },
    );
  }

  Widget _buildDateHeader(String dateKey) {
    if (dateKey == 'No Date') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'No Due Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      );
    }

    final date = DateTime.parse(dateKey);
    final isToday = isSameDay(date, DateTime.now());
    final isPast = date.isBefore(DateTime.now()) && !isToday;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isToday
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : isPast
                ? Colors.red.withOpacity(0.1)
                : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isToday
            ? 'Today - ${DateFormat('MMMM d').format(date)}'
            : DateFormat('EEEE, MMMM d').format(date),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isToday
              ? Theme.of(context).colorScheme.primary
              : isPast
                  ? Colors.red[700]
                  : Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    final isCompleted = task.status == 'completed';
    final isOverdue = task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCompleted
              ? Colors.green
              : isOverdue
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
          child: Icon(
            task.taskType != null
                ? _getTaskTypeIcon(task.taskType!)
                : Icons.task_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (task.dueDate != null)
                  Text(
                    'Due: ${DateFormat('MMM d, h:mm a').format(task.dueDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                    ),
                  ),
                if (task.taskType != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.taskType!.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isCompleted)
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: () => _markTaskComplete(task),
                tooltip: 'Mark Complete',
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editTask(task),
              tooltip: 'Edit Task',
            ),
          ],
        ),
        onTap: () => _viewTaskDetails(task),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToCreateTask,
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
          ),
        ],
      ),
    );
  }

  IconData _getTaskTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.task:
        return Icons.task_alt;
      case TaskType.appointment:
        return Icons.event;
      case TaskType.dueDate:
        return Icons.schedule;
      case TaskType.activity:
        return Icons.local_activity;
      case TaskType.transport:
        return Icons.directions_car;
      case TaskType.accommodation:
        return Icons.hotel;
      case TaskType.anniversary:
        return Icons.cake;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Tasks'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status filter
            DropdownButtonFormField<String?>(
              value: _statusFilter,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All Statuses')),
                ...[
                  'pending',
                  'in_progress',
                  'completed',
                  'cancelled'
                ].map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.replaceAll('_', ' ').toUpperCase()),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _statusFilter = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Type filter
            DropdownButtonFormField<TaskType?>(
              value: _typeFilter,
              decoration: const InputDecoration(labelText: 'Task Type'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Types')),
                ...TaskType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _typeFilter = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _statusFilter = null;
                _typeFilter = null;
                _entityFilter = null;
                _showProfessionalOnly = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear Filters'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskScreen(),
      ),
    );
  }

  void _viewTaskDetails(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(taskId: task.id),
      ),
    );
  }

  void _editTask(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTaskScreen(
          taskToEdit: task,
        ),
      ),
    );
  }

  void _markTaskComplete(TaskModel task) {
    // Update task status to completed
    final updatedTask = task.copyWith(
      status: 'completed',
      completedAt: DateTime.now(),
    );

    // You would call your task service here to update the task
    // ref.read(taskServiceProvider).updateTask(updatedTask);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" marked as complete'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Undo the completion
            final revertedTask = task.copyWith(
              status: 'pending',
              completedAt: null,
            );
            // ref.read(taskServiceProvider).updateTask(revertedTask);
          },
        ),
      ),
    );
  }
}
