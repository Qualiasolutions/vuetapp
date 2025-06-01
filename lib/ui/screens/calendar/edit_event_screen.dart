import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/services/calendar_event_service.dart';
// import 'package:vuet_app/utils/string_extensions.dart'; // Ensure this is removed or commented out

/// Screen for editing an existing calendar event
class EditEventScreen extends ConsumerStatefulWidget {
  /// The event to edit
  final CalendarEventModel event;

  const EditEventScreen({
    super.key,
    required this.event,
  });

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late bool _isAllDay;
  late bool _isRecurring;
  String? _recurrencePattern;

  final _recurrenceOptions = [
    'DAILY',
    'WEEKLY',
    'MONTHLY',
    'YEARLY',
  ];

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description ?? '');
    _locationController = TextEditingController(text: widget.event.location ?? '');
    
    _startDate = widget.event.startTime;
    _endDate = widget.event.endTime;
    
    _startTime = TimeOfDay(
      hour: widget.event.startTime.hour,
      minute: widget.event.startTime.minute,
    );
    _endTime = TimeOfDay(
      hour: widget.event.endTime.hour,
      minute: widget.event.endTime.minute,
    );
    
    _isAllDay = widget.event.allDay;
    _isRecurring = widget.event.isRecurring;
    _recurrencePattern = widget.event.recurrencePattern ?? 'DAILY';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16.0),
              
              SwitchListTile(
                title: const Text('All Day Event'),
                value: _isAllDay,
                onChanged: (value) {
                  setState(() {
                    _isAllDay = value;
                  });
                },
              ),
              
              const Text(
                'Start',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      context: context,
                      selectedDate: _startDate,
                      onDateSelected: (date) {
                        setState(() {
                          _startDate = date;
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate;
                          }
                        });
                      },
                    ),
                  ),
                  if (!_isAllDay) ...[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: _buildTimePicker(
                        context: context,
                        selectedTime: _startTime,
                        onTimeSelected: (time) {
                          setState(() {
                            _startTime = time;
                            if (_startDate.year == _endDate.year &&
                                _startDate.month == _endDate.month &&
                                _startDate.day == _endDate.day &&
                                _timeToMinutes(_endTime) <= _timeToMinutes(_startTime)) {
                              _endTime = TimeOfDay(
                                hour: _startTime.hour + 1,
                                minute: _startTime.minute,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16.0),
              
              const Text(
                'End',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      context: context,
                      selectedDate: _endDate,
                      onDateSelected: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                      minDate: _startDate,
                    ),
                  ),
                  if (!_isAllDay) ...[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: _buildTimePicker(
                        context: context,
                        selectedTime: _endTime,
                        onTimeSelected: (time) {
                          setState(() {
                            _endTime = time;
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16.0),
              
              SwitchListTile(
                title: const Text('Recurring Event'),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),
              
              if (_isRecurring) ...[
                const SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Recurrence Pattern',
                    border: OutlineInputBorder(),
                  ),
                  value: _recurrencePattern,
                  items: _recurrenceOptions.map((String pattern) {
                    return DropdownMenuItem<String>(
                      value: pattern,
                      child: Text(pattern.toLowerCase()), // Reverted to just toLowerCase()
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _recurrencePattern = value;
                    });
                  },
                ),
              ],
              
              const SizedBox(height: 24.0),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Update Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
    DateTime? minDate,
  }) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: minDate ?? DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEE, MMM d, yyyy').format(selectedDate),
              style: const TextStyle(fontSize: 16.0),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedTime.format(context),
              style: const TextStyle(fontSize: 16.0),
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final startDateTime = _combineDateAndTime(_startDate, _isAllDay ? const TimeOfDay(hour: 0, minute: 0) : _startTime);
      final endDateTime = _combineDateAndTime(_endDate, _isAllDay ? const TimeOfDay(hour: 23, minute: 59) : _endTime);
      
      if (endDateTime.isBefore(startDateTime)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End time cannot be before start time')),
          );
        }
        return;
      }
      
      final updatedEvent = CalendarEventModel(
        id: widget.event.id,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        startTime: startDateTime,
        endTime: endDateTime,
        allDay: _isAllDay,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        userId: widget.event.userId,
        isRecurring: _isRecurring,
        recurrencePattern: _isRecurring ? _recurrencePattern : null,
        createdAt: widget.event.createdAt,
        updatedAt: DateTime.now(),
      );
      
      final calendarService = ref.read(calendarEventServiceProvider);
      
      try {
        await calendarService.updateEvent(updatedEvent);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update event: $error')),
          );
        }
      }
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
