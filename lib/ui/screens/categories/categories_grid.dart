import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/config/app_categories.dart'; // Import the new category configuration
import 'package:vuet_app/ui/widgets/premium_tag.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';
import 'package:vuet_app/providers/setup_service_provider.dart';
import 'package:vuet_app/ui/screens/onboarding/category_introduction_screen.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/pets_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/social_interests_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/education_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/travel_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/finance_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/transport_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/health_beauty_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/home_garden_category_screen.dart';
import 'package:vuet_app/ui/screens/categories/charity_religion_category_screen.dart';
import 'package:vuet_app/ui/theme/app_theme.dart'; // Add import for AppTheme

class CategoriesGrid extends ConsumerWidget {
  final String searchQuery;

  const CategoriesGrid({
    super.key,
    this.searchQuery = '',
  });

  // Helper to convert display name to a switch-case friendly ID
  String _getGroupId(String displayName) {
    return displayName
        .toLowerCase()
        .replaceAll(' & ', '_and_')
        .replaceAll(' ', '_');
  }

  // Get appropriate icon for each category
  IconData _getCategoryIcon(String groupId) {
    switch (groupId) {
      case 'pets':
        return Icons.pets;
      case 'social_interests':
        return Icons.people;
      case 'education_and_career':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'health_and_beauty':
        return Icons.spa;
      case 'home_and_garden':
        return Icons.home;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'transport':
        return Icons.directions_car;
      case 'references':
        return Icons.auto_stories;
      default:
        return Icons.category;
    }
  }

