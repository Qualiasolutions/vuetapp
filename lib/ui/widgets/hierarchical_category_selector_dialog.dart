import 'package:flutter/material.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/models/hierarchical_category_display_model.dart';
import 'package:vuet_app/utils/logger.dart';

class HierarchicalCategorySelectorDialog extends StatefulWidget {
  final List<HierarchicalCategoryDisplayModel> topLevelCategories;
  final Function(EntityCategoryModel) onCategorySelected;

  const HierarchicalCategorySelectorDialog({
    super.key,
    required this.topLevelCategories,
    required this.onCategorySelected,
  });

  @override
  State<HierarchicalCategorySelectorDialog> createState() => _HierarchicalCategorySelectorDialogState();
}

class _HierarchicalCategorySelectorDialogState extends State<HierarchicalCategorySelectorDialog> {
  List<HierarchicalCategoryDisplayModel> _currentCategories = [];
  String _currentTitle = "Select Category";
  final List<List<HierarchicalCategoryDisplayModel>> _history = [];
  final List<String> _titleHistory = [];

  @override
  void initState() {
    super.initState();
    _currentCategories = widget.topLevelCategories;
    _history.add(widget.topLevelCategories);
    _titleHistory.add("Select Category");
  }

  void _navigateToSubcategories(HierarchicalCategoryDisplayModel parent) {
    setState(() {
      _history.add(parent.children);
      _titleHistory.add(parent.category.name);
      _currentCategories = parent.children;
      _currentTitle = parent.category.name;
    });
  }

  void _navigateBack() {
    if (_history.length > 1) {
      setState(() {
        _history.removeLast();
        _titleHistory.removeLast();
        _currentCategories = _history.last;
        _currentTitle = _titleHistory.last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_history.length > 1)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: _navigateBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          Expanded(
            child: Text(
                _currentTitle, 
                textAlign: _history.length > 1 ? TextAlign.center: TextAlign.start, 
                overflow: TextOverflow.ellipsis
            ),
          ),
          if (_history.length <= 1)
             const SizedBox(width: 40) 
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5, 
        child: _currentCategories.isEmpty
            ? const Center(child: Text('No categories available.'))
            : ListView.builder(
                itemCount: _currentCategories.length,
                itemBuilder: (context, index) {
                  final hierarchicalCategory = _currentCategories[index];
                  final category = hierarchicalCategory.category;
                  return ListTile(
                    leading: category.icon != null && category.icon!.isNotEmpty
                        ? Image.asset(category.icon!, width: 24, height: 24, errorBuilder: (context, error, stackTrace) {
                            log('Error loading category icon in dialog: ${category.icon}', name: 'HierarchicalCategorySelectorDialog');
                            return const Icon(Icons.folder_open, size: 24);
                          })
                        : const Icon(Icons.folder_open, size: 24),
                    title: Text(category.name),
                    trailing: hierarchicalCategory.children.isNotEmpty ? const Icon(Icons.chevron_right) : null,
                    onTap: () {
                      if (hierarchicalCategory.children.isNotEmpty) {
                        _navigateToSubcategories(hierarchicalCategory);
                      } else {
                        widget.onCategorySelected(category); 
                        Navigator.of(context).pop(); 
                      }
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

Future<EntityCategoryModel?> showHierarchicalCategorySelectorDialog(
  BuildContext context, 
  List<HierarchicalCategoryDisplayModel> topLevelCategories
) async {
  EntityCategoryModel? selectedCategory;
  if (topLevelCategories.isEmpty) {
    log("HierarchicalCategorySelectorDialog: No categories to display.", name: 'showHierarchicalCategorySelectorDialog');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No categories available to select.')),
    );
    return null;
  }
  await showDialog<EntityCategoryModel>(
    context: context,
    builder: (BuildContext dialogContext) {
      return HierarchicalCategorySelectorDialog(
        topLevelCategories: topLevelCategories,
        onCategorySelected: (category) {
          selectedCategory = category;
        },
      );
    },
  );
  return selectedCategory;
}
