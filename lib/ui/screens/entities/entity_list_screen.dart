import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/models/entity_subcategory_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_edit_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_navigator_screen.dart';
import 'package:vuet_app/ui/widgets/entity_card.dart';
import 'package:vuet_app/config/app_categories.dart';
import 'package:vuet_app/utils/logger.dart';
import 'package:vuet_app/utils/entity_type_helper.dart' as helper_util;
import 'package:vuet_app/providers/task_providers.dart';
import 'package:vuet_app/constants/default_entities.dart';

class EntityListScreen extends ConsumerStatefulWidget {
  final int? appCategoryId;
  final String? categoryId;
  final String? subcategoryId;
  final String? categoryName;
  final String? screenTitle;
  final EntitySubtype? defaultEntityType;
  final EntitySubcategoryModel? currentSubcategory;
  final Widget Function()? emptyStateBuilder;
  final bool isDefaultEntityMode; // New parameter for default entity selection mode

  const EntityListScreen({
    super.key,
    this.appCategoryId,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
    this.screenTitle,
    this.defaultEntityType,
    this.currentSubcategory,
    this.emptyStateBuilder,
    this.isDefaultEntityMode = false, // Default to false for backward compatibility
  });

  @override
  ConsumerState<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends ConsumerState<EntityListScreen> {
  late Future<List<BaseEntityModel>> _entitiesFuture;
  String? _quickNavValue;
  String? _iWantToValue;
  List<BaseEntityModel> _currentEntities = [];

  final List<String> iWantToItems = [
    'Be reminded of due dates for MOT, Service, Warranty, Insurance, Lease Expiration',
    'Schedule a monthly wash',
    'Schedule a repair',
    'Be reminded to decide if trading',
    'Keep up with driving license numbers, contact information, warranty, insurance logins',
    'Be reminded when driving license(s) will expire',
    'Remember to buy train tickets for commute'
  ];
  final List<String> quickNavItems = ['Quick Nav Option 1', 'Quick Nav Option 2']; // Placeholder

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  void _loadEntities() {
    Future<List<BaseEntityModel>> fetchAll() async {
      List<BaseEntityModel> combinedEntities = [];
      if (widget.currentSubcategory != null && widget.currentSubcategory!.entityTypeIds.isNotEmpty) {
        final List<EntitySubtype> subtypesToFetch = widget.currentSubcategory!.entityTypeIds
            .map((typeString) => _mapEntityTypeStringToEnum(typeString))
            .where((subtype) => subtype != null)
            .cast<EntitySubtype>()
            .toList();

        if (subtypesToFetch.isNotEmpty) {
          for (EntitySubtype subtype in subtypesToFetch) {
            // We need to get the appCategoryId for this individual subtype
            // Assuming EntityTypeHelper.categoryMapping exists for this
            final int? appCatId = helper_util.EntityTypeHelper.categoryMapping[subtype];
            if (appCatId != null) {
              try {
                final List<BaseEntityModel> entitiesForSubtype = await ref.read(entityServiceProvider).listEntities(
                    appCategoryId: appCatId,
                    // If listEntities also takes subcategoryId, and it's relevant for individual types within a group, pass it.
                    // subcategoryId: widget.currentSubcategory!.id, // This might be too broad, or just right.
                                                                    // For now, primarily filtering by appCatId derived from each subtype.
                  );
                combinedEntities.addAll(entitiesForSubtype);
              } catch (e) {
                // print('Error fetching entities for subtype $subtype with appCatId $appCatId: $e');
                // Optionally rethrow or handle error for partial data loading
              }
            }
          }
          // Remove duplicates if any entity somehow matched multiple subtypes in the list
          if (combinedEntities.isNotEmpty) {
            final seenIds = <String>{};
            combinedEntities.retainWhere((entity) => seenIds.add(entity.id!));
          }
          return combinedEntities;
        }
      } else if (widget.appCategoryId != null && widget.subcategoryId != null) {
        return ref.read(entityServiceProvider).listEntities(
        appCategoryId: widget.appCategoryId,
        subcategoryId: widget.subcategoryId,
      );
    } else if (widget.appCategoryId != null) {
        return ref.read(entityServiceProvider).listEntities(
        appCategoryId: widget.appCategoryId,
      );
      }
      return ref.read(entityServiceProvider).getAllUserEntities();
    }

    _entitiesFuture = fetchAll();

    _entitiesFuture.then((entities) {
      if (mounted) {
        setState(() {
          _currentEntities = entities;
        });
      }
    }).catchError((_) {
      if (mounted) {
        setState(() {}); // Also refresh on error to show error state
      }
    });
  }

  // Helper method to map entity type string to EntitySubtype enum
  EntitySubtype? _mapEntityTypeStringToEnum(String typeString) {
    // This mapping needs to be comprehensive for all typeStrings used in entityTypeIds
    switch (typeString) {
      case 'Car': return EntitySubtype.car;
      case 'Motorcycle': return EntitySubtype.motorcycle;
      case 'Boat': return EntitySubtype.boat;
      case 'JetSki': return EntitySubtype.other;
      case 'RV': return EntitySubtype.other;
      case 'ATV': return EntitySubtype.other;
      case 'Truck': return EntitySubtype.other;
      case 'Van': return EntitySubtype.other;
      case 'Bicycle': return EntitySubtype.other;
      case 'PublicTransport': return EntitySubtype.publicTransport;
      // Add other mappings from EntitySubcategoryModel.entityTypeIds here
      case 'Pet': return EntitySubtype.pet;
      // ... include all other types used across all subcategories ...
      default:
        // Log unmapped typeString for debugging
        // print('Warning: Unmapped entityTypeString in EntityListScreen: $typeString');
        return null;
    }
  }

  void _navigateToCreateEntity() async {
    EntitySubtype? initialSubtype;
    int? effectiveAppCategoryId = widget.appCategoryId;

    // Debug logging
    log('_navigateToCreateEntity called', name: 'EntityListScreen');
    log('widget.currentSubcategory = ${widget.currentSubcategory?.id}', name: 'EntityListScreen');
    log('widget.currentSubcategory entityTypeIds = ${widget.currentSubcategory?.entityTypeIds}', name: 'EntityListScreen');
    log('widget.defaultEntityType = ${widget.defaultEntityType}', name: 'EntityListScreen');
    log('widget.appCategoryId = ${widget.appCategoryId}', name: 'EntityListScreen');

    // For transport group views, show a dialog to choose the specific subtype
    if (widget.currentSubcategory != null && widget.currentSubcategory!.categoryId == 'transport' && widget.currentSubcategory!.entityTypeIds.length > 1) {
      log('Multiple entity types in transport subcategory', name: 'EntityListScreen');
      // Map string entityTypeIds from currentSubcategory to EntitySubtype enums
      final List<EntitySubtype> choices = widget.currentSubcategory!.entityTypeIds
          .map((typeStr) => _mapEntityTypeStringToEnum(typeStr))
          .where((typeEnum) => typeEnum != null)
          .cast<EntitySubtype>()
          .toList();

      log('Mapped choices = $choices', name: 'EntityListScreen');

      if (choices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No specific types available to create for this group.')),
        );
        return;
      }
      
      // Show dialog to pick a subtype
      initialSubtype = await showDialog<EntitySubtype>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Create New ${widget.currentSubcategory!.displayName}'),
            content: SingleChildScrollView(
              child: ListBody(
                children: choices.map((subtype) {
                  return ListTile(
                    title: Text(subtype.name), // Or a more user-friendly display name for the subtype
                    onTap: () {
                      Navigator.of(context).pop(subtype);
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      if (initialSubtype == null) return; // User cancelled dialog
      
      // For CreateEntityScreen, we need appCategoryId for the *chosen* specific subtype
      effectiveAppCategoryId = helper_util.EntityTypeHelper.categoryMapping[initialSubtype];

    } else if (widget.currentSubcategory != null && widget.currentSubcategory!.entityTypeIds.length == 1) {
      // Single entity type in subcategory - use it directly
      log('Single entity type in subcategory', name: 'EntityListScreen');
      final String entityTypeString = widget.currentSubcategory!.entityTypeIds[0];
      log('Entity type string = $entityTypeString', name: 'EntityListScreen');
      initialSubtype = _mapEntityTypeStringToEnum(entityTypeString);
      log('Mapped to subtype = $initialSubtype', name: 'EntityListScreen');
      
      if (initialSubtype != null) {
        effectiveAppCategoryId = helper_util.EntityTypeHelper.categoryMapping[initialSubtype];
        log('Effective app category ID = $effectiveAppCategoryId', name: 'EntityListScreen');
      }
    } else if (widget.defaultEntityType != null) {
      initialSubtype = widget.defaultEntityType;
      log('Using widget.defaultEntityType = $initialSubtype', name: 'EntityListScreen');
      // appCategoryId and subcategoryId are hopefully already correct from widget constructor
    } else if (widget.appCategoryId != null) {
      log('Fallback using appCategoryId', name: 'EntityListScreen');
      // Fallback: Try to determine a suitable entity type for this category if not a transport group
      for (final entry in helper_util.EntityTypeHelper.categoryMapping.entries) {
        if (entry.value == widget.appCategoryId) {
          initialSubtype = entry.key;
          break;
        }
      }
      initialSubtype ??= EntitySubtype.general; // Default if no specific match found
    } else {
      initialSubtype = EntitySubtype.general; // Absolute fallback
      log('Using absolute fallback EntitySubtype.general', name: 'EntityListScreen');
    }

    log('Final initialSubtype = $initialSubtype', name: 'EntityListScreen');
    log('Final effectiveAppCategoryId = $effectiveAppCategoryId', name: 'EntityListScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditEntityScreen(
          appCategoryId: effectiveAppCategoryId ?? widget.appCategoryId ?? 1, // Use determined appCategoryId or fallback
          initialSubtype: initialSubtype!,
        ),
      ),
    ).then((entity) {
      if (mounted && entity != null) {
        setState(() {
          _loadEntities();
        });
      }
    });
  }

  Future<void> _promptToSelectEntityForTask(String taskTitle) async {
    if (_currentEntities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add an entity first to link this action.')),
      );
      // Reset dropdown if no entities
      setState(() {
        _iWantToValue = null;
      });
      return;
    }

    if (_currentEntities.length == 1) {
      // If only one entity, use it directly
      _createTaskForEntity(taskTitle, _currentEntities.first);
      return;
    }

    // If multiple entities, show a selection dialog
    final BaseEntityModel? selectedEntity = await showDialog<BaseEntityModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Link "${taskTitle.truncate(30)}" to which entity?'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _currentEntities.length,
              itemBuilder: (BuildContext context, int index) {
                final entity = _currentEntities[index];
                return ListTile(
                  title: Text(entity.name),
                  onTap: () {
                    Navigator.of(context).pop(entity);
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (selectedEntity != null) {
      _createTaskForEntity(taskTitle, selectedEntity);
    } else {
      // User cancelled dialog, reset dropdown
      setState(() {
        _iWantToValue = null;
      });
    }
  }

  Future<void> _createTaskForEntity(String taskTitle, BaseEntityModel entity) async {
    final taskService = ref.read(taskServiceProvider);
    try {
      final taskId = await taskService.createTask(
        title: taskTitle,
        entityId: entity.id,
        // Add other relevant default parameters if needed, e.g., priority
        priority: 'medium', 
      );
      if (taskId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${taskTitle.truncate(30)}" created for ${entity.name.truncate(20)}.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create task. Please try again.')),
        );
      }
    } catch (e) {
      log('Error creating task from EntityListScreen: $e', name: "EntityListScreen", error: e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while creating the task: ${e.toString()}')),
      );
    } finally {
      // Reset dropdown value whether task creation succeeded or failed
      setState(() {
        _iWantToValue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if this is a transport-specific view that needs dropdowns
    final bool isTransportGroupView = widget.currentSubcategory?.categoryId == 'transport';
    final String appBarTitle = widget.screenTitle ?? widget.categoryName ?? 'Entities';

    // If in default entity mode, show default entity selection UI
    if (widget.isDefaultEntityMode) {
      final List<String> entities = defaultGlobalEntities[widget.categoryName?.toUpperCase()] ?? [];
      
      return Scaffold(
        appBar: AppBar(
          title: Text('Select ${widget.categoryName} Entity'),
        ),
        body: entities.isEmpty
            ? Center(
                child: Text(
                  'No default entities defined for "${widget.categoryName}".',
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  final entityName = entities[index];
                  return ListTile(
                    title: Text(entityName),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to the entity creation form with pre-filled category ID and entity name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEditEntityScreen(
                            appCategoryId: widget.appCategoryId ?? 1,
                            initialSubtype: widget.defaultEntityType ?? EntitySubtype.general,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        // Potentially style AppBar differently for transport views if needed
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadEntities();
          });
          await _entitiesFuture;
        },
        child: Column(
          children: [
            if (isTransportGroupView)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Quick Nav Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Quick Nav'),
                          value: _quickNavValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: quickNavItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _quickNavValue = newValue;
                            });
                            // Handle Quick Nav selection
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // I Want To Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('I Want To'),
                          value: _iWantToValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: iWantToItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              log("Selected 'I Want To' on EntityListScreen: $newValue", name: "EntityListScreen");
                              // Handle I Want To selection
                              setState(() {
                                _iWantToValue = newValue;
                              });
                              _promptToSelectEntityForTask(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
        child: FutureBuilder<List<BaseEntityModel>>(
          future: _entitiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                            'Error loading entities:  ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadEntities();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final entities = snapshot.data ?? [];
            if (entities.isEmpty) {
              if (widget.emptyStateBuilder != null) {
                return widget.emptyStateBuilder!();
              }
                    // Custom empty state for transport groups
                    if (isTransportGroupView && widget.currentSubcategory != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.directions_car_filled_outlined, size: 64, color: Colors.grey), // Example icon
                              const SizedBox(height: 16),
                              Text(
                                'You don\'t currently have any ${widget.currentSubcategory!.displayName}.',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Click the + button below to add some',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                               ElevatedButton.icon(
                                onPressed: _navigateToCreateEntity, // This will need context for the group
                                icon: const Icon(Icons.add),
                                label: Text('Add ${widget.currentSubcategory!.displayName}'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                            'No ${appBarTitle.toLowerCase()} found',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _navigateToCreateEntity,
                      icon: const Icon(Icons.add),
                      label: Text('Create ${widget.categoryName ?? 'Entity'}'),
                    ),
                  ],
                ),
              );
            }

                  // Group entities by appCategoryId (original grouping logic)
                  // For transport groups, entities are already fetched as a combined list,
                  // so this specific grouping might not be what we want for the flat list display.
                  // If widget.currentSubcategory is present, we probably want a flat list.
                  
                  if (isTransportGroupView) {
                    // Display as a flat list for transport groups
                    return ListView.builder(
                      itemCount: entities.length,
                      itemBuilder: (context, index) {
                        final entity = entities[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: EntityCard(
                            entity: entity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntityNavigatorScreen(entityId: entity.id!),
                                ),
                              ).then((_) {
                                setState(() {
                                  _loadEntities();
                                });
                              });
                            },
                            // onEdit can be added here if needed
                          ),
                        );
                      },
                    );
                  } else {
                    // Original grouping logic for other categories
            final Map<int, List<BaseEntityModel>> grouped = {};
            for (final entity in entities) {
              final catId = entity.appCategoryId;
              if (catId != null) {
                grouped.putIfAbsent(catId, () => []).add(entity);
              }
            }
            return ListView(
              children: [
                        for (final categoryFromAppConfig in appCategories) // Use appCategories from config
                          if (grouped[categoryFromAppConfig.id]?.isNotEmpty ?? false) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text(
                                categoryFromAppConfig.readableName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                                itemCount: grouped[categoryFromAppConfig.id]!.length,
                        itemBuilder: (context, index) {
                                  final entity = grouped[categoryFromAppConfig.id]![index];
                          return EntityCard(
                            entity: entity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntityNavigatorScreen(entityId: entity.id!),
                                ),
                              ).then((_) {
                                setState(() {
                                  _loadEntities();
                                });
                              });
                            },
                                    // onEdit can be added here from the original implementation if needed
                          );
                        },
                      ),
                    ),
                  ],
              ],
            );
                  }
          },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEntity, // This needs to be smarter for grouped transport views
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Helper extension for truncating strings (optional, can be placed in a utils file)
extension StringTruncate on String {
  String truncate(int maxLength) {
    return (length <= maxLength) ? this : '${substring(0, maxLength)}...';
  }
}
