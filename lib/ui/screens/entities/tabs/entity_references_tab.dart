import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityReferencesTab extends ConsumerWidget {
  final String entityId;

  const EntityReferencesTab({
    super.key,
    required this.entityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ModernComponents.modernEmptyState(
            icon: Icons.link,
            title: 'Entity References',
            subtitle: 'Reference management for this entity will be implemented here.\n\nThis will allow you to organize and access related documents, links, and resources.',
          ),
        ],
      ),
    );
  }
}
