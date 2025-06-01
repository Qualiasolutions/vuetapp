import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';

/// MOT type reschedule form for vehicle-related tasks
class MotTypeRescheduleForm extends ConsumerWidget {
  final TaskModel task;
  final int? recurrenceIndex;
  final VoidCallback onCompleted;
  final VoidCallback onCancelled;

  const MotTypeRescheduleForm({
    super.key,
    required this.task,
    this.recurrenceIndex,
    required this.onCompleted,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle Service Update',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.car_repair, color: Colors.purple.shade600),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Update vehicle service information',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'This form will be expanded to handle MOT, insurance, service, and warranty updates.',
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onCancelled,
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onCompleted,
              child: const Text('Update Service'),
            ),
          ],
        ),
      ],
    );
  }
} 