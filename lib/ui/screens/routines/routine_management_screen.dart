import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/routine_service.dart';


/// Screen for managing routines and advanced task scheduling
class RoutineManagementScreen extends ConsumerStatefulWidget {
  const RoutineManagementScreen({super.key});

  @override
  ConsumerState<RoutineManagementScreen> createState() => _RoutineManagementScreenState();
}

class _RoutineManagementScreenState extends ConsumerState<RoutineManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _scheduleType = 'daily';
  int _interval = 1;
  final List<int> _selectedDays = [];
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  TimeOfDay? _timeOfDay;
  
  final List<String> _scheduleTypes = [
    'daily',
    'weekly', 
    'monthly_date',
    'monthly_day'
  ];

  final List<String> _dayNames = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 
    'Thursday', 'Friday', 'Saturday'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routineService = ref.watch(routineServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Task Scheduling'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Create Routine Template',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Set up recurring task templates that automatically generate tasks based on your schedule',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Create Routine Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  _buildSectionHeader('Basic Information'),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Routine Name',
                      hintText: 'e.g., Morning Workout, Weekly Review',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a routine name';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'Brief description of this routine',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Schedule Configuration
                  _buildSectionHeader('Schedule Configuration'),
                  DropdownButtonFormField<String>(
                    value: _scheduleType,
                    decoration: const InputDecoration(
                      labelText: 'Schedule Type',
                      border: OutlineInputBorder(),
                    ),
                    items: _scheduleTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getScheduleTypeDisplayName(type)),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _scheduleType = value!;
                        _selectedDays.clear();
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Interval Selection
                  Row(
                    children: [
                      const Text('Repeat every: '),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          initialValue: _interval.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          onChanged: (value) {
                            _interval = int.tryParse(value) ?? 1;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_getIntervalUnit()),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Days of Week Selection (for weekly schedules)
                  if (_scheduleType == 'weekly' || _scheduleType == 'monthly_day')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Days of Week:', style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(7, (index) {
                            final isSelected = _selectedDays.contains(index);
                            return FilterChip(
                              label: Text(_dayNames[index]),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedDays.add(index);
                                  } else {
                                    _selectedDays.remove(index);
                                  }
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  
                  // Date Range
                  _buildSectionHeader('Date Range'),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text('Start Date'),
                          subtitle: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            if (date != null) {
                              setState(() {
                                _startDate = date;
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('End Date (Optional)'),
                          subtitle: Text(_endDate != null 
                              ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                              : 'No end date'
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
                              firstDate: _startDate,
                              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                            );
                            setState(() {
                              _endDate = date;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time Selection
                  ListTile(
                    title: const Text('Time of Day (Optional)'),
                    subtitle: Text(_timeOfDay != null 
                        ? _timeOfDay!.format(context)
                        : 'No specific time'
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _timeOfDay ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _timeOfDay = time;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _createRoutine();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Create Routine'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Existing Routines List
            _buildSectionHeader('Your Routines'),
            _buildRoutinesList(routineService),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoutinesList(RoutineService routineService) {
    final routines = routineService.routines;
    
    if (routines.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.schedule, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No routines created yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your first routine template above',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: routines.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final routine = routines[index];
        return Card(
          child: ListTile(
            title: Text(routine.name),
            subtitle: Text(
              '${_getScheduleTypeDisplayName(routine.scheduleType)} • '
              'Starting ${routine.startDate.day}/${routine.startDate.month}/${routine.startDate.year}'
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  await routineService.deleteRoutine(routine.id);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getScheduleTypeDisplayName(String type) {
    switch (type) {
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly_date':
        return 'Monthly (by date)';
      case 'monthly_day':
        return 'Monthly (by day)';
      default:
        return type;
    }
  }

  String _getIntervalUnit() {
    switch (_scheduleType) {
      case 'daily':
        return _interval == 1 ? 'day' : 'days';
      case 'weekly':
        return _interval == 1 ? 'week' : 'weeks';
      case 'monthly_date':
      case 'monthly_day':
        return _interval == 1 ? 'month' : 'months';
      default:
        return 'units';
    }
  }

  Future<void> _createRoutine() async {
    final routineService = ref.read(routineServiceProvider);
    
    final routineId = await routineService.createRoutine(
      name: _nameController.text,
      description: _descriptionController.text.isEmpty 
          ? null 
          : _descriptionController.text,
      scheduleType: _scheduleType,
      interval: _interval,
      daysOfWeek: _selectedDays.isEmpty ? null : _selectedDays,
      startDate: _startDate,
      endDate: _endDate,
      timeOfDay: _timeOfDay?.format(context),
    );
    
    if (routineId != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Routine "${_nameController.text}" created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Clear form
      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _scheduleType = 'daily';
        _interval = 1;
        _selectedDays.clear();
        _startDate = DateTime.now();
        _endDate = null;
        _timeOfDay = null;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create routine. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
