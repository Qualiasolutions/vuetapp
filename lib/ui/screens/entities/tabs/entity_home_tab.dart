import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_model.dart';
import 'package:vuet_app/providers/entity_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityHomeTab extends ConsumerWidget {
  final String entityId;

  const EntityHomeTab({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entityAsyncValue = ref.watch(entityDetailProvider(entityId));

    return entityAsyncValue.when(
      data: (entity) {
        if (entity == null) {
          return _buildNotFoundState();
        }
        return _buildEntitySpecificHome(entity);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(error),
    );
  }

  Widget _buildEntitySpecificHome(BaseEntityModel entity) {
    // Build entity-specific home page based on entity type
    switch (entity.subtype) {
      case EntitySubtype.event:
        return _buildEventEntityHome(entity);
      default:
        return _buildGenericEntityHome(entity);
    }
  }

  Widget _buildEventEntityHome(BaseEntityModel entity) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernComponents.modernCard(
            margin: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: Colors.purple.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Event Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Manage this event. Invite guests, track RSVPs, and organize event details.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) => Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Navigate to guest list management
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Guest list management coming soon!')),
                            );
                          },
                          icon: const Icon(Icons.people),
                          label: const Text('Manage Guests'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Navigate to event planning
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Event planning coming soon!')),
                            );
                          },
                          icon: const Icon(Icons.event_note),
                          label: const Text('Plan Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ModernComponents.modernEmptyState(
            icon: Icons.celebration,
            title: 'Event Details',
            subtitle: 'Event-specific features will be implemented here.\n\nGuest lists, invitations, and event planning tools.',
          ),
        ],
      ),
    );
  }

  Widget _buildGenericEntityHome(BaseEntityModel entity) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ModernComponents.modernEmptyState(
            icon: Icons.home,
            title: 'Entity Home',
            subtitle: 'Entity-specific functionality for ${_getSubtypeDisplayName(entity.subtype)} will be implemented here.\n\nThis will provide specialized tools and features for this type of entity.',
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return ModernComponents.modernEmptyState(
      icon: Icons.search_off,
      title: 'Entity Not Found',
      subtitle: 'The entity you\'re looking for doesn\'t exist.',
    );
  }

  Widget _buildErrorState(Object error) {
    return ModernComponents.modernEmptyState(
      icon: Icons.error_outline,
      title: 'Error Loading Entity',
      subtitle: error.toString(),
    );
  }

  String _getSubtypeDisplayName(EntitySubtype subtype) {
    switch (subtype) {
      case EntitySubtype.pet:
        return 'Pet';
      case EntitySubtype.vet:
        return 'Veterinarian';
      case EntitySubtype.car:
        return 'Car';
      case EntitySubtype.home:
        return 'Home';
      case EntitySubtype.event:
        return 'Event';
      case EntitySubtype.hobby:
        return 'Hobby';
      default:
        return subtype.toString().split('.').last;
    }
  }
}
