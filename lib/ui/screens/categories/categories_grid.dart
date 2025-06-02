import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart'; // Using EntityCategoryModel
import 'package:vuet_app/ui/widgets/premium_tag.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart'; // Import the subcategory screen
import 'package:vuet_app/providers/category_screen_providers.dart'; // Import centralized providers
import 'package:vuet_app/ui/screens/categories/category_introduction_screen.dart'; // Import the introduction screen

class CategoriesGrid extends ConsumerWidget {
  final String searchQuery;
  
  const CategoriesGrid({
    super.key,
    this.searchQuery = '',
  });

  // Define the 9 main category groups based on documentation
  static final List<Map<String, dynamic>> categoryGroups = [
    {
      'id': 'pets',
      'name': 'Pets',
      'color': '#8B4513', // Brown
      'categoryIds': <String>['pets'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'social_interests',
      'name': 'Social & Interests',
      'color': '#4682B4', // Steel Blue
      'categoryIds': <String>['social_interests'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'education_career',
      'name': 'Education & Career',
      'color': '#2E8B57', // Sea Green
      'categoryIds': <String>['education_career'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'travel',
      'name': 'Travel',
      'color': '#FF8C00', // Dark Orange
      'categoryIds': <String>['travel'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'health_beauty',
      'name': 'Health & Beauty',
      'color': '#9370DB', // Medium Purple
      'categoryIds': <String>['health_beauty'], // Explicitly typed as List<String>
      'isPremium': true,
    },
    {
      'id': 'home_garden',
      'name': 'Home & Garden',
      'color': '#3CB371', // Medium Sea Green
      'categoryIds': <String>['home_garden'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'finance',
      'name': 'Finance',
      'color': '#6A5ACD', // Slate Blue
      'categoryIds': <String>['finance'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'transport',
      'name': 'Transport',
      'color': '#CD5C5C', // Indian Red
      'categoryIds': <String>['transport'], // Explicitly typed as List<String>
      'isPremium': false,
    },
    {
      'id': 'references',
      'name': 'References',
      'color': '#808080', // Grey
      'categoryIds': <String>[], // Empty List<String> for special premium feature
      'isPremium': true,
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We still watch the categories provider to ensure we have the latest data
    // This will be used for subcategories when we navigate
    final categoriesAsyncValue = ref.watch(personalCategoriesProvider);

    // Create EntityCategoryModel objects from our defined groups
    final allGridItems = categoryGroups.map((group) => EntityCategoryModel(
      id: group['id'],
      name: group['name'],
      color: group['color'],
      ownerId: 'system',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isProfessional: false,
      // Store the categoryIds as a comma-separated string
      // Cast to List<String> to ensure correct type
      description: (group['categoryIds'] as List<String>).join(','),
    )).toList();
    
    // Filter grid items based on search query if provided
    final filteredGridItems = searchQuery.isEmpty
        ? allGridItems
        : allGridItems.where((category) => 
            category.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh categories by invalidating the provider
        ref.invalidate(personalCategoriesProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: categoriesAsyncValue.when(
        data: (fetchedCategories) {
          // We use the hardcoded grid items but we've still loaded the actual
          // categories for when we navigate to subcategories
          
          if (filteredGridItems.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No categories matching "$searchQuery"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: filteredGridItems.length,
            itemBuilder: (context, index) {
              final category = filteredGridItems[index];
              final isReferences = category.id == 'references';
              
              // Find the original index to get isPremium value
              final originalIndex = allGridItems.indexWhere((item) => item.id == category.id);
              final isPremium = categoryGroups[originalIndex]['isPremium'] as bool;

              // Use FutureBuilder for staggered animation effect
              return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 50 * index)),
                builder: (context, snapshot) {
                  final isReady = snapshot.connectionState == ConnectionState.done;
                  return AnimatedOpacity(
                    opacity: isReady ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: AnimatedScale(
                      scale: isReady ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: InkWell(
                        onTap: () {
                          if (isReferences) {
                            // References screen not implemented yet
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('References screen not implemented yet.')),
                            );
                          } else {
                            // For category groups, we need to pass the subcategory key directly
                            final subCategoryKeys = category.description?.split(',') ?? [];
                            
                            // Navigate to introduction screen based on category
                            Widget introScreen;
                            
                            switch (category.id) {
                              case 'pets':
                                introScreen = CategoryIntroFactory.createPetsIntro(
                                  onComplete: () {},
                                );
                                break;
                              case 'social_interests':
                                introScreen = CategoryIntroFactory.createSocialIntro(
                                  onComplete: () {},
                                );
                                break;
                              case 'education_career':
                                introScreen = CategoryIntroFactory.createEducationIntro(
                                  onComplete: () {},
                                );
                                break;
                              default:
                                // For other categories, create a generic intro
                                introScreen = CategoryIntroductionScreen(
                                  categoryId: category.id,
                                  categoryName: category.name,
                                  subCategoryKeys: subCategoryKeys,
                                  introPages: [
                                    CategoryIntroPage(
                                      content: "Welcome to the ${category.name} category. Here you can manage all your ${category.name.toLowerCase()} related items.",
                                      backgroundImage: 'assets/images/categories/${_getCategoryImageName(category.id)}.png',
                                    ),
                                  ],
                                );
                                break;
                            }
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => introScreen,
                              ),
                            );
                          }
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Use a placeholder color until we have proper images
                              Container(
                                color: Color(int.parse(category.color?.substring(1, 7) ?? '808080', radix: 16) + 0xFF000000).withAlpha((0.9 * 255).round()),
                              ),
                              
                              // Try to load category image but use color background if not found
                              Image.asset(
                                'assets/images/categories/${_getCategoryImageName(category.id)}.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox(); // Return empty widget, we already have the color background
                                },
                              ),
                              
                              // Category name overlay
                              Container(
                                color: Color(int.parse(category.color?.substring(1, 7) ?? '808080', radix: 16) + 0xFF000000).withAlpha((0.6 * 255).round()),
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    category.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              
                              // Premium tag
                              if (isPremium)
                                const Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: PremiumTag(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(personalCategoriesProvider);
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

  // Helper method to map category IDs to image names
  String _getCategoryImageName(String categoryId) {
    switch (categoryId) {
      case 'pets':
        return 'pets';
      case 'social_interests':
        return 'social';
      case 'education_career':
        return 'education';
      case 'travel':
        return 'travel';
      case 'health_beauty':
        return 'health';
      case 'home_garden':
        return 'home';
      case 'finance':
        return 'finance';
      case 'transport':
        return 'transport';
      case 'references':
        return 'charity';
      default:
        return categoryId;
    }
  }
}

// Extension to add delay to animations
extension AnimationDelay on Widget {
  Widget delay(Duration delay) {
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return this;
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
