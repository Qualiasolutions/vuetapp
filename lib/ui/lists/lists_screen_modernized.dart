import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/providers/lists_providers.dart';
import 'package:vuet_app/ui/navigation/app_drawer.dart';
import 'package:vuet_app/ui/lists/components/category_section_card.dart';
import 'package:vuet_app/ui/lists/components/create_list_modal.dart';
import 'package:vuet_app/ui/lists/components/shopping_group_controls.dart';

/// Provider for the current Lists tab index (0=Planning, 1=Shopping, 2=Delegated)
final modernListsTabIndexProvider = StateProvider<int>((ref) => 0);

/// Provider for category expansion states
final categoryExpansionProvider = StateProvider<Map<String, bool>>((ref) => {});

/// Provider for shopping list grouping mode
final shoppingGroupModeProvider = StateProvider<ShoppingGroupMode>((ref) => ShoppingGroupMode.none);

enum ShoppingGroupMode { none, store, category }

class ModernizedListsScreen extends ConsumerWidget {
  const ModernizedListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(modernListsTabIndexProvider);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lists'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchModal(context, ref),
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              ref.read(modernListsTabIndexProvider.notifier).state = index;
            },
            tabs: [
              _buildTabWithDescription(
                'MY PLANNING\nLISTS',
                'For organizing tasks\nand projects',
                theme,
              ),
              _buildTabWithDescription(
                'MY SHOPPING &\nSELLING LISTS',
                'For tracking items\nto purchase',
                theme,
              ),
              _buildTabWithDescription(
                'DELEGATED\nLISTS',
                'Lists shared\nwith you',
                theme,
              ),
            ],
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
            indicatorColor: theme.colorScheme.onPrimary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _PlanningListsTab(),
            _ShoppingListsTab(),
            _DelegatedListsTab(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context, ref, tabIndex),
      ),
    );
  }

  Widget _buildTabWithDescription(String title, String description, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              height: 1.1,
                                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, WidgetRef ref, int tabIndex) {
    return FloatingActionButton(
      onPressed: () => _showCreateListModal(context, ref, tabIndex),
      child: const Icon(Icons.add),
    );
  }

  void _showCreateListModal(BuildContext context, WidgetRef ref, int tabIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateListModal(
        listType: tabIndex == 0 ? ListType.planning : ListType.shopping,
      ),
    );
  }

  void _showSearchModal(BuildContext context, WidgetRef ref) {
    showSearch(
      context: context,
      delegate: ListSearchDelegate(ref),
    );
  }
}

class _PlanningListsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planningListsAsync = ref.watch(planningListsProvider);
    final categoryExpansion = ref.watch(categoryExpansionProvider);

    return planningListsAsync.when(
      data: (lists) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(planningListsProvider),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = ListCategories.defaultCategories[index];
                    final categoryLists = lists.where((list) => 
                        list.templateCategory == category.id).toList();
                    final isExpanded = categoryExpansion[category.id] ?? false;

                    return CategorySectionCard(
                      category: category,
                      lists: categoryLists,
                      isExpanded: isExpanded,
                      onToggleExpansion: () => _toggleCategoryExpansion(ref, category.id),
                      onAddToCategory: () => _addToCategory(context, ref, category),
                    );
                  },
                  childCount: ListCategories.defaultCategories.length,
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Error loading lists: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(planningListsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCategoryExpansion(WidgetRef ref, String categoryId) {
    final current = ref.read(categoryExpansionProvider);
    ref.read(categoryExpansionProvider.notifier).state = {
      ...current,
      categoryId: !(current[categoryId] ?? false),
    };
  }

  void _addToCategory(BuildContext context, WidgetRef ref, ListCategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateListModal(
        listType: ListType.planning,
        preselectedCategory: category,
      ),
    );
  }
}

class _ShoppingListsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingListsAsync = ref.watch(shoppingListsProvider);
    final groupMode = ref.watch(shoppingGroupModeProvider);

    return Column(
      children: [
        ShoppingGroupControls(
          currentMode: groupMode,
          onModeChanged: (mode) => 
              ref.read(shoppingGroupModeProvider.notifier).state = mode,
        ),
        Expanded(
          child: shoppingListsAsync.when(
            data: (lists) => RefreshIndicator(
              onRefresh: () async => ref.invalidate(shoppingListsProvider),
              child: _buildShoppingListsContent(lists, groupMode),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading shopping lists: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingListsContent(List<ListModel> lists, ShoppingGroupMode groupMode) {
    if (lists.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No shopping lists yet'),
            Text('Tap the + button to create your first shopping list'),
          ],
        ),
      );
    }

    switch (groupMode) {
      case ShoppingGroupMode.store:
        return _buildStoreGroupedLists(lists);
      case ShoppingGroupMode.category:
        return _buildCategoryGroupedLists(lists);
      case ShoppingGroupMode.none:
        return _buildSimpleShoppingList(lists);
    }
  }

  Widget _buildSimpleShoppingList(List<ListModel> lists) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(list.name),
            subtitle: list.description != null ? Text(list.description!) : null,
            trailing: const Icon(Icons.add),
            onTap: () {
              // Navigate to shopping list detail
            },
          ),
        );
      },
    );
  }

  Widget _buildStoreGroupedLists(List<ListModel> lists) {
    // Group lists by store (implement store grouping logic)
    return const Center(child: Text('Store-grouped shopping lists'));
  }

  Widget _buildCategoryGroupedLists(List<ListModel> lists) {
    // Group lists by category (implement category grouping logic)
    return const Center(child: Text('Category-grouped shopping lists'));
  }
}

class _DelegatedListsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delegatedListsAsync = ref.watch(delegatedListsProvider);

    return delegatedListsAsync.when(
      data: (lists) {
        if (lists.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No delegated lists'),
                Text('Lists shared with you will appear here'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(delegatedListsProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              final list = lists[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(list.name),
                  subtitle: Text('Delegated by: ${list.ownerId}'), // Replace with actual user name
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to delegated list detail
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading delegated lists: $error'),
      ),
    );
  }
}

// Search delegate for list search functionality
class ListSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  ListSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return const Center(child: Text('Search results will appear here'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement search suggestions
    return const Center(child: Text('Search suggestions will appear here'));
  }
} 