import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/providers/modernized_list_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/lists/list_detail_screen.dart';

class ModernizedListsScreen extends ConsumerStatefulWidget {
  const ModernizedListsScreen({super.key});

  @override
  ConsumerState<ModernizedListsScreen> createState() => _ModernizedListsScreenState();
}

class _ModernizedListsScreenState extends ConsumerState<ModernizedListsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Lists',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Planning'),
                Tab(text: 'Shopping'),
              ],
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPlanningListsView(),
            _buildShoppingListsView(),
          ],
        ),
      ),
      floatingActionButton: ModernComponents.modernFAB(
        icon: Icons.add,
        onPressed: _showCreateListDialog,
        tooltip: 'Create New List',
      ),
    );
  }

  Widget _buildPlanningListsView() {
    final planningListsAsync = ref.watch(planningListsProvider);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader('My Planning Lists'),
              const SizedBox(height: 16),
            ]),
          ),
        ),
        planningListsAsync.when(
          data: (lists) => _buildListsSliver(lists, 'planning'),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => SliverToBoxAdapter(
            child: _buildErrorState('Failed to load planning lists', error.toString()),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _buildSectionHeader('Quick Actions'),
              const SizedBox(height: 16),
              _buildQuickActionRow([
                _buildQuickAction(
                  'Daily Tasks',
                  Icons.today,
                  const Color(0xFF9C27B0),
                  () => _createQuickList('Daily Tasks', false),
                ),
                _buildQuickAction(
                  'Ideas',
                  Icons.lightbulb,
                  const Color(0xFFFF9800),
                  () => _createQuickList('Ideas', false),
                ),
                _buildQuickAction(
                  'Notes',
                  Icons.note,
                  const Color(0xFF607D8B),
                  () => _createQuickList('Notes', false),
                ),
              ]),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingListsView() {
    final shoppingListsAsync = ref.watch(shoppingListsProvider);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader('My Shopping Lists'),
              const SizedBox(height: 16),
            ]),
          ),
        ),
        shoppingListsAsync.when(
          data: (lists) => _buildListsSliver(lists, 'shopping'),
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => SliverToBoxAdapter(
            child: _buildErrorState('Failed to load shopping lists', error.toString()),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _buildSectionHeader('Shopping Categories'),
              const SizedBox(height: 16),
              _buildCategoryGrid(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
    );
  }


  Widget _buildQuickActionRow(List<Widget> actions) {
    return Row(
      children: actions
          .map((action) => Expanded(child: action))
          .expand((widget) => [widget, const SizedBox(width: 12)])
          .toList()
        ..removeLast(), // Remove last spacer
    );
  }

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ModernComponents.modernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {'name': 'Food', 'icon': Icons.restaurant, 'color': const Color(0xFFFF5722)},
      {'name': 'Clothing', 'icon': Icons.checkroom, 'color': const Color(0xFF9C27B0)},
      {'name': 'Electronics', 'icon': Icons.electrical_services, 'color': const Color(0xFF2196F3)},
      {'name': 'Health', 'icon': Icons.local_pharmacy, 'color': const Color(0xFF4CAF50)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ModernComponents.modernCard(
          onTap: () => _openCategoryList(category['name'] as String),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: category['color'] as Color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildListsSliver(List<ListModel> lists, String listType) {
    if (lists.isEmpty) {
      return SliverToBoxAdapter(
        child: _buildEmptyState('No $listType lists yet', 'Create your first list to get started!'),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final list = lists[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildRealListCard(list),
            );
          },
          childCount: lists.length,
        ),
      ),
    );
  }

  Widget _buildRealListCard(ListModel list) {
    final listItemsAsync = ref.watch(listItemsProviderFamily(list.id));
    
    return listItemsAsync.when(
      data: (items) {
        final completedCount = items.where((item) => item.isCompleted).length;
        final totalCount = items.length;
        
        return ModernComponents.modernCard(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListDetailScreen(
                listId: list.id,
                listName: list.name,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getListColor(list).withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getListIcon(list),
                  color: _getListColor(list),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalCount items • $completedCount completed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (list.description != null && list.description!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        list.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        );
      },
      loading: () => ModernComponents.modernCard(
        child: const Row(
          children: [
            SizedBox(width: 50, height: 50, child: CircularProgressIndicator()),
            SizedBox(width: 16),
            Expanded(child: Text('Loading...')),
          ],
        ),
      ),
      error: (error, stack) => ModernComponents.modernCard(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Error loading items',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(planningListsProvider);
                ref.invalidate(shoppingListsProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getListColor(ListModel list) {
    if (list.isShoppingList) {
      return const Color(0xFF4CAF50);
    } else if (list.isTemplate) {
      return const Color(0xFF9C27B0);
    } else {
      return const Color(0xFF2196F3);
    }
  }

  IconData _getListIcon(ListModel list) {
    if (list.isShoppingList) {
      return Icons.shopping_cart;
    } else if (list.isTemplate) {
      return Icons.bookmark;
    } else {
      return Icons.assignment;
    }
  }

  void _createQuickList(String listName, bool isShoppingList) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to create lists')),
        );
      }
      return;
    }

    final newList = ListModel.create(
      name: listName,
      ownerId: userId,
      isShoppingList: isShoppingList,
    );

    try {
      await ref.read(listRepositoryProvider).createList(newList);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created $listName list'),
            backgroundColor: const Color(0xFF0D9488),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create list: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openCategoryList(String categoryName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $categoryName shopping list'),
        backgroundColor: const Color(0xFF0D9488),
      ),
    );
  }

  void _showCreateListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Create New List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModernComponents.modernTextField(
              label: 'List Name',
              hint: 'Enter list name',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ModernComponents.modernButton(
                    text: 'Planning',
                    onPressed: () {
                      Navigator.pop(context);
                      _createQuickList('My Planning List', false);
                    },
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ModernComponents.modernButton(
                    text: 'Shopping',
                    onPressed: () {
                      Navigator.pop(context);
                      _createQuickList('My Shopping List', true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
