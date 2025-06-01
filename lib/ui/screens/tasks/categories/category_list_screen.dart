import 'package:flutter/material.dart';
import 'package:vuet_app/models/task_category_model.dart';
import 'package:vuet_app/services/task_category_service.dart';
import 'package:vuet_app/ui/screens/tasks/categories/create_category_screen.dart';
import 'package:vuet_app/ui/screens/tasks/categories/edit_category_screen.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';

/// Screen for displaying and managing task categories
class CategoryListScreen extends StatefulWidget {
  /// Constructor
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final TaskCategoryService _categoryService = TaskCategoryService();
  
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
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading categories: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await _categoryService.deleteCategory(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted')),
      );
      _loadCategories();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category: $e')),
      );
    }
  }

  void _navigateToCreateCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCategoryScreen(),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh if a new category was created
        _loadCategories();
      }
    });
  }

  void _navigateToEditCategory(TaskCategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(category: category),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh if the category was updated
        _loadCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCategories,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _categories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No categories yet',
                            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _navigateToCreateCategory,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Category'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final categoryColor = _getCategoryColor(category.color);
                        
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: categoryColor,
                            child: category.icon != null
                                ? Icon(
                                    _getIconData(category.icon!),
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          title: Text(category.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _navigateToEditCategory(category),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _showDeleteConfirmation(category),
                              ),
                            ],
                          ),
                          onTap: () => _navigateToEditCategory(category),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateCategory,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Show a confirmation dialog before deleting a category
  void _showDeleteConfirmation(TaskCategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text('Are you sure you want to delete "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteCategory(category.id);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
