import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vuet_app/models/task_type_enums.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/utils/logger.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  final String? linkedEntityId;
  final String? linkedEntityName;

  const CreateTaskScreen({
    super.key,
    this.linkedEntityId,
    this.linkedEntityName,
  });

  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();

  // Task type selection (7 traditional types)
  TaskType _selectedTaskType = TaskType.task;

  // Common fields
  String? _assignedTo; // Single doer selection
  String _urgency = 'medium'; // Hi, Med, Low
  bool _isPrivate = false;
  DateTime? _dueDate;
  final List<String> _tags = [];

  // Time fields
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  int _duration = 15; // Default 15 minutes

  // Scheduling preference
  String _timePreference =
      'flexible'; // 'flexible', 'specific_time', 'date_range'

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() {
    if (widget.linkedEntityId != null && widget.linkedEntityName != null) {
      _titleController.text = 'Task for ${widget.linkedEntityName}';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isTaskDynamic => _selectedTaskType == TaskType.task;

  Future<void> _selectDate(
      DateTime? initialDate, Function(DateTime) onDateSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectDateTime(
      DateTime? initialDateTime, Function(DateTime) onDateTimeSelected) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(dateTime);
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Widget _buildTaskTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Event Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskType>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: _selectedTaskType,
              items: TaskType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getTaskTypeIcon(type), size: 20),
                      const SizedBox(width: 8),
                      Text(type.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTaskType = value!;
                  // Reset time preference when switching types
                  if (_isTaskDynamic) {
                    _timePreference = 'flexible';
                  } else {
                    _timePreference = 'specific_time';
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              _isTaskDynamic
                  ? 'Tasks are dynamic and can be scheduled flexibly'
                  : 'This event type is static and considered during scheduling',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTaskTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.task:
        return Icons.task_alt;
      case TaskType.appointment:
        return Icons.event;
      case TaskType.dueDate:
        return Icons.schedule;
      case TaskType.activity:
        return Icons.local_activity;
      case TaskType.transport:
        return Icons.directions;
      case TaskType.accommodation:
        return Icons.hotel;
      case TaskType.anniversary:
        return Icons.cake;
    }
  }

  Widget _buildBasicFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Name of Task*',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Single Doer selection (only for Tasks)
            if (_isTaskDynamic) ...[
              const Text('Doer*',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                          'Current User'), // TODO: Replace with actual user selection
                    ),
                    if (_assignedTo == null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.warning,
                            color: Colors.white, size: 16),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              if (_assignedTo == null)
                const Text(
                  'Who is doing?',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              const SizedBox(height: 16),
            ],

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),

            // Phone number (clickable)
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number (Optional)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: _phoneController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () => _makePhoneCall(_phoneController.text),
                      )
                    : null,
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyAndPrivacy() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Urgency Level
            const Text('Urgency Level:',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['low', 'medium', 'high'].map((urgency) {
                return ChoiceChip(
                  label: Text(urgency.toUpperCase()),
                  selected: _urgency == urgency,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _urgency = urgency;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Private checkbox
            Row(
              children: [
                Checkbox(
                  value: _isPrivate,
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    'Private - When ticked, the event only shows on user\'s calendar',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Time preference selection
            if (_isTaskDynamic) ...[
              const Text('When would you like to do this?'),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Any time today / No Set Time'),
                    subtitle: const Text('Flexible scheduling'),
                    value: 'flexible',
                    groupValue: _timePreference,
                    onChanged: (value) {
                      setState(() {
                        _timePreference = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Add during a specific time'),
                    value: 'specific_time',
                    groupValue: _timePreference,
                    onChanged: (value) {
                      setState(() {
                        _timePreference = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Click to add within specific dates'),
                    value: 'date_range',
                    groupValue: _timePreference,
                    onChanged: (value) {
                      setState(() {
                        _timePreference = value!;
                      });
                    },
                  ),
                ],
              ),
            ],

            // Duration field (for flexible tasks)
            if (_isTaskDynamic && _timePreference == 'flexible') ...[
              const SizedBox(height: 16),
              _buildDurationSelector(),
            ],

            // Specific time fields
            if (_timePreference == 'specific_time') ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Starts*',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _startDateTime != null
                      ? DateFormat('MMM d, yyyy - h:mm a')
                          .format(_startDateTime!)
                      : '',
                ),
                onTap: () => _selectDateTime(_startDateTime, (dateTime) {
                  setState(() {
                    _startDateTime = dateTime;
                    // Auto-set end time
                    _endDateTime ??= dateTime.add(Duration(minutes: _duration));
                  });
                }),
                validator: (value) {
                  if (_timePreference == 'specific_time' &&
                      _startDateTime == null) {
                    return 'Please select a start time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Ends*',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _endDateTime != null
                      ? DateFormat('MMM d, yyyy - h:mm a').format(_endDateTime!)
                      : '',
                ),
                onTap: () => _selectDateTime(_endDateTime, (dateTime) {
                  setState(() {
                    _endDateTime = dateTime;
                  });
                }),
                validator: (value) {
                  if (_timePreference == 'specific_time' &&
                      _endDateTime == null) {
                    return 'Please select an end time';
                  }
                  if (_startDateTime != null &&
                      _endDateTime != null &&
                      _endDateTime!.isBefore(_startDateTime!)) {
                    return 'End time must be after start time';
                  }
                  return null;
                },
              ),
            ],

            // Date range fields
            if (_timePreference == 'date_range') ...[
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Earliest Date (Optional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _startDateTime != null
                      ? DateFormat.yMMMd().format(_startDateTime!)
                      : '',
                ),
                onTap: () => _selectDate(_startDateTime, (date) {
                  setState(() {
                    _startDateTime = date;
                  });
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Due Date (Optional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: _dueDate != null
                      ? DateFormat.yMMMd().format(_dueDate!)
                      : '',
                ),
                onTap: () => _selectDate(_dueDate, (date) {
                  setState(() {
                    _dueDate = date;
                  });
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      children: [
        const Text('Duration: '),
        Expanded(
          child: Slider(
            value: _duration.toDouble(),
            min: 5,
            max: 480, // 8 hours
            divisions: 95,
            label: '$_duration min',
            onChanged: (value) {
              setState(() {
                _duration = value.round();
              });
            },
          ),
        ),
        Text('$_duration min'),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final currentUser = authService.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      // Create task using Supabase MCP
      final taskData = {
        'user_id': currentUser.id,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'task_type': _selectedTaskType.name,
        'priority': _urgency,
        'is_private': _isPrivate,
        'location': _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        'type_specific_data': {
          'phone_number': _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        },
        'entity_id': widget.linkedEntityId,
        'tags': _tags,
      };

      // Add scheduling data based on type and preference
      if (_isTaskDynamic) {
        // Flexible task
        taskData['scheduling_type'] = 'FLEXIBLE';
        taskData['duration_minutes'] = _duration;
        taskData['task_urgency'] = _urgency.toUpperCase();

        if (_timePreference == 'specific_time' &&
            _startDateTime != null &&
            _endDateTime != null) {
          taskData['start_datetime'] = _startDateTime!.toIso8601String();
          taskData['end_datetime'] = _endDateTime!.toIso8601String();
          taskData['is_scheduled'] = true;
        } else if (_timePreference == 'date_range') {
          if (_startDateTime != null) {
            taskData['earliest_action_date'] =
                _startDateTime!.toIso8601String().split('T')[0];
          }
          if (_dueDate != null) {
            taskData['due_date'] = _dueDate!.toIso8601String();
          }
        }
      } else {
        // Fixed task
        taskData['scheduling_type'] = 'FIXED';
        if (_startDateTime != null && _endDateTime != null) {
          taskData['start_datetime'] = _startDateTime!.toIso8601String();
          taskData['end_datetime'] = _endDateTime!.toIso8601String();
          taskData['duration_minutes'] =
              _endDateTime!.difference(_startDateTime!).inMinutes;
        }
      }

      // Insert task via Supabase MCP
      await ref.read(supabaseRepositoryProvider).createTask(taskData);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${_selectedTaskType.displayName} created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      log('Error creating task: $e', name: 'CreateTaskScreen');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error creating ${_selectedTaskType.displayName.toLowerCase()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Change',
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTaskTypeSelector(),
            const SizedBox(height: 16),
            _buildBasicFields(),
            const SizedBox(height: 16),
            _buildUrgencyAndPrivacy(),
            const SizedBox(height: 16),
            _buildTimeFields(),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Creating...'),
                        ],
                      )
                    : Text('Create ${_selectedTaskType.displayName}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add missing provider reference
final supabaseRepositoryProvider = Provider<SupabaseRepository>((ref) {
  return SupabaseRepository();
});

// Temporary repository class - will be replaced with proper implementation
class SupabaseRepository {
  Future<void> createTask(Map<String, dynamic> taskData) async {
    // TODO: Implement actual Supabase task creation
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    log('Task created: $taskData', name: 'SupabaseRepository');
  }
}