  String _getCategorySetupKey(String displayName) {
    // Map display names to setup content keys
    switch (displayName.toLowerCase()) {
      case 'pets':
        return 'pets';
      case 'social interests':
        return 'social_interests';
      case 'education & career':
        return 'education'; // Use education as primary for the combined group
      case 'travel':
        return 'travel';
      case 'health & beauty':
        return 'health_beauty';
      case 'home & garden':
        return 'home'; // Use home as primary for the combined group
      case 'finance':
        return 'finance';
      case 'transport':
        return 'transport';
      default:
        return displayName
            .toLowerCase()
            .replaceAll(' & ', '_')
            .replaceAll(' ', '_');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    // Keep 3 columns on phones, 4 on tablets
    final crossAxisCount = isTablet ? 4 : 3;

    // Calculate padding to maximize screen usage
    final gridPadding = 10.0;
    final gridSpacing = 10.0;

    // Calculate icon size proportionally to screen width but ensure minimum size
    final iconSize =
        (screenSize.width / (crossAxisCount * 2.8)).clamp(40.0, 56.0);

    // Directly watch the provider which now returns List<CategoryDisplayGroup>
    final List<CategoryDisplayGroup> allDisplayGroups =
        ref.watch(personalCategoryDisplayGroupsProvider);

    // Filter out the family category and apply search query if any
    final filteredDisplayGroups = allDisplayGroups
        .where((group) =>
            group.displayName.toLowerCase() !=
                "family" && // Filter out family category
            (searchQuery.isEmpty ||
                group.displayName
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())))
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(personalCategoryDisplayGroupsProvider);
        await Future.delayed(const Duration(milliseconds: 50));
      },
      child: Builder(builder: (context) {
        if (filteredDisplayGroups.isEmpty && searchQuery.isNotEmpty) {
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
        if (filteredDisplayGroups.isEmpty &&
            searchQuery.isEmpty &&
            allDisplayGroups.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                SizedBox(height: 16),
                Text(
                  'No categories available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Calculate rows needed for a perfect 3x3 grid if needed
        final int itemCount = filteredDisplayGroups.length;

        return Padding(
          padding: EdgeInsets.all(gridPadding),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              // Expanded aspect ratio for better spacing
              childAspectRatio: 1.0,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final group = filteredDisplayGroups[index];
              final groupId = _getGroupId(group.displayName);
              final isReferences = group.displayName == 'References';

              return FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 50 * index)),
                builder: (context, snapshot) {
                  final isReady =
                      snapshot.connectionState == ConnectionState.done;
                  return AnimatedOpacity(
                    opacity: isReady ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: AnimatedScale(
                      scale: isReady ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: InkWell(
                        onTap: () async {
                          if (isReferences) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'References is a premium feature that will be available soon.')),
                            );
                          } else {
                            final List<AppCategory> actualCategoriesInGroup =
                                getCategoriesInGroup(group.displayName);
                            String categorySetupKey =
                                _getCategorySetupKey(group.displayName);

                            // Check if setup is already completed
                            final setupService = ref.read(setupServiceProvider);
                            final isCompleted = await setupService
                                .isCategorySetupCompleted(categorySetupKey);

                            if (!context.mounted) return;

                            if (isCompleted) {
                              // Navigate directly to category-specific screen
                              _navigateToCategoryScreen(context, group.displayName);
                            } else {
                              // Show introduction screen
                              final introScreen = CategoryIntroductionScreen(
                                categoryId: categorySetupKey,
                                categoryName: group.displayName,
                                onComplete: () {
                                  // Optional completion callback
                                },
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => introScreen,
                                ),
                              );
                            }
                          }
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6.0,
                          shadowColor: Colors.black.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          color: AppTheme.primary,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primary,
                                  AppTheme.primary.withOpacity(0.85),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Decorative corner accent
                                Positioned(
                                  top: -15,
                                  right: -15,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppTheme.accent.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                // Main content with perfectly centered icon and text
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Icon container with enhanced styling
                                      Container(
                                        width: iconSize + 16,
                                        height: iconSize + 16,
                                        decoration: BoxDecoration(
                                          color:
                                              AppTheme.primary.withOpacity(0.8),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.accent
                                                .withOpacity(0.5),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _getCategoryIcon(groupId),
                                            color: AppTheme.accent,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Category name with perfect centering
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          group.displayName,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            height: 1.2,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Premium Tag
                                if (group.isPremium)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: PremiumTag(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  // Navigate to the appropriate category-specific screen
  void _navigateToCategoryScreen(BuildContext context, String displayName) {
    Widget screen;
    
    switch (displayName.toLowerCase()) {
      case 'pets':
        screen = const PetsCategoryScreen();
        break;
      case 'social interests':
        screen = const SocialInterestsCategoryScreen();
        break;
      case 'education & career':
        screen = const EducationCategoryScreen();
        break;
      case 'travel':
        screen = const TravelCategoryScreen();
        break;
      case 'health & beauty':
        screen = const HealthBeautyCategoryScreen();
        break;
      case 'home & garden':
        screen = const HomeGardenCategoryScreen();
        break;
      case 'finance':
        screen = const FinanceCategoryScreen();
        break;
      case 'transport':
        screen = const TransportCategoryScreen();
        break;
      case 'charity & religion':
        screen = const CharityReligionCategoryScreen();
        break;
      default:
        screen = SubCategoryScreen(
          categoryId: displayName.toLowerCase().replaceAll(' & ', '_').replaceAll(' ', '_'),
          categoryName: displayName,
          subCategoryKeys: const [],
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

// Ensure CategoryIntroFactory is defined and implemented elsewhere in your project.
// Example (remove if actual factory exists):
/* 
class CategoryIntroFactory {
  static Widget createPetsIntro({required VoidCallback onComplete}) => _DummyIntro('Pets Intro', onComplete);
  static Widget createSocialIntro({required VoidCallback onComplete}) => _DummyIntro('Social Intro', onComplete);
  static Widget createEducationIntro({required VoidCallback onComplete}) => _DummyIntro('Education Intro', onComplete);
  static Widget createTravelIntro({required VoidCallback onComplete}) => _DummyIntro('Travel Intro', onComplete);
  static Widget createHealthBeautyIntro({required VoidCallback onComplete}) => _DummyIntro('Health & Beauty Intro', onComplete);
  static Widget createHomeGardenIntro({required VoidCallback onComplete}) => _DummyIntro('Home & Garden Intro', onComplete);
  static Widget createFinanceIntro({required VoidCallback onComplete}) => _DummyIntro('Finance Intro', onComplete);
  static Widget createTransportIntro({required VoidCallback onComplete}) => _DummyIntro('Transport Intro', onComplete);
}

class _DummyIntro extends StatelessWidget {
  final String title;
  final VoidCallback onComplete;
  const _DummyIntro(this.title, this.onComplete);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the $title screen.'),
            ElevatedButton(
              onPressed: () {
                onComplete();
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              child: const Text('Done'),
            )
          ],
        ),
      ),
    );
  }
}
*/
