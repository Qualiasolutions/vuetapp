import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart'; // Using EntityCategoryModel
import 'package:vuet_app/ui/widgets/premium_tag.dart';
import 'package:vuet_app/repositories/supabase_category_repository.dart'; // Import the repository
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart'; // Import the subcategory screen

// Provider for personal categories, fetching data from the repository
final personalCategoriesProvider = FutureProvider<List<EntityCategoryModel>>((ref) async {
  final repository = ref.read(supabaseCategoryRepositoryProvider);
  return repository.fetchPersonalCategories();
});

class CategoriesGrid extends ConsumerWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsyncValue = ref.watch(personalCategoriesProvider);

    // Dummy data for the "Charity and Religion" tile (will likely be fetched from backend later)
    final referencesCategory = EntityCategoryModel(
      id: 'charity',
      name: 'Charity and Religion',
      color: '#808080', // Grey color
      ownerId: 'system',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return categoriesAsyncValue.when(
      data: (categories) {
        // Filter out "Routines" category
        final filteredCategories = categories.where((category) => category.name.toLowerCase() != 'routines').toList();
        
        // Combine filtered categories and references for the grid
        final allGridItems = [...filteredCategories, referencesCategory];

        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust as needed
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0, // Adjust as needed
          ),
          itemCount: allGridItems.length,
          itemBuilder: (context, index) {
            final category = allGridItems[index];
            final isReferences = category.id == 'charity';

            return InkWell(
              onTap: () {
                if (isReferences) {
                  // TODO: Implement navigation to References screen
                  debugPrint('Tapped on References');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('References screen not implemented yet.')),
                  );
                } else {
                  // Navigate to SubCategoryScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoryScreen.fromCategoryId(
                        parentCategoryName: category.name,
                        parentCategoryId: category.id.toUpperCase(),
                      ),
                    ),
                  );
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias, // Clip content to card shape
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Implement ImageBackground similar to React version
                    Image.asset(
                      'assets/images/categories/${category.name.toLowerCase().replaceAll(' & ', '_').replaceAll(' ', '_')}.png', // Placeholder image path
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Handle cases where the image asset is not found
                        return Container(color: Colors.grey[300]); // Placeholder color
                      },
                    ),
                    Container(
                      color: Color(int.parse(category.color?.substring(1, 7) ?? '808080', radix: 16) + 0xFF000000).withAlpha((0.7 * 255).round()), // Overlay color with category color
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (isReferences) // Assuming References is always premium in the old app
                       const Positioned(
                         bottom: 5,
                         right: 5,
                         child: PremiumTag(),
                       ),
                    // TODO: Implement logic to display PremiumTag based on actual category data (e.g., category.is_premium)
                    // if (category.is_premium) // Placeholder for actual premium check
                    //    const Positioned(
                    //      bottom: 5,
                    //      right: 5,
                    //      child: PremiumTag(),
                    //    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
