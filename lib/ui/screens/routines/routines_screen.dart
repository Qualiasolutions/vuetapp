import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/providers/routine_providers.dart';
import 'package:vuet_app/ui/screens/routines/routine_detail_screen.dart';
import 'package:vuet_app/ui/screens/routines/create_edit_routine_screen.dart';
import 'package:vuet_app/widgets/modern_components.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Routines',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF374151),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => _navigateToCreateRoutine(context),
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: routinesAsync.when(
        data: (routines) => _buildRoutinesList(context, ref, routines),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _buildErrorState(context, ref, error),
      ),
    );
  }

  Widget _buildRoutinesList(BuildContext context, WidgetRef ref, List<RoutineModel> routines) {
    if (routines.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(routinesProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return _buildRoutineCard(context, ref, routine);
        },
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, WidgetRef ref, RoutineModel routine) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ModernComponents.modernCard(
        child: InkWell(
          onTap: () => _navigateToRoutineDetail(context, routine),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                              fontSize: 18,
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuAction(context, ref, routine, value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildDaysChip(routine),
                    const SizedBox(width: 8),
                    _buildTimeChip(routine),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _getRoutineDescription(routine),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (routine.members.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Members: ${routine.members.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysChip(RoutineModel routine) {
    final activeDays = <String>[];
    if (routine.monday) activeDays.add('Mo');
    if (routine.tuesday) activeDays.add('Tu');
    if (routine.wednesday) activeDays.add('We');
    if (routine.thursday) activeDays.add('Th');
    if (routine.friday) activeDays.add('Fr');
    if (routine.saturday) activeDays.add('Sa');
    if (routine.sunday) activeDays.add('Su');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        activeDays.join(', '),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildTimeChip(RoutineModel routine) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '${routine.startTime} - ${routine.endTime}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.repeat_rounded,
              size: 48,
              color: Colors.blue.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Routines Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first routine to automate\nrecurring tasks and stay organized',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ModernComponents.modernButton(
            text: 'Create Routine',
            onPressed: () => _navigateToCreateRoutine(context),
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to Load Routines',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ModernComponents.modernButton(
            text: 'Try Again',
            onPressed: () => ref.invalidate(routinesProvider),
          ),
        ],
      ),
    );
  }

  void _navigateToCreateRoutine(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateEditRoutineScreen(),
      ),
    );
  }

  void _navigateToRoutineDetail(BuildContext context, RoutineModel routine) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoutineDetailScreen(routineId: routine.id),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, RoutineModel routine, String action) {
    switch (action) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateEditRoutineScreen(routine: routine),
          ),
        );
        break;
      case 'duplicate':
        _duplicateRoutine(ref, routine);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, routine);
        break;
    }
  }

  void _duplicateRoutine(WidgetRef ref, RoutineModel routine) {
    final duplicatedRoutine = routine.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${routine.name} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(routinesNotifierProvider.notifier).createRoutine(duplicatedRoutine);
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, RoutineModel routine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: Text('Are you sure you want to delete "${routine.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(routinesNotifierProvider.notifier).deleteRoutine(routine.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _getRoutineDescription(RoutineModel routine) {
    final activeDays = <String>[];
    if (routine.monday) activeDays.add('Monday');
    if (routine.tuesday) activeDays.add('Tuesday');
    if (routine.wednesday) activeDays.add('Wednesday');
    if (routine.thursday) activeDays.add('Thursday');
    if (routine.friday) activeDays.add('Friday');
    if (routine.saturday) activeDays.add('Saturday');
    if (routine.sunday) activeDays.add('Sunday');

    if (activeDays.isEmpty) {
      return 'No days selected';
    }

    if (activeDays.length == 7) {
      return 'Every day from ${routine.startTime} to ${routine.endTime}';
    }

    if (activeDays.length == 5 && 
        routine.monday && routine.tuesday && routine.wednesday && 
        routine.thursday && routine.friday) {
      return 'Weekdays from ${routine.startTime} to ${routine.endTime}';
    }

    if (activeDays.length == 2 && routine.saturday && routine.sunday) {
      return 'Weekends from ${routine.startTime} to ${routine.endTime}';
    }

    return '${activeDays.join(', ')} from ${routine.startTime} to ${routine.endTime}';
  }
}
