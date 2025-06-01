import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/list_category_model.dart';
import 'package:vuet_app/models/list_template_model.dart';
import 'package:vuet_app/models/list_model.dart';
import 'package:vuet_app/providers/lists_providers.dart';

enum ListType { planning, shopping }

class CreateListModal extends ConsumerStatefulWidget {
  final ListType listType;
  final ListCategoryModel? preselectedCategory;

  const CreateListModal({
    super.key,
    required this.listType,
    this.preselectedCategory,
  });

  @override
  ConsumerState<CreateListModal> createState() => _CreateListModalState();
}

class _CreateListModalState extends ConsumerState<CreateListModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Create New form fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  ListCategoryModel? _selectedCategory;
  
  // Template selection
  ListTemplateModel? _selectedTemplate;
  String? _customNameForTemplate;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedCategory = widget.preselectedCategory;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Create ${widget.listType == ListType.planning ? 'Planning' : 'Shopping'} List',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Tab Selector
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Create New'),
                      Tab(text: 'Select Template'),
                    ],
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCreateNewTab(),
                _buildSelectTemplateTab(),
              ],
            ),
          ),
          
          // Actions
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleCreate,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create List'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List Name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'List Name *',
              hintText: 'Enter a name for your list',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          
          // Description
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Add a description for your list',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          
          // Category Selection (only for planning lists)
          if (widget.listType == ListType.planning) ...[
            Text(
              'Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildCategoryGrid(),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectTemplateTab() {
    List<ListTemplateModel> templates = [];
    
    if (widget.listType == ListType.planning) {
      if (_selectedCategory != null) {
        templates = ListTemplates.getTemplatesForCategory(_selectedCategory!.id);
      } else {
        templates = ListTemplates.getPopularTemplates(limit: 10);
      }
    }

    return Column(
      children: [
        // Category filter for planning lists
        if (widget.listType == ListType.planning) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: _buildCategoryFilter(),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
        
        // Templates List
        Expanded(
          child: templates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedCategory != null 
                            ? 'No templates available for ${_selectedCategory!.name}'
                            : 'No templates available',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return _buildTemplateCard(template);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ListCategories.defaultCategories.map((category) {
        final isSelected = _selectedCategory?.id == category.id;
        final categoryColor = _parseColor(category.color);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = isSelected ? null : category;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? categoryColor : categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: categoryColor,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconData(category.icon),
                  size: 16,
                  color: isSelected ? Colors.white : categoryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : categoryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryFilter() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ListCategories.defaultCategories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // "All" option
          final isSelected = _selectedCategory == null;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = null;
                });
              },
            ),
          );
        }
        
        final category = ListCategories.defaultCategories[index - 1];
        final isSelected = _selectedCategory?.id == category.id;
        
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: FilterChip(
            avatar: Icon(
              _getIconData(category.icon),
              size: 16,
            ),
            label: Text(category.name),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = selected ? category : null;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildTemplateCard(ListTemplateModel template) {
    final isSelected = _selectedTemplate?.id == template.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTemplate = isSelected ? null : template;
            });
            
            if (!isSelected) {
              // Show dialog for custom name
              _showCustomNameDialog(template);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: isSelected 
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                // Template Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    template.icon != null ? _getIconData(template.icon!) : Icons.list_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Template Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (template.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          template.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${template.popularity}% popular',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomNameDialog(ListTemplateModel template) {
    final controller = TextEditingController(text: template.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customize List Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'List Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customNameForTemplate = controller.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Use Template'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCreate() async {
    if (_tabController.index == 0) {
      // Create New
      await _createNewList();
    } else {
      // From Template
      await _createFromTemplate();
    }
  }

  Future<void> _createNewList() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a list name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) throw Exception('User not authenticated');

      final newList = ListModel.create(
        name: name,
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        ownerId: userId,
        isShoppingList: widget.listType == ListType.shopping,
        templateCategory: _selectedCategory?.id,
      );

      final listRepository = ref.read(listRepositoryProvider);
      await listRepository.createList(newList);

      // Refresh the appropriate provider
      if (widget.listType == ListType.planning) {
        ref.invalidate(planningListsProvider);
      } else {
        ref.invalidate(shoppingListsProvider);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.listType == ListType.planning ? 'Planning' : 'Shopping'} list created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create list: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createFromTemplate() async {
    if (_selectedTemplate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a template')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = ref.read(currentUserIdProvider);
      if (userId == null) throw Exception('User not authenticated');

      final templateList = ListModel.create(
        name: _selectedTemplate!.name,
        description: _selectedTemplate!.description,
        ownerId: userId,
        isShoppingList: widget.listType == ListType.shopping,
        templateCategory: _selectedTemplate!.categoryId,
        isTemplate: true,
      );

      final newList = ListModel.fromTemplate(
        template: templateList,
        ownerId: userId,
        customName: _customNameForTemplate,
      );

      final listRepository = ref.read(listRepositoryProvider);
      await listRepository.createList(newList);

      // Refresh the appropriate provider
      if (widget.listType == ListType.planning) {
        ref.invalidate(planningListsProvider);
      } else {
        ref.invalidate(shoppingListsProvider);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('List created from template successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create list: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse('0xFF${colorString.substring(1)}'));
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'pets':
        return Icons.pets;
      case 'group':
        return Icons.group;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'flight':
        return Icons.flight;
      case 'spa':
        return Icons.spa;
      case 'home':
        return Icons.home;
      case 'yard':
        return Icons.yard;
      case 'restaurant':
        return Icons.restaurant;
      case 'checkroom':
        return Icons.checkroom;
      default:
        return Icons.folder_outlined;
    }
  }
} 