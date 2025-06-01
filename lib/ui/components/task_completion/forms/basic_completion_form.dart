import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/task_completion_providers.dart';

/// Basic completion form with multiple completion options
class BasicCompletionForm extends ConsumerStatefulWidget {
  final TaskModel task;
  final int? recurrenceIndex;
  final VoidCallback onCompleted;
  final VoidCallback onCancelled;

  const BasicCompletionForm({
    super.key,
    required this.task,
    this.recurrenceIndex,
    required this.onCompleted,
    required this.onCancelled,
  });

  @override
  ConsumerState<BasicCompletionForm> createState() => _BasicCompletionFormState();
}

class _BasicCompletionFormState extends ConsumerState<BasicCompletionForm> {
  final _notesController = TextEditingController();
  bool _isPartialCompletion = false;
  DateTime? _rescheduledDate;
  TimeOfDay? _rescheduledTime;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskCompleter = ref.watch(taskCompleterProvider);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Complete Task: ${widget.task.title}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Completion type selector
        _buildCompletionTypeSelector(),
        const SizedBox(height: 16),
        
        // Notes field
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Add any completion notes...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        
        // Partial completion options
        if (_isPartialCompletion) ...[
          _buildPartialCompletionOptions(),
          const SizedBox(height: 16),
        ],
        
        // Action buttons
        _buildActionButtons(),
        
        // Loading indicator
        if (taskCompleter.isLoading) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
  
  Widget _buildCompletionTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Completion Type:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Partial Completion'),
              subtitle: const Text('Mark as partially complete and reschedule remainder'),
              value: _isPartialCompletion,
              onChanged: (value) {
                setState(() {
                  _isPartialCompletion = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPartialCompletionOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reschedule Remainder For:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            
            // Quick reschedule options
            Wrap(
              spacing: 8,
              children: [
                _quickRescheduleButton('Tomorrow', 1),
                _quickRescheduleButton('Next Week', 7),
                _quickRescheduleButton('Next Month', 30),
              ],
            ),
            const SizedBox(height: 12),
            
            // Custom date/time picker
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectRescheduleDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _rescheduledDate != null
                          ? '${_rescheduledDate!.day}/${_rescheduledDate!.month}/${_rescheduledDate!.year}'
                          : 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.task.dueDate != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectRescheduleTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _rescheduledTime != null
                            ? '${_rescheduledTime!.hour.toString().padLeft(2, '0')}:${_rescheduledTime!.minute.toString().padLeft(2, '0')}'
                            : 'Select Time',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _quickRescheduleButton(String label, int days) {
    final isSelected = _rescheduledDate != null && 
        _rescheduledDate!.difference(DateTime.now()).inDays == days;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _rescheduledDate = DateTime.now().add(Duration(days: days));
            if (widget.task.dueDate != null) {
              _rescheduledTime = TimeOfDay.fromDateTime(widget.task.dueDate!);
            }
          });
        }
      },
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel button
        TextButton(
          onPressed: widget.onCancelled,
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        
        // Skip button
        TextButton(
          onPressed: _handleSkip,
          style: TextButton.styleFrom(
            foregroundColor: Colors.orange,
          ),
          child: const Text('Skip'),
        ),
        const Spacer(),
        
        // Main action button
        ElevatedButton(
          onPressed: _isPartialCompletion ? _handlePartialComplete : _handleComplete,
          child: Text(_isPartialCompletion ? 'Partial Complete' : 'Complete'),
        ),
      ],
    );
  }
  
  Future<void> _selectRescheduleDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _rescheduledDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _rescheduledDate = date;
      });
    }
  }
  
  Future<void> _selectRescheduleTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _rescheduledTime ?? 
          (widget.task.dueDate != null 
              ? TimeOfDay.fromDateTime(widget.task.dueDate!)
              : TimeOfDay.now()),
    );
    
    if (time != null) {
      setState(() {
        _rescheduledTime = time;
      });
    }
  }
  
  Future<void> _handleComplete() async {
    try {
      await ref.read(taskCompleterProvider.notifier).completeTask(
        widget.task.id,
        recurrenceIndex: widget.recurrenceIndex,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _handlePartialComplete() async {
    try {
      DateTime? rescheduledDateTime;
      if (_rescheduledDate != null) {
        rescheduledDateTime = _rescheduledDate!;
        if (_rescheduledTime != null) {
          rescheduledDateTime = DateTime(
            _rescheduledDate!.year,
            _rescheduledDate!.month,
            _rescheduledDate!.day,
            _rescheduledTime!.hour,
            _rescheduledTime!.minute,
          );
        }
      }
      
      await ref.read(taskCompleterProvider.notifier).partiallyCompleteTask(
        widget.task.id,
        recurrenceIndex: widget.recurrenceIndex,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        rescheduledDate: rescheduledDateTime,
      );
      
      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to partially complete task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Future<void> _handleSkip() async {
    try {
      await ref.read(taskCompleterProvider.notifier).skipTask(
        widget.task.id,
        recurrenceIndex: widget.recurrenceIndex,
        reason: _notesController.text.isNotEmpty ? _notesController.text : 'Task skipped',
      );
      
      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to skip task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 