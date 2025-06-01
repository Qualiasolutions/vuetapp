import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/routine_model.dart';
import 'package:vuet_app/providers/routine_providers.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/widgets/modern_components.dart';

class CreateEditRoutineScreen extends ConsumerStatefulWidget {
  final RoutineModel? routine;

  const CreateEditRoutineScreen({
    super.key,
    this.routine,
  });

  @override
  ConsumerState<CreateEditRoutineScreen> createState() => _CreateEditRoutineScreenState();
}

class _CreateEditRoutineScreenState extends ConsumerState<CreateEditRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  
  bool _monday = true;
  bool _tuesday = true;
  bool _wednesday = true;
  bool _thursday = true;
  bool _friday = true;
  bool _saturday = false;
  bool _sunday = false;
  
  List<String> _members = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _nameController.text = widget.routine!.name;
      _descriptionController.text = widget.routine!.description ?? '';
      
      // Parse time strings to TimeOfDay
      _startTime = _parseTimeString(widget.routine!.startTime);
      _endTime = _parseTimeString(widget.routine!.endTime);
      
      _monday = widget.routine!.monday;
      _tuesday = widget.routine!.tuesday;
      _wednesday = widget.routine!.wednesday;
      _thursday = widget.routine!.thursday;
      _friday = widget.routine!.friday;
      _saturday = widget.routine!.saturday;
      _sunday = widget.routine!.sunday;
      
      _members = List<String>.from(widget.routine!.members);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.routine == null ? 'Create Routine' : 'Edit Routine',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _saveRoutine,
              icon: const Icon(
                Icons.check,
                color: Color(0xFF374151),
              ),
              tooltip: 'Save',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade800),
                      ),
                    ),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 16),
                  _buildScheduleSection(),
                  const SizedBox(height: 16),
                  _buildMembersSection(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _saveRoutine,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.routine == null ? 'Create Routine' : 'Save Changes',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBasicInfoSection() {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Routine Name',
              hintText: 'Enter a name for this routine',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Enter a description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTimeOfDay(_startTime)),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTimeOfDay(_endTime)),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Repeat on',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildWeekdaySelector(),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: _selectWeekdays,
                icon: const Icon(Icons.work_outline, size: 18),
                label: const Text('Weekdays'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _selectWeekends,
                icon: const Icon(Icons.weekend_outlined, size: 18),
                label: const Text('Weekends'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _selectAllDays,
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: const Text('All Days'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return ModernComponents.modernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: _addMember,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Add family members who should be included in this routine',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          if (_members.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'No members added yet',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.person, color: Colors.blue),
                  ),
                  title: Text(_members[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => _removeMember(index),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDayToggle('M', _monday, (value) => setState(() => _monday = value)),
        _buildDayToggle('T', _tuesday, (value) => setState(() => _tuesday = value)),
        _buildDayToggle('W', _wednesday, (value) => setState(() => _wednesday = value)),
        _buildDayToggle('T', _thursday, (value) => setState(() => _thursday = value)),
        _buildDayToggle('F', _friday, (value) => setState(() => _friday = value)),
        _buildDayToggle('S', _saturday, (value) => setState(() => _saturday = value)),
        _buildDayToggle('S', _sunday, (value) => setState(() => _sunday = value)),
      ],
    );
  }

  Widget _buildDayToggle(String day, bool isSelected, Function(bool) onChanged) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.grey.shade200,
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final initialTime = isStartTime ? _startTime : _endTime;
    
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    
    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
  }

  void _selectWeekdays() {
    setState(() {
      _monday = true;
      _tuesday = true;
      _wednesday = true;
      _thursday = true;
      _friday = true;
      _saturday = false;
      _sunday = false;
    });
  }

  void _selectWeekends() {
    setState(() {
      _monday = false;
      _tuesday = false;
      _wednesday = false;
      _thursday = false;
      _friday = false;
      _saturday = true;
      _sunday = true;
    });
  }

  void _selectAllDays() {
    setState(() {
      _monday = true;
      _tuesday = true;
      _wednesday = true;
      _thursday = true;
      _friday = true;
      _saturday = true;
      _sunday = true;
    });
  }

  void _addMember() {
    // This is a placeholder. In a real app, you would show a dialog to select family members.
    setState(() {
      _members.add('Family Member ${_members.length + 1}');
    });
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  void _saveRoutine() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final routineData = RoutineModel(
        id: widget.routine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        userId: ref.read(authServiceProvider).currentUser?.id ?? 'default-user-id',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
        startTime: _formatTimeOfDay(_startTime),
        endTime: _formatTimeOfDay(_endTime),
        monday: _monday,
        tuesday: _tuesday,
        wednesday: _wednesday,
        thursday: _thursday,
        friday: _friday,
        saturday: _saturday,
        sunday: _sunday,
        members: _members,
        createdAt: widget.routine?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.routine == null) {
        // Create new routine
        await ref.read(routinesNotifierProvider.notifier).createRoutine(routineData);
      } else {
        // Update existing routine
        await ref.read(routinesNotifierProvider.notifier).updateRoutine(routineData);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save routine: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  TimeOfDay _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}
