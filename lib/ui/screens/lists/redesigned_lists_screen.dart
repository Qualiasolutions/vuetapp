import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/models/list_sublist_model.dart';
import 'package:vuet_app/providers/modernized_list_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:vuet_app/ui/screens/lists/list_detail_screen.dart';
import 'package:intl/intl.dart';

class RedesignedListsScreen extends ConsumerStatefulWidget {
  const RedesignedListsScreen({super.key});

  @override
  ConsumerState<RedesignedListsScreen> createState() => _RedesignedListsScreenState();
}

class _RedesignedListsScreenState extends ConsumerState<RedesignedListsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Controller for the list name text field in the create list dialog
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // State for the create list dialog
  bool _isCreatingList = false;
  bool _isShoppingList = false;

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
    _listNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'My Lists',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151), // Explicit dark color
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF374151), // Explicit foreground color
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).round()),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF0D9488)], // Teal gradient
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D9488).withAlpha((0.3 * 255).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.checklist, size: 18),
                        const SizedBox(width: 6),
                        Text('Planning'),
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart, size: 18),
                        const SizedBox(width: 6),
                        Text('Shopping'),
                      ],
                    ),
                  ),
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateListDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Create New List',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlanningListsView() {
    final planningListsAsync = ref.watch(planningListsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(planningListsProvider);
      },
      child: CustomScrollView(
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
            data: (lists) => lists.isEmpty 
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(
                    'No planning lists yet', 
                    'Create your first planning list using the + button'
                  ),
                )
              : _buildListsSliver(lists, 'planning'),
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: _buildErrorState('Failed to load planning lists', error.toString()),
            ),
          ),
          if (planningListsAsync.hasValue && planningListsAsync.value!.isNotEmpty)
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
      ),
    );
  }

  Widget _buildShoppingListsView() {
    final shoppingListsAsync = ref.watch(shoppingListsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(shoppingListsProvider);
      },
      child: CustomScrollView(
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
            data: (lists) => lists.isEmpty 
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(
                    'No shopping lists yet', 
                    'Create your first shopping list using the + button'
                  ),
                )
              : _buildListsSliver(lists, 'shopping'),
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: _buildErrorState('Failed to load shopping lists', error.toString()),
            ),
          ),
          if (shoppingListsAsync.hasValue && shoppingListsAsync.value!.isNotEmpty)
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
      ),
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
      {'name': 'Groceries', 'icon': Icons.shopping_basket, 'color': const Color(0xFF4CAF50)},
      {'name': 'Clothing', 'icon': Icons.checkroom, 'color': const Color(0xFF9C27B0)},
      {'name': 'Electronics', 'icon': Icons.devices, 'color': const Color(0xFF2196F3)},
      {'name': 'Household', 'icon': Icons.home, 'color': const Color(0xFFFF9800)},
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
          onTap: () => _createQuickList(category['name'] as String, true),
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
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final list = lists[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildListCard(list),
            );
          },
          childCount: lists.length,
        ),
      ),
    );
  }

  Widget _buildListCard(ListModel list) {
    final listItemsAsync = ref.watch(listItemsProviderFamily(list.id));
    
    return listItemsAsync.when(
      data: (items) {
        // Updated stats calculation to include sublist items
        int totalCount = 0;
        int completedCount = 0;
        
        if (list.hasHierarchy) {
          // If we have sublists, count items across all sublists
          totalCount = list.totalItems;
          completedCount = list.completedItems;
        } else {
          // Otherwise just count the direct items
          totalCount = items.length;
          completedCount = items.where((item) => item.isCompleted).length;
        }
        
        return ModernComponents.modernCard(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListDetailScreen(
                listId: list.id,
                listName: list.name,
              ),
            ),
          ).then((_) {
            // Refresh the lists when returning from the detail screen
            ref.invalidate(planningListsProvider);
            ref.invalidate(shoppingListsProvider);
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$completedCount of $totalCount items',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        if (list.description != null && list.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            list.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 24,
                      ),
                      ...[
                        const SizedBox(height: 4),
                        Text(
                          _getRelativeTime(list.updatedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              
              // Progress bar (if items exist)
              if (totalCount > 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? completedCount / totalCount : 0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completedCount == totalCount ? Colors.green : Theme.of(context).colorScheme.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
              
              // Show a preview of list items (up to 3)
              if (items.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...items.take(3).map((item) => _buildItemPreview(item)),
                if (items.length > 3) ...[
                  const SizedBox(height: 4),
                  Text(
                    '+ ${items.length - 3} more items',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
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

  Widget _buildItemPreview(ListItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            item.isCompleted 
              ? Icons.check_circle
              : Icons.circle_outlined,
            size: 16,
            color: item.isCompleted 
              ? Colors.green
              : Colors.grey.shade400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                fontSize: 14,
                color: item.isCompleted 
                  ? Colors.grey.shade500
                  : Colors.grey.shade800,
                decoration: item.isCompleted 
                  ? TextDecoration.lineThrough
                  : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.quantity != null && item.quantity! > 1)
            Text(
              '×${item.quantity}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
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
            Icon(Icons.list_alt, size: 64, color: Colors.grey.shade300),
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
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showCreateListDialog,
              icon: const Icon(Icons.add),
              label: const Text('Create List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
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
      return Icons.checklist;
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return DateFormat.yMMMd().format(dateTime);
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
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

    setState(() {
      _isCreatingList = true;
    });

    final newList = ListModel.create(
      name: listName,
      description: isShoppingList ? 'Shopping list for $listName' : null,
      ownerId: userId,
      isShoppingList: isShoppingList,
    );

    try {
      await ref.read(listRepositoryProvider).createList(newList);
      
      // Add a default sublist if it's a new list
      if (isShoppingList) {
        final sublist = ListSublist.create(
          listId: newList.id,
          title: 'To Buy',
          sortOrder: 0,
        );
        
        // Create a repository reference to add the sublist
        // We need to use a different approach since createSublist isn't available
        final listRepository = ref.read(listRepositoryProvider);
        await listRepository.updateList(newList.addSublist(sublist));
      } else {
        final sublist = ListSublist.create(
          listId: newList.id,
          title: 'Tasks',
          sortOrder: 0,
        );
        
        // We need to use a different approach since createSublist isn't available
        final listRepository = ref.read(listRepositoryProvider);
        await listRepository.updateList(newList.addSublist(sublist));
      }
      
      // Refresh the lists
      ref.invalidate(planningListsProvider);
      ref.invalidate(shoppingListsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created $listName list'),
            backgroundColor: Theme.of(context).colorScheme.primary,
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
    } finally {
      setState(() {
        _isCreatingList = false;
      });
    }
  }

  void _showCreateListDialog() {
    // Reset the controllers and state
    _listNameController.clear();
    _descriptionController.clear();
    _isShoppingList = false;
    _isCreatingList = false;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Create New List',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'List Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _listNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter list name',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description (Optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'List Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isShoppingList = false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: !_isShoppingList 
                                  ? Theme.of(context).colorScheme.primary.withAlpha(30)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: !_isShoppingList 
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.checklist,
                                  color: !_isShoppingList 
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Planning',
                                  style: TextStyle(
                                    color: !_isShoppingList 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade700,
                                    fontWeight: !_isShoppingList 
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isShoppingList = true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _isShoppingList 
                                  ? Theme.of(context).colorScheme.primary.withAlpha(30)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isShoppingList 
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: _isShoppingList 
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey.shade700,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Shopping',
                                  style: TextStyle(
                                    color: _isShoppingList 
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade700,
                                    fontWeight: _isShoppingList 
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              TextButton(
                onPressed: _isCreatingList ? null : _createList,
                child: _isCreatingList
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Create',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Future<void> _createList() async {
    final name = _listNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('List name cannot be empty')),
      );
      return;
    }

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not identified')),
      );
      return;
    }

    setState(() {
      _isCreatingList = true;
    });

    try {
      final newList = ListModel.create(
        name: name,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        ownerId: userId,
        isShoppingList: _isShoppingList,
      );

      await ref.read(listRepositoryProvider).createList(newList);
      
      // Add a default sublist for the new list
      final defaultSublistTitle = _isShoppingList ? 'To Buy' : 'Tasks';
      final sublist = ListSublist.create(
        listId: newList.id,
        title: defaultSublistTitle,
        sortOrder: 0,
      );
      
      // Update the list with the sublist
      final listRepository = ref.read(listRepositoryProvider);
      await listRepository.updateList(newList.addSublist(sublist));
      
      // Refresh the lists
      ref.invalidate(planningListsProvider);
      ref.invalidate(shoppingListsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name created successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create list: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingList = false;
        });
      }
    }
  }
}
