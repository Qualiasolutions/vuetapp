import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_detail_screen.dart';
import 'package:vuet_app/ui/widgets/entity_card.dart';

class EntityListScreen extends ConsumerStatefulWidget {
  final int? appCategoryId;
  final String? categoryId;
  final String? subcategoryId;
  final String? categoryName;
  final EntitySubtype? defaultEntityType;
  final Widget Function()? emptyStateBuilder;

  const EntityListScreen({
    Key? key,
    this.appCategoryId,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
    this.defaultEntityType,
    this.emptyStateBuilder,
  }) : super(key: key);

  @override
  ConsumerState<EntityListScreen> createState() => _EntityListScreenState();
}

class _EntityListScreenState extends ConsumerState<EntityListScreen> {
  late Future<List<BaseEntityModel>> _entitiesFuture;

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  void _loadEntities() {
    if (widget.appCategoryId != null && widget.subcategoryId != null) {
      _entitiesFuture = ref.read(entityServiceProvider).listEntities(
        appCategoryId: widget.appCategoryId,
        subcategoryId: widget.subcategoryId,
      );
    } else if (widget.appCategoryId != null) {
      _entitiesFuture = ref.read(entityServiceProvider).listEntities(
        appCategoryId: widget.appCategoryId,
      );
    } else {
      // Default to loading all entities if no filters provided
      _entitiesFuture = ref.read(entityServiceProvider).getAllUserEntities();
    }
  }

  void _navigateToCreateEntity() {
    EntitySubtype initialSubtype = widget.defaultEntityType ?? EntitySubtype.pet;
    
    // If there's a category ID, try to determine the best entity type for it
    if (widget.appCategoryId != null) {
      // Find a suitable entity type for this category
      for (final entry in EntityTypeHelper.categoryMapping.entries) {
        if (entry.value == widget.appCategoryId) {
          initialSubtype = entry.key;
          break;
        }
      }
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEntityScreen(
          initialSubtype: initialSubtype,
          initialCategoryId: widget.categoryId,
          initialSubcategoryId: widget.subcategoryId,
          appCategoryId: widget.appCategoryId,
        ),
      ),
    ).then((_) {
      // Refresh the entity list when returning from create screen
      setState(() {
        _loadEntities();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadEntities();
          });
          // Don't return the future directly, just wait for it to complete
          await _entitiesFuture;
        },
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
                      'Error loading entities: ${snapshot.error}',
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
              // Use the custom empty state builder if provided
              if (widget.emptyStateBuilder != null) {
                return widget.emptyStateBuilder!();
              }
              
              // Default empty state
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No ${widget.categoryName?.toLowerCase() ?? 'entities'} found',
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
            
            // Show the list of entities
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  final entity = entities[index];
                  return EntityCard(
                    entity: entity,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntityDetailScreen(entityId: entity.id!),
                        ),
                      ).then((_) {
                        // Refresh when returning from details
                        setState(() {
                          _loadEntities();
                        });
                      });
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateEntityScreen(
                            entityId: entity.id,
                            initialSubtype: entity.subtype,
                            initialCategoryId: widget.categoryId,
                            initialSubcategoryId: widget.subcategoryId,
                            appCategoryId: widget.appCategoryId,
                          ),
                        ),
                      ).then((_) {
                        // Refresh when returning from edit
                        setState(() {
                          _loadEntities();
                        });
                      });
                    },
                    onDelete: () {
                      _showDeleteConfirmation(context, entity);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEntity,
        child: const Icon(Icons.add),
        tooltip: 'Add ${widget.categoryName ?? 'Entity'}',
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, BaseEntityModel entity) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete ${entity.name}?'),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref.read(entityServiceProvider).deleteEntity(entity.id!);
                  // Refresh the list
                  setState(() {
                    _loadEntities();
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${entity.name} has been deleted')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting entity: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
