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
  // This might still be useful for other logic or can be removed if not needed.
  String _getGroupId(String displayName) {
    return displayName
        .toLowerCase()
        .replaceAll(' & ', '_and_')
        .replaceAll(' ', '_');
  }

  // Maps string icon names from the database to Material IconData
  IconData _getIconFromString(String? iconName) {
    if (iconName == null) return Icons.category; // Default icon
    // Ensure iconName is treated as case-insensitive for matching
    switch (iconName.toLowerCase()) {
      // Main Categories & Aliases
      case 'family':
      case 'family_restroom':
        return Icons.family_restroom;
      case 'pets':
        return Icons.pets;
      case 'social_interests':
      case 'people':
        return Icons.people;
      case 'education':
      case 'education_and_career':
      // 'school' is also a subcategory key, handled below if more specific icon needed
        return Icons.school;
      case 'career':
      // 'work' is also a subcategory key
        return Icons.work;
      case 'travel':
      // 'flight' is also a subcategory key
        return Icons.flight_takeoff; // Main travel icon
      case 'health_beauty':
      case 'health_and_beauty':
      case 'spa': // Also a direct subcategory icon string
        return Icons.spa;
      case 'home':
      case 'home_and_garden':
      // 'home_property' is a subcategory key
        return Icons.home;
      case 'garden':
      // 'garden_generic' is a subcategory key
        return Icons.local_florist; // Main garden icon
      case 'food':
      // 'restaurant' is also a subcategory key/direct icon string
        return Icons.restaurant; // Main food icon
      case 'laundry':
        return Icons.local_laundry_service;
      case 'finance':
      case 'account_balance_wallet':
      case 'account_balance':
        return Icons.account_balance_wallet;
      case 'transport':
      case 'directions_car': // Also a subcategory key 'car'
        return Icons.directions_car;
      case 'charity_religion':
      case 'church':
        return Icons.church;

      // PETS Subcategories
      case 'pet': // Generic pet, covered by main 'pets' if not distinct
        return Icons.pets_outlined;
      case 'bird':
        return Icons.flutter_dash; // Placeholder, consider Icons.emoji_nature
      case 'cat':
        return Icons.pets_outlined; // No specific Material cat icon
      case 'dog':
        return Icons.pets_outlined; // No specific Material dog icon
      case 'fish':
        return Icons.waves_outlined; 
      case 'other_pet':
        return Icons.pets_outlined;
      case 'vet':
        return Icons.medical_services_outlined;
      case 'pet_walker':
        return Icons.directions_walk_outlined;
      case 'pet_groomer':
        return Icons.content_cut_outlined;
      case 'pet_sitter':
        return Icons.home_work_outlined;
      case 'microchip_company':
        return Icons.memory_outlined;
      case 'insurance_company_pet': 
      case 'insurance_company': 
        return Icons.shield_outlined;
      case 'insurance_policy_pet': 
      case 'insurance_policy': 
        return Icons.article_outlined;
      case 'pet_birthday':
        return Icons.cake_outlined;

      // SOCIAL INTERESTS Subcategories
      case 'event':
        return Icons.event_outlined;
      case 'hobby':
        return Icons.interests_outlined;
      case 'holiday_social': // key from _iconPath
      case 'holiday': // general holiday
        return Icons.celebration_outlined;
      case 'holiday_plan_social': // key from _iconPath
      case 'holiday_plan':
        return Icons.edit_calendar_outlined;
      case 'social_plan':
        return Icons.group_outlined;
      case 'social_media':
        return Icons.share_outlined;
      case 'anniversary_plan':
        return Icons.edit_calendar_outlined;
      case 'birthday':
        return Icons.cake_outlined; // Shared with pet_birthday
      case 'anniversary':
        return Icons.auto_awesome_outlined;
      case 'event_subentity':
        return Icons.event_note_outlined;
      case 'guest_list_invite':
        return Icons.list_alt_outlined;

      // EDUCATION Subcategories
      case 'school': // Subcategory, distinct from main 'Education' if needed
        return Icons.school_outlined;
      case 'subject':
        return Icons.book_online_outlined;
      case 'course_work':
        return Icons.assignment_ind_outlined;
      case 'teacher':
        return Icons.person_pin_outlined;
      case 'tutor':
        return Icons.supervisor_account_outlined;
      case 'academic_plan':
        return Icons.assessment_outlined;
      case 'extracurricular_plan':
        return Icons.sports_soccer_outlined;
      case 'student':
        return Icons.face_retouching_natural_outlined;
      case 'school_break':
        return Icons.beach_access_outlined;
      case 'school_term':
        return Icons.date_range_outlined;
      case 'school_term_end':
        return Icons.event_available_outlined;
      case 'school_term_start':
        return Icons.event_note_outlined;
      case 'school_year_end':
        return Icons.emoji_events_outlined;
      case 'school_year_start':
        return Icons.flag_circle_outlined;

      // CAREER Subcategories
      case 'work': // Subcategory, distinct from main 'Career' if needed
        return Icons.work_outline;
      case 'colleague':
        return Icons.people_alt_outlined;
      case 'career_goal':
        return Icons.emoji_flags_outlined;
      case 'days_off':
        return Icons.weekend_outlined;
      case 'employee':
        return Icons.badge_outlined;

      // TRAVEL Subcategories
      case 'trip':
        return Icons.explore_outlined;
      case 'accommodations': // Direct name 'hotel'
      case 'hotel':
        return Icons.hotel_outlined;
      case 'attractions': // Direct name 'photo_camera'
      case 'photo_camera':
        return Icons.photo_camera_outlined;
      case 'drive_time':
        return Icons.timer_outlined;
      case 'flight': // Subcategory, distinct from main 'Travel' if needed
        return Icons.flight_outlined;
      case 'holiday_travel':
        return Icons.luggage_outlined;
      case 'holiday_plan_travel':
        return Icons.calendar_month_outlined;
      case 'hotel_or_rental':
        return Icons.holiday_village_outlined;
      case 'rental_car':
        return Icons.car_rental_outlined;
      case 'stay_with_friend':
        return Icons.night_shelter_outlined;
      case 'taxi_or_transfer':
        return Icons.local_taxi_outlined;
      case 'train_bus_ferry':
        return Icons.commute_outlined;
      case 'travel_plan':
        return Icons.map_outlined;

      // HEALTH & BEAUTY Subcategories
      case 'doctor':
        return Icons.medical_information_outlined;
      case 'dentist':
        return Icons.tag_faces_outlined;
      case 'beauty_salon':
        return Icons.storefront_outlined;
      case 'stylist':
        return Icons.cut_outlined;
      case 'appointment':
        return Icons.calendar_today_outlined;
      case 'beauty_generic': // Direct name 'spa', covered by main
        return Icons.spa_outlined; // Explicit for subcategory
      case 'fitness_activity': // Direct name 'fitness_center'
      case 'fitness_center':
        return Icons.fitness_center_outlined;
      case 'health_goal':
        return Icons.favorite_border_outlined;
      case 'medical_generic': // Direct name 'local_hospital'
      case 'local_hospital':
        return Icons.local_hospital_outlined;
      case 'patient':
        return Icons.personal_injury_outlined;

      // HOME Subcategories
      case 'home_property': // key from _iconPath
        return Icons.home_outlined; // Explicit for subcategory
      case 'room':
        return Icons.meeting_room_outlined;
      case 'furniture':
        return Icons.chair_outlined;
      case 'appliance':
        return Icons.kitchen_outlined;
      case 'contractor':
        return Icons.construction_outlined;
      case 'cleaning_home': // Direct name 'cleaning_services'
      case 'cleaning_services':
        return Icons.cleaning_services_outlined;
      case 'cooking_home': 
        return Icons.soup_kitchen_outlined;
      case 'home_maintenance_tasks': // Direct name 'home_repair_service'
      case 'home_repair_service':
        return Icons.home_repair_service_outlined;

      // GARDEN Subcategories
      case 'plant':
        return Icons.eco_outlined;
      case 'garden_tool':
        return Icons.handyman_outlined;
      case 'garden_generic':
        return Icons.grass_outlined;
      case 'gardening_tasks': // Direct name 'yard'
      case 'yard':
        return Icons.yard_outlined;
      
      // FOOD Subcategories
      case 'food_plan':
        return Icons.restaurant_menu_outlined;
      case 'recipe':
        return Icons.menu_book_outlined;
      // 'restaurant' (main food icon) also from _iconPath('restaurant')
      case 'food_generic':
        return Icons.lunch_dining_outlined;

      // LAUNDRY Subcategories
      case 'laundry_item':
        return Icons.checkroom_outlined;
      case 'dry_cleaners':
        return Icons.dry_cleaning_outlined;
      case 'clothing_laundry':
        return Icons.style_outlined; // Corrected from styler_outlined
      case 'laundry_plan':
        return Icons.event_note_outlined;

      // FINANCE Subcategories
      case 'bank': 
        return Icons.account_balance_outlined; // More specific than main finance icon
      case 'credit_card':
        return Icons.credit_card_outlined;
      case 'bank_account':
        return Icons.account_box_outlined;
      case 'finance_generic':
        return Icons.savings_outlined;

      // TRANSPORT Subcategories
      case 'car': // key from _iconPath('car'), covered by main 'transport'
        return Icons.directions_car_outlined; // Explicit for subcategory
      case 'boat': // key from _iconPath('boat')
        return Icons.directions_boat_outlined;
      case 'public_transport_cat': // key from _iconPath('public_transport')
      case 'public_transport':
        return Icons.train_outlined;

      // From Hierarchical Dialog specific additions / other existing
      case 'local_florist': // Already in Hierarchical, good for main Garden
         return Icons.local_florist_outlined;
      // 'restaurant' already handled for Food main/sub
      // 'local_laundry_service' already handled for Laundry main
      case 'favorite': // From Hierarchical, was spa, now favorite
         return Icons.favorite_outlined;

      default:
        print('Unknown iconName: $iconName, using default.'); // Optional: for debugging
        return Icons.category; // Fallback icon
    }
  }

  // String _getCategorySetupKey(String displayName) { // This method will be replaced by using group.systemName directly
  //   // Map display names to setup content keys
  //   switch (displayName.toLowerCase()) {
  //     case 'pets':
  //       return 'pets';
  //     case 'social interests':
  //       return 'social_interests';
  //     case 'education & career':
  //       return 'education'; // Use education as primary for the combined group
  //     case 'travel':
  //       return 'travel';
  //     case 'health & beauty':
  //       return 'health_beauty';
  //     case 'home & garden':
  //       return 'home'; // Use home as primary for the combined group
  //     case 'finance':
  //       return 'finance';
  //     case 'transport':
  //       return 'transport';
  //     default:
  //       return displayName
  //           .toLowerCase()
  //           .replaceAll(' & ', '_')
  //           .replaceAll(' ', '_');
  //   }
  // }

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

    // Apply search query if any. Filtering by isDisplayedOnGrid is now handled by the provider.
    final filteredDisplayGroups = allDisplayGroups
        .where((group) =>
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
              // final groupId = _getGroupId(group.displayName); // Unused variable
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
                            // Use group.systemName (which is EntityCategory.name) as the categoryId for setup and intro.
                            // This is more stable than displayName.
                            // Ensure group.systemName is not null or empty if it's critical.
                            // For now, we assume it's valid.
                            // final List<AppCategory> actualCategoriesInGroup = getCategoriesInGroup(group.displayName); // Removed, uses old static data
                            final String categorySetupKey = group.systemName.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and');

                            // Check if setup is already completed
                            final setupService = ref.read(setupServiceProvider);
                            final isCompleted = await setupService
                                .isCategorySetupCompleted(categorySetupKey);

                            if (!context.mounted) return;

                            if (isCompleted) {
                              // Navigate directly to category-specific screen
                              // Pass group.systemName or group.displayName as needed by _navigateToCategoryScreen
                              _navigateToCategoryScreen(context, group.systemName, group.displayName);
                            } else {
                              // Show introduction screen
                              final introScreen = CategoryIntroductionScreen(
                                categoryId: categorySetupKey, // Use the system name based key
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
                                            _getIconFromString(group.iconName), // Use new icon logic
                                            color: AppTheme.accent,
                                            size: iconSize,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Reduced from 12
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
                                            fontSize: 13.0, // Reduced from 14.0
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
                                if (group.isPremium == true) // Handle nullable bool
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
  void _navigateToCategoryScreen(BuildContext context, String systemName, String displayName) {
    Widget screen;
    
    // systemName is EntityCategory.name, e.g., "PETS", "SOCIAL_INTERESTS", "HOME_AND_GARDEN"
    // These should match the 'name' column in the entity_categories table.
    switch (systemName) { 
      case 'PETS':
        screen = const PetsCategoryScreen(); // These screens might need displayName for their AppBar title
        break;
      case 'SOCIAL_INTERESTS':
        screen = const SocialInterestsCategoryScreen();
        break;
      case 'EDUCATION_AND_CAREER': // Assuming EntityCategory.name is 'EDUCATION_AND_CAREER'
        screen = const EducationCategoryScreen();
        break;
      case 'TRAVEL':
        screen = const TravelCategoryScreen();
        break;
      case 'HEALTH_AND_BEAUTY': // Assuming EntityCategory.name is 'HEALTH_AND_BEAUTY'
        screen = const HealthBeautyCategoryScreen();
        break;
      case 'HOME_AND_GARDEN': // Assuming EntityCategory.name is 'HOME_AND_GARDEN'
        screen = const HomeGardenCategoryScreen();
        break;
      case 'FINANCE':
        screen = const FinanceCategoryScreen();
        break;
      case 'TRANSPORT':
        screen = const TransportCategoryScreen();
        break;
      case 'CHARITY_AND_RELIGION': // Assuming EntityCategory.name is 'CHARITY_AND_RELIGION'
        screen = const CharityReligionCategoryScreen();
        break;
      default:
        // Pass systemName as categoryId, and displayName for display purposes
        screen = SubCategoryScreen(
          categoryId: systemName, 
          categoryName: displayName,
          subCategoryKeys: const [], // This remains as is for now
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
