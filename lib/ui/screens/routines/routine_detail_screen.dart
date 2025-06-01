import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/models/routine_task_template_model.dart';
import 'package:vuet_app/providers/routine_providers.dart';
import 'package:vuet_app/ui/screens/routines/create_edit_routine_screen.dart';
import 'package:vuet_app/widgets/modern_components.dart';

// Temporary placeholder for RoutineTaskTemplateListScreen
class RoutineTaskTemplateListScreen extends StatelessWidget {
  final RoutineModel routine;
  
  const RoutineTaskTemplateListScreen({
    super.key,
    required this.routine,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Templates'),
      ),
      body: const Center(
        child: Text('Task Templates Screen - Coming Soon'),
      ),
    );
  }
}

class RoutineDetailScreen extends ConsumerWidget {
  final String routineId;

  const RoutineDetailScreen({
    super.key,
    required this.routineId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineAsync = ref.watch(routineByIdProviderFamily(routineId));
    final taskTemplatesAsync = ref.watch(routineTaskTemplatesProviderFamily(routineId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Routine Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => _editRoutine(context, routineAsync.value),
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF374151),
            ),
            tooltip: 'Edit Routine',
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmation(context, ref),
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            tooltip: 'Delete Routine',
          ),
        ],
      ),
      body: routineAsync.when(
        data: (routine) {
          if (routine == null) {
            return const Center(
              child: Text('Routine not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRoutineInfoCard(context, routine),
                const SizedBox(height: 16),
                _buildScheduleCard(context, routine),
                const SizedBox(height: 16),
                _buildMembersCard(context, routine),
                const SizedBox(height: 16),
                _buildTaskTemplatesSection(context, ref, routine, taskTemplatesAsync),
                const SizedBox(height: 24),
                _buildActionButtons(context, ref, routine),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }

  Widget _buildRoutineInfoCard(BuildContext context, RoutineModel routine) {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.repeat_rounded,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (routine.description != null && routine.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        routine.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Created',
            value: _formatDate(routine.createdAt),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.update_outlined,
            label: 'Last Updated',
            value: _formatDate(routine.updatedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, RoutineModel routine) {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule_outlined, size: 22),
              SizedBox(width: 8),
              Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: '${routine.startTime} - ${routine.endTime}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.repeat_rounded,
            label: 'Repeats',
            value: _getRepeatDaysText(routine),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersCard(BuildContext context, RoutineModel routine) {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.people_outline, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement add member functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add member functionality coming soon'),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          if (routine.members.isEmpty)
            const Text(
              'No members assigned to this routine yet.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            )
          else
            Column(
              children: routine.members.map((member) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  title: Text(member),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () {
                      // TODO: Implement remove member functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Remove member functionality coming soon'),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskTemplatesSection(
    BuildContext context,
    WidgetRef ref,
    RoutineModel routine,
    AsyncValue<List<RoutineTaskTemplateModel>> taskTemplatesAsync,
  ) {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.task_alt_outlined, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Task Templates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _navigateToTaskTemplateList(context, routine),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Manage'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'These tasks will be automatically created according to the routine schedule.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          taskTemplatesAsync.when(
            data: (templates) {
              if (templates.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No task templates added yet.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: templates.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return ListTile(
                    leading: const Icon(Icons.task_alt_outlined),
                    title: Text(template.title),
                    subtitle: template.description != null && template.description!.isNotEmpty
                        ? Text(template.description!)
                        : null,
                    trailing: Text(
                      _getTaskPriorityText(template.priority),
                      style: TextStyle(
                        color: _getTaskPriorityColor(template.priority),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Error loading task templates: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, RoutineModel routine) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ModernComponents.modernButton(
                text: 'Generate Tasks Now',
                onPressed: () {
                  // TODO: Implement generate tasks functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Generate tasks functionality coming soon'),
                    ),
                  );
                },
                icon: Icons.play_arrow_rounded,
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernComponents.modernButton(
                text: 'Pause Routine',
                onPressed: () {
                  // TODO: Implement pause routine functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pause routine functionality coming soon'),
                    ),
                  );
                },
                icon: Icons.pause_rounded,
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ModernComponents.modernButton(
          text: 'Delete Routine',
          onPressed: () => _showDeleteConfirmation(context, ref),
          icon: Icons.delete_outline,
          backgroundColor: Colors.red,
        ),
        const SizedBox(height: 16),
        ModernComponents.modernButton(
          text: 'Duplicate Routine',
          onPressed: () => _duplicateRoutine(context, ref, routine),
          icon: Icons.content_copy_outlined,
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editRoutine(BuildContext context, RoutineModel? routine) {
    if (routine == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateEditRoutineScreen(routine: routine),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: const Text('Are you sure you want to delete this routine? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteRoutine(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteRoutine(BuildContext context, WidgetRef ref) {
    ref.read(routinesNotifierProvider.notifier).deleteRoutine(routineId);
    Navigator.of(context).pop(); // Go back to routines list
  }

  void _duplicateRoutine(BuildContext context, WidgetRef ref, RoutineModel routine) {
    final duplicatedRoutine = routine.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${routine.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(routinesNotifierProvider.notifier).createRoutine(duplicatedRoutine);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Routine duplicated successfully'),
      ),
    );
  }

  void _navigateToTaskTemplateList(BuildContext context, RoutineModel routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineTaskTemplateListScreen(routine: routine),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getRepeatDaysText(RoutineModel routine) {
    final days = <String>[];
    if (routine.monday) days.add('Monday');
    if (routine.tuesday) days.add('Tuesday');
    if (routine.wednesday) days.add('Wednesday');
    if (routine.thursday) days.add('Thursday');
    if (routine.friday) days.add('Friday');
    if (routine.saturday) days.add('Saturday');
    if (routine.sunday) days.add('Sunday');

    if (days.isEmpty) return 'No days selected';
    if (days.length == 7) return 'Every day';
    if (days.length == 5 && 
        routine.monday && routine.tuesday && routine.wednesday && 
        routine.thursday && routine.friday) {
      return 'Weekdays';
    }
    if (days.length == 2 && routine.saturday && routine.sunday) {
      return 'Weekends';
    }

    return days.join(', ');
  }

  String _getTaskPriorityText(TaskPriority? priority) {
    if (priority == null) return 'Medium';
    
    switch (priority) {
      case TaskPriority.high:
        return 'High';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.low:
        return 'Low';
    }
  }

  Color _getTaskPriorityColor(TaskPriority? priority) {
    if (priority == null) return Colors.orange;
    
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
