import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/providers/modernized_list_providers.dart';
import 'package:vuet_app/ui/lists/components/list_item_components.dart';
import 'package:vuet_app/ui/lists/screens/shopping_list_detail_screen.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsAsync = ref.watch(shoppingListsProvider);

    return Scaffold(
      body: shoppingListsAsync.when(
        data: (shoppingLists) {
          if (shoppingLists.isEmpty) {
            return const EmptyListState(
              message: 'No shopping lists yet.\nCreate a new shopping list to get started!',
              icon: Icons.shopping_cart_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(shoppingListsProvider);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: shoppingLists.length,
                itemBuilder: (context, index) {
                  final list = shoppingLists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ShoppingListCard(
                      list: list,
                      onTap: () => _navigateToListDetail(context, list),
                      onDelete: () => _confirmDeleteList(context, ref, list),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading shopping lists: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddShoppingListDialog(context, ref);
        },
        tooltip: 'Add Shopping List',
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void _navigateToListDetail(BuildContext context, ListModel list) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShoppingListDetailScreen(list: list),
      ),
    );
  }

  void _showAddShoppingListDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

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
                'Add Shopping List',
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
                  final name = nameController.text.trim();
                  final userId = ref.read(currentUserIdProvider);

                  if (name.isNotEmpty && userId != null) {
                    try {
                      final listNotifier = ref.read(listNotifierProvider.notifier);
                      final newList = ListModel.create(
                        name: name,
                        ownerId: userId,
                        isShoppingList: true,
                      );
                      await listNotifier.createList(newList);

                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to add list: $e')),
                        );
                      }
                    }
                  }
                },
                child: const Text('Add Shopping List'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteList(BuildContext context, WidgetRef ref, ListModel list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Shopping List'),
          content: Text('Are you sure you want to delete "${list.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  final listNotifier = ref.read(listNotifierProvider.notifier);
                  await listNotifier.deleteList(list.id);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shopping list deleted')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete list: $e')),
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
