import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/providers/task_completion_providers.dart';

/// Due date reschedule form for tasks without recurrence
/// This form allows users to reschedule a due date task or mark it complete
class DueDateRescheduleForm extends ConsumerStatefulWidget {
  final TaskModel task;
  final int? recurrenceIndex;
  final VoidCallback onCompleted;
  final VoidCallback onCancelled;

  const DueDateRescheduleForm({
    super.key,
    required this.task,
    this.recurrenceIndex,
    required this.onCompleted,
    required this.onCancelled,
  });

  @override
  ConsumerState<DueDateRescheduleForm> createState() => _DueDateRescheduleFormState();
}

class _DueDateRescheduleFormState extends ConsumerState<DueDateRescheduleForm> {
  bool _showRescheduleForm = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with next month as default (matching React implementation)
    if (widget.task.dueDate != null) {
      final nextMonth = DateTime.now().add(const Duration(days: 30));
      _selectedDate = DateTime(nextMonth.year, nextMonth.month, nextMonth.day);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskCompleter = ref.watch(taskCompleterProvider);
    
    if (_showRescheduleForm) {
      return _buildRescheduleForm(taskCompleter);
    }
    
    return _buildInitialChoice();
  }
  
  Widget _buildInitialChoice() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.schedule, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Date Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.task.title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Question
        const Text(
          'Would you like to reschedule this due date task?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
        Text(
          'Due date tasks can be rescheduled to a new date or marked as complete.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        
        // Buttons
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showRescheduleForm = true;
                });
              },
              icon: const Icon(Icons.schedule),
              label: const Text('Reschedule Task'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _handleMarkComplete,
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark as Complete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: widget.onCancelled,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildRescheduleForm(AsyncValue<dynamic> taskCompleter) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showRescheduleForm = false;
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Text(
              'Reschedule Task',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Task info card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                if (widget.task.dueDate != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Current due date: ${_formatDate(widget.task.dueDate!)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Quick reschedule options
        const Text(
          'Quick Reschedule:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _quickRescheduleChip('Next Week', 7),
            _quickRescheduleChip('Next Month', 30),
            _quickRescheduleChip('3 Months', 90),
          ],
        ),
        const SizedBox(height: 16),
        
        // Custom date selection
        const Text(
          'Or select custom date:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'Select Date',
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (widget.task.dueDate != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selectTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    _selectedTime != null
                        ? _formatTime(_selectedTime!)
                        : 'Select Time',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Notes field
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Reason for rescheduling (optional)',
            hintText: 'Why are you rescheduling this task?',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _showRescheduleForm = false;
                });
              },
              child: const Text('Back'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _selectedDate != null ? _handleReschedule : null,
              child: const Text('Reschedule'),
            ),
          ],
        ),
        
        // Loading indicator
        if (taskCompleter.isLoading) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
  
  Widget _quickRescheduleChip(String label, int days) {
    final targetDate = DateTime.now().add(Duration(days: days));
    final isSelected = _selectedDate != null && 
        _isSameDay(_selectedDate!, targetDate);
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedDate = targetDate;
            if (widget.task.dueDate != null) {
              _selectedTime = TimeOfDay.fromDateTime(widget.task.dueDate!);
            }
          });
        }
      },
    );
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }
  
  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? 
          (widget.task.dueDate != null 
              ? TimeOfDay.fromDateTime(widget.task.dueDate!)
              : TimeOfDay.now()),
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }
  
  Future<void> _handleMarkComplete() async {
    try {
      await ref.read(taskCompleterProvider.notifier).completeTask(
        widget.task.id,
        recurrenceIndex: widget.recurrenceIndex,
        notes: 'Marked complete from due date reschedule dialog',
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
  
  Future<void> _handleReschedule() async {
    if (_selectedDate == null) return;
    
    try {
      DateTime rescheduleDateTime = _selectedDate!;
      
      // If time is selected and original task had a time, combine them
      if (_selectedTime != null && widget.task.dueDate != null) {
        rescheduleDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
      } else if (widget.task.dueDate != null) {
        // Keep original time if no new time selected
        final originalTime = TimeOfDay.fromDateTime(widget.task.dueDate!);
        rescheduleDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          originalTime.hour,
          originalTime.minute,
        );
      }
      
      await ref.read(taskCompleterProvider.notifier).rescheduleTask(
        widget.task.id,
        recurrenceIndex: widget.recurrenceIndex,
        newDueDate: rescheduleDateTime,
        reason: _notesController.text.isNotEmpty ? _notesController.text : 'Due date rescheduled',
        rescheduleRecurring: false, // Due date tasks are typically not recurring
      );
      
      // TODO: In a complete implementation, we would also create a new task with the new due date
      // This requires integration with the task creation system
      
      widget.onCompleted();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reschedule task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 