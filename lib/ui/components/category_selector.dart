import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/ui/screens/tasks/categories/category_list_screen.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// Widget for selecting a task category
class CategorySelector extends StatefulWidget {
  /// Currently selected category ID
  final String? selectedCategoryId;
  
  /// Initial category ID to be selected when first loaded
  final String? initialCategoryId;
  
  /// Callback when a category is selected
  final Function(TaskCategoryModel?) onCategorySelected;
  
  /// Whether the category is required
  final bool isRequired;
  
  /// Constructor
  const CategorySelector({
    super.key,
    this.selectedCategoryId,
    this.initialCategoryId,
    required this.onCategorySelected,
    this.isRequired = false,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final TaskCategoryService _categoryService = TaskCategoryService();
  
  TaskCategoryModel? _selectedCategory;
  List<TaskCategoryModel> _categories = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final categories = await _categoryService.getCategories();
      TaskCategoryModel? selectedCategory;
      
      // Use selectedCategoryId if provided, otherwise use initialCategoryId
      final categoryId = widget.selectedCategoryId ?? widget.initialCategoryId;
      
      if (categoryId != null) {
        selectedCategory = categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => throw Exception('Category not found'),
        );
      }
      
      setState(() {
        _categories = categories;
        _selectedCategory = selectedCategory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading categories: $e';
        _isLoading = false;
      });
    }
  }
  
  void _navigateToCategoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryListScreen(),
      ),
    ).then((_) {
      // Reload categories when returning from category screen
      _loadCategories();
    });
  }
  
  void _selectCategory(TaskCategoryModel? category) {
    setState(() {
      _selectedCategory = category;
    });
    widget.onCategorySelected(category);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with add category button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isRequired ? 'Category *' : 'Category',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: _navigateToCategoryScreen,
              icon: const Icon(Icons.settings),
              label: const Text('Manage'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_error.isNotEmpty)
          Column(
            children: [
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadCategories,
                child: const Text('Retry'),
              ),
            ],
          )
        else if (_categories.isEmpty)
          Column(
            children: [
              const Text(
                'No categories found. Create a category first.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _navigateToCategoryScreen,
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
              ),
            ],
          )
        else
          // Category list
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Option for no category
              if (!widget.isRequired)
                GestureDetector(
                  onTap: () => _selectCategory(null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _selectedCategory == null 
                          ? Colors.grey.shade300 
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedCategory == null 
                            ? Colors.black 
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: const Text('None'),
                  ),
                ),
              
              // Category chips
              ..._categories.map((category) {
                final isSelected = category.id == _selectedCategory?.id;
                final categoryColor = _getCategoryColor(category.color);
                
                return GestureDetector(
                  onTap: () => _selectCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? categoryColor.withAlpha((255 * 0.2).round()) 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? categoryColor : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.icon != null) ...[
                          Icon(
                            _getIconData(category.icon!),
                            color: categoryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected 
                                ? categoryColor 
                                : AppTheme.textPrimary,
                            fontWeight: isSelected 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }
  
  /// Convert hex color string to Color
  Color _getCategoryColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      return Color(int.parse('FF${hexColor.substring(1)}', radix: 16));
    }
    return Colors.grey;
  }

  /// Get IconData from icon string in a tree-shake friendly way
  IconData _getIconData(String iconString) {
    try {
      final codePoint = int.parse(iconString);
      // Use a predefined set of common icons for better tree shaking
      switch (codePoint) {
        case 0xe047: return Icons.work;
        case 0xe88a: return Icons.home;
        case 0xe5ca: return Icons.favorite;
        case 0xe865: return Icons.shopping_cart;
        case 0xe5d2: return Icons.school;
        case 0xe571: return Icons.fitness_center;
        case 0xe3e7: return Icons.restaurant;
        case 0xe1b1: return Icons.travel_explore;
        case 0xe037: return Icons.computer;
        case 0xe3f7: return Icons.music_note;
        default:
          // Fallback to a safe default icon
          return Icons.category;
      }
    } catch (e) {
      return Icons.category;
    }
  }
}
