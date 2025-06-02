import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/screens/entities/create_entity_screen.dart';

class EntityDetailScreen extends ConsumerWidget {
  final String entityId;

  const EntityDetailScreen({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsyncValue = ref.watch(entityByIdProvider(entityId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
              _navigateToEditEntity(context, entityAsyncValue.value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, entityAsyncValue.value, ref);
            },
          ),
        ],
      ),
      body: entityAsyncValue.when(
        data: (entity) {
          if (entity == null) {
            return const Center(
              child: Text('Entity not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entity Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entity.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type: ${_getEntityTypeDisplay(entity.subtype)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (entity.description != null && entity.description!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Description:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entity.description!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Custom Fields Section
                if (entity.customFields != null && entity.customFields!.isNotEmpty) ...[
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...entity.customFields!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      '${_formatFieldName(entry.key)}:',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _formatFieldValue(entry.value),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Metadata Section
                Text(
                  'Metadata',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildMetadataItem(
                          context, 
                          'Created', 
                          _formatDate(entity.createdAt),
                        ),
                        if (entity.updatedAt != null)
                          _buildMetadataItem(
                            context, 
                            'Updated', 
                            _formatDate(entity.updatedAt!),
                          ),
                        if (entity.dueDate != null)
                          _buildMetadataItem(
                            context, 
                            'Due Date', 
                            _formatDate(entity.dueDate!),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error loading entity: $error'),
        ),
      ),
    );
  }

  void _navigateToEditEntity(BuildContext context, BaseEntityModel? entity) {
    if (entity == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEntityScreen(
          initialSubtype: entity.subtype,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BaseEntityModel? entity, WidgetRef ref) {
    if (entity == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entity'),
        content: Text('Are you sure you want to delete "${entity.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              
              try {
                await ref.read(entityServiceProvider).deleteEntity(entity.id!);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Entity deleted successfully')),
                  );
                  Navigator.pop(context); // Go back to previous screen
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting entity: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatFieldName(String key) {
    // Convert camelCase or snake_case to Title Case
    String name = key.replaceAllMapped(
      RegExp(r'([A-Z])'), 
      (match) => ' ${match.group(0)}',
    );
    
    // Replace underscores with spaces
    name = name.replaceAll('_', ' ');
    
    // Capitalize first letter and trim
    name = name.trim();
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1);
    }
    
    return name;
  }

  String _formatFieldValue(dynamic value) {
    if (value == null) return 'Not specified';
    
    if (value is bool) {
      return value ? 'Yes' : 'No';
    }
    
    if (value is DateTime) {
      return _formatDate(value);
    }
    
    if (value is List) {
      if (value.isEmpty) return 'None';
      return value.join(', ');
    }
    
    if (value is Map) {
      if (value.isEmpty) return 'None';
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    }
    
    return value.toString();
  }

  String _getEntityTypeDisplay(EntitySubtype subtype) {
    // Convert enum value like 'EntitySubtype.pet' to 'Pet'
    final subtypeString = subtype.toString().split('.').last;
    
    // Convert camelCase to Title Case
    final words = subtypeString.replaceAllMapped(
      RegExp(r'([A-Z])'), 
      (match) => ' ${match.group(0)}',
    ).trim().split(' ');
    
    // Capitalize each word
    return words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
