import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/ui/components/task_completion/completion_form_content.dart';

/// Modal for completing tasks with various completion options
class TaskCompletionModal extends ConsumerStatefulWidget {
  final TaskModel task;
  final int? recurrenceIndex;
  final VoidCallback? onCompleted;
  final VoidCallback? onCancelled;

  const TaskCompletionModal({
    super.key,
    required this.task,
    this.recurrenceIndex,
    this.onCompleted,
    this.onCancelled,
  });

  @override
  ConsumerState<TaskCompletionModal> createState() => _TaskCompletionModalState();
}

class _TaskCompletionModalState extends ConsumerState<TaskCompletionModal> {
  CompletionFormType _selectedFormType = CompletionFormType.complete;
  
  /// Determine the appropriate completion form type based on task properties
  CompletionFormType _getInitialFormType() {
    final task = widget.task;
    
    // Check for special task types that need specific completion flows
    if (task.taskSubtype != null) {
      final subtype = task.taskSubtype!.toUpperCase();
      if (['MOT_DUE', 'INSURANCE_DUE', 'SERVICE_DUE', 'WARRANTY_DUE', 'TAX_DUE']
          .contains(subtype)) {
        return CompletionFormType.motType;
      }
    }
    
    // Check if this is the final occurrence of a recurring task
    if (task.isRecurring && _isFinalOccurrence()) {
      return CompletionFormType.finalOccurrence;
    }
    
    // Check if this is a due date task without recurrence
    if (task.taskType?.toString().contains('DUE_DATE') == true && !task.isRecurring) {
      return CompletionFormType.dueDateReschedule;
    }
    
    // Default completion form
    return CompletionFormType.complete;
  }
  
  bool _isFinalOccurrence() {
    // This would need to be determined by checking if there are future occurrences
    // For now, we'll return false and implement the logic later
    return false;
  }

  @override
  void initState() {
    super.initState();
    _selectedFormType = _getInitialFormType();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Complete Task: ${widget.task.title}'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Form type selector (for debugging/testing)
            if (_shouldShowFormTypeSelector())
              _buildFormTypeSelector(),
            
            const SizedBox(height: 16),
            
            // Main completion form content
            CompletionFormContent(
              task: widget.task,
              formType: _selectedFormType,
              recurrenceIndex: widget.recurrenceIndex,
              onCompleted: _handleCompleted,
              onCancelled: _handleCancelled,
            ),
          ],
        ),
      ),
    );
  }
  
  bool _shouldShowFormTypeSelector() {
    // Show selector in debug mode or for testing
    return false; // Set to true for debugging
  }
  
  Widget _buildFormTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Completion Type:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: CompletionFormType.values.map((type) {
            return ChoiceChip(
              label: Text(type.displayName),
              selected: _selectedFormType == type,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFormType = type;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  void _handleCompleted() {
    Navigator.of(context).pop();
    widget.onCompleted?.call();
  }
  
  void _handleCancelled() {
    Navigator.of(context).pop();
    widget.onCancelled?.call();
  }
}

/// Show the task completion modal
Future<void> showTaskCompletionModal(
  BuildContext context, {
  required TaskModel task,
  int? recurrenceIndex,
  VoidCallback? onCompleted,
  VoidCallback? onCancelled,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return TaskCompletionModal(
        task: task,
        recurrenceIndex: recurrenceIndex,
        onCompleted: onCompleted,
        onCancelled: onCancelled,
      );
    },
  );
}

/// Enum for different completion form types based on React implementation
enum CompletionFormType {
  complete,
  dueDateReschedule,
  finalOccurrence,
  motType,
}

extension CompletionFormTypeExtension on CompletionFormType {
  String get displayName {
    switch (this) {
      case CompletionFormType.complete:
        return 'Complete';
      case CompletionFormType.dueDateReschedule:
        return 'Due Date Reschedule';
      case CompletionFormType.finalOccurrence:
        return 'Final Occurrence';
      case CompletionFormType.motType:
        return 'MOT Type';
    }
  }
} 