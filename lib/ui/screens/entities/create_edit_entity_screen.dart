import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart'; 
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:intl/intl.dart';

class CreateEditEntityScreen extends ConsumerStatefulWidget {
  final int appCategoryId; // Changed from String categoryId
  final String? entityId;
  final EntitySubtype? initialSubtype; // Added initialSubtype

  const CreateEditEntityScreen({
    super.key,
    required this.appCategoryId, // Changed from categoryId
    this.entityId,
    this.initialSubtype, // Added to constructor
  });

  @override
  CreateEditEntityScreenState createState() => CreateEditEntityScreenState();
}

class CreateEditEntityScreenState extends ConsumerState<CreateEditEntityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  BaseEntityModel? _existingEntity;
  EntitySubtype? _selectedSubtype;

  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _dropdownSelectedValues = {};
  final Map<String, bool> _booleanValues = {};

  bool get _isEditMode => widget.entityId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    if (!_isEditMode && widget.initialSubtype != null) {
      _selectedSubtype = widget.initialSubtype;
      // Defer _initializeFormFields to build or post-frame callback 
      // to ensure widget properties are fully available and avoid calling setState too early.
    }
  }

  void _initializeFormFields(EntitySubtype subtype, {BaseEntityModel? entity}) {
    _clearDynamicControllers();
    final fields = entityFormFields[subtype] ?? [];
    for (var fieldDef in fields) {
      dynamic initialValue = entity?.customFields?[fieldDef.name];
      if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
        String textValue = '';
        if (initialValue != null) {
          if ((fieldDef.type == FormFieldType.date || fieldDef.type == FormFieldType.dateTime) && initialValue is DateTime) {
            textValue = fieldDef.type == FormFieldType.dateTime ? DateFormat.yMd().add_Hm().format(initialValue) : DateFormat.yMd().format(initialValue);
          } else if (initialValue is String) {
            textValue = initialValue;
          } else {
            textValue = initialValue.toString();
          }
        }
        _textControllers[fieldDef.name] = TextEditingController(text: textValue);
      } else if (fieldDef.type == FormFieldType.dropdown) {
        _dropdownSelectedValues[fieldDef.name] = initialValue ?? fieldDef.options?.first.value;
      } else if (fieldDef.type == FormFieldType.boolean) {
        _booleanValues[fieldDef.name] = initialValue as bool? ?? false;
      }
    }
    if (mounted) {
        setState(() {}); // Refresh UI with new fields
    }
  }

  void _clearDynamicControllers() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    _dropdownSelectedValues.clear();
    _booleanValues.clear();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clearDynamicControllers();
    super.dispose();
  }

  Future<void> _saveEntity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final entityName = _nameController.text;
      
      // Get user ID directly from Supabase auth
      final supabaseUser = ref.read(currentUserProvider);
      if (supabaseUser == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in or user ID is missing.')),
        );
        return;
      }
      final currentUserId = supabaseUser.id;

      if (_selectedSubtype == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Entity subtype not selected.')),
        );
        return;
      }

      Map<String, dynamic> customFieldsData = {}; 
      final fields = entityFormFields[_selectedSubtype!] ?? [];
      for (var fieldDef in fields) {
        if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
          customFieldsData[fieldDef.name] = _textControllers[fieldDef.name]?.text;
        } else if (fieldDef.type == FormFieldType.dropdown) {
          customFieldsData[fieldDef.name] = _dropdownSelectedValues[fieldDef.name];
        } else if (fieldDef.type == FormFieldType.boolean) {
          customFieldsData[fieldDef.name] = _booleanValues[fieldDef.name];
        }
      }

      try {
        final entityNotifier = ref.read(entityActionsProvider.notifier);
        if (_isEditMode && _existingEntity != null) {
          final updatedEntity = _existingEntity!.copyWith(
            name: entityName,
            subtype: _selectedSubtype!, 
            customFields: customFieldsData, 
            updatedAt: DateTime.now(),
          );
          await entityNotifier.updateEntity(updatedEntity); 
        } else {
          final newEntity = BaseEntityModel(
            id: null, 
            name: entityName,
            userId: currentUserId, 
            appCategoryId: widget.appCategoryId, // Changed to appCategoryId
            subtype: _selectedSubtype!,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            customFields: customFieldsData, 
          );
          await entityNotifier.createEntity(newEntity); 
        }
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save entity: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context, TextEditingController controller, FormFieldDefinition fieldDef) async {
    DateTime initialDate = DateTime.now();
    TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDate);

    if (controller.text.isNotEmpty) {
      try {
        if (fieldDef.type == FormFieldType.dateTime) {
          initialDate = DateFormat.yMd().add_Hm().parse(controller.text);
        } else { 
          initialDate = DateFormat.yMd().parse(controller.text);
        }
        initialTime = TimeOfDay.fromDateTime(initialDate);
      } catch (e) { /* Ignore parse error, use now */ }
    }

    if (!mounted) return;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      if (fieldDef.type == FormFieldType.dateTime) {
        if (!mounted) return;
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (pickedTime != null && mounted) {
          final pickedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          setState(() {
            controller.text = DateFormat.yMd().add_Hm().format(pickedDateTime);
          });
        }
      } else { 
        if (mounted) {
          setState(() {
            controller.text = DateFormat.yMd().format(pickedDate);
          });
        }
      }
    }
  }

  Widget _buildTextFormField(FormFieldDefinition fieldDef) {
    final controller = _textControllers[fieldDef.name];
    if (controller == null) return const SizedBox.shrink();
    bool isDateField = fieldDef.type == FormFieldType.date;
    bool isDateTimeField = fieldDef.type == FormFieldType.dateTime;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: fieldDef.label,
        hintText: fieldDef.hintText,
        border: const OutlineInputBorder(),
        suffixIcon: (isDateField || isDateTimeField) ? const Icon(Icons.calendar_today) : null,
      ),
      keyboardType: (isDateField || isDateTimeField) ? TextInputType.none : fieldDef.keyboardType,
      readOnly: isDateField || isDateTimeField,
      maxLines: fieldDef.type == FormFieldType.multilineText ? 3 : 1,
      validator: (value) {
        if (fieldDef.isRequired && (value == null || value.isEmpty)) {
          return '${fieldDef.label} is required';
        }
        return null;
      },
      onTap: (isDateField || isDateTimeField) ? () => _selectDateTime(context, controller, fieldDef) : null,
    );
  }

  Widget _buildDropdownFormField(FormFieldDefinition fieldDef) {
    return DropdownButtonFormField<dynamic>(
      value: _dropdownSelectedValues[fieldDef.name],
      decoration: InputDecoration(labelText: fieldDef.label, border: const OutlineInputBorder()),
      items: fieldDef.options!.map((option) {
        return DropdownMenuItem<dynamic>(
          value: option.value,
          child: Text(option.label),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _dropdownSelectedValues[fieldDef.name] = newValue;
        });
      },
      validator: (value) {
        if (fieldDef.isRequired && value == null) return '${fieldDef.label} is required';
        return null;
      },
    );
  }

  Widget _buildSwitchListTile(FormFieldDefinition fieldDef) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).inputDecorationTheme.border?.borderSide.color ?? Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4.0),
      child: SwitchListTile(
        title: Text(fieldDef.label, style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: Theme.of(context).hintColor)),
        value: _booleanValues[fieldDef.name] ?? false,
        onChanged: (newValue) {
          setState(() {
            _booleanValues[fieldDef.name] = newValue;
          });
        },
        dense: true,
      ),
    );
  }

  Widget _buildFormContent() {
    if (!_isEditMode && _selectedSubtype != null && _textControllers.isEmpty && (_selectedSubtype == widget.initialSubtype)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
                _initializeFormFields(_selectedSubtype!, entity: null);
            }
        });
    }

    List<Widget> formWidgets = [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Entity Name', border: OutlineInputBorder()),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter a name';
          return null;
        },
      ),
      const SizedBox(height: 16),
    ];

    if (_isEditMode && _selectedSubtype != null) {
      formWidgets.addAll([
        InputDecorator(
          decoration: InputDecoration(
            labelText: 'Entity Type',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15)
          ),
          child: Text(_selectedSubtype.toString().split('.').last, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 16),
      ]);
    } else if (!_isEditMode) {
      if (widget.initialSubtype == null) { 
        formWidgets.addAll([
          DropdownButtonFormField<EntitySubtype>(
            value: _selectedSubtype, 
            decoration: const InputDecoration(labelText: 'Select Entity Type', border: OutlineInputBorder()),
            items: entityFormFields.keys.map((subtype) {
              return DropdownMenuItem<EntitySubtype>(
                value: subtype,
                child: Text(subtype.toString().split('.').last), 
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedSubtype = newValue;
                if (newValue != null) {
                    _initializeFormFields(newValue);
                } else {
                  _clearDynamicControllers(); 
                }
              });
            },
            validator: (value) => value == null ? 'Please select a type' : null,
          ),
          const SizedBox(height: 16),
        ]);
      } else if (_selectedSubtype != null) { 
         formWidgets.addAll([
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Entity Type',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15)
              ),
              child: Text(_selectedSubtype.toString().split('.').last, style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 16),
        ]);
      }
    }

    if (_selectedSubtype != null) {
      final fields = entityFormFields[_selectedSubtype!] ?? [];
      if (fields.isEmpty && _textControllers.isEmpty && _dropdownSelectedValues.isEmpty && _booleanValues.isEmpty){
         formWidgets.add(Center(child: Text("No specific fields defined for type: ${_selectedSubtype.toString().split('.').last}")));
      } else {
        for (var fieldDef in fields) {
          if (FormFieldDefinition.textTypes.contains(fieldDef.type)) { 
            formWidgets.add(_buildTextFormField(fieldDef));
          } else if (fieldDef.type == FormFieldType.dropdown && fieldDef.options != null) {
            formWidgets.add(_buildDropdownFormField(fieldDef));
          } else if (fieldDef.type == FormFieldType.boolean) {
            formWidgets.add(_buildSwitchListTile(fieldDef));
          }
          formWidgets.add(const SizedBox(height: 16));
        }
      }
    } else if (widget.initialSubtype == null && !_isEditMode) { 
       formWidgets.add(const Center(child: Text("Select an entity type to see more fields.")));
    }
    return Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(16.0), children: formWidgets));
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditMode && widget.entityId != null) {
      final entityAsync = ref.watch(entityDetailProvider(widget.entityId!));
      return Scaffold(
        appBar: AppBar(title: Text(_isEditMode ? 'Edit Entity' : 'Create Entity')),
        body: entityAsync.when(
          data: (entity) {
            if (entity == null) return const Center(child: Text("Entity not found."));
            if (_existingEntity == null) { 
                _existingEntity = entity; 
                _nameController.text = _existingEntity!.name;
                _selectedSubtype = _existingEntity!.subtype;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _selectedSubtype != null) {
                    _initializeFormFields(_selectedSubtype!, entity: _existingEntity);
                  }
                });
            }
            return _buildFormContent(); 
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text("Error loading entity: $err")),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveEntity,
          tooltip: 'Save Entity',
          child: const Icon(Icons.save),
        ),
      );
    }
    
    // Create mode: if initialSubtype is set, _initializeFormFields will be called in _buildFormContent's postFrameCallback.
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Entity' : 'Create Entity'),
      ),
      body: _buildFormContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveEntity,
        tooltip: 'Save Entity',
        child: const Icon(Icons.save),
      ),
    );
  }
}
