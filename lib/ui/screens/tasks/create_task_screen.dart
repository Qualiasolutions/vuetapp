import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/models/entity_model.dart'; // Provides BaseEntityModel, EntityTypeName
import 'package:vuet_app/models/task_type_enums.dart'; // Import task type enums
import 'package:vuet_app/providers/task_providers.dart'; // Correct provider import
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/services/entity_service.dart'; // Added for EntityService and its provider
import 'package:vuet_app/utils/logger.dart'; // Import logger for logging
import 'package:vuet_app/ui/widgets/task_type_selector.dart'; // Import TaskTypeSelector

// TODO: Move providers to a dedicated providers file later

// AuthService is used statically by TaskService, so a provider for it might not be needed here
// unless other parts of this screen directly interact with a non-static AuthService instance.
// For now, removing the authServiceProvider from this file as TaskService handles createdById.

// Removed local taskServiceProvider, TaskService will be accessed via context.read<TaskService>()
// as it's provided by legacy 'provider' in main.dart.

// Local Riverpod provider for TaskCategoryService
final taskCategoryServiceProvider = Provider<TaskCategoryService>((ref) {
  // Assuming TaskCategoryService has a default constructor or its dependencies are handled by Riverpod
  return TaskCategoryService(); 
});

// Provider to fetch categories using the local Riverpod provider for TaskCategoryService
final taskCategoriesProvider = FutureProvider<List<TaskCategoryModel>>((ref) async {
  final categoryService = ref.watch(taskCategoryServiceProvider);
  return await categoryService.getCategories();
});

// Provider to fetch all entities for the current user
final userEntitiesProvider = FutureProvider<List<BaseEntityModel>>((ref) async {
  final entityService = ref.watch(entityServiceProvider);
  // Using `getAllUserEntities()` which is more appropriate.
  return await entityService.getAllUserEntities(); 
});

class CreateTaskScreen extends ConsumerStatefulWidget {
  final String? linkedEntityId;
  final String? linkedEntityName; // Added for display purposes

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
  final _dueDateController = TextEditingController(); // For displaying the date
  final _locationController = TextEditingController(); // For location
  final _startDateTimeController = TextEditingController(); // For start date/time
  final _endDateTimeController = TextEditingController(); // For end date/time

  DateTime? _dueDate;
  String? _selectedPriority;
  TaskCategoryModel? _selectedCategory;
  BaseEntityModel? _selectedEntity; // Changed to BaseEntityModel
  
