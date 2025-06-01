import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:vuet_app/models/task_model.dart';
import 'package:vuet_app/models/task_type_enums.dart';
// import 'package:vuet_app/services/task_category_service.dart'; // Accessed via provider
// import 'package:vuet_app/services/task_service.dart'; // Old import for taskServiceProvider
import 'package:vuet_app/providers/task_providers.dart'; // New import for taskServiceProvider
import 'package:vuet_app/models/entity_model.dart'; // Provides BaseEntityModel, EntityTypeName
// Added for EntityService and its provider
import 'package:vuet_app/ui/components/category_selector.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/widgets/task_type_selector.dart';
// taskCategoriesProvider and userEntitiesProvider are imported from create_task_screen.dart.
// Ensure they are correctly defined there or move them to a central providers file.
import 'package:vuet_app/ui/screens/tasks/create_task_screen.dart' show userEntitiesProvider; 

/// Screen for editing an existing task
class EditTaskScreen extends ConsumerStatefulWidget {
  /// The task to edit
  final TaskModel task;

  /// Constructor
  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;
  
  DateTime? _dueDate;
  String? _selectedCategoryId;
  late String _selectedPriority;
  late String _selectedStatus;
  BaseEntityModel? _selectedEntity; // Changed to BaseEntityModel
  String? _initialEntityId; // Reverted to String? To store initial entityId from widget.task
  
  // Task type fields
  TaskType? _selectedTaskType;
  String? _selectedTaskSubtype;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _startDateTimeController = TextEditingController();
  TextEditingController _endDateTimeController = TextEditingController();
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  
  // bool _isLoadingCategories = true; // Handled by taskCategoriesProvider
  bool _isSaving = false;
  String _error = '';
  // TaskModel? _task; // Passed via widget.task
  
  // List<TaskCategoryModel> _categories = []; // Handled by taskCategoriesProvider
  
  // final TaskService _taskService = TaskService(); // Accessed via provider
  // final TaskCategoryService _categoryService = TaskCategoryService(); // Accessed via provider
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _dueDateController = TextEditingController();
    _locationController = TextEditingController(text: widget.task.location ?? '');
    _startDateTimeController = TextEditingController();
    _endDateTimeController = TextEditingController();

    _dueDate = widget.task.dueDate;
    if (_dueDate != null) {
      _dueDateController.text = _formatDate(_dueDate!);
    }
    
    _selectedTaskType = widget.task.taskType;
    _selectedTaskSubtype = widget.task.taskSubtype;
    
    _startDateTime = widget.task.startDateTime;
    if (_startDateTime != null) {
      _startDateTimeController.text = _formatDateTime(_startDateTime!);
    }
    
    _endDateTime = widget.task.endDateTime;
    if (_endDateTime != null) {
      _endDateTimeController.text = _formatDateTime(_endDateTime!);
    }
    
    _selectedCategoryId = widget.task.categoryId; 
    _selectedPriority = widget.task.priority;
    _selectedStatus = widget.task.status;
    _initialEntityId = widget.task.entityId; // Store initial entityId
    
