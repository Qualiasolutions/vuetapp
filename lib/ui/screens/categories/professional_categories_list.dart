import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart'; // Import the repository
import 'package:vuet_app/providers/category_screen_providers.dart'; // Import centralized providers
// Assuming PremiumTag widget exists
// For generating dummy IDs


class ProfessionalCategoriesList extends ConsumerStatefulWidget {
  const ProfessionalCategoriesList({super.key});

  @override
  ConsumerState<ProfessionalCategoriesList> createState() => _ProfessionalCategoriesListState();
}

class _ProfessionalCategoriesListState extends ConsumerState<ProfessionalCategoriesList> {
  EntityCategoryModel? _editingCategory;
  String _editingCategoryName = '';
  bool _showCreateModal = false;
  String _newCategoryName = '';
  EntityCategoryModel? _categoryToDelete;
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

          return Column(
          children: [
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(), // Enable scrolling even with few items for pull-to-refresh
                padding: const EdgeInsets.all(10.0),
                itemCount: categories.length + (uncategorisedCount > 0 ? 1 : 0), // Add 1 for uncategorised if needed
                itemBuilder: (context, index) {
                  // Handle Uncategorised section
                  if (uncategorisedCount > 0 && index == categories.length) {
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

                  final category = categories[index];

                  return Card(
                    child: ListTile(
                      title: Text(category.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _editingCategory = category;
                                _editingCategoryName = category.name;
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
                        debugPrint('Tapped on professional category: ${category.name}');
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
                        final newCategory = EntityCategoryModel(
                          id: '', // Will be generated by the repository
                          name: _newCategoryName,
                          ownerId: 'dummy_user_id', // TODO: Get actual user ID
                          isProfessional: true,
                          createdAt: DateTime.now(),
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
                          name: _editingCategoryName,
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
                content: Text('Are you sure you want to delete "${_categoryToDelete!.name}"?'), // TODO: Localize
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
