import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/providers/entity_actions_provider.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:intl/intl.dart';

class EntityFormScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;
  final EntitySubtype defaultSubtype;
  final String? subcategoryId;
  final BaseEntityModel? existingEntity; // For editing mode

  const EntityFormScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.defaultSubtype,
    this.subcategoryId,
    this.existingEntity,
  }) : super(key: key);

  @override
  ConsumerState<EntityFormScreen> createState() => _EntityFormScreenState();
}

class _EntityFormScreenState extends ConsumerState<EntityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _dropdownSelectedValues = {};
  final Map<String, bool> _booleanValues = {};
  
  late EntitySubtype _selectedSubtype;
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingEntity?.name ?? '',
    );
    _selectedSubtype = widget.existingEntity?.subtype ?? widget.defaultSubtype;
    
    // Initialize the form fields based on entity type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFormFields();
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _clearControllers();
    super.dispose();
  }
  
  void _clearControllers() {
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    _dropdownSelectedValues.clear();
    _booleanValues.clear();
  }
  
  void _initializeFormFields() {
    _clearControllers();
    
    // Get form fields for the selected entity type
    final fields = entityFormFields[_selectedSubtype] ?? [];
    
    // Initialize controllers with existing values if in edit mode
    if (widget.existingEntity != null) {
      final customFields = widget.existingEntity?.customFields ?? {};
      
      for (var fieldDef in fields) {
        final existingValue = customFields[fieldDef.name];
        
        if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
          String textValue = '';
          if (existingValue != null) {
            if ((fieldDef.type == FormFieldType.date || fieldDef.type == FormFieldType.dateTime) && 
                existingValue is DateTime) {
              textValue = fieldDef.type == FormFieldType.dateTime 
                  ? DateFormat.yMd().add_Hm().format(existingValue)
                  : DateFormat.yMd().format(existingValue);
            } else {
              textValue = existingValue.toString();
            }
          }
          _textControllers[fieldDef.name] = TextEditingController(text: textValue);
        } else if (fieldDef.type == FormFieldType.dropdown) {
          _dropdownSelectedValues[fieldDef.name] = existingValue ?? fieldDef.options?.first.value;
        } else if (fieldDef.type == FormFieldType.boolean) {
          _booleanValues[fieldDef.name] = existingValue as bool? ?? false;
        }
      }
    } else {
      // Initialize with default values for new entity
      for (var fieldDef in fields) {
        if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
          _textControllers[fieldDef.name] = TextEditingController();
        } else if (fieldDef.type == FormFieldType.dropdown && fieldDef.options != null && fieldDef.options!.isNotEmpty) {
          _dropdownSelectedValues[fieldDef.name] = fieldDef.options!.first.value;
        } else if (fieldDef.type == FormFieldType.boolean) {
          _booleanValues[fieldDef.name] = false;
        }
      }
    }
    
    setState(() {}); // Refresh UI with new fields
  }
  
  Future<void> _saveEntity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Get the current user ID
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      // Collect custom field values
      final Map<String, dynamic> customFieldsData = {};
      final fields = entityFormFields[_selectedSubtype] ?? [];
      
      for (var fieldDef in fields) {
        if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
          customFieldsData[fieldDef.name] = _textControllers[fieldDef.name]?.text;
        } else if (fieldDef.type == FormFieldType.dropdown) {
          customFieldsData[fieldDef.name] = _dropdownSelectedValues[fieldDef.name];
        } else if (fieldDef.type == FormFieldType.boolean) {
          customFieldsData[fieldDef.name] = _booleanValues[fieldDef.name];
        }
      }
      
      final entityActionsNotifier = ref.read(entityActionsProvider.notifier);
      
      // Get the app category ID for this entity type
      final appCategoryId = EntityTypeHelper.getCategoryId(_selectedSubtype);
      
      if (widget.existingEntity != null) {
        // Update existing entity
        final updatedEntity = widget.existingEntity!.copyWith(
          name: _nameController.text,
          subtype: _selectedSubtype,
          appCategoryId: appCategoryId,
          customFields: customFieldsData,
          subcategoryId: widget.subcategoryId,
          updatedAt: DateTime.now(),
        );
        
        await entityActionsNotifier.updateEntity(updatedEntity);
      } else {
        // Create new entity
        final newEntity = BaseEntityModel(
          name: _nameController.text,
          userId: currentUser.id,
          appCategoryId: appCategoryId,
          subtype: _selectedSubtype,
          subcategoryId: widget.subcategoryId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          customFields: customFieldsData,
        );
        
        await entityActionsNotifier.createEntity(newEntity);
      }
      
      if (mounted) {
        Navigator.pop(context, true); // Return success
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to save: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildFormField(FormFieldDefinition fieldDef) {
    switch (fieldDef.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.phone:
      case FormFieldType.url:
      case FormFieldType.number:
        return TextFormField(
          controller: _textControllers[fieldDef.name],
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
          ),
          maxLines: 1,
          keyboardType: fieldDef.keyboardType,
          validator: fieldDef.isRequired
              ? (value) => (value == null || value.isEmpty) ? 'Please enter ${fieldDef.label}' : null
              : null,
        );
      
      case FormFieldType.multilineText:
        return TextFormField(
          controller: _textControllers[fieldDef.name],
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
          ),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          validator: fieldDef.isRequired
              ? (value) => (value == null || value.isEmpty) ? 'Please enter ${fieldDef.label}' : null
              : null,
        );

      case FormFieldType.date:
      case FormFieldType.dateTime:
        return TextFormField(
          controller: _textControllers[fieldDef.name],
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectDateTime(context, _textControllers[fieldDef.name]!, fieldDef),
          validator: fieldDef.isRequired
              ? (value) => (value == null || value.isEmpty) ? 'Please enter ${fieldDef.label}' : null
              : null,
        );

      case FormFieldType.dropdown:
        final options = fieldDef.options ?? [];
        return DropdownButtonFormField<dynamic>(
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
          ),
          value: _dropdownSelectedValues[fieldDef.name],
          items: options.map((option) {
            return DropdownMenuItem(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _dropdownSelectedValues[fieldDef.name] = value;
            });
          },
          validator: fieldDef.isRequired
              ? (value) => (value == null) ? 'Please select ${fieldDef.label}' : null
              : null,
        );

      case FormFieldType.boolean:
        return SwitchListTile(
          title: Text(fieldDef.label),
          subtitle: fieldDef.hintText != null ? Text(fieldDef.hintText!) : null,
          value: _booleanValues[fieldDef.name] ?? false,
          onChanged: (value) {
            setState(() {
              _booleanValues[fieldDef.name] = value;
            });
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  TextInputType _getKeyboardType(FormFieldType type) {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.url:
        return TextInputType.url;
      case FormFieldType.multilineText:
        return TextInputType.multiline;
      case FormFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
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
      } catch (e) {
        // Use default if parsing fails
      }
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      if (fieldDef.type == FormFieldType.dateTime) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );

        if (pickedTime != null && mounted) {
          final pickedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          setState(() {
            controller.text = DateFormat.yMd().add_Hm().format(pickedDateTime);
          });
        }
      } else {
        setState(() {
          controller.text = DateFormat.yMd().format(pickedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = entityFormFields[_selectedSubtype] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntity != null ? 'Edit ${widget.categoryName}' : 'Add ${widget.categoryName}'),
        backgroundColor: Colors.grey[700],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field (always required)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name*',
                  hintText: 'Enter name',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              
              // Members field (placeholder - would need implementation based on your user model)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('Members*', style: TextStyle(fontSize: 16)),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Text('Current User'),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // This would open member selection
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Member selection not implemented yet')),
                        );
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Change'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB23B00),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Dynamic form fields based on entity type
              ...fields.map((fieldDef) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildFormField(fieldDef),
              )),
              
              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                
              // Save button
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEntity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB23B00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.existingEntity != null ? 'Update' : 'Create',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 