import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityMessagesTab extends ConsumerWidget {
  final String entityId;

  const EntityMessagesTab({
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
            icon: Icons.message,
            title: 'Entity Messages',
            subtitle: 'Messaging and collaboration for this entity will be implemented here.\n\nFamily members will be able to communicate about this entity.',
          ),
        ],
      ),
    );
  }
}
