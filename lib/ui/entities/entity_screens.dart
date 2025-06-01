// Placeholder file for entity screens

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for ConsumerStatefulWidget
import 'package:vuet_app/services/auth_service.dart'; // Added for authServiceProvider
import '../../providers/entity_providers.dart'; // Added for entityRepositoryProvider
import '../../models/entity_model.dart'; // Imports BaseEntityModel, EntitySubtype
// Import subtype models
// Import reference group model
// Import DateTime extensions
import 'entity_components.dart'; // Import UI components
import 'entity_tagging_widget.dart'; // Import EntityTaggingWidget

// Screen for displaying entity details
class EntityDetailScreen extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  final String entityId;

  const EntityDetailScreen({super.key, required this.entityId});

  @override
  EntityDetailScreenState createState() => EntityDetailScreenState();
}

class EntityDetailScreenState extends ConsumerState<EntityDetailScreen> {
  // Changed to ConsumerState
  BaseEntityModel? _entity;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEntityDetails();
  }

  Future<void> _fetchEntityDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // Use ref.read here to access the service
      final entity = await ref.read(entityServiceProvider).getEntityById(widget.entityId);
      setState(() {
        _entity = entity;
      });
    } catch (e) {
      // TODO: Handle error
      // print('Error fetching entity details: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_entity?.name ?? 'Entity Details'),
        actions: [
          if (_entity != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // TODO: Navigate to edit entity screen
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _entity != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use the dynamic display widget
                        getEntityDisplayWidget(_entity!),
                        SizedBox(height: 16),
                        // TODO: Add EntityTaggingWidget here
                        // EntityTaggingWidget(entity: _entity!, onTagsChanged: (tags) {
                        //   // TODO: Handle tags changed (e.g., update entity in repository)
                        // }),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text('Entity not found')), // Handle entity not found
    );
  }
}

// Screen for creating or editing entities
class EntityFormScreen extends ConsumerStatefulWidget {
  // Changed to ConsumerStatefulWidget
  final BaseEntityModel? entity; // Null for create, provided for edit

  const EntityFormScreen({super.key, this.entity});

  @override
  EntityFormScreenState createState() => EntityFormScreenState();
}

