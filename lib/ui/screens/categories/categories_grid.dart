import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/config/app_categories.dart'; // Import the new category configuration
import 'package:vuet_app/ui/widgets/premium_tag.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';
import 'package:vuet_app/providers/setup_service_provider.dart';
import 'package:vuet_app/ui/screens/onboarding/category_introduction_screen.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';
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
    final isLargePhone = screenSize.width > 400 && screenSize.width <= 600;

    // Calculate cross axis count based on screen width
    final crossAxisCount = isTablet ? 4 : 3;

    // Calculate child aspect ratio and padding based on screen size
    final childAspectRatio = isTablet ? 1.2 : (isLargePhone ? 1.1 : 1.0);
    final gridPadding = isTablet ? 20.0 : (isLargePhone ? 18.0 : 16.0);
    final gridSpacing = isTablet ? 20.0 : (isLargePhone ? 18.0 : 16.0);

    // Calculate icon size based on screen size
    final iconSize = isTablet ? 56.0 : (isLargePhone ? 52.0 : 48.0);

    // Directly watch the provider which now returns List<CategoryDisplayGroup>
    final List<CategoryDisplayGroup> allDisplayGroups =
        ref.watch(personalCategoryDisplayGroupsProvider);

    final filteredDisplayGroups = searchQuery.isEmpty
        ? allDisplayGroups
        : allDisplayGroups
            .where((group) => group.displayName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(personalCategoryDisplayGroupsProvider);
        // Even though it's sync, a small delay might be perceived as a refresh action if desired
        await Future.delayed(const Duration(milliseconds: 50));
      },
      child: Builder(
          // Added Builder to ensure context for ScaffoldMessenger is correct if needed immediately
          builder: (context) {
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
          // Handles the case where allDisplayGroups itself is empty initially (e.g. error in config)
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

        return GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(gridPadding), // Responsive padding
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Responsive grid
            crossAxisSpacing: gridSpacing, // Responsive spacing
            mainAxisSpacing: gridSpacing, // Responsive spacing
            childAspectRatio: childAspectRatio, // Responsive aspect ratio
          ),
          itemCount: filteredDisplayGroups.length,
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
                            // Navigate directly to subcategory screen
                            final subCategoryKeys = actualCategoriesInGroup
                                .map((cat) => cat.id.toString())
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCategoryScreen(
                                  categoryId: categorySetupKey,
                                  categoryName: group.displayName,
                                  subCategoryKeys: subCategoryKeys,
                                ),
                              ),
                            );
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
                        elevation: 6.0, // Increased elevation
                        shadowColor: Colors.black.withOpacity(0.3), // Custom shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0), // Slightly larger radius
                        ),
                        color: AppTheme.primary, // Dark teal background
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
                              // Center Icon
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: iconSize + 20,
                                      height: iconSize + 20,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.accent.withOpacity(0.3),
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        _getCategoryIcon(groupId),
                                        color: AppTheme.accent, // Orange icon
                                        size: iconSize, // Responsive icon size
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      group.displayName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: isTablet
                                            ? 16.0
                                            : 14.0, // Responsive font size
                                        letterSpacing: 0.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
        );
      }),
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
