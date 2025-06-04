import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/models/list_item_model.dart';
import 'package:vuet_app/providers/modernized_list_providers.dart';
import 'package:vuet_app/ui/widgets/modern_components.dart';
import 'package:intl/intl.dart';

class ListDetailScreen extends ConsumerStatefulWidget {
  final String listId;
  final String? listName;

  const ListDetailScreen({
    super.key,
    required this.listId,
    this.listName,
  });

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _newItemController = TextEditingController();
  final FocusNode _newItemFocus = FocusNode();
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _newItemController.dispose();
    _newItemFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(listByIdProviderFamily(widget.listId));
    final listItemsAsync = ref.watch(listItemsProviderFamily(widget.listId));
    // ListNotifier is no longer directly watched here, actions will use repository directly

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.listName ?? 'List Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        actions: [
          IconButton(
            icon: Icon(_showCompleted ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _showCompleted = !_showCompleted),
            tooltip: _showCompleted ? 'Hide Completed' : 'Show Completed',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, listAsync.value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit List'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'template',
                child: Row(
                  children: [
                    Icon(Icons.bookmark_add),
                    SizedBox(width: 8),
                    Text('Save as Template'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share List'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete List', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Add new item section
            Container(
              margin: const EdgeInsets.all(16),
              child: ModernComponents.modernCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newItemController,
                        focusNode: _newItemFocus,
                        decoration: const InputDecoration(
                          hintText: 'Add new item...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: _addNewItem,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => _addNewItem(_newItemController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List items
            Expanded(
              child: listItemsAsync.when(
                data: (items) => _buildListItems(items),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading list items',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(color: Colors.grey.shade500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(listItemsProviderFamily(widget.listId)),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItems(List<ListItemModel> items) {
    final filteredItems = _showCompleted 
        ? items 
        : items.where((item) => !item.isCompleted).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              _showCompleted ? 'No items in this list' : 'No pending items',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some items to get started!',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      onReorder: (oldIndex, newIndex) => _reorderItems(filteredItems, oldIndex, newIndex),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildListItem(item, key: ValueKey(item.id));
      },
    );
  }

  Widget _buildListItem(ListItemModel item, {required Key key}) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      child: ModernComponents.modernCard(
        onTap: () => _editItem(item),
        child: Row(
          children: [
            // Completion checkbox
            Checkbox(
              value: item.isCompleted,
              onChanged: (value) {
                if (value != null) {
                  ref.read(listRepositoryProvider).toggleItemCompletion(item.id, value);
                }
              },
              activeColor: const Color(0xFF0D9488),
            ),
            
            // Item content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      color: item.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                  if (item.quantity != null && item.quantity! > 1) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    'Item added: ${DateFormat.yMd().add_jm().format(item.createdAt)}',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  if (item.updatedAt != item.createdAt)
                    Text(
                      'Last updated: ${DateFormat.yMd().add_jm().format(item.updatedAt)}',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                    ),
                ],
              ),
            ),
            
            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editItem(item),
                  color: Colors.grey.shade600,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _deleteItem(item),
                  color: Colors.red.shade400,
                ),
                const Icon(Icons.drag_handle, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNewItem(String text) {
    if (text.trim().isEmpty) return;

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    final newItem = ListItemModel(
      id: '', // Will be generated by Supabase
      listId: widget.listId,
      name: text.trim(),
      description: null,
      isCompleted: false,
      quantity: 1,
      sortOrder: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(listRepositoryProvider).createListItem(newItem);
    _newItemController.clear();
  }

  void _editItem(ListItemModel item) {
    showDialog(
      context: context,
      builder: (context) => _EditItemDialog(item: item),
    );
  }

  void _deleteItem(ListItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(listRepositoryProvider).deleteListItem(item.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _reorderItems(List<ListItemModel> items, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    
    final reorderedItems = List<ListItemModel>.from(items);
    final item = reorderedItems.removeAt(oldIndex);
    reorderedItems.insert(newIndex, item);
    
    final itemIds = reorderedItems.map((item) => item.id).toList();
    ref.read(listRepositoryProvider).reorderListItems(widget.listId, itemIds);
  }

  void _handleMenuAction(String action, ListModel? list) {
    switch (action) {
      case 'edit':
        _editList(list);
        break;
      case 'template':
        _saveAsTemplate(list);
        break;
      case 'share':
        _shareList(list);
        break;
      case 'delete':
        _deleteList();
        break;
    }
  }

  void _editList(ListModel? list) {
    if (list == null) return;
    
    showDialog(
      context: context,
      builder: (context) => _EditListDialog(list: list),
    );
  }

  void _saveAsTemplate(ListModel? list) {
    if (list == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template feature coming soon!'),
        backgroundColor: Color(0xFF0D9488),
      ),
    );
  }

  void _shareList(ListModel? list) {
    if (list == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share feature coming soon!'),
        backgroundColor: Color(0xFF0D9488),
      ),
    );
  }

  void _deleteList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List'),
        content: const Text('Are you sure you want to delete this list? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(listRepositoryProvider).deleteList(widget.listId);
              Navigator.pop(context); // Return to lists screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EditItemDialog extends ConsumerStatefulWidget {
  final ListItemModel item;

  const _EditItemDialog({required this.item});

  @override
  ConsumerState<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends ConsumerState<_EditItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _descriptionController = TextEditingController(text: widget.item.description ?? '');
    _quantityController = TextEditingController(text: widget.item.quantity?.toString() ?? '1');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveItem() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final description = _descriptionController.text.trim();

    final updatedItem = widget.item.copyWith(
      name: name,
      description: description.isEmpty ? null : description,
      quantity: quantity,
      updatedAt: DateTime.now(),
    );

    ref.read(listRepositoryProvider).updateListItem(updatedItem);
    ref.invalidate(listItemsProviderFamily(widget.item.listId));
    
    Navigator.pop(context);
  }
}

class _EditListDialog extends ConsumerStatefulWidget {
  final ListModel list;

  const _EditListDialog({required this.list});

  @override
  ConsumerState<_EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends ConsumerState<_EditListDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.name);
    _descriptionController = TextEditingController(text: widget.list.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit List'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'List Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveList,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveList() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final description = _descriptionController.text.trim();

    final updatedList = widget.list.copyWith(
      name: name,
      description: description.isEmpty ? null : description,
      updatedAt: DateTime.now(),
    );

    ref.read(listRepositoryProvider).updateList(updatedList);
    ref.invalidate(listByIdProviderFamily(widget.list.id));
    ref.invalidate(allListsProvider);
    
    Navigator.pop(context);
  }
}
