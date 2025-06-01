import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/categories/sub_category_screen.dart';
import 'package:vuet_app/ui/screens/routines/routines_screen.dart';
import 'package:vuet_app/widgets/premium_tag.dart';
import 'package:vuet_app/widgets/premium_modal.dart';
import 'package:vuet_app/providers/user_providers.dart';

class VuetColors {
  static const primaryDark = Color(0xFF1C2827);
  static const secondary = Color(0xFF55C6D4);
  static const accent = Color(0xFFE49F30);
  static const neutral = Color(0xFF79858D);
  static const categoryHome = Color(0xFF1A6E68);
  static const categoryPets = Color(0xFFE49F30);
}

// Professional/Personal mode provider
final professionalModeProvider = StateProvider<bool>((ref) => false);

// Category group definition matching React original exactly
class CategoryGroup {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isProfessional;
  final List<String> categoryIds;

  const CategoryGroup({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isProfessional = false,
    required this.categoryIds,
  });
}

// The exact 9 categories from React original with modern icons
final List<CategoryGroup> categoryGroups = [
  CategoryGroup(
    id: 'PETS',
    name: 'Pets',
    icon: Icons.pets,
    color: const Color(0xFFE49F30),
    categoryIds: ['pets'],
  ),
  CategoryGroup(
    id: 'SOCIAL_INTERESTS',
    name: 'Social & Interests',
    icon: Icons.people,
    color: const Color(0xFF9C27B0),
    categoryIds: ['social_interests'],
  ),
  CategoryGroup(
    id: 'EDUCATION_CAREER',
    name: 'Education & Career',
    icon: Icons.school,
    color: const Color(0xFF2196F3),
    categoryIds: ['education', 'career'],
  ),
  CategoryGroup(
    id: 'TRAVEL',
    name: 'Travel',
    icon: Icons.flight,
    color: const Color(0xFF00BCD4),
    categoryIds: ['travel'],
  ),
  CategoryGroup(
    id: 'HEALTH_BEAUTY',
    name: 'Health & Beauty',
    icon: Icons.spa,
    color: const Color(0xFF4CAF50),
    categoryIds: ['health_beauty'],
  ),
  CategoryGroup(
    id: 'HOME_GARDEN',
    name: 'Home & Garden',
    icon: Icons.home,
    color: const Color(0xFF1A6E68),
    categoryIds: ['home', 'garden', 'food', 'laundry'],
  ),
  CategoryGroup(
    id: 'FINANCE',
    name: 'Finance',
    icon: Icons.account_balance,
    color: const Color(0xFF795548),
    categoryIds: ['finance'],
  ),
  CategoryGroup(
    id: 'TRANSPORT',
    name: 'Transport',
    icon: Icons.directions_car,
    color: const Color(0xFF607D8B),
    categoryIds: ['transport'],
  ),
  CategoryGroup(
    id: 'CHARITY_RELIGION',
    name: 'Charity & Religion',
    icon: Icons.volunteer_activism,
    color: const Color(0xFFFF5722),
    categoryIds: ['charity_religion'],
  ),
];

// Professional categories (subset of the main categories)
final List<CategoryGroup> professionalCategories = [
  CategoryGroup(
    id: 'EDUCATION_CAREER',
    name: 'Education & Career',
    icon: Icons.business_center,
    color: const Color(0xFF2196F3),
    isProfessional: true,
    categoryIds: ['education', 'career'],
  ),
  CategoryGroup(
    id: 'FINANCE',
    name: 'Finance',
    icon: Icons.trending_up,
    color: const Color(0xFF795548),
    isProfessional: true,
    categoryIds: ['finance'],
  ),
  CategoryGroup(
    id: 'TRANSPORT',
    name: 'Transport',
    icon: Icons.business,
    color: const Color(0xFF607D8B),
    isProfessional: true,
    categoryIds: ['transport'],
  ),
];

// Routines category (special case)
final CategoryGroup routinesCategory = CategoryGroup(
  id: 'ROUTINES',
  name: 'Routines',
  icon: Icons.repeat,
  color: VuetColors.secondary,
  categoryIds: ['routines'],
);

class MainCategoriesScreen extends ConsumerWidget {
  const MainCategoriesScreen({super.key});

  void _handleCategoryTap(BuildContext context, CategoryGroup category, bool isUserPremium) {
    if (category.id == 'ROUTINES') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RoutinesScreen()),
      );
      return;
    }

    if (category.isProfessional && !isUserPremium) {
      PremiumModal.show(context);
      return;
    }

    // Navigate to SubCategoryScreen for all categories (matching React flow)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen.fromCategoryId(
          parentCategoryName: category.name,
          parentCategoryId: category.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProfessionalMode = ref.watch(professionalModeProvider);
    final isUserPremiumAsyncValue = ref.watch(userIsPremiumProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Professional/Personal Toggle
            _buildModeToggle(context, ref, isProfessionalMode),
            
            // Categories Grid
            Expanded(
              child: isUserPremiumAsyncValue.when(
                data: (isUserPremium) => _buildCategoriesGrid(
                  context, 
                  isProfessionalMode, 
                  isUserPremium,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error loading user data: $err'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context, WidgetRef ref, bool isProfessionalMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Personal',
            style: TextStyle(
              fontWeight: isProfessionalMode ? FontWeight.normal : FontWeight.bold,
              color: isProfessionalMode ? Colors.grey.shade600 : VuetColors.primaryDark,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: isProfessionalMode,
            onChanged: (value) {
              ref.read(professionalModeProvider.notifier).state = value;
            },
            activeColor: VuetColors.primaryDark,
            activeTrackColor: VuetColors.accent.withAlpha((0.3 * 255).round()),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          const SizedBox(width: 16),
          Text(
            'Professional',
            style: TextStyle(
              fontWeight: isProfessionalMode ? FontWeight.bold : FontWeight.normal,
              color: isProfessionalMode ? VuetColors.primaryDark : Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, bool isProfessionalMode, bool isUserPremium) {
    List<CategoryGroup> categories;
    
    if (isProfessionalMode) {
      categories = professionalCategories;
    } else {
      categories = [routinesCategory, ...categoryGroups];
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryItem(context, category, isUserPremium);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryGroup category, bool isUserPremium) {
    final iconSize = MediaQuery.of(context).size.height * 0.2 * 0.30;

    return Hero(
      tag: 'category-${category.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleCategoryTap(context, category, isUserPremium),
          splashColor: Colors.white.withAlpha((0.3 * 255).round()),
          highlightColor: Colors.white.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.1 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          category.color,
                          category.color.withAlpha((0.8 * 255).round()),
                        ],
                      ),
                    ),
                  ),
                  
                  // Icon
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Icon(
                      category.icon,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  
                  // Bottom gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withAlpha((0.7 * 255).round()),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  
                  // Category name
                  Positioned(
                    bottom: 10,
                    left: 8,
                    right: 8,
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Premium tag for professional categories
                  if (category.isProfessional)
                    const Positioned(
                      bottom: 4,
                      right: 4,
                      child: PremiumTag(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
