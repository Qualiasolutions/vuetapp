import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart'; // Updated
import 'package:vuet_app/models/list_item_model.dart'; // Updated
import 'package:vuet_app/providers/lists_providers.dart';
// import 'package:vuet_app/services/lists_service.dart'; // To be replaced by repository
import 'package:vuet_app/ui/lists/components/list_item_components.dart';
// import 'package:vuet_app/ui/lists/screens/planning_sublist_detail_screen.dart'; // Sublist detail screen removed for now

// Assuming categoryByIdProvider is available, e.g., from list_item_components or a dedicated provider file
// If not, it needs to be defined or imported. For now, relying on its definition in list_item_components.dart

class PlanningListDetailScreen extends ConsumerWidget {
  final ListModel list; // Changed from PlanningList to ListModel

  const PlanningListDetailScreen({
    super.key,
    required this.list, // Changed parameter name
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch list items instead of sublists
    final listItemsAsync = ref.watch(listItemsProviderFamily(list.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(list.name), // Use list.name
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit planning list screen (pass ListModel)
              _showEditListDialog(context, ref, list);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Items', // Changed from 'Sublists' to 'Items'
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: listItemsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const EmptyListState( // Using the generic EmptyListState
                    message: 'No items in this list yet.\nAdd an item to get started!',
                    icon: Icons.list_alt_outlined,
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(listItemsProviderFamily(list.id));
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Using PlanningListItemTile, assuming it's adapted for ListItemModel
                      return PlanningListItemTile( 
                        item: item,
                        onCheckChanged: (bool? checked) async {
                          if (checked != null) {
                            final updatedItem = item.copyWith(isCompleted: checked);
                            try {
                              await ref.read(listRepositoryProvider).updateListItem(updatedItem);
                              ref.invalidate(listItemsProviderFamily(list.id));
                            } catch (e) {
                              // Handle error
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
                  'Error loading items: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, ref, list.id), // Changed to add item
        child: const Icon(Icons.add),
      ),
    );
  }

  // Removed _navigateToSublistDetail as sublists are not handled here for now

  void _confirmDeleteItem(BuildContext context, WidgetRef ref, ListItemModel item) { // Changed to ListItemModel
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Item'), // Changed title
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
                      const SnackBar(content: Text('Item deleted')), // Changed message
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

  void _showAddItemDialog(BuildContext context, WidgetRef ref, String currentListId) { // Changed to add item
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    
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
                'Add Item', // Changed title
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Item Name', // Changed label
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final name = titleController.text.trim();
                  final description = descriptionController.text.trim();
                  
                  if (name.isNotEmpty) {
                    try {
                      final listRepository = ref.read(listRepositoryProvider);
                      // Create a new ListItemModel - ID will be generated by backend/DB
                      // createdAt, updatedAt also by DB. isCompleted, sortOrder have defaults.
                      final now = DateTime.now();
                      final newItem = ListItemModel(
                        id: '', // Placeholder, will be set by DB
                        listId: currentListId,
                        name: name,
                        description: description.isNotEmpty ? description : null,
                        createdAt: now,
                        updatedAt: now,
                      );
                      await listRepository.createListItem(newItem);
                      
                      ref.invalidate(listItemsProviderFamily(currentListId));
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                       if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add item: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Add Item'), // Changed button text
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showEditListDialog(BuildContext context, WidgetRef ref, ListModel currentList) {
    final nameController = TextEditingController(text: currentList.name);
    // Potentially allow editing type or category if applicable for planning lists
    
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
                'Edit List',
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
                      
                      ref.invalidate(planningListsProvider); // Or specific list provider
                      ref.invalidate(allListsProvider);
                      ref.invalidate(listByIdProviderFamily(currentList.id));


                      if (context.mounted) {
                        Navigator.pop(context); 
                        // Potentially update the AppBar title if this screen stays open
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
                     if (context.mounted) Navigator.pop(context); // No changes made
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
