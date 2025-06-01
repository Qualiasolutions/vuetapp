import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart'; // Updated
import 'package:vuet_app/models/list_item_model.dart'; // Updated
import 'package:vuet_app/providers/lists_providers.dart';
// import 'package:vuet_app/services/lists_service.dart'; // To be replaced by repository
import 'package:vuet_app/ui/lists/components/list_item_components.dart';

class ShoppingListDetailScreen extends ConsumerWidget {
  final ListModel list; // Changed from ShoppingList to ListModel

  const ShoppingListDetailScreen({
    super.key,
    required this.list, // Changed parameter name
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use listItemsProviderFamily to fetch items for the current list
    final itemsAsync = ref.watch(listItemsProviderFamily(list.id));
    // Removed storesAsync and shoppingListStoresProvider logic for simplification

    return Scaffold(
      appBar: AppBar(
        title: Text(list.name), // Use list.name
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditListDialog(context, ref, list);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Removed Members display as it's not directly on ListModel
          // const Divider(), // Keep divider if needed for visual separation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CreateItemField( // This component can be reused
              hintText: 'Add item to shopping list',
              onSubmit: (name) async {
                try {
                  final listRepository = ref.read(listRepositoryProvider);
                  final now = DateTime.now();
                  final newItem = ListItemModel(
                    id: '', // Will be set by DB
                    listId: list.id,
                    name: name,
                    createdAt: now,
                    updatedAt: now,
                  );
                  await listRepository.createListItem(newItem);
                  ref.invalidate(listItemsProviderFamily(list.id));
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add item: $e')),
                    );
                  }
                }
              },
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyListState(
                    message: 'No items in this shopping list yet.\nAdd items using the field above!',
                    icon: Icons.shopping_bag_outlined,
                  );
                }
                // Removed nested storesAsync.when
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(listItemsProviderFamily(list.id));
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Assuming ShoppingListItemTile is adapted for ListItemModel
                      return ShoppingListItemTile(
                        item: item,
                        // storeName can be derived from item.description or a dedicated field if added later
                        storeName: null, // Simplified for now
                        onCheckChanged: (checked) async {
                          if (checked != null) {
                            try {
                              final listRepository = ref.read(listRepositoryProvider);
                              final updatedItem = item.copyWith(isCompleted: checked);
                              await listRepository.updateListItem(updatedItem);
                              ref.invalidate(listItemsProviderFamily(list.id));
                            } catch (e) {
                               if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update item: $e')),
                                );
                              }
                            }
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
                  'Error loading shopping list items: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      // FAB for adding items is handled by CreateItemField above, FAB for stores removed.
      // If a general "add item" FAB is preferred, CreateItemField can be moved to a dialog.
      // For now, keeping CreateItemField in the main column.
    );
  }

  void _confirmDeleteItem(BuildContext context, WidgetRef ref, ListItemModel item) { // Changed to ListItemModel
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item.name}"?'), // Use item.name
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  final listRepository = ref.read(listRepositoryProvider);
                  await listRepository.deleteListItem(item.id); // Use deleteListItem
                  ref.invalidate(listItemsProviderFamily(list.id)); // Refresh items for the current list
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item deleted')),
                    );
                  }
                } catch (e) {
                   if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete item: $e')),
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

  // _showAddStoreDialog removed as store functionality is simplified for now.

  void _showEditListDialog(BuildContext context, WidgetRef ref, ListModel currentList) {
    final nameController = TextEditingController(text: currentList.name);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Shopping List',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'List Name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty && newName != currentList.name) {
                    try {
                      final listRepository = ref.read(listRepositoryProvider);
                      final updatedList = currentList.copyWith(name: newName);
                      await listRepository.updateList(updatedList);
                      
                      ref.invalidate(shoppingListsProvider); 
                      ref.invalidate(allListsProvider);
                      ref.invalidate(listByIdProviderFamily(currentList.id));

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update list: $e')),
                        );
                      }
                    }
                  } else if (newName.isEmpty) {
                     if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('List name cannot be empty')),
                        );
                      }
                  } else {
                     if (context.mounted) Navigator.pop(context); // No changes
                  }
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