  // Task type properties
  TaskType? _selectedTaskType;
  String? _selectedTaskSubtype;
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  // Database requires lowercase priority values: 'low', 'medium', 'high'
  final List<String> _priorityValues = ['low', 'medium', 'high'];
  final List<String> _priorityLabels = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    if (widget.linkedEntityId != null) {
      // Attempt to pre-select the entity if linkedEntityId is provided
      ref.read(userEntitiesProvider.future).then((entities) {
        if (mounted) {
          final entity = entities.firstWhere(
            (e) => e.id == widget.linkedEntityId,
            orElse: () => BaseEntityModel(
              id: 'not-found', // Sentinel value
              name: '',
              userId: '',
              subtype: EntitySubtype.home, // Dummy subtype
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
          if (entity.id != 'not-found') {
            setState(() {
              _selectedEntity = entity;
              // Optionally pre-fill title with entity name
              if (_titleController.text.isEmpty) {
                _titleController.text = 'Task for ${entity.name}';
              }
            });
          }
        }
      });
    }
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
  
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
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

  void _submitForm() async { // Made async
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String description = _descriptionController.text;

      // Show loading indicator
      // TODO: Implement a more robust loading indicator (e.g., a modal overlay)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saving Task...')),
        );
      }

      try {
        // Access TaskService via Riverpod's ref.read
        final taskService = ref.read(taskServiceProvider);
        
        // Create a map for type-specific data based on task type
        Map<String, dynamic>? typeSpecificData;
        if (_selectedTaskType != null) {
          typeSpecificData = {};
          
          // Add type-specific fields based on the selected type
          if (_selectedTaskType == TaskType.appointment || 
              _selectedTaskType == TaskType.activity ||
              _selectedTaskType == TaskType.transport ||
              _selectedTaskType == TaskType.accommodation) {
            
            if (_locationController.text.isNotEmpty) {
              typeSpecificData['locationDetails'] = _locationController.text.trim();
            }
            
            if (_startDateTime != null) {
              typeSpecificData['startTimeDetails'] = _startDateTime!.toIso8601String();
            }
            
            if (_endDateTime != null) {
              typeSpecificData['endTimeDetails'] = _endDateTime!.toIso8601String();
            }
          }
        }

        // TaskService.createTask uses named parameters and handles createdById internally
        final taskId = await taskService.createTask(
          title: title,
          description: description.isNotEmpty ? description : null,
          dueDate: _dueDate,
          priority: _selectedPriority ?? 'medium', // Default if null
          categoryId: _selectedCategory?.id,
          entityId: _selectedEntity?.id.toString(), // Convert ID to String
          taskType: _selectedTaskType,
          taskSubtype: _selectedTaskSubtype,
          startDateTime: _startDateTime,
          endDateTime: _endDateTime,
          location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
          typeSpecificData: typeSpecificData,
        );

        log(
          'Task Created with ID: $taskId, Title: $title, Description: $description, DueDate: $_dueDate, Priority: $_selectedPriority, Category: ${_selectedCategory?.id}, Entity: ${_selectedEntity?.name}',
          name: 'CreateTaskScreen'
        );

        if (mounted) {
          Navigator.pop(context, true); // Pop with a result to indicate success
        }
      } catch (e) {
        log('Error creating task: $e', name: 'CreateTaskScreen', error: e, stackTrace: StackTrace.current);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving task: $e')),
          );
        }
      }
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    if (!mounted) return; // Guard against async gap
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat.yMMMd().format(_dueDate!); // e.g., Sep 10, 2023
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(taskCategoriesProvider);
    final entitiesAsyncValue = ref.watch(userEntitiesProvider); // Watch entities provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Task',
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
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
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Due Date (Optional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDueDate(context),
              ),
              const SizedBox(height: 16),
              
              // Add TaskTypeSelector
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
              
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Priority (Optional)',
                  border: OutlineInputBorder(),
                ),
                value: _selectedPriority,
                hint: const Text('Select Priority'),
                items: List.generate(_priorityValues.length, (index) {
                  return DropdownMenuItem<String>(
                    value: _priorityValues[index],  // Use lowercase value for database
                    child: Text(_priorityLabels[index]),  // Display capitalized label to user
                  );
                }),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              categoriesAsyncValue.when(
                data: (categories) {
                  // Check if _selectedCategory is still valid, otherwise reset it
                  if (_selectedCategory != null && !categories.any((cat) => cat.id == _selectedCategory!.id)) {
                    // Post-frame callback to avoid calling setState during build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _selectedCategory = null;
                        });
                      }
                    });
                  }
                  return DropdownButtonFormField<TaskCategoryModel>(
                    decoration: const InputDecoration(
                      labelText: 'Category (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    hint: const Text('Select Category'),
                    isExpanded: true, // This prevents overflow by allowing the dropdown to expand
                    items: categories.map((TaskCategoryModel category) {
                      return DropdownMenuItem<TaskCategoryModel>(
                        value: category,
                        child: Text(
                          category.name,
                          overflow: TextOverflow.ellipsis, // Handle long names
                        ),
                      );
                    }).toList(),
                    onChanged: (TaskCategoryModel? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add some padding
                  child: Text(
                    'Error loading categories: $err',
                    softWrap: true, // Ensure text wraps
                    overflow: TextOverflow.ellipsis, // Handle overflow if still too long
                    maxLines: 10, // Limit lines for very long errors
                  ),
                ),
              ),
              const SizedBox(height: 16),
              entitiesAsyncValue.when(
                data: (entities) {
                  final currentSelectedEntity = _selectedEntity; // Help analyzer
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
                    isExpanded: true, // This prevents overflow by allowing the dropdown to expand
                    items: entities.map<DropdownMenuItem<BaseEntityModel>>((BaseEntityModel entity) {
                      return DropdownMenuItem<BaseEntityModel>(
                        value: entity,
                        child: Text(
                          entity.name, // Display entity name
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (BaseEntityModel? newValue) {
                      setState(() {
                        _selectedEntity = newValue;
                      });
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Error loading entities: $err',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