    // Categories and Entities will be loaded by their respective providers
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    _locationController.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    super.dispose();
  }
    
  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date); // Using intl for consistency
  }
  
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
  }
  
  Future<void> _selectDueDate() async {
    if (!mounted) return; // Guard against async gap
    final initialDate = _dueDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000), // Adjusted for wider range
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
        _dueDateController.text = _formatDate(pickedDate);
      });
    }
  }
  
  Future<void> _clearDueDate() async {
    setState(() {
      _dueDate = null;
      _dueDateController.text = '';
    });
  }
  
  Future<void> _selectStartDateTime() async {
    final initialDate = _startDateTime ?? DateTime.now();
    if (!mounted) return; // Guard against async gap
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null) {
      if (!mounted) return; // Guard against async gap
      final initialTime = TimeOfDay.fromDateTime(_startDateTime ?? DateTime.now());
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      
      if (pickedTime != null) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startDateTimeController.text = _formatDateTime(_startDateTime!);
        });
      }
    }
  }
  
  Future<void> _selectEndDateTime() async {
    final initialDate = _endDateTime ?? _startDateTime ?? DateTime.now();
    if (!mounted) return; // Guard against async gap
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    
    if (pickedDate != null) {
      if (!mounted) return; // Guard against async gap
      final initialTime = TimeOfDay.fromDateTime(_endDateTime ?? _startDateTime ?? DateTime.now().add(const Duration(hours: 1)));
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );
      
      if (pickedTime != null) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _endDateTimeController.text = _formatDateTime(_endDateTime!);
        });
      }
    }
  }
  
  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
      _error = '';
    });
    
    try {
      final taskService = ref.read(taskServiceProvider);
      await taskService.updateTask(
        id: widget.task.id, // Use widget.task.id
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(), // Send null if empty
        dueDate: _dueDate,
        categoryId: _selectedCategoryId,
        priority: _selectedPriority,
        status: _selectedStatus,
        entityId: _selectedEntity?.id, 
        taskType: _selectedTaskType,
        taskSubtype: _selectedTaskSubtype,
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to refresh the list
      }
    } catch (e) {
      setState(() {
        _error = 'Error updating task: $e';
        _isSaving = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final entitiesAsyncValue = ref.watch(userEntitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Due Date (Optional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dueDateController,
                          decoration: const InputDecoration(
                            hintText: 'Select due date',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: _selectDueDate,
                        ),
                      ),
                      if (_dueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearDueDate,
                          tooltip: 'Clear date',
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // const Text( // Title for CategorySelector is inside the component
                  //   'Category',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  Card( // Optional: keep Card for consistent styling if CategorySelector doesn't have it
                    margin: EdgeInsets.zero,
                    child: CategorySelector(
                      initialCategoryId: _selectedCategoryId, // Pass initial/current category
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategoryId = category?.id;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Add the task type selector
                  TaskTypeSelector(
                    initialTaskType: _selectedTaskType,
                    initialTaskSubtype: _selectedTaskSubtype,
                    onTaskTypeChanged: (taskType) {
                      setState(() {
                        _selectedTaskType = taskType;
                      });
                    },
                    onTaskSubtypeChanged: (taskSubtype) {
                      setState(() {
                        _selectedTaskSubtype = taskSubtype;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Add start date/time field - shown for appointment, activity, transport
                  if (_selectedTaskType == TaskType.appointment || 
                      _selectedTaskType == TaskType.activity ||
                      _selectedTaskType == TaskType.transport)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start Date & Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _startDateTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Select start date and time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event),
                          ),
                          readOnly: true,
                          onTap: _selectStartDateTime,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    
                  // Add end date/time field - shown for appointment, activity, transport, accommodation
                  if (_selectedTaskType == TaskType.appointment || 
                      _selectedTaskType == TaskType.activity ||
                      _selectedTaskType == TaskType.transport ||
                      _selectedTaskType == TaskType.accommodation)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End Date & Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _endDateTimeController,
                          decoration: const InputDecoration(
                            hintText: 'Select end date and time',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event),
                          ),
                          readOnly: true,
                          onTap: _selectEndDateTime,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  
                  // Add location field - shown for appointment, activity, transport, accommodation
                  if (_selectedTaskType == TaskType.appointment || 
                      _selectedTaskType == TaskType.activity ||
                      _selectedTaskType == TaskType.transport ||
                      _selectedTaskType == TaskType.accommodation)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            hintText: 'Enter location',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_on),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  
                  entitiesAsyncValue.when(
                    data: (entities) {
                      // Initialize _selectedEntity once entities are loaded
                      if (_initialEntityId != null && _selectedEntity == null) {
                        try {
                          _selectedEntity = entities.firstWhere((e) => e.id.toString() == _initialEntityId);
                        } catch (e) {
                          // Entity not found, _selectedEntity remains null
                          // Use logger instead of print in production code
                          debugPrint('Initial linked entity with ID $_initialEntityId not found in the list.');
                        }
                      }
                      // If _selectedEntity is set but not in the current list (e.g. list refreshed), reset it
                      final currentSelectedEntity = _selectedEntity; // Help analyzer with flow analysis
                      if (currentSelectedEntity != null && !entities.any((ent) => ent.id == currentSelectedEntity.id)) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                           if (mounted) {
                            setState(() {
                              _selectedEntity = null;
                            });
                           }
                         });
                      }

                      return DropdownButtonFormField<BaseEntityModel>(
                        decoration: const InputDecoration(
                          labelText: 'Link to Entity (Optional)',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedEntity,
                        hint: const Text('Select Entity'),
                        items: entities.map<DropdownMenuItem<BaseEntityModel>>((BaseEntityModel entity) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final dropdownContentWidth = screenWidth - (16 * 2) - 48;
                          return DropdownMenuItem<BaseEntityModel>(
                            value: entity,
                            child: SizedBox(
                              width: dropdownContentWidth > 0 ? dropdownContentWidth : 200,
                              child: Text(
                                entity.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (BaseEntityModel? newValue) {
                          setState(() {
                            _selectedEntity = newValue;
                            _initialEntityId = null; // User made a new selection
                          });
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Error loading entities: $err', softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'low',
                        label: Text('Low'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                      ButtonSegment<String>(
                        value: 'medium',
                        label: Text('Medium'),
                        icon: Icon(Icons.drag_handle),
                      ),
                      ButtonSegment<String>(
                        value: 'high',
                        label: Text('High'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ],
                    selected: {_selectedPriority},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedPriority = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'pending',
                        label: Text('Pending'),
                      ),
                      ButtonSegment<String>(
                        value: 'in_progress',
                        label: Text('In Progress'),
                      ),
                      ButtonSegment<String>(
                        value: 'completed',
                        label: Text('Done'),
                      ),
                    ],
                    selected: {_selectedStatus},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedStatus = newSelection.first;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _updateTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
