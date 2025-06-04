import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_detail_screen.dart';
import 'package:vuet_app/ui/widgets/entity_card.dart';
import 'package:vuet_app/config/app_categories.dart';

class EntityListScreen extends ConsumerStatefulWidget {
  final int? appCategoryId;
  final String? categoryId;
  final String? subcategoryId;
  final String? categoryName;
  final EntitySubtype? defaultEntityType;
  final Widget Function()? emptyStateBuilder;

  const EntityListScreen({
    super.key,
    this.appCategoryId,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
    this.defaultEntityType,
    this.emptyStateBuilder,
  });

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
                      'Error loading entities: ${snapshot.error}',
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

            // Group entities by appCategoryId
            final Map<int, List<BaseEntityModel>> grouped = {};
            for (final entity in entities) {
              final catId = entity.appCategoryId;
              if (catId != null) {
                grouped.putIfAbsent(catId, () => []).add(entity);
              }
            }

            // Build the grouped list
            return ListView(
              children: [
                for (final category in appCategories)
                  if (grouped[category.id]?.isNotEmpty ?? false) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text(
                        category.readableName,
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
                        itemCount: grouped[category.id]!.length,
                        itemBuilder: (context, index) {
                          final entity = grouped[category.id]![index];
                          return EntityCard(
                            entity: entity,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EntityDetailScreen(entityId: entity.id!),
                                ),
                              ).then((_) {
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
                                setState(() {
                                  _loadEntities();
                                });
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEntity,
        child: const Icon(Icons.add),
      ),
    );
  }
}
