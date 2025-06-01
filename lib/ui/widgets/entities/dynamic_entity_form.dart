import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/providers/category_providers.dart'; // To fetch categories for dropdown

class DynamicEntityForm extends ConsumerStatefulWidget {
  final EntitySubtype entitySubtype;
  final BaseEntityModel? initialEntity; // For editing
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic> customFieldsData, int? appCategoryId, String name, String description) onSave;
  final int? selectedCategoryId; // To pre-select category if available

  const DynamicEntityForm({
    super.key,
    required this.entitySubtype,
    this.initialEntity,
    required this.formKey,
    required this.onSave,
    this.selectedCategoryId,
  });

  @override
  ConsumerState<DynamicEntityForm> createState() => _DynamicEntityFormState();
}

class _DynamicEntityFormState extends ConsumerState<DynamicEntityForm> {
  late Map<String, dynamic> _customFieldsData;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedCategoryId; // This is EntityCategoryModel.id (String UUID)
  List<EntityCategoryModel> _displayCategories = []; // To store categories for lookup

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialEntity?.name ?? '');
    _descriptionController = TextEditingController(text: widget.initialEntity?.description ?? '');
    _customFieldsData = Map<String, dynamic>.from(widget.initialEntity?.customFields ?? {});
    // widget.selectedCategoryId is int?, initialEntity.appCategoryId is int?
    // _selectedCategoryId (state) is String? for the dropdown (EntityCategoryModel.id)
    // This pre-selection logic is tricky. If widget.selectedCategoryId (int) is provided,
    // we'd need to find the EntityCategoryModel with a matching conceptual app_category_id.
    // For now, if initialEntity has an appCategoryId, we can't directly use it for a String dropdown.
    // Let's try to use initialEntity.categoryId (old field) if it exists and matches a current category.id for basic prefill.
    // This is a temporary patch for pre-selection.
    if (widget.initialEntity?.appCategoryId != null) {
        // If we have an appCategoryId (int), we ideally need to find the corresponding EntityCategoryModel.id (String)
        // This mapping is not directly available here.
        // For now, we can't reliably pre-select based on widget.selectedCategoryId (int) or initialEntity.appCategoryId (int)
        // without fetching all categories and finding a match, or having app_category_id on EntityCategoryModel.
        // So, _selectedCategoryId might remain null if pre-selection based on int ID is needed.
    }
    // The previous logic for `_selectedCategoryId = widget.selectedCategoryId ?? widget.initialEntity?.categoryId;`
    // was trying to assign String? to String? (if _selectedCategoryId was String?)
    // or int? to int? (if _selectedCategoryId was int?).
    // Since BaseEntityModel.categoryId was removed, initialEntity.categoryId won't exist.
    // We use initialEntity.appCategoryId (int?) or widget.selectedCategoryId (int?) for pre-selection logic if possible.
    // However, the dropdown expects a String value.
    // For now, let's clear _selectedCategoryId and rely on the dropdown's default/hint.
    // Proper pre-selection based on int appCategoryId will be handled when categories load.
    _selectedCategoryId = null; 

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<FormFieldDefinition> subtypeFields = entityFormFields[widget.entitySubtype] ?? [];
    final categoriesAsyncValue = ref.watch(hierarchicalCategoriesProvider);

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
          const SizedBox(height: 16),
          categoriesAsyncValue.when(
            data: (hierarchicalCategories) {
              // Flatten the hierarchy for a single dropdown.
              // A more complex UI might use a hierarchical selector.
              List<EntityCategoryModel> flatCategories = [];
              void flatten(List<HierarchicalCategoryDisplayModel> items) {
                for (var item in items) {
                  flatCategories.add(item.category);
                  flatten(item.children);
                }
              }
              flatten(hierarchicalCategories);
              
              // Ensure unique categories by ID, preferring user-owned if names clash (though IDs should be unique)
              final uniqueCategoriesMap = <String, EntityCategoryModel>{};
              for (var cat in flatCategories) {
                uniqueCategoriesMap[cat.id] = cat;
              }
              final localDisplayCategories = uniqueCategoriesMap.values.toList();

              // Update state with fetched categories and attempt pre-selection
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _displayCategories = localDisplayCategories;
                    // Attempt pre-selection if not already selected and initial entity has appCategoryId
                    if (_selectedCategoryId == null && widget.initialEntity?.appCategoryId != null) {
                      final initialAppCatId = widget.initialEntity!.appCategoryId;
                      final matchingCategory = _displayCategories.firstWhere(
                        (cat) => cat.appCategoryId == initialAppCatId,
                        orElse: () => _displayCategories.firstWhere((cat) => cat.id == 'never_found_dummy_id'), // Ensure a non-null orElse that won't match
                      );
                      if (matchingCategory.id != 'never_found_dummy_id') {
                         _selectedCategoryId = matchingCategory.id;
                      }
                    } else if (_selectedCategoryId == null && widget.selectedCategoryId != null) {
                      // Pre-selection based on widget.selectedCategoryId (int)
                       final initialAppCatId = widget.selectedCategoryId;
                       final matchingCategory = _displayCategories.firstWhere(
                        (cat) => cat.appCategoryId == initialAppCatId,
                        orElse: () => _displayCategories.firstWhere((cat) => cat.id == 'never_found_dummy_id'),
                      );
                      if (matchingCategory.id != 'never_found_dummy_id') {
                         _selectedCategoryId = matchingCategory.id;
                      }
                    }
                  });
                }
              });

              return DropdownButtonFormField<String>(
                value: _selectedCategoryId, // This is String? (EntityCategoryModel.id)
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select a category (optional)'),
                isExpanded: true,
                items: _displayCategories.map((category) { // Use state variable _displayCategories
                  return DropdownMenuItem<String>(
                    value: category.id, // Value is String (EntityCategoryModel.id)
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryId = newValue; // _selectedCategoryId is String? (EntityCategoryModel.id)
                  });
                },
                // No validator needed for optional category
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error loading categories: $err'),
          ),
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
                
                int? appCategoryIdToSave;
                if (_selectedCategoryId != null && _displayCategories.isNotEmpty) {
                  final selectedModel = _displayCategories.firstWhere(
                    (cat) => cat.id == _selectedCategoryId,
                    // orElse: () => null, // Should ideally not be null if _selectedCategoryId is valid and from _displayCategories
                  );
                  // if (selectedModel != null) { // selectedModel will not be null if firstWhere doesn't have orElse and finds a match
                    appCategoryIdToSave = selectedModel.appCategoryId;
                  // }
                }
                widget.onSave(_customFieldsData, appCategoryIdToSave, _nameController.text, _descriptionController.text);
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
