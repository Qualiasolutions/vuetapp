import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/timeblock_model.dart';
import 'package:vuet_app/providers/timeblock_providers.dart';

// Helper to convert TimeOfDay to 'HH:mm:ss' string
String formatTimeOfDay(TimeOfDay tod) {
  final hour = tod.hour.toString().padLeft(2, '0');
  final minute = tod.minute.toString().padLeft(2, '0');
  return '$hour:$minute:00'; // Adding seconds as 00
}

// Helper to parse 'HH:mm:ss' string to TimeOfDay
TimeOfDay parseTimeOfDay(String timeStr) {
  try {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  } catch (e) {
    // Fallback or error handling
    debugPrint('Error parsing time string "$timeStr": $e');
    return TimeOfDay.now();
  }
}

class CreateEditTimeblockScreen extends ConsumerStatefulWidget {
  final String? timeblockId; // If null, creating new; otherwise, editing.

  const CreateEditTimeblockScreen({super.key, this.timeblockId});

  @override
  ConsumerState<CreateEditTimeblockScreen> createState() =>
      _CreateEditTimeblockScreenState();
}

class _CreateEditTimeblockScreenState
    extends ConsumerState<CreateEditTimeblockScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _colorController; // For hex color input

  int _selectedDayOfWeek = 1; // Default to Monday
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

  bool _isLoading = false;
  TimeblockModel? _editingTimeblock;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _colorController = TextEditingController(text: '#FF0000'); // Default color

    if (widget.timeblockId != null) {
      _loadTimeblockData();
    }
  }

  Future<void> _loadTimeblockData() async {
    setState(() => _isLoading = true);
    try {
      _editingTimeblock = await ref.read(timeblockRepositoryProvider).fetchTimeblockById(widget.timeblockId!);
      if (_editingTimeblock != null) {
        _titleController.text = _editingTimeblock!.title ?? '';
        _descriptionController.text = _editingTimeblock!.description ?? '';
        _colorController.text = _editingTimeblock!.color ?? '#FFFFFF';
        _selectedDayOfWeek = _editingTimeblock!.dayOfWeek;
        _startTime = parseTimeOfDay(_editingTimeblock!.startTime);
        _endTime = parseTimeOfDay(_editingTimeblock!.endTime);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timeblock not found.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading timeblock: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }
  
  void _submitForm() async {
    // Basic validation for end time > start time
    if (_endTime.hour < _startTime.hour || (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time.')),
        );
      }
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final currentUserId = ref.read(currentUserIdProvider);

      if (currentUserId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You need to be logged in to create timeblocks.'))
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      try {
        final repo = ref.read(timeblockRepositoryProvider);
        final title = _titleController.text.isEmpty ? null : _titleController.text;
        final description = _descriptionController.text.isEmpty ? null : _descriptionController.text;
        final color = _colorController.text.isEmpty ? null : _colorController.text;

        if (_editingTimeblock == null) { // Create new
          final timeblock = TimeblockModel(
            id: '', // Will be generated by Supabase
            userId: currentUserId!,
            title: title,
            dayOfWeek: _selectedDayOfWeek,
            startTime: formatTimeOfDay(_startTime),
            endTime: formatTimeOfDay(_endTime),
            color: color,
            description: description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await repo.createTimeblock(timeblock);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timeblock created!')));
        } else { // Update existing
          final updatedTimeblock = _editingTimeblock!.copyWith(
            title: title,
            dayOfWeek: _selectedDayOfWeek,
            startTime: formatTimeOfDay(_startTime),
            endTime: formatTimeOfDay(_endTime),
            color: color,
            description: description,
            updatedAt: DateTime.now(),
          );
          await repo.updateTimeblock(updatedTimeblock);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Timeblock updated!')));
        }
        if (mounted) Navigator.of(context).pop(); // Go back after save
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving timeblock: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.timeblockId == null ? 'Create Timeblock' : 'Edit Timeblock',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151), // Explicit dark color
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151), // Explicit foreground color
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _submitForm,
              icon: const Icon(
                Icons.check,
                color: Color(0xFF374151),
              ),
              tooltip: 'Save',
            ),
        ],
      ),
      body: _isLoading && widget.timeblockId != null && _editingTimeblock == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedDayOfWeek,
                      decoration: const InputDecoration(labelText: 'Day of the Week', border: OutlineInputBorder()),
                      items: List.generate(7, (index) {
                        final day = index + 1;
                        String dayName = '';
                        switch (day) {
                          case 1: dayName = 'Monday'; break;
                          case 2: dayName = 'Tuesday'; break;
                          case 3: dayName = 'Wednesday'; break;
                          case 4: dayName = 'Thursday'; break;
                          case 5: dayName = 'Friday'; break;
                          case 6: dayName = 'Saturday'; break;
                          case 7: dayName = 'Sunday'; break;
                        }
                        return DropdownMenuItem<int>(
                          value: day,
                          child: Text(dayName),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDayOfWeek = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text('Start Time: ${MaterialLocalizations.of(context).formatTimeOfDay(_startTime)}'),
                      trailing: const Icon(Icons.edit_calendar_outlined),
                      onTap: () => _pickStartTime(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0), side: BorderSide(color: Theme.of(context).colorScheme.outline)),
                    ),
                    const SizedBox(height: 16),
                     ListTile(
                      title: Text('End Time: ${MaterialLocalizations.of(context).formatTimeOfDay(_endTime)}'),
                      trailing: const Icon(Icons.edit_calendar_outlined),
                      onTap: () => _pickEndTime(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0), side: BorderSide(color: Theme.of(context).colorScheme.outline)),
                    ),
                    if (_endTime.hour < _startTime.hour || (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('End time must be after start time.', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(labelText: 'Color (Hex e.g., #RRGGBB)', border: OutlineInputBorder()),
                       validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final RegExp hexColorPattern = RegExp(r'^#[0-9a-fA-F]{6}$');
                          if (!hexColorPattern.hasMatch(value)) {
                            return 'Enter a valid hex color (e.g., #RRGGBB)';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    if (_isLoading) 
                      const Center(child: CircularProgressIndicator())
                    else 
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: Text(widget.timeblockId == null ? 'Create Timeblock' : 'Save Changes'),
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
