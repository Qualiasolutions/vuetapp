import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vuet_app/models/calendar_event_model.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/services/calendar_event_service.dart';
import 'package:vuet_app/ui/components/entity_selector.dart';

/// Screen for creating a new calendar event
class CreateEventScreen extends ConsumerStatefulWidget {
  /// Pre-selected date for the new event
  final DateTime selectedDate;
  
  /// Pre-linked entity ID (optional)
  final String? entityId;
  
  /// Pre-selected event type (optional)
  final String? eventType;

  const CreateEventScreen({
    super.key,
    required this.selectedDate,
    this.entityId,
    this.eventType,
  });

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  late DateTime _startDate;
  late DateTime _endDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _isAllDay = false;
  bool _isRecurring = false;
  String? _recurrencePattern = 'DAILY';
  String? _selectedEntityId;
  String? _selectedEventType;
  
  final _eventTypes = [
    'personal',
    'social_event',
    'appointment',
    'meeting',
    'travel',
    'celebration',
    'reminder',
    'dining',
  ];

  final _recurrenceOptions = [
    'DAILY',
    'WEEKLY',
    'MONTHLY',
    'YEARLY',
  ];

  @override
  void initState() {
    super.initState();
    
    _startDate = widget.selectedDate;
    _endDate = widget.selectedDate;
    
    final now = TimeOfDay.now();
    _startTime = TimeOfDay(hour: now.hour, minute: 0);
    _endTime = TimeOfDay(hour: now.hour + 1, minute: 0);
    
    _selectedEntityId = widget.entityId;
    _selectedEventType = widget.eventType;
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
    final authService = ref.read(authServiceProvider);
    final userId = authService.currentUser?.id;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Event'),
      ),
      body: userId == null
          ? const Center(child: Text('Please sign in to create events'))
          : SingleChildScrollView(
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
                    
                    // Event Type Dropdown
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Event Type',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      value: _selectedEventType,
                      items: _eventTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(_formatEventType(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedEventType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    
                    // Entity Selector (add it right before the recurring event section)
                    EntitySelector(
                      selectedEntityId: _selectedEntityId,
                      onEntitySelected: (entityId) {
                        setState(() {
                          _selectedEntityId = entityId;
                        });
                      },
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
                        items: _recurrenceOptions.map((pattern) {
                          return DropdownMenuItem<String>(
                            value: pattern,
                            child: Text(pattern.toLowerCase()),
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
                        onPressed: () => _saveEvent(userId),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: const Text('Save Event'),
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
  }) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat.yMMMd().format(selectedDate)),
      ),
    );
  }

  Widget _buildTimePicker({
    required BuildContext context,
    required TimeOfDay selectedTime,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return InkWell(
      onTap: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.access_time),
        ),
        child: Text(selectedTime.format(context)),
      ),
    );
  }
  
  String _formatEventType(String type) {
    return type.replaceAll('_', ' ').split(' ')
      .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
      .join(' ');
  }

  void _saveEvent(String? userId) {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to create events')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final startDateTime = _combineDateAndTime(_startDate, _isAllDay ? const TimeOfDay(hour: 0, minute: 0) : _startTime);
      final endDateTime = _combineDateAndTime(_endDate, _isAllDay ? const TimeOfDay(hour: 23, minute: 59) : _endTime);
      
      if (endDateTime.isBefore(startDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time cannot be before start time')),
        );
        return;
      }
      
      final event = CalendarEventModel(
        title: _titleController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        startTime: startDateTime,
        endTime: endDateTime,
        allDay: _isAllDay,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        userId: userId,
        isRecurring: _isRecurring,
        recurrencePattern: _isRecurring ? _recurrencePattern : null,
        entityId: _selectedEntityId,
        eventType: _selectedEventType,
      );
      
      final calendarService = ref.read(calendarEventServiceProvider);
      
      calendarService.createEvent(event).then((_) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }).catchError((error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event: $error')),
          );
        }
      });
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