class EntityFormScreenState extends ConsumerState<EntityFormScreen> {
  // Changed to ConsumerState
  late Map<String, dynamic> _formValues;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize form values from existing entity or with defaults
    _formValues = _initializeFormValues(widget.entity);
    // _selectedTags = widget.entity?.references ?? []; // TODO: References not on BaseEntityModel, load separately
    if (widget.entity != null) {
      // TODO: Fetch tags for the entity if editing, e.g., using entityRepository.fetchTagsForEntity(widget.entity!.id)
    }
  }

  Map<String, dynamic> _initializeFormValues(BaseEntityModel? entity) {
    if (entity == null) {
      // Defaults for new entity
      return {
        'name': '',
        'notes': '', // New common field
        'imageUrl': '', // New common field
        'isFavourite':
            false, // New common field (will go into additionalProperties or specificData)
        'isArchived':
            false, // New common field (will go into additionalProperties or specificData)
        'entitySubtype':
            EntitySubtype.car.name, // Default to 'car', or make it selectable
        'mainCategoryId':
            null, // Default category ID as string - should be UUID or null
        'parentId': null,
        // Subtype specific defaults are handled by individual forms if needed,
        // or can be added here based on initial 'entitySubtype'.
      };
    } else {
      // Initialize from existing entity
      // Subtype specific fields are initialized by the specific forms (e.g. PetForm)
      // This map will be further populated by those forms.
      return {
        'id': entity.id,
        'mainCategoryId': entity.appCategoryId, // Changed to appCategoryId (int?)
        'entitySubtype': entity.subtype.name, // Use subtype
        'name': entity.name,
        'notes': entity.description ?? '',
        'imageUrl': entity.imageUrl ?? '',
        // 'isFavourite' and 'isArchived' are not direct fields on BaseEntityModel.
        // They would be in entity.customFields or loaded from specificData if applicable.
        // For now, let form handle them if they are part of dynamic form fields.
        'isFavourite': (entity.customFields?['isFavourite'] as bool?) ?? false,
        'isArchived': (entity.customFields?['isArchived'] as bool?) ?? false,
        'parentId': entity.parentId, // Use parentId
        // Subtype-specific fields will be added by the respective forms based on widget.initialValues
        // and should be merged into _formValues if editing.
        // This part needs to be handled by getEntityFormWidget or here if specific data is fetched.
        // For now, assuming specific data is part of entity.customFields or fetched separately.
        ...(entity.customFields ?? {}), // Spread custom fields
      };
    }
  }

  void _onFormValuesChange(Map<String, dynamic> newValues) {
    setState(() {
      _formValues = newValues;
    });
  }

  Future<void> _saveEntity() async {
    setState(() {
      _isLoading = true;
    });

    final authService = ref.read(authServiceProvider);
    if (!authService.isSignedIn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
      }
      setState(() => _isLoading = false);
      return;
    }
    final String userId = authService.currentUser!.id;

    try {
      // Construct BaseEntityModel from form values and selected tags
      // This part needs significant rework to match BaseEntityModel fields
      // For now, commenting out the direct instantiation and focusing on type rename.
      // final entityToSave = BaseEntityModel(
      //   id: _formValues['id'] as String? ?? '', // BaseEntityModel ID is int
      //   userId: _formValues['userId'] as String? ?? 'replace_with_actual_user_id', // Not in BaseEntityModel
      //   mainCategoryId: _formValues['mainCategoryId'] as String? ?? 'replace_with_default_category_id', // category in BaseEntityModel
      //   entitySubtype: _formValues['entitySubtype'] as String, // resourcetype in BaseEntityModel (EntityTypeName)
      //   name: _formValues['name'] as String,
      //   description: _formValues['description'] as String?, // Not in BaseEntityModel
      //   imageUrl: _formValues['imageUrl'] as String?, // Not in BaseEntityModel
      //   parentId: _formValues['parentId'] as String?, // parent in BaseEntityModel
      //   // TODO: Include subtype-specific details from _formValues
      //   // Example: subtypeDetails: PetEntityDetails(breed: _formValues['breed']), // additionalProperties
      //   references: _selectedTags, // Not in BaseEntityModel
      //   createdAt: widget.entity?.createdAt ?? DateTime.now(),
      //   updatedAt: DateTime.now(), // Not in BaseEntityModel
      // );

      // Add subtype-specific fields from _formValues to entityJson directly
      // These are expected by the fromJson constructors of subtype models.
      EntitySubtype subtypeEnum = EntitySubtype.car; // Default
      String subtypeString =
          _formValues['entitySubtype'] as String? ?? EntitySubtype.car.name;
      try {
        subtypeEnum = EntitySubtype.values.byName(subtypeString);
      } catch (_) {
        // print("Error parsing entitySubtype string in _saveEntity: $subtypeString. Defaulting to car.");
        subtypeString = EntitySubtype.car.name; // Ensure json has valid string
      }

      Map<String, dynamic> specificData = {};
      // Store additional properties in specificData for now
      specificData.addAll({
        'isFavourite': _formValues['isFavourite'] as bool? ?? false,
        'isArchived': _formValues['isArchived'] as bool? ?? false,
      });

      // Manually construct specificData map
      switch (subtypeEnum) {
        case EntitySubtype.car:
          specificData = {
            'make': _formValues['make'] as String? ?? '',
            'model': _formValues['model'] as String? ?? '',
            'registration': _formValues['registration'] as String? ?? '',
            'mot_due_date': _formValues['motDueDate']
                ?.toString(), // Store as ISO string or handle conversion in repo
            'insurance_due_date': _formValues['insuranceDueDate']?.toString(),
            'service_due_date': _formValues['serviceDueDate']?.toString(),
          };
          break;
        case EntitySubtype.appliance:
          specificData = {
            'appliance_type': _formValues['applianceType'] as String?,
            'brand': _formValues['brand'] as String?,
            'model_number': _formValues['modelNumber'] as String?,
            'purchase_date': _formValues['purchaseDate']?.toString(),
            'warranty_expiry_date':
                _formValues['warrantyExpiryDate']?.toString(),
            'serial_number': _formValues['serialNumber'] as String?,
            'manual_url':
                _formValues['manualUrl'] as String?, // Added from model
          };
          break;
        case EntitySubtype.pet:
          specificData = {
            'pet_type': _formValues['petType'] as String? ?? '',
            'breed': _formValues['breed'] as String?,
            'date_of_birth': _formValues['dateOfBirth']?.toString(),
            'vet_name': _formValues['vetName'] as String?,
            'vet_phone_number': _formValues['vetPhoneNumber'] as String?,
            'microchip_id': _formValues['microchipId'] as String?,
            'insurance_policy_number':
                _formValues['insurancePolicyNumber'] as String?,
            'notes': _formValues['petNotes']
                as String?, // Assuming a form field like 'petNotes' for pet-specific notes
          };
          break;
        case EntitySubtype.holiday:
          specificData = {
            'destination': _formValues['destination'] as String? ?? '',
            'start_date': (_formValues['startDate'] != null
                    ? DateTime.tryParse(_formValues['startDate']!.toString()) ??
                        DateTime.now()
                    : DateTime.now())
                .toIso8601String(),
            'end_date': (_formValues['endDate'] != null
                    ? DateTime.tryParse(_formValues['endDate']!.toString()) ??
                        DateTime.now().add(const Duration(days: 7))
                    : DateTime.now().add(const Duration(days: 7)))
                .toIso8601String(),
            'holiday_type': _formValues['holidayType'] as String?,
            'transportation_details':
                _formValues['transportationDetails'] as String?,
            'accommodation_details':
                _formValues['accommodationDetails'] as String?,
            'budget': double.tryParse(_formValues['budget']?.toString() ?? ''),
            'string_id': _formValues['stringId'] as String?, // Added from model
            'country_code':
                _formValues['countryCode'] as String?, // Added from model
          };
          break;
        // Add cases for other EntitySubtype values as needed
        // case EntitySubtype.event:
        // case EntitySubtype.person:
        // case EntitySubtype.document:
        // case EntitySubtype.task:
        // case EntitySubtype.note:
        // case EntitySubtype.other:
        default:
          // print("Cannot extract specific data: Unhandled type $subtypeEnum");
          // additionalPropertiesForBase will still be used.
          break;
      }

      // Remove null values from specificData to avoid sending them to Supabase if columns don't allow nulls
      specificData.removeWhere((key, value) => value == null);

      final baseEntityToSave = BaseEntityModel(
        id: widget.entity?.id, // Null for create, has value for update
        userId: userId,
        name: _formValues['name'] as String? ?? '',
        description:
            _formValues['notes'] as String?, // Using notes as description
        imageUrl: _formValues['imageUrl'] as String?,
        appCategoryId: _formValues['mainCategoryId'] 
            as int?, // Changed to appCategoryId (int?)
        subtype: subtypeEnum,
        parentId: _formValues['parentId'] as String?,
        isHidden: _formValues['hidden'] as bool? ?? false,
        createdAt: widget.entity?.createdAt ??
            DateTime.now(), // Repo handles for new, preserved for update
        updatedAt: DateTime.now(), // Repo might override this for update
        customFields: specificData, // Store specificData in customFields
        // childEntityIds and memberIds are not handled by this form directly yet
      );

      // TODO: Handle saving _selectedTags separately using repository methods for entity-tag relationships
      final entityService = ref.read(entityServiceProvider); // Use ref.read here
      if (widget.entity == null) {
        // Create new entity
        await entityService.createEntity(baseEntityToSave);
      } else {
        // Update existing entity
        await entityService.updateEntity(baseEntityToSave);
      }

      // TODO: Show success message
      if (mounted) {
        Navigator.of(context).pop(); // Go back after saving
      }
    } catch (e) {
      // TODO: Handle error
      // print('Error saving entity: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  BaseEntityModel _createPlaceholderEntity(String? subtypeNameString,
      {required String userId}) {
    EntitySubtype subtype = EntitySubtype.car; // Default
    if (subtypeNameString != null) {
      try {
        subtype = EntitySubtype.values.byName(subtypeNameString);
      } catch (_) {
        // Keep default type if parsing fails
      }
    }

    return BaseEntityModel(
        // id is nullable, so null for a new placeholder is fine
        userId: userId,
        name: _formValues['name'] as String? ?? 'New Entity',
        description:
            _formValues['notes'] as String?, // Using notes as description
        imageUrl: _formValues['imageUrl'] as String?,
        appCategoryId:
            _formValues['mainCategoryId'] as int?, // Changed to appCategoryId (int?)
        subtype: subtype,
        parentId: _formValues['parentId'] as String?,
        isHidden: _formValues['hidden'] as bool? ?? false,
        createdAt: DateTime.now(), // Placeholder, won't be saved as is
        updatedAt: DateTime.now(), // Placeholder
        customFields: {
          // Storing specificData in customFields
          'isFavourite': _formValues['isFavourite'] as bool? ?? false,
          'isArchived': _formValues['isArchived'] as bool? ?? false,
        }
        // childEntityIds and memberIds are not part of this placeholder
        );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entity != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entity' : 'Create Entity'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Use the dynamic form widget
                    getEntityFormWidget(
                      widget.entity,
                      onFormValuesChange: _onFormValuesChange,
                      initialValues: _formValues,
                    ),
                    SizedBox(height: 16),
                    // Tagging widget
                    EntityTaggingWidget(
                      entity: widget.entity ??
                          _createPlaceholderEntity(
                            _formValues['entitySubtype'] as String?,
                            userId: ref
                                .watch(authServiceProvider)
                                .currentUser!
                                .id, // Provide userId
                          ),
                      onTagsChanged: (tags) {}, // Provide empty callback
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveEntity,
                      child: Text(isEditing ? 'Update' : 'Create'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
