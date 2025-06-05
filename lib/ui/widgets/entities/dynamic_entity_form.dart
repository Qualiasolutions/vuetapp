import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/providers/category_providers.dart'; // To fetch categories for dropdown
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DynamicEntityForm extends ConsumerStatefulWidget {
  final EntitySubtype entitySubtype;
  final BaseEntityModel? initialEntity; // For editing
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic> customFieldsData, String name, String description) onSave;
  final int appCategoryId; // Fixed category ID - no selection needed

  const DynamicEntityForm({
    super.key,
    required this.entitySubtype,
    this.initialEntity,
    required this.formKey,
    required this.onSave,
    required this.appCategoryId,
  });

  @override
  ConsumerState<DynamicEntityForm> createState() => _DynamicEntityFormState();
}

class _DynamicEntityFormState extends ConsumerState<DynamicEntityForm> {
  late Map<String, dynamic> _customFieldsData;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final Map<String, File?> _imageFiles = {};
  final Map<String, List<String>> _selectedMembers = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialEntity?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialEntity?.description ?? '');
    _customFieldsData = Map<String, dynamic>.from(widget.initialEntity?.customFields ?? {});
    // Category is now fixed via appCategoryId parameter - no selection needed

    // Initialize custom fields with default values if creating a new entity
    if (widget.initialEntity == null) {
      final fields = entityFormFields[widget.entitySubtype] ?? [];
      for (var fieldDef in fields) {
        if (fieldDef.defaultValue != null && _customFieldsData[fieldDef.name] == null) {
          _customFieldsData[fieldDef.name] = fieldDef.defaultValue;
        } else if (fieldDef.type == FormFieldType.boolean && _customFieldsData[fieldDef.name] == null) {
          _customFieldsData[fieldDef.name] = false; // Default boolean to false
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String fieldName, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null && mounted) {
        setState(() {
          _imageFiles[fieldName] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showMemberPicker(String fieldName) async {
    // For now, show a placeholder dialog with mock family members
    // TODO: Implement actual family member selection with invitations
    final List<String> availableMembers = [
      'John Doe',
      'Jane Smith',
      'Alice Johnson',
      'Bob Wilson'
    ];
    
    final List<String> currentlySelected = _selectedMembers[fieldName] ?? [];
    final List<String> tempSelected = List.from(currentlySelected);
    
    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Members'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Family Members:'),
                    const SizedBox(height: 8),
                    ...availableMembers.map((member) => CheckboxListTile(
                      title: Text(member),
                      value: tempSelected.contains(member),
                      onChanged: (bool? selected) {
                        setDialogState(() {
                          if (selected == true) {
                            if (!tempSelected.contains(member)) {
                              tempSelected.add(member);
                            }
                          } else {
                            tempSelected.remove(member);
                          }
                        });
                      },
                    )),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement email invitation feature
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email invitation feature coming soon')),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Invite by Email'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(tempSelected),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB23B00),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
    
    if (result != null && mounted) {
      setState(() {
        _selectedMembers[fieldName] = result;
      });
    }
  }

  Widget _buildFormField(FormFieldDefinition fieldDef) {
    dynamic initialValue = _customFieldsData[fieldDef.name];

    switch (fieldDef.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.phone:
      case FormFieldType.url:
      case FormFieldType.number: // Number can also use TextFormField with appropriate keyboard
        return TextFormField(
          initialValue: initialValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
            border: const OutlineInputBorder(),
          ),
          keyboardType: fieldDef.keyboardType,
          validator: fieldDef.validator ?? (value) {
            if (fieldDef.isRequired && (value == null || value.isEmpty)) {
              return '${fieldDef.label} is required';
            }
            return null;
          },
          onSaved: (value) {
            if (fieldDef.type == FormFieldType.number) {
              _customFieldsData[fieldDef.name] = num.tryParse(value ?? '');
            } else {
              _customFieldsData[fieldDef.name] = value;
            }
          },
        );
      case FormFieldType.multilineText:
        return TextFormField(
          initialValue: initialValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allows for multiple lines
          minLines: 3,
          validator: fieldDef.validator ?? (value) {
            if (fieldDef.isRequired && (value == null || value.isEmpty)) {
              return '${fieldDef.label} is required';
            }
            return null;
          },
          onSaved: (value) {
            _customFieldsData[fieldDef.name] = value;
          },
        );
      case FormFieldType.date:
      case FormFieldType.dateTime:
        return TextFormField(
          // Using a controller for date fields might be better for complex interactions
          // For simplicity, using initialValue and onSaved for now.
          initialValue: initialValue != null ? (initialValue is DateTime ? initialValue.toIso8601String().substring(0, fieldDef.type == FormFieldType.date ? 10 : 16) : initialValue.toString()) : '',
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText ?? (fieldDef.type == FormFieldType.date ? 'YYYY-MM-DD' : 'YYYY-MM-DD HH:MM'),
            border: const OutlineInputBorder(),
            suffixIcon: Icon(fieldDef.type == FormFieldType.date ? Icons.calendar_today : Icons.schedule),
          ),
          readOnly: true, // Make it read-only to force picker usage
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode()); // unfocus keyboard
            DateTime? pickedDate;
            if (fieldDef.type == FormFieldType.date || fieldDef.type == FormFieldType.dateTime) {
              pickedDate = await showDatePicker(
                context: context,
                initialDate: initialValue is DateTime ? initialValue : (DateTime.tryParse(initialValue?.toString() ?? '') ?? DateTime.now()),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
            }
            if (pickedDate != null) {
              if (fieldDef.type == FormFieldType.dateTime) {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: initialValue is DateTime ? TimeOfDay.fromDateTime(initialValue) : (DateTime.tryParse(initialValue?.toString() ?? '') != null ? TimeOfDay.fromDateTime(DateTime.parse(initialValue.toString())) : TimeOfDay.now()),
                );
                if (pickedTime != null) {
                  pickedDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                }
              }
              setState(() {
                _customFieldsData[fieldDef.name] = pickedDate;
              });
              // This is a bit of a hack to update the TextFormField. A controller would be cleaner.
              // Consider using a dedicated state variable for the TextFormField's display value.
            }
          },
          validator: fieldDef.validator ?? (value) {
            if (fieldDef.isRequired && _customFieldsData[fieldDef.name] == null) {
              return '${fieldDef.label} is required';
            }
            return null;
          },
          // onSaved is tricky here without a controller if we rely on _customFieldsData directly.
          // The onTap updates _customFieldsData, so it should be fine.
        );

      case FormFieldType.boolean:
        return CheckboxListTile(
          title: Text(fieldDef.label),
          value: _customFieldsData[fieldDef.name] as bool? ?? false,
          onChanged: (bool? value) {
            setState(() {
              _customFieldsData[fieldDef.name] = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      case FormFieldType.dropdown:
        return DropdownButtonFormField<String>(
          value: initialValue?.toString(),
          decoration: InputDecoration(
            labelText: fieldDef.label,
            border: const OutlineInputBorder(),
          ),
          hint: fieldDef.hintText != null ? Text(fieldDef.hintText!) : null,
          isExpanded: true,
          items: fieldDef.options?.map((option) {
            return DropdownMenuItem<String>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _customFieldsData[fieldDef.name] = newValue;
            });
          },
          validator: fieldDef.validator ?? (value) {
            if (fieldDef.isRequired && (value == null || value.isEmpty)) {
              return '${fieldDef.label} is required';
            }
            return null;
          },
          onSaved: (value) {
             _customFieldsData[fieldDef.name] = value;
          },
        );

      case FormFieldType.imagePicker:
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fieldDef.label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_imageFiles[fieldDef.name] != null) ...[
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_imageFiles[fieldDef.name]!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(fieldDef.name, ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB23B00),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(fieldDef.name, ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB23B00),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (_imageFiles[fieldDef.name] != null) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _imageFiles[fieldDef.name] = null;
                        });
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
              if (fieldDef.hintText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    fieldDef.hintText!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        );

      case FormFieldType.memberPicker:
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(fieldDef.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showMemberPicker(fieldDef.name),
                    icon: const Icon(Icons.people),
                    label: const Text('Select Members'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB23B00),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_selectedMembers[fieldDef.name]?.isNotEmpty ?? false) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _selectedMembers[fieldDef.name]!.map((member) => Chip(
                    label: Text(member),
                    onDeleted: () {
                      setState(() {
                        _selectedMembers[fieldDef.name]?.remove(member);
                      });
                    },
                  )).toList(),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Current user only',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
              if (fieldDef.hintText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    fieldDef.hintText!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FormFieldDefinition> subtypeFields = entityFormFields[widget.entitySubtype] ?? [];
    ref.watch(hierarchicalCategoriesProvider);

    return Form(
      key: widget.formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter entity name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter entity description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          // Category is fixed - no selection needed
          const SizedBox(height: 24),
          if (subtypeFields.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${widget.entitySubtype.toString().split('.').last.replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}').trim()} Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ...subtypeFields.map((fieldDef) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildFormField(fieldDef),
            );
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                widget.formKey.currentState!.save();
                // Use the fixed appCategoryId from widget
                widget.onSave(_customFieldsData, _nameController.text, _descriptionController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: Text(widget.initialEntity == null ? 'Create Entity' : 'Update Entity'),
          ),
        ],
      ),
    );
  }
}
