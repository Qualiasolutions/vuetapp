import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart'; // Will be EntityCategory
import 'package:vuet_app/repositories/supabase_category_repository.dart'; // Import the repository
import 'package:vuet_app/providers/category_screen_providers.dart'; // Import centralized providers
// Assuming PremiumTag widget exists
// For generating dummy IDs


class ProfessionalCategoriesList extends ConsumerStatefulWidget {
  final String searchQuery;
  
  const ProfessionalCategoriesList({
    super.key,
    this.searchQuery = '',
  });

  @override
  ConsumerState<ProfessionalCategoriesList> createState() => _ProfessionalCategoriesListState();
}

class _ProfessionalCategoriesListState extends ConsumerState<ProfessionalCategoriesList> {
  EntityCategory? _editingCategory; // Updated
  String _editingCategoryName = '';
  bool _showCreateModal = false;
  String _newCategoryName = '';
  EntityCategory? _categoryToDelete; // Updated
  bool _showDeleteConfirmation = false;

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(professionalCategoriesProvider);
    final uncategorisedCountAsyncValue = ref.watch(uncategorisedEntitiesCountProvider);
    final repository = ref.read(supabaseCategoryRepositoryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh both providers by invalidating them
        ref.invalidate(professionalCategoriesProvider);
        ref.invalidate(uncategorisedEntitiesCountProvider);
        // Wait a moment for the providers to refresh
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: categoriesAsyncValue.when(
        data: (categories) {
          final uncategorisedCount = uncategorisedCountAsyncValue.when(
            data: (count) => count,
            loading: () => 0, // Default to 0 while loading
            error: (error, stack) => 0, // Default to 0 on error
          );
          
          // Filter categories based on search query if provided
          final filteredCategories = widget.searchQuery.isEmpty
              ? categories
              : categories.where((category) => 
                  (category.displayName ?? '').toLowerCase().contains(widget.searchQuery.toLowerCase())).toList(); // Updated to displayName
          
          // Show empty state for search with no results
          if (filteredCategories.isEmpty && widget.searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No categories matching "${widget.searchQuery}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling even with few items for pull-to-refresh
                padding: const EdgeInsets.all(10.0),
                itemCount: filteredCategories.length + (uncategorisedCount > 0 ? 1 : 0), // Add 1 for uncategorised if needed
                itemBuilder: (context, index) {
                  // Handle Uncategorised section
                  if (uncategorisedCount > 0 && index == filteredCategories.length) {
                     return Card(
                       child: ListTile(
                         title: const Text('Uncategorised'), // TODO: Localize
                         trailing: Text('($uncategorisedCount)'),
                         onTap: () {
                           // TODO: Implement navigation to uncategorised entities list screen
                           // Example: Navigator.pushNamed(context, '/uncategorisedEntities');
                           debugPrint('Tapped on Uncategorised');
                         },
                       ),
                     );
                  }

                  final category = filteredCategories[index];

                  return Card(
                    child: ListTile(
                      title: Text(category.displayName ?? ''), // Updated to displayName
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _editingCategory = category;
                                _editingCategoryName = category.displayName ?? ''; // Updated to displayName
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _categoryToDelete = category;
                                _showDeleteConfirmation = true;
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Implement navigation to professional category detail screen
                        // Example: Navigator.pushNamed(context, '/professionalCategoryDetail', arguments: category.id);
                        debugPrint('Tapped on professional category: ${category.displayName}'); // Updated to displayName
                      },
                    ),
                  );
                },
              ),
            ),
            // Button to add new category
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showCreateModal = true;
                    _newCategoryName = ''; // Clear previous input
                  });
                },
                child: const Text('Add New Category'), // TODO: Localize
              ),
            ),

            // Create Category Modal
            if (_showCreateModal)
              AlertDialog(
                title: const Text('Create New Category'), // TODO: Localize
                content: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Category Name'), // TODO: Localize
                  onChanged: (value) {
                    _newCategoryName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showCreateModal = false;
                      });
                    },
                    child: const Text('Cancel'), // TODO: Localize
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_newCategoryName.isNotEmpty) {
                        // Create a professional category
                        // Note: 'isProfessional' is not a field in the new EntityCategory model or DB table.
                        // This logic might need adjustment based on how professional categories are now identified.
                        // For now, creating a general category.
                        final newCategory = EntityCategory(
                          id: '', // Supabase will generate UUID if column is PK with default
                          name: _newCategoryName.toLowerCase().replaceAll(' ', '_'), // Internal name
                          displayName: _newCategoryName,
                          // iconName, colorHex, sortOrder can be set to defaults or prompted
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          // isDisplayedOnGrid: true, // Default for professional categories?
                        );
                        await repository.createCategory(newCategory);
                        // Refresh categories after creation
                        ref.invalidate(professionalCategoriesProvider);
                        setState(() {
                          _showCreateModal = false;
                        });
                      }
                    },
                    child: const Text('Create'), // TODO: Localize
                  ),
                ],
              ),

            // Edit Category Modal
            if (_editingCategory != null)
              AlertDialog(
                title: const Text('Edit Category'), // TODO: Localize
                content: TextField(
                  autofocus: true,
                  controller: TextEditingController(text: _editingCategoryName),
                  decoration: const InputDecoration(hintText: 'Category Name'), // TODO: Localize
                  onChanged: (value) {
                    _editingCategoryName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _editingCategory = null;
                        _editingCategoryName = '';
                      });
                    },
                    child: const Text('Cancel'), // TODO: Localize
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_editingCategoryName.isNotEmpty && _editingCategory != null) {
                        // Create updated category with the new name
                        final updatedCategory = _editingCategory!.copyWith(
                          displayName: _editingCategoryName, // Assuming internal 'name' doesn't change, only display name
                          updatedAt: DateTime.now(),
                        );
                        await repository.updateCategory(updatedCategory);
                        // Refresh categories after update
                        ref.invalidate(professionalCategoriesProvider);
                        setState(() {
                          _editingCategory = null;
                          _editingCategoryName = '';
                        });
                      }
                    },
                    child: const Text('Save'), // TODO: Localize
                  ),
                ],
              ),

            // Delete Confirmation Modal
            if (_showDeleteConfirmation && _categoryToDelete != null)
              AlertDialog(
                title: const Text('Confirm Deletion'), // TODO: Localize
                content: Text('Are you sure you want to delete "${_categoryToDelete!.displayName}"?'), // Updated to displayName // TODO: Localize
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showDeleteConfirmation = false;
                        _categoryToDelete = null;
                      });
                    },
                    child: const Text('No'), // TODO: Localize
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_categoryToDelete != null) {
                        await repository.deleteCategory(_categoryToDelete!.id);
                        // Refresh categories after deletion
                        ref.invalidate(professionalCategoriesProvider);
                        setState(() {
                          _showDeleteConfirmation = false;
                          _categoryToDelete = null;
                        });
                      }
                    },
                    child: const Text('Yes'), // TODO: Localize
                  ),
                ],
              ),
          ],
        );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(professionalCategoriesProvider);
            ref.invalidate(uncategorisedEntitiesCountProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(child: Text('Error: $error\n\nPull to refresh')),
            ),
          ),
        ),
      ),
    );
  }
}
