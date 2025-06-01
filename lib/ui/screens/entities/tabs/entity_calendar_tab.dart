import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';

class EntityCalendarTab extends ConsumerWidget {
  final String entityId;

  const EntityCalendarTab({
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
            icon: Icons.calendar_today,
            title: 'Entity Calendar',
            subtitle: 'Calendar integration for this entity will be implemented here.\n\nThis will show entity-specific events, tasks, and schedules.',
          ),
        ],
      ),
    );
  }
}
