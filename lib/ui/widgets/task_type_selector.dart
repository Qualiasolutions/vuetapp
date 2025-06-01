import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_type_enums.dart';

/// A widget for selecting task types and subtypes
class TaskTypeSelector extends StatefulWidget {
  /// Initial task type
  final TaskType? initialTaskType;
  
  /// Initial task subtype
  final String? initialTaskSubtype;
  
  /// Callback when task type changes
  final Function(TaskType?) onTaskTypeChanged;
  
  /// Callback when task subtype changes
  final Function(String?) onTaskSubtypeChanged;

  /// Constructor
  const TaskTypeSelector({
    super.key,
    this.initialTaskType,
    this.initialTaskSubtype,
    required this.onTaskTypeChanged,
    required this.onTaskSubtypeChanged,
  });

  @override
  State<TaskTypeSelector> createState() => _TaskTypeSelectorState();
}

class _TaskTypeSelectorState extends State<TaskTypeSelector> {
  late TaskType? _selectedTaskType;
  String? _selectedTaskSubtype;

  @override
  void initState() {
    super.initState();
    _selectedTaskType = widget.initialTaskType;
    _selectedTaskSubtype = widget.initialTaskSubtype;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Type', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildTaskTypeSelector(),
        const SizedBox(height: 16),
        if (_selectedTaskType != null && _hasSubtypes(_selectedTaskType!))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getSubtypeTitle(_selectedTaskType!),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildTaskSubtypeSelector(_selectedTaskType!),
            ],
          ),
      ],
    );
  }

  Widget _buildTaskTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: TaskType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ChoiceChip(
                label: Text(
                  type.displayName,
                  style: TextStyle(
                    color: _selectedTaskType == type 
                        ? Colors.white 
                        : Colors.grey[800],
                    fontWeight: _selectedTaskType == type 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                  ),
                ),
                selected: _selectedTaskType == type,
                selectedColor: const Color(0xFF0D9488),
                backgroundColor: Colors.grey[100],
                onSelected: (selected) {
                  setState(() {
                    _selectedTaskType = selected ? type : null;
                    _selectedTaskSubtype = null;
                  });
                  widget.onTaskTypeChanged(_selectedTaskType);
                  widget.onTaskSubtypeChanged(null);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskSubtypeSelector(TaskType taskType) {
    List<String> subtypes = [];
    
    switch (taskType) {
      case TaskType.activity:
        subtypes = ActivitySubtype.values.map((e) => e.toString()).toList();
        break;
      case TaskType.transport:
        subtypes = TransportSubtype.values.map((e) => e.toString()).toList();
        break;
      case TaskType.accommodation:
        subtypes = AccommodationSubtype.values.map((e) => e.toString()).toList();
        break;
      case TaskType.anniversary:
        subtypes = AnniversarySubtype.values.map((e) => e.toString()).toList();
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: subtypes.map((subtype) {
            String displayName = _getSubtypeDisplayName(taskType, subtype);
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ChoiceChip(
                label: Text(
                  displayName,
                  style: TextStyle(
                    color: _selectedTaskSubtype == subtype 
                        ? Colors.white 
                        : Colors.grey[800],
                    fontWeight: _selectedTaskSubtype == subtype 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                  ),
                ),
                selected: _selectedTaskSubtype == subtype,
                selectedColor: const Color(0xFF0D9488),
                backgroundColor: Colors.grey[100],
                onSelected: (selected) {
                  setState(() {
                    _selectedTaskSubtype = selected ? subtype : null;
                  });
                  widget.onTaskSubtypeChanged(_selectedTaskSubtype);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
  
  bool _hasSubtypes(TaskType taskType) {
    return taskType == TaskType.activity ||
        taskType == TaskType.transport ||
        taskType == TaskType.accommodation ||
        taskType == TaskType.anniversary;
  }
  
  String _getSubtypeTitle(TaskType taskType) {
    switch (taskType) {
      case TaskType.activity:
        return 'Activity Type';
      case TaskType.transport:
        return 'Transport Type';
      case TaskType.accommodation:
        return 'Accommodation Type';
      case TaskType.anniversary:
        return 'Anniversary Type';
      default:
        return 'Subtype';
    }
  }
  
  String _getSubtypeDisplayName(TaskType taskType, String subtype) {
    switch (taskType) {
      case TaskType.activity:
        final activitySubtype = ActivitySubtype.values.firstWhere(
          (e) => e.toString() == subtype,
          orElse: () => ActivitySubtype.activity,
        );
        return activitySubtype.displayName;
        
      case TaskType.transport:
        final transportSubtype = TransportSubtype.values.firstWhere(
          (e) => e.toString() == subtype,
          orElse: () => TransportSubtype.flight,
        );
        return transportSubtype.displayName;
        
      case TaskType.accommodation:
        final accommodationSubtype = AccommodationSubtype.values.firstWhere(
          (e) => e.toString() == subtype,
          orElse: () => AccommodationSubtype.hotel,
        );
        return accommodationSubtype.displayName;
        
      case TaskType.anniversary:
        final anniversarySubtype = AnniversarySubtype.values.firstWhere(
          (e) => e.toString() == subtype,
          orElse: () => AnniversarySubtype.birthday,
        );
        return anniversarySubtype.displayName;
        
      default:
        return subtype.split('.').last;
    }
  }
}
