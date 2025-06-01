import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/routine_model.dart';

class RoutineCard extends ConsumerWidget {
  final RoutineModel routine;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final void Function(DateTime)? onGenerateTasks;

  const RoutineCard({
    super.key,
    required this.routine,
    this.onEdit,
    this.onDelete,
    this.onGenerateTasks,
  });

  String _getFormattedDays(RoutineModel routine) {
    final days = <String>[];
    if (routine.monday) days.add('Mon');
    if (routine.tuesday) days.add('Tue');
    if (routine.wednesday) days.add('Wed');
    if (routine.thursday) days.add('Thu');
    if (routine.friday) days.add('Fri');
    if (routine.saturday) days.add('Sat');
    if (routine.sunday) days.add('Sun');
    
    if (days.isEmpty) return 'No days selected';
    if (days.length == 7) return 'Every day';
    return days.join(', ');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              routine.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (routine.description != null && routine.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(routine.description!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _getFormattedDays(routine),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    'From ${routine.startTime} to ${routine.endTime}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            onTap: onEdit,
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              if (onEdit != null)
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  onPressed: onEdit,
                ),
              TextButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Generate Tasks'),
                onPressed: onGenerateTasks != null ? () async {
                  // Show date picker for task generation
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 7)),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                  );
                  
                  if (pickedDate != null && context.mounted) {
                    onGenerateTasks!(pickedDate);
                  }
                } : null,
              ),
              if (onDelete != null)
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
