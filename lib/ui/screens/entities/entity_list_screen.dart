import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/entity_upsert_screen.dart';
import 'package:vuet_app/ui/screens/entities/entity_detail_screen.dart'; // Import the detail screen
import 'package:vuet_app/utils/logger.dart';

class EntityListScreen extends ConsumerWidget {
  final int appCategoryId; // Changed from String categoryId to int appCategoryId
  final String categoryName; // To display in AppBar
  final EntitySubtype defaultSubtypeForNew; // Default subtype when pressing FAB

  const EntityListScreen({
    super.key,
    required this.appCategoryId, // Changed from categoryId
    required this.categoryName,
    required this.defaultSubtypeForNew,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use appCategoryId (int) for the provider
    final entitiesStream = ref.watch(entityByCategoryStreamProvider(appCategoryId)); 

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: entitiesStream.when(
        data: (entities) {
          if (entities.isEmpty) {
            return Center(
              child: Text(
                'No entities found in $categoryName.\nTap the + button to add one!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              final entity = entities[index];
              return ListTile(
                title: Text(entity.name),
                subtitle: Text(entity.description ?? 'No description'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EntityUpsertScreen(
                              entity: entity,
                              entitySubtype: entity.subtype, // Use entity's actual subtype for editing
                              // Pass appCategoryId to EntityUpsertScreen
                              appCategoryId: appCategoryId, 
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Entity?'),
                            content: Text('Are you sure you want to delete "${entity.name}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && entity.id != null) {
                          try {
                            await ref.read(entityActionsProvider.notifier).deleteEntity(entity.id!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${entity.name} deleted.')),
                            );
                          } catch (e,s) {
                            log('Error deleting entity: $e', name: 'EntityListScreen', error: e, stackTrace: s);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error deleting ${entity.name}: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to entity detail screen
                   Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EntityDetailScreen(
                        entityId: entity.id!,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          log('Error loading entities: $error', name: 'EntityListScreen', error: error, stackTrace: stack);
          return Center(child: Text('Error loading entities: $error'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EntityUpsertScreen(
                entitySubtype: defaultSubtypeForNew,
                appCategoryId: appCategoryId, // Pass appCategoryId
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
