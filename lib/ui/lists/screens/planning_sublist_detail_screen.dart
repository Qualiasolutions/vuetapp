/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/lists/planning_list_model.dart';
import 'package:vuet_app/providers/lists_providers.dart';
import 'package:vuet_app/services/lists_service.dart';
import 'package:vuet_app/ui/lists/components/list_item_components.dart';

class PlanningSublistDetailScreen extends ConsumerWidget {
  final PlanningSublist planningSublist;
  final String planningListName;

  const PlanningSublistDetailScreen({
    super.key,
    required this.planningSublist,
    required this.planningListName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(planningListItemsProvider(planningSublist.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(planningSublist.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(planningListName, style: const TextStyle(color: Colors.white70)),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CreateItemField(
              hintText: 'Add item to list',
              onSubmit: (title) async {
                final listsService = ref.read(listsServiceProvider);
                final item = await listsService.createPlanningListItem(
                  sublistId: planningSublist.id,
                  title: title,
                );
                
                if (item != null) {
                  ref.invalidate(planningListItemsProvider(planningSublist.id));
                }
              },
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyListState(
                    message: 'No items in this list yet.\nAdd items using the field above!',
                    icon: Icons.check_box_outline_blank,
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(planningListItemsProvider(planningSublist.id));
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return PlanningListItemTile(
                        item: item,
                        onCheckChanged: (checked) async {
                          if (checked != null) {
                            final listsService = ref.read(listsServiceProvider);
                            await listsService.togglePlanningListItemChecked(
                              item.id,
                              checked,
                            );
                            ref.invalidate(planningListItemsProvider(planningSublist.id));
                          }
                        },
                        onDelete: () => _confirmDeleteItem(context, ref, item),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Error loading items: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteItem(BuildContext context, WidgetRef ref, PlanningListItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                
                final listsService = ref.read(listsServiceProvider);
                final success = await listsService.deletePlanningListItem(item.id);
                
                if (success) {
                  ref.invalidate(planningListItemsProvider(planningSublist.id));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item deleted')),
                    );
                  }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
*/

// This file is commented out to avoid errors due to obsolete models and providers.
// The "sublist" functionality needs to be re-evaluated and implemented with the new data structure if required.
// For now, PlanningListDetailScreen directly manages ListItems.
