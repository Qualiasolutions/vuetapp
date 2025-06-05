import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/config/app_categories.dart'; // Import the new category configuration
import 'package:vuet_app/ui/widgets/premium_tag.dart';
import 'package:vuet_app/providers/category_screen_providers.dart';
import 'package:vuet_app/providers/setup_service_provider.dart';
import 'package:vuet_app/ui/screens/onboarding/category_introduction_screen.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';

class CategoriesGrid extends ConsumerWidget {
  final String searchQuery;
  
  const CategoriesGrid({
    super.key,
    this.searchQuery = '',
  });

  // Helper to convert display name to a switch-case friendly ID
  String _getGroupId(String displayName) {
    return displayName.toLowerCase().replaceAll(' & ', '_and_').replaceAll(' ', '_');
  }

  String _getCategoryImageName(String groupId) {
    // This function might need more robust logic if image names don't directly match group IDs
    // For now, assume direct mapping or a simple lookup
    // Example: 'pets.png', 'social_interests.png'
    if (groupId == 'social_interests') return 'social.png'; // Example specific mapping if names differ
    if (groupId == 'health_and_beauty') return 'health.png';
    if (groupId == 'home_and_garden') return 'home.png'; // Assuming a generic home image
    if (groupId == 'education_and_career') return 'education.png'; // Added mapping
    if (groupId == 'references') return 'charity.png'; // Added mapping, though References is special
    return '\${groupId}.png';
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
        return displayName.toLowerCase().replaceAll(' & ', '_').replaceAll(' ', '_');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Directly watch the provider which now returns List<CategoryDisplayGroup>
    final List<CategoryDisplayGroup> allDisplayGroups = ref.watch(personalCategoryDisplayGroupsProvider);

    final filteredDisplayGroups = searchQuery.isEmpty
        ? allDisplayGroups
        : allDisplayGroups.where((group) => 
            group.displayName.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(personalCategoryDisplayGroupsProvider);
        // Even though it's sync, a small delay might be perceived as a refresh action if desired
        await Future.delayed(const Duration(milliseconds: 50)); 
      },
      child: Builder( // Added Builder to ensure context for ScaffoldMessenger is correct if needed immediately
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
          if (filteredDisplayGroups.isEmpty && searchQuery.isEmpty && allDisplayGroups.isEmpty) {
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
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: filteredDisplayGroups.length,
            itemBuilder: (context, index) {
              final group = filteredDisplayGroups[index];
              final groupId = _getGroupId(group.displayName);
              final isReferences = group.displayName == 'References';

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
                        onTap: () async {
                          if (isReferences) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('References is a premium feature that will be available soon.')),
                            );
                          } else {
                            final List<AppCategory> actualCategoriesInGroup = getCategoriesInGroup(group.displayName);
                            String categorySetupKey = _getCategorySetupKey(group.displayName);
                            
                            // Check if setup is already completed
                            final setupService = ref.read(setupServiceProvider);
                            final isCompleted = await setupService.isCategorySetupCompleted(categorySetupKey);
                            
                            if (!context.mounted) return;
                            
                            if (isCompleted) {
                              // Navigate directly to subcategory screen
                              final subCategoryKeys = actualCategoriesInGroup.map((cat) => cat.id.toString()).toList();
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
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/images/categories/${_getCategoryImageName(groupId)}',
                                  fit: BoxFit.cover,
                                  // Optional: Add error builder for image loading
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.category, size: 50, color: Colors.grey[600]),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    gradient: LinearGradient(
                                      colors: [Colors.black.withAlpha((0.7 * 255).round()), Colors.transparent],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              if (group.isPremium)
                                const Positioned(
                                  top: 8,
                                  right: 8,
                                  child: PremiumTag(),
                                ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Text(
                                  group.displayName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0, // Increased font size
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black54,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
        }
      ),
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
