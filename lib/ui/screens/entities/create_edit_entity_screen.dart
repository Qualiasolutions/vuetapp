import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart'; 
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/entity_actions_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateEditEntityScreen extends ConsumerStatefulWidget {
  final int appCategoryId;
  final String? entityId;
  final EntitySubtype? initialSubtype;

  const CreateEditEntityScreen({
    super.key,
    required this.appCategoryId,
    this.entityId,
    this.initialSubtype,
  });

  @override
  CreateEditEntityScreenState createState() => CreateEditEntityScreenState();
}

class CreateEditEntityScreenState extends ConsumerState<CreateEditEntityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  BaseEntityModel? _existingEntity;
  EntitySubtype? _selectedSubtype;
  bool _isLoading = false;
  String? _errorMessage;

  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, dynamic> _dropdownSelectedValues = {};
  final Map<String, bool> _booleanValues = {};
  final Map<String, File?> _imageValues = {};
  final Map<String, List<String>> _memberValues = {};
  final ImagePicker _imagePicker = ImagePicker();

  bool get _isEditMode => widget.entityId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    if (!_isEditMode && widget.initialSubtype != null) {
      _selectedSubtype = widget.initialSubtype;
    }
  }

  void _initializeFormFields(EntitySubtype subtype, {BaseEntityModel? entity}) {
    _clearDynamicControllers();
    final fields = entityFormFields[subtype] ?? [];
    
    if (entity?.description != null) {
      _descriptionController.text = entity!.description!;
    }
    
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
    _descriptionController.dispose();
    _clearDynamicControllers();
    super.dispose();
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
      
      // Debug selected entity type before saving
      // print('📝 Creating entity with type: ${_selectedSubtype?.toString()}');
      if (_selectedSubtype != null) {
        // Get the JsonValue from the enum
        // final enumString = _selectedSubtype.toString(); // Removed unused variable
        // final enumValue = enumString.split('.').last; // Removed unused variable
        // print('📝 EntitySubtype enum value: $enumValue');
        
        // Get the database ID that will be used
        // final databaseTypeId = EntityTypeHelper.getEntityTypeId(_selectedSubtype!); // Removed unused variable
        // print('📝 Database entity_type_id that will be used: $databaseTypeId');
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

      try {
        final entityNotifier = ref.read(entityActionsProvider.notifier);
        if (_isEditMode && _existingEntity != null) {
          final updatedEntity = _existingEntity!.copyWith(
            name: _nameController.text,
            description: _descriptionController.text,
            subtype: _selectedSubtype!, 
            customFields: customFieldsData, 
            updatedAt: DateTime.now(),
          );
          await entityNotifier.updateEntity(updatedEntity); 
        } else {
          final newEntity = BaseEntityModel(
            id: null, 
            name: _nameController.text,
            description: _descriptionController.text,
            userId: currentUser.id, 
            appCategoryId: widget.appCategoryId,
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
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Image picker methods
  Future<void> _takePhoto(String fieldName) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (image != null && mounted) {
        setState(() {
          _imageValues[fieldName] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        );
      }
    }
  }

  Future<void> _choosePhoto(String fieldName) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (image != null && mounted) {
        setState(() {
          _imageValues[fieldName] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to choose photo: $e')),
        );
      }
    }
  }

  void _removeImage(String fieldName) {
    setState(() {
      _imageValues[fieldName] = null;
    });
  }

  void _showImageSourceDialog(String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Photo'),
          content: const Text('How would you like to change the photo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _takePhoto(fieldName);
              },
              child: const Text('Take Photo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _choosePhoto(fieldName);
              },
              child: const Text('Choose from Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Member picker methods
  void _inviteByPhone() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String phoneNumber = '';
        return AlertDialog(
          title: const Text('Invite by Phone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter phone number to send an invitation:'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+1234567890',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => phoneNumber = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (phoneNumber.isNotEmpty) {
                  Navigator.of(context).pop();
                  _sendPhoneInvitation(phoneNumber);
                }
              },
              child: const Text('Send Invitation'),
            ),
          ],
        );
      },
    );
  }

  void _inviteInApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email = '';
        return AlertDialog(
          title: const Text('Invite in App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter email address to send an app invitation:'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'user@example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (email.isNotEmpty) {
                  Navigator.of(context).pop();
                  _sendAppInvitation(email);
                }
              },
              child: const Text('Send Invitation'),
            ),
          ],
        );
      },
    );
  }

  void _sendPhoneInvitation(String phoneNumber) {
    // For now, add to member list - in the future this will send SMS
    final fieldName = 'members'; // This should be dynamic based on context
    final currentMembers = _memberValues[fieldName] ?? [];
    if (!currentMembers.contains(phoneNumber)) {
      setState(() {
        _memberValues[fieldName] = [...currentMembers, phoneNumber];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone invitation sent to $phoneNumber')),
      );
    }
  }

  void _sendAppInvitation(String email) {
    // For now, add to member list - in the future this will send app invitation
    final fieldName = 'members'; // This should be dynamic based on context
    final currentMembers = _memberValues[fieldName] ?? [];
    if (!currentMembers.contains(email)) {
      setState(() {
        _memberValues[fieldName] = [...currentMembers, email];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('App invitation sent to $email')),
      );
    }
  }

  void _removeMember(String fieldName, String member) {
    setState(() {
      _memberValues[fieldName]?.remove(member);
    });
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _getEntityTypeColor(_selectedSubtype),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (fieldDef.type == FormFieldType.dateTime) {
        if (!mounted) return;
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: _getEntityTypeColor(_selectedSubtype),
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
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

  Color _getEntityTypeColor(EntitySubtype? subtype) {
    if (subtype == null) return Colors.blue;
    
    // Return a color based on entity type for visual consistency
    switch (EntityTypeHelper.getCategoryId(subtype)) {
      case 1: return const Color(0xFFE49F30); // Pets - Orange
      case 2: return const Color(0xFF9C27B0); // Social - Purple
      case 3: return const Color(0xFF2196F3); // Education - Blue
      case 4: return const Color(0xFF3F51B5); // Career - Indigo
      case 5: return const Color(0xFF00BCD4); // Travel - Cyan
      case 6: return const Color(0xFF4CAF50); // Health - Green
      case 7: return const Color(0xFF009688); // Home - Teal
      case 8: return const Color(0xFF8BC34A); // Garden - Light Green
      case 9: return const Color(0xFFFF5722); // Food - Orange Red
      default: return const Color(0xFF607D8B); // Default - Blue Grey
    }
  }

  IconData _getEntityTypeIcon(EntitySubtype? subtype) {
    if (subtype == null) return Icons.category;
    
    switch (subtype) {
      case EntitySubtype.pet: return Icons.pets;
      case EntitySubtype.vet: return Icons.medical_services;
      case EntitySubtype.car: return Icons.directions_car;
      case EntitySubtype.home: return Icons.home;
      case EntitySubtype.event: return Icons.event;
      case EntitySubtype.hobby: return Icons.sports_esports;
      case EntitySubtype.doctor: return Icons.local_hospital;
      case EntitySubtype.plant: return Icons.local_florist;
      case EntitySubtype.restaurant: return Icons.restaurant;
      case EntitySubtype.bank: return Icons.account_balance;
      case EntitySubtype.creditCard: return Icons.credit_card;
      default: return Icons.category;
    }
  }

  Widget _buildTextFormField(FormFieldDefinition fieldDef) {
    final controller = _textControllers[fieldDef.name];
    if (controller == null) return const SizedBox.shrink();
    
    bool isDateField = fieldDef.type == FormFieldType.date;
    bool isDateTimeField = fieldDef.type == FormFieldType.dateTime;
    bool isMultiline = fieldDef.type == FormFieldType.multilineText;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: fieldDef.label,
            hintText: fieldDef.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            suffixIcon: (isDateField || isDateTimeField) 
                ? Icon(
                    Icons.calendar_today,
                    color: _getEntityTypeColor(_selectedSubtype),
                  ) 
                : null,
            labelStyle: TextStyle(
              color: _getEntityTypeColor(_selectedSubtype),
              fontWeight: FontWeight.w500,
            ),
          ),
          keyboardType: (isDateField || isDateTimeField) ? TextInputType.none : fieldDef.keyboardType,
          readOnly: isDateField || isDateTimeField,
          maxLines: isMultiline ? 3 : 1,
          style: const TextStyle(fontSize: 16),
          validator: (value) {
            if (fieldDef.isRequired && (value == null || value.isEmpty)) {
              return '${fieldDef.label} is required';
            }
            return null;
          },
          onTap: (isDateField || isDateTimeField) ? () => _selectDateTime(context, controller, fieldDef) : null,
        ),
      ),
    );
  }

  Widget _buildDropdownFormField(FormFieldDefinition fieldDef) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldDef.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getEntityTypeColor(_selectedSubtype),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<dynamic>(
              value: _dropdownSelectedValues[fieldDef.name],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                isDense: true,
              ),
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
              icon: Icon(
                Icons.arrow_drop_down,
                color: _getEntityTypeColor(_selectedSubtype),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile(FormFieldDefinition fieldDef) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: SwitchListTile(
        title: Text(
          fieldDef.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        value: _booleanValues[fieldDef.name] ?? false,
        onChanged: (newValue) {
          setState(() {
            _booleanValues[fieldDef.name] = newValue;
          });
        },
        activeColor: _getEntityTypeColor(_selectedSubtype),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildImagePickerField(FormFieldDefinition fieldDef) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldDef.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getEntityTypeColor(_selectedSubtype),
              ),
            ),
            const SizedBox(height: 12),
            if (_imageValues[fieldDef.name] != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageValues[fieldDef.name]!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _removeImage(fieldDef.name),
                      icon: const Icon(Icons.delete),
                      label: const Text('Remove Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showImageSourceDialog(fieldDef.name),
                      icon: const Icon(Icons.edit),
                      label: const Text('Change Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getEntityTypeColor(_selectedSubtype).withAlpha(51),
                        foregroundColor: _getEntityTypeColor(_selectedSubtype),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 32,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (fieldDef.hintText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        fieldDef.hintText!,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _takePhoto(fieldDef.name),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getEntityTypeColor(_selectedSubtype),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _choosePhoto(fieldDef.name),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getEntityTypeColor(_selectedSubtype).withAlpha(51),
                        foregroundColor: _getEntityTypeColor(_selectedSubtype),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMemberPickerField(FormFieldDefinition fieldDef) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldDef.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getEntityTypeColor(_selectedSubtype),
              ),
            ),
            const SizedBox(height: 12),
            if (fieldDef.hintText != null) ...[
              Text(
                fieldDef.hintText!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _inviteByPhone(),
                    icon: const Icon(Icons.phone),
                    label: const Text('Invite by Phone'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getEntityTypeColor(_selectedSubtype),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _inviteInApp(),
                    icon: const Icon(Icons.person_add),
                    label: const Text('Invite in App'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getEntityTypeColor(_selectedSubtype).withAlpha(51),
                      foregroundColor: _getEntityTypeColor(_selectedSubtype),
                    ),
                  ),
                ),
              ],
            ),
            if (_memberValues[fieldDef.name]?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Invited Members:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...(_memberValues[fieldDef.name]!.map((member) => 
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getEntityTypeColor(_selectedSubtype).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: _getEntityTypeColor(_selectedSubtype),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          member,
                          style: TextStyle(
                            color: _getEntityTypeColor(_selectedSubtype),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => _removeMember(fieldDef.name, member),
                        color: Colors.grey.shade600,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ],
        ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entity Type Selection
            if (!_isEditMode && widget.initialSubtype == null) 
              _buildEntityTypeSelector()
            else if (_selectedSubtype != null)
              _buildEntityTypeDisplay(),
                
            const SizedBox(height: 16),
            
            // Basic Info Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getEntityTypeColor(_selectedSubtype),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter a name';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Custom Fields Section
            if (_selectedSubtype != null) ...[
              Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getEntityTypeColor(_selectedSubtype),
                ),
              ),
              const SizedBox(height: 16),
              
              ..._buildCustomFields(),
              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEntity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getEntityTypeColor(_selectedSubtype),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _isEditMode ? 'Update' : 'Create',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEntityTypeSelector() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Entity Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<EntitySubtype>(
              value: _selectedSubtype,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Select a type',
              ),
              items: entityFormFields.keys
                  .where((subtype) => EntityTypeHelper.getCategoryId(subtype) == widget.appCategoryId)
                  .map((subtype) {
                return DropdownMenuItem<EntitySubtype>(
                  value: subtype,
                  child: Row(
                    children: [
                      Icon(_getEntityTypeIcon(subtype), size: 20, color: _getEntityTypeColor(subtype)),
                      const SizedBox(width: 12),
                      Text(
                        _formatSubtypeName(subtype.toString().split('.').last),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
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
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEntityTypeDisplay() {
    return Card(
      color: _getEntityTypeColor(_selectedSubtype).withAlpha((0.1 * 255).round()),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getEntityTypeColor(_selectedSubtype).withAlpha((0.3 * 255).round())),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getEntityTypeIcon(_selectedSubtype),
              size: 32,
              color: _getEntityTypeColor(_selectedSubtype),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Entity Type',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatSubtypeName(_selectedSubtype.toString().split('.').last),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getEntityTypeColor(_selectedSubtype),
                    ),
                  ),
                ],
              ),
            ),
            if (!_isEditMode && widget.initialSubtype == null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: _getEntityTypeColor(_selectedSubtype),
                ),
                onPressed: () {
                  setState(() {
                    _selectedSubtype = null;
                    _clearDynamicControllers();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCustomFields() {
    final List<Widget> fields = [];
    final entityFields = entityFormFields[_selectedSubtype!] ?? [];
    
    if (entityFields.isEmpty && _textControllers.isEmpty && _dropdownSelectedValues.isEmpty && _booleanValues.isEmpty) {
      fields.add(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Text(
              "No additional fields for ${_formatSubtypeName(_selectedSubtype.toString().split('.').last)}",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      );
      return fields;
    }
    
    for (var fieldDef in entityFields) {
      if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
        fields.add(_buildTextFormField(fieldDef));
      } else if (fieldDef.type == FormFieldType.dropdown && fieldDef.options != null) {
        fields.add(_buildDropdownFormField(fieldDef));
      } else if (fieldDef.type == FormFieldType.boolean) {
        fields.add(_buildSwitchListTile(fieldDef));
      } else if (fieldDef.type == FormFieldType.imagePicker) {
        fields.add(_buildImagePickerField(fieldDef));
      } else if (fieldDef.type == FormFieldType.memberPicker) {
        fields.add(_buildMemberPickerField(fieldDef));
      }
    }
    
    return fields;
  }

  String _formatSubtypeName(String name) {
    return name
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditMode && widget.entityId != null) {
      final entityAsync = ref.watch(entityByIdProvider(widget.entityId!));
      return Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Entity' : 'Create Entity'),
          backgroundColor: _getEntityTypeColor(_selectedSubtype),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: entityAsync.when(
          data: (entity) {
            if (entity == null) {
              return const Center(child: Text("Entity not found."));
            }
            if (_existingEntity == null) { 
              _existingEntity = entity; 
              _nameController.text = _existingEntity!.name;
              if (_existingEntity!.description != null) {
                _descriptionController.text = _existingEntity!.description!;
              }
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
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    "Error Loading Entity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    err.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Create mode
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Entity' : 'Create Entity'),
        backgroundColor: _getEntityTypeColor(_selectedSubtype),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildFormContent(),
    );
  }
}
