import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/ui/components/task_completion/task_completion_modal.dart';
import 'package:vuet_app/ui/components/task_completion/forms/basic_completion_form.dart';
import 'package:vuet_app/ui/components/task_completion/forms/due_date_reschedule_form.dart';
import 'package:vuet_app/ui/components/task_completion/forms/final_occurrence_form.dart';
import 'package:vuet_app/ui/components/task_completion/forms/mot_type_reschedule_form.dart';

/// Content widget that displays the appropriate completion form based on the form type
class CompletionFormContent extends ConsumerWidget {
  final TaskModel task;
  final CompletionFormType formType;
  final int? recurrenceIndex;
  final VoidCallback onCompleted;
  final VoidCallback onCancelled;

  const CompletionFormContent({
    super.key,
    required this.task,
    required this.formType,
    this.recurrenceIndex,
    required this.onCompleted,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFormDescription(),
        const SizedBox(height: 16),
        _buildForm(),
      ],
    );
  }
  
  Widget _buildFormDescription() {
    String description;
    IconData icon;
    Color color;
    
    switch (formType) {
      case CompletionFormType.complete:
        description = 'Mark this task as completed';
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case CompletionFormType.dueDateReschedule:
        description = 'Reschedule this due date task';
        icon = Icons.schedule;
        color = Colors.orange;
        break;
      case CompletionFormType.finalOccurrence:
        description = 'Final occurrence of recurring task';
        icon = Icons.event_available;
        color = Colors.blue;
        break;
      case CompletionFormType.motType:
        description = 'Update MOT/Service information';
        icon = Icons.car_repair;
        color = Colors.purple;
        break;
    }
    
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildForm() {
    switch (formType) {
      case CompletionFormType.complete:
        return BasicCompletionForm(
          task: task,
          recurrenceIndex: recurrenceIndex,
          onCompleted: onCompleted,
          onCancelled: onCancelled,
        );
      case CompletionFormType.dueDateReschedule:
        return DueDateRescheduleForm(
          task: task,
          recurrenceIndex: recurrenceIndex,
          onCompleted: onCompleted,
          onCancelled: onCancelled,
        );
      case CompletionFormType.finalOccurrence:
        return FinalOccurrenceForm(
          task: task,
          recurrenceIndex: recurrenceIndex,
          onCompleted: onCompleted,
          onCancelled: onCancelled,
        );
      case CompletionFormType.motType:
        return MotTypeRescheduleForm(
          task: task,
          recurrenceIndex: recurrenceIndex,
          onCompleted: onCompleted,
          onCancelled: onCancelled,
        );
    }
  }
} 