import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/services/entity_service.dart';

/// A widget for selecting an entity to link with an event or other item
class EntitySelector extends ConsumerWidget {
  /// The currently selected entity ID
  final String? selectedEntityId;
  
  /// Callback when an entity is selected
  final Function(String?) onEntitySelected;
  
  /// Constructor
  const EntitySelector({
    super.key, 
    this.selectedEntityId,
    required this.onEntitySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Link to Entity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showEntitySelectionDialog(context, ref),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.link),
              hintText: 'Select Entity',
            ),
            child: selectedEntityId != null
                ? FutureBuilder<BaseEntityModel?>(
                    future: ref.read(entityServiceProvider).getEntity(selectedEntityId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading entity...');
                      }
                      
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Text('Select Entity');
                      }
                      
                      final entity = snapshot.data!;
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              entity.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () => onEntitySelected(null),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      );
                    },
                  )
                : const Text('Select Entity'),
          ),
        ),
      ],
    );
  }
  
  void _showEntitySelectionDialog(BuildContext context, WidgetRef ref) async {
    final entityService = ref.read(entityServiceProvider);
    final entities = await entityService.listEntities();
    
    if (!context.mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Entity'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              final entity = entities[index];
              return ListTile(
                leading: Icon(_getIconForEntityType(entity.subtype)),
                title: Text(entity.name),
                subtitle: entity.description != null && entity.description!.isNotEmpty
                    ? Text(
                        entity.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  onEntitySelected(entity.id);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForEntityType(EntitySubtype subtype) {
    switch (subtype) {
      case EntitySubtype.event:
        return Icons.event;
      case EntitySubtype.anniversary:
      case EntitySubtype.birthday:
        return Icons.cake;
      case EntitySubtype.doctor:
      case EntitySubtype.dentist:
      case EntitySubtype.therapist:
      case EntitySubtype.physiotherapist:
      case EntitySubtype.specialist:
      case EntitySubtype.surgeon:
        return Icons.medical_services;
      case EntitySubtype.trip:
        return Icons.flight;
      case EntitySubtype.restaurant:
        return Icons.restaurant;
      case EntitySubtype.pet:
        return Icons.pets;
      case EntitySubtype.car:
      case EntitySubtype.boat:
      case EntitySubtype.vehicleCar:
        return Icons.directions_car;
      case EntitySubtype.home:
        return Icons.home;
      default:
        return Icons.category;
    }
  }
} 