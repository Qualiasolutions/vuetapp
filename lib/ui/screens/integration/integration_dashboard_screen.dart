import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/integrated_task_providers.dart';
import 'package:vuet_app/providers/routine_providers.dart';
import 'package:vuet_app/providers/lists_providers.dart' as lists_providers;
import 'package:vuet_app/providers/timeblock_providers.dart'
    as timeblock_providers;
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/task_model.dart';

class IntegrationDashboardScreen extends ConsumerWidget {
  const IntegrationDashboardScreen({super.key});

  // Helper method to format days for routine display
  String _getFormattedDays(RoutineModel routine) {
    final days = <String>[];
    if (routine.monday) days.add('Mon');
    if (routine.tuesday) days.add('Tue');
    if (routine.wednesday) days.add('Wed');
    if (routine.thursday) days.add('Thu');
    if (routine.friday) days.add('Fri');
    if (routine.saturday) days.add('Sat');
    if (routine.sunday) days.add('Sun');
    
    if (days.isEmpty) return 'No specific days'; // Or 'Runs as per schedule'
    if (days.length == 7) return 'Every day';
    return days.join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 4 Integration Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('🔗 Cross-Feature Integration Status'),
            const SizedBox(height: 16),

            // Integration Overview Cards
            _buildIntegrationOverview(ref),
            const SizedBox(height: 24),

            // Routines → Tasks Integration
            _buildSectionHeader('🔄 Routines → Tasks Integration'),
            const SizedBox(height: 16),
            _buildRoutineTasksSection(ref),
            const SizedBox(height: 24),

            // Lists → Tasks Integration
            _buildSectionHeader('📝 Lists → Tasks Integration'),
            const SizedBox(height: 16),
            _buildListTasksSection(ref),
            const SizedBox(height: 24),

            // Timeblocks ↔ Integration
            _buildSectionHeader('⏰ Timeblocks Integration'),
            const SizedBox(height: 16),
            _buildTimeblocksSection(ref),
            const SizedBox(height: 24),

            // Analytics Section
            _buildSectionHeader('📊 Integration Analytics'),
            const SizedBox(height: 16),
            _buildAnalyticsSection(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildIntegrationOverview(WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Routine Tasks',
            ref.watch(tasksByIntegrationTypeProvider('routine')),
            Colors.green,
            Icons.repeat,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Manual Tasks',
            ref.watch(tasksByIntegrationTypeProvider('manual')),
            Colors.blue,
            Icons.task_alt,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Overdue Tasks',
            ref.watch(tasksByIntegrationTypeProvider('overdue')),
            Colors.red,
            Icons.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title,
      AsyncValue<List<TaskModel>> tasksAsync, Color color, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            tasksAsync.when(
              data: (tasks) => Text(
                '${tasks.length}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) =>
                  const Text('Error', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineTasksSection(WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);

    return routinesAsync.when(
      data: (routines) => Column(
        children: [
          if (routines.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'No routines found. Create a routine to see task generation in action!'),
              ),
            )
          else
            ...routines
                .take(3)
                .map((routine) => _buildRoutineCard(routine, ref)),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading routines: $error',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildRoutineCard(RoutineModel routine, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksFromRoutineProvider(routine.id));
    final analyticsAsync = ref.watch(routineTaskAnalyticsProvider(routine.id));
    final formattedDays = _getFormattedDays(routine);
    final timeDisplay = '${routine.startTime} - ${routine.endTime}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(routine.name),
        subtitle: Text('$formattedDays at $timeDisplay'), // Updated subtitle
        leading: const Icon(Icons.repeat, color: Colors.green),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Analytics
                analyticsAsync.when(
                  data: (analytics) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnalyticChip(
                          'Total', '${analytics['totalTasks']}', Colors.blue),
                      _buildAnalyticChip('Completed',
                          '${analytics['completedTasks']}', Colors.green),
                      _buildAnalyticChip('Pending',
                          '${analytics['pendingTasks']}', Colors.orange),
                      _buildAnalyticChip(
                          'Rate',
                          '${(analytics['completionRate'] * 100).toInt()}%',
                          Colors.purple),
                    ],
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Analytics unavailable'),
                ),
                const SizedBox(height: 16),

                // Generated Tasks
                const Text('Generated Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                tasksAsync.when(
                  data: (tasks) => tasks.isEmpty
                      ? const Text('No tasks generated yet')
                      : Column(
                          children: tasks
                              .take(3)
                              .map((task) => ListTile(
                                    dense: true,
                                    leading: Icon(
                                      task.status == 'completed'
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: task.status == 'completed'
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    title: Text(task.title),
                                    subtitle: Text(
                                        'Priority: ${task.priority} • ${task.status}'),
                                    trailing: Text(task.dueDate
                                            ?.toString()
                                            .split(' ')[0] ??
                                        'No due date'),
                                  ))
                              .toList(),
                        ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Error loading tasks'),
                ),

                // Action Button
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _generateTasksForRoutine(routine, ref),
                  icon: const Icon(Icons.add_task),
                  label: const Text('Generate Tasks for Today'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticChip(String label, String value, Color color) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
      backgroundColor: color.withAlpha((0.1 * 255).round()),
    );
  }

  Widget _buildListTasksSection(WidgetRef ref) {
    final listsAsync = ref.watch(lists_providers.allListsProvider);

    return listsAsync.when(
      data: (lists) => Column(
        children: [
          if (lists.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    'No lists found. Create a list to see task conversion in action!'),
              ),
            )
          else
            ...lists.take(2).map((list) => _buildListCard(list, ref)),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading lists: $error',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildListCard(ListModel list, WidgetRef ref) {
    final itemsAsync =
        ref.watch(lists_providers.listItemsProviderFamily(list.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(list.name),
        subtitle: Text('${list.isShoppingList ? "Shopping" : list.isTemplate ? "Template" : "Planning"} list'),
        leading: Icon(
          list.isShoppingList ? Icons.shopping_cart : Icons.list,
          color: Colors.blue,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: itemsAsync.when(
              data: (items) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('List Items:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (items.isEmpty)
                    const Text('No items in this list')
                  else
                    ...items.take(3).map((item) => ListTile(
                          dense: true,
                          leading: Icon(
                            item.isCompleted
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color:
                                item.isCompleted ? Colors.green : Colors.grey,
                          ),
                          title: Text(item.name),
                          subtitle: item.linkedTaskId != null
                              ? const Text('🔗 Linked to task',
                                  style: TextStyle(color: Colors.green))
                              : null,
                          trailing: item.linkedTaskId == null
                              ? IconButton(
                                  icon: const Icon(Icons.task_alt,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _convertListItemToTask(item.id, ref),
                                  tooltip: 'Convert to Task',
                                )
                              : const Icon(Icons.link, color: Colors.green),
                        )),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Error loading list items'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeblocksSection(WidgetRef ref) {
    final timeblocksAsync = ref.watch(timeblock_providers.currentUserTimeblocksProvider);

    return timeblocksAsync.when(
      data: (timeblocks) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Weekly Timeblocks',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${timeblocks.length} blocks'),
                ],
              ),
              const SizedBox(height: 12),
              if (timeblocks.isEmpty)
                const Text('No timeblocks found')
              else
                ...timeblocks.take(3).map((timeblock) => ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.schedule,
                        color: timeblock.color != null
                            ? Color(int.parse(
                                timeblock.color!.replaceFirst('#', '0xFF')))
                            : Colors.blue,
                      ),
                      title: Text(timeblock.title ?? 'Untitled'),
                      subtitle: Text(
                          '${_getDayName(timeblock.dayOfWeek)} ${timeblock.startTime} - ${timeblock.endTime}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (timeblock.linkedRoutineId != null)
                            const Icon(Icons.repeat,
                                color: Colors.green, size: 16),
                          if (timeblock.linkedTaskId != null)
                            const Icon(Icons.task_alt,
                                color: Colors.blue, size: 16),
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ),
      loading: () => const Card(
          child: Padding(
              padding: EdgeInsets.all(16.0), child: LinearProgressIndicator())),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading timeblocks: $error',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(WidgetRef ref) {
    final tasksAsync = ref.watch(integratedTasksProvider);

    return tasksAsync.when(
      data: (tasks) {
        final routineTasks =
            tasks.where((t) => t.isGeneratedFromRoutine).length;
        final manualTasks =
            tasks.where((t) => !t.isGeneratedFromRoutine).length;
        final completedTasks =
            tasks.where((t) => t.status == 'completed').length;
        final totalTasks = tasks.length;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Integration Summary',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Total Tasks', '$totalTasks', Colors.blue),
                    _buildStatColumn(
                        'From Routines', '$routineTasks', Colors.green),
                    _buildStatColumn('Manual', '$manualTasks', Colors.orange),
                    _buildStatColumn(
                        'Completed', '$completedTasks', Colors.purple),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  'Overall Completion Rate: ${totalTasks > 0 ? ((completedTasks / totalTasks) * 100).toInt() : 0}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
          child: Padding(
              padding: EdgeInsets.all(16.0), child: LinearProgressIndicator())),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading analytics: $error',
              style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getDayName(int dayOfWeek) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Ensure dayOfWeek is within valid range (1-7 for DateTime.weekday, adjust if 0-6 is used elsewhere)
    if (dayOfWeek >= 1 && dayOfWeek <= 7) {
      return days[dayOfWeek - 1];
    }
    return 'Invalid Day'; // Fallback for out-of-range values
  }

  void _generateTasksForRoutine(RoutineModel routine, WidgetRef ref) async {
    try {
      final generator = ref.read(routineTaskGeneratorProvider.notifier);
      await generator.generateTasksForRoutine(routine.id, DateTime.now());

      // Show success message
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Tasks generated for ${routine.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (ref.context.mounted) {
        ScaffoldMessenger.of(ref.context).showSnackBar(
          SnackBar(
            content: Text('Error generating tasks: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _convertListItemToTask(String itemId, WidgetRef ref) async {
    // TODO: Implement list item to task conversion
    if (ref.context.mounted) {
      ScaffoldMessenger.of(ref.context).showSnackBar(
        const SnackBar(
          content: Text('List item to task conversion - coming soon!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }
}
