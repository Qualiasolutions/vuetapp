import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/form_field_definition.dart';
import 'package:vuet_app/config/entity_form_fields.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/providers/category_providers.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';

class CreateEntityScreen extends ConsumerStatefulWidget {
  final EntitySubtype? initialSubtype;
  final String? initialCategoryId;
  final String? initialSubcategoryId;
  final int? appCategoryId;
  final EntitySubcategoryModel? subcategory;
  final String? entityId; // For editing existing entities

  const CreateEntityScreen({
    super.key,
    this.initialSubtype,
    this.initialCategoryId,
    this.initialSubcategoryId,
    this.appCategoryId,
    this.subcategory,
    this.entityId,
  });

  @override
  ConsumerState<CreateEntityScreen> createState() => _CreateEntityScreenState();
}

class _CreateEntityScreenState extends ConsumerState<CreateEntityScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _dropdownSelectedValues = {};
  final Map<String, bool> _booleanValues = {};

  EntitySubtype? _selectedSubtype;
  EntityCategoryModel? _selectedParentCategory;
  EntityCategoryModel? _selectedSubEntityCategory;

  List<EntityCategoryModel> _allCategories = [];
  List<EntityCategoryModel> _subcategoriesForSelectedParent = [];

  @override
  void initState() {
    super.initState();
    _controllers['name'] = TextEditingController();

    if (widget.initialSubtype != null) {
      _selectedSubtype = widget.initialSubtype;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _tryFindCategoryForSubtype(_selectedSubtype!);
        if (mounted) _initializeFormFieldsBasedOnSubtype();
      });
    } else if (widget.initialCategoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final categoriesAsync = ref.read(categoriesProvider);
        categoriesAsync.when(
          data: (allCats) {
            if (!mounted) return;
            _allCategories = allCats;
            if (_allCategories.isNotEmpty) {
              final foundCategory = _allCategories.where(
                  (cat) => cat.id == widget.initialCategoryId && cat.parentId == null).firstOrNull;
              _selectedParentCategory = foundCategory;

              if (_selectedParentCategory != null) {
                _updateSubcategoriesForParent();
                if (widget.initialSubcategoryId != null) {
                  final foundSubCategory = _subcategoriesForSelectedParent.where(
                      (sub) => sub.id == widget.initialSubcategoryId).firstOrNull;
                  _selectedSubEntityCategory = foundSubCategory;
                }
              }
              _determineSubtypeFromSelection();
              _initializeFormFieldsBasedOnSubtype();
            }
          },
          loading: () => log("Loading categories in initState for initial ID selection", name: "CreateEntityScreen"),
          error: (err, st) => log("Error loading categories in initState: $err", error: err, stackTrace: st, name: "CreateEntityScreen")
        );
      });
    } else {
       WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
         final categoriesAsync = ref.read(categoriesProvider);
         categoriesAsync.when(
           data: (allCats) {
            if (!mounted) return;
            _allCategories = allCats;
            if (_selectedSubtype == null) { // Only init if subtype isn't already set (e.g. by initialSubtype)
                _initializeFormFieldsBasedOnSubtype();
            }
           },
           loading: () => log("Loading categories in initState (no initial selection)", name: "CreateEntityScreen"),
           error: (err, st) => log("Error loading categories in initState: $err", error: err, stackTrace: st, name: "CreateEntityScreen")
         );
       });
    }
  }

  void _tryFindCategoryForSubtype(EntitySubtype subtype) {
    final categoriesAsync = ref.read(categoriesProvider);
    categoriesAsync.when(
      data: (allCats) {
        if(!mounted) return;
        _allCategories = allCats;
        if (_allCategories.isEmpty) return;

        for (var parentCat in _allCategories.where((c) => c.parentId == null)) {
          // Get subcategories of the parent category
          _allCategories.where((sub) => sub.parentId == parentCat.id).toList();

          // The problematic block using categorySubcategories and SubCategoryItem starts here
          // This logic needs to be re-evaluated or removed as categorySubcategories is undefined
          // For now, I will comment it out to proceed with other fixes.
          /*
          final List<EntitySubcategoryModel>? subCategoryItemsMap = categorySubcategories[parentCat.name.toUpperCase()];
          if (subCategoryItemsMap != null) {
            for (var subItemMapped in subCategoryItemsMap) {
              if (subItemMapped.entityTypeIds.contains(subtype.name)) { // Assuming entityTypeIds are strings like subtype.name
                final matchingSubEntityCategory = currentSubcategories.where(
                    (ecm) => ecm.name == subItemMapped.displayName).firstOrNull;

                setState(() {
                  _selectedParentCategory = parentCat;
                  _updateSubcategoriesForParent();
                  _selectedSubEntityCategory = matchingSubEntityCategory;
                });
                return;
              }
            }
          }

          if (subCategoryItemsMap != null) {
             final parentAsSubItem = subCategoryItemsMap.where(
                (item) => item.name.toLowerCase() == parentCat.name.toLowerCase().replaceAll(' ', '') && item.entityTypeIds.contains(subtype.name)).firstOrNull;
             if (parentAsSubItem != null) {
              setState(() {
                  _selectedParentCategory = parentCat;
                  _updateSubcategoriesForParent();
                  _selectedSubEntityCategory = null;
              });
              return;
             }
          }
          */

          if (parentCat.name.toLowerCase().replaceAll(' ', '_') == subtype.toString().split('.').last.toLowerCase()){
             setState(() {
                _selectedParentCategory = parentCat;
                _updateSubcategoriesForParent();
                _selectedSubEntityCategory = null;
            });
            return;
          }
        }
      },
      loading: () => log("Loading categories in _tryFindCategoryForSubtype", name: "CreateEntityScreen"),
      error: (err, st) => log("Error loading categories in _tryFindCategoryForSubtype: $err", error: err, stackTrace: st, name: "CreateEntityScreen")
    );
  }

  void _updateSubcategoriesForParent() {
    if (_selectedParentCategory != null) {
      _subcategoriesForSelectedParent = _allCategories
          .where((cat) => cat.parentId == _selectedParentCategory!.id)
          .toList();
    } else {
      _subcategoriesForSelectedParent = [];
    }
    if (_selectedSubEntityCategory != null &&
        !_subcategoriesForSelectedParent.contains(_selectedSubEntityCategory)) {
      _selectedSubEntityCategory = null;
    }
  }

  void _determineSubtypeFromSelection() {
    EntitySubtype? determinedSubtype;

    EntityCategoryModel? categoryForDirectNameMatch = _selectedSubEntityCategory ?? _selectedParentCategory;

    // We previously determined a category key for mapping, but it's not being used
    // since the categorySubcategories lookup code is commented out
    if (_selectedSubEntityCategory != null) {
        // Look up parent if needed, but we're not using it now
        // _allCategories.where((cat) => cat.id == _selectedSubEntityCategory!.parentId).firstOrNull;
    }

    // This block also uses categorySubcategories and SubCategoryItem
    // Commenting out for now.
    /*
    if (categoryKeyForMapLookup != null) {
        final List<EntitySubcategoryModel>? subCategoryItems = categorySubcategories[categoryKeyForMapLookup];
        if (subCategoryItems != null) {
            EntitySubcategoryModel? matchedItem;
            if (_selectedSubEntityCategory != null) {
                matchedItem = subCategoryItems.where(
                    (item) => item.displayName == _selectedSubEntityCategory!.name).firstOrNull;
            } else if (_selectedParentCategory != null) {
                 final parentNameLower = _selectedParentCategory!.name.toLowerCase().replaceAll(' ', '');
                 matchedItem = subCategoryItems.where(
                    (item) => item.name.toLowerCase() == parentNameLower && item.entityTypeIds.isNotEmpty).firstOrNull;
                 matchedItem ??= subCategoryItems.where((item) => item.entityTypeIds.isNotEmpty).firstOrNull;
            }

            if (matchedItem != null && matchedItem.entityTypeIds.isNotEmpty) {
                // Assuming EntitySubtype.values.byName or similar is needed here if entityTypeIds are strings
                // For now, this is problematic as EntitySubtype is an enum and entityTypeIds are List<String>
                // determinedSubtype = matchedItem.entityTypeIds.first;
            }
        }
    }
    */

    if (categoryForDirectNameMatch != null) {
        final subtypeString = categoryForDirectNameMatch.name.toLowerCase().replaceAll(' ', '_');
         try {
            determinedSubtype = EntitySubtype.values.firstWhere(
                (e) => e.toString().split('.').last.toLowerCase() == subtypeString);
        } catch (e) {
            // log("No direct EntitySubtype match for category name: ${categoryForDirectNameMatch.name}", name: 'CreateEntityScreen');
        }
    }

    if (determinedSubtype == null && _selectedParentCategory?.name.toLowerCase() == 'pets' && _selectedSubEntityCategory == null) {
        determinedSubtype = EntitySubtype.pet;
    }

    if (mounted) {
        setState(() {
            _selectedSubtype = determinedSubtype;
        });
    } else {
        _selectedSubtype = determinedSubtype;
    }
  }

  void _initializeFormFieldsBasedOnSubtype() {
    _clearDynamicControllers();
    
    // If no subtype is selected, just return after clearing controllers
    if (_selectedSubtype == null) {
      if (mounted) setState(() {});
      return;
    }
    
    // At this point, _selectedSubtype is guaranteed to be non-null
    final fields = entityFormFields[_selectedSubtype] ?? [];
    for (var fieldDef in fields) {
      if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
        _controllers[fieldDef.name] = TextEditingController();
      } else if (fieldDef.type == FormFieldType.dropdown) {
        _dropdownSelectedValues[fieldDef.name] = fieldDef.options != null && fieldDef.options!.isNotEmpty
            ? fieldDef.options!.first.value
            : null;
      } else if (fieldDef.type == FormFieldType.boolean) {
        _booleanValues[fieldDef.name] = false;
      }
    }
  }

  void _clearDynamicControllers() {
    _controllers.forEach((key, controller) {
      if (key != 'name') controller.dispose();
    });
    _controllers.removeWhere((key, value) => key != 'name');
    _dropdownSelectedValues.clear();
    _booleanValues.clear();
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Widget _buildDynamicFormField(FormFieldDefinition fieldDef) {
    if (FormFieldDefinition.textTypes.contains(fieldDef.type)) {
      return TextFormField(
        controller: _controllers[fieldDef.name],
        decoration: InputDecoration(
          labelText: fieldDef.label,
          hintText: fieldDef.hintText,
          border: const OutlineInputBorder(),
        ),
        keyboardType: fieldDef.keyboardType,
        maxLines: fieldDef.type == FormFieldType.multilineText ? 3 : 1,
        validator: (value) {
          if (fieldDef.isRequired && (value == null || value.isEmpty)) {
            return '${fieldDef.label} is required';
          }
          return null;
        },
      );
    } else if (fieldDef.type == FormFieldType.dropdown &&
        fieldDef.options != null) {
      return DropdownButtonFormField<dynamic>(
        value: _dropdownSelectedValues[fieldDef.name],
        decoration: InputDecoration(
            labelText: fieldDef.label, border: const OutlineInputBorder()),
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
          if (fieldDef.isRequired && value == null) {
            return '${fieldDef.label} is required';
          }
          return null;
        },
      );
    } else if (fieldDef.type == FormFieldType.boolean) {
      return SwitchListTile(
        title: Text(fieldDef.label),
        value: _booleanValues[fieldDef.name] ?? false,
        onChanged: (newValue) {
          setState(() {
            _booleanValues[fieldDef.name] = newValue;
          });
        },
      );
    }
    return const SizedBox.shrink();
  }

  void _createEntity() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        final customFields = <String, dynamic>{};
        for (var field in _controllers.entries) {
          if (field.value.text.isNotEmpty) {
            customFields[field.key] = field.value.text;
          }
        }
        for (var entry in _dropdownSelectedValues.entries) {
          customFields[entry.key] = entry.value;
        }
        for (var entry in _booleanValues.entries) {
          customFields[entry.key] = entry.value;
        }

        int? appCategoryId;
        if (_selectedParentCategory != null) {
          appCategoryId = _selectedParentCategory!.appCategoryId;
        } else if (_selectedSubtype != null) {
          appCategoryId = EntityTypeHelper.getCategoryId(_selectedSubtype!);
        }

        String? subcategoryId = _selectedSubEntityCategory?.id;

        final newEntity = BaseEntityModel(
          name: _controllers['name']!.text,
          description: '',
          userId: '',
          appCategoryId: appCategoryId,
          subtype: _selectedSubtype!,
          createdAt: DateTime.now(),
          customFields: customFields.isNotEmpty ? customFields : null,
        );

        final createdEntity = await ref.read(entityServiceProvider).createEntity(
          newEntity,
          subcategoryId: subcategoryId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${createdEntity.name} created successfully'))
          );
          Navigator.pop(context, createdEntity);
        }
      } catch (e) {
        log(e.toString(), name: 'CreateEntityScreen');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating entity: ${e.toString()}'))
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entity'),
        actions: [
          TextButton(
            onPressed: _createEntity,
            child: const Text('Save'),
          ),
        ],
      ),
      body: categoriesAsyncValue.when(
        data: (allCats) {
          if (!listEquals(_allCategories, allCats)) {
             WidgetsBinding.instance.addPostFrameCallback((_) { // Ensure setState is not called during build
                if(mounted) {
                    setState(() {
                        _allCategories = allCats;
                        // Re-evaluate selections if category list changes
                        if (_selectedParentCategory != null) {
                            _selectedParentCategory = _allCategories.where((c) => c.id == _selectedParentCategory!.id).firstOrNull;
                            if(_selectedParentCategory == null) {
                                _selectedSubEntityCategory = null;
                                _subcategoriesForSelectedParent = [];
                                _selectedSubtype = null;
                            } else {
                                _updateSubcategoriesForParent();
                                if(_selectedSubEntityCategory != null) {
                                    _selectedSubEntityCategory = _subcategoriesForSelectedParent.where((c) => c.id == _selectedSubEntityCategory!.id).firstOrNull;
                                }
                            }
                            _determineSubtypeFromSelection();
                            _initializeFormFieldsBasedOnSubtype();
                        } else if (widget.initialCategoryId != null && widget.initialSubtype == null) {
                            // Attempt to re-apply initial category if it was lost or not set
                            _selectedParentCategory = _allCategories.where(
                                (cat) => cat.id == widget.initialCategoryId && cat.parentId == null).firstOrNull;
                            if (_selectedParentCategory != null) {
                                _updateSubcategoriesForParent();
                                if(widget.initialSubcategoryId != null) {
                                    _selectedSubEntityCategory = _subcategoriesForSelectedParent.where(
                                        (sub) => sub.id == widget.initialSubcategoryId).firstOrNull;
                                }
                                _determineSubtypeFromSelection();
                                _initializeFormFieldsBasedOnSubtype();
                            }
                        }
                    });
                }
            });
          }

          final parentCategories = _allCategories.where((cat) => cat.parentId == null).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Name field
                  TextFormField(
                    controller: _controllers['name'],
                    decoration: const InputDecoration(
                      labelText: 'Name',
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

                  // Parent Category Dropdown
                  DropdownButtonFormField<EntityCategoryModel>(
                    value: _selectedParentCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: parentCategories.map((category) {
                      return DropdownMenuItem<EntityCategoryModel>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (newCategory) {
                      setState(() {
                        _selectedParentCategory = newCategory;
                        _selectedSubEntityCategory = null;
                        _updateSubcategoriesForParent();
                        _determineSubtypeFromSelection();
                        _initializeFormFieldsBasedOnSubtype();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Subcategory Dropdown (if available)
                  if (_subcategoriesForSelectedParent.isNotEmpty) ...[
                    DropdownButtonFormField<EntityCategoryModel>(
                      value: _selectedSubEntityCategory,
                      decoration: const InputDecoration(
                        labelText: 'Subcategory',
                        border: OutlineInputBorder(),
                      ),
                      items: _subcategoriesForSelectedParent.map((subcategory) {
                        return DropdownMenuItem<EntityCategoryModel>(
                          value: subcategory,
                          child: Text(subcategory.name),
                        );
                      }).toList(),
                      onChanged: (newSubcategory) {
                        setState(() {
                          _selectedSubEntityCategory = newSubcategory;
                          _determineSubtypeFromSelection();
                          _initializeFormFieldsBasedOnSubtype();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Entity Type Display
                  if (_selectedSubtype != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Entity Type: ${_selectedSubtype.toString().split('.').last}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Dynamic form fields based on entity subtype
                  if (_selectedSubtype != null) ...[
                    const Text(
                      'Entity Details:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...entityFormFields[_selectedSubtype!]?.map((fieldDef) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildDynamicFormField(fieldDef),
                    )) ?? [],
                  ],
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading categories: $error'),
        ),
      ),
    );
  }
}
