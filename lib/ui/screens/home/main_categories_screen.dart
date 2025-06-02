import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/entity_category_model.dart';
import 'package:vuet_app/providers/category_providers.dart';
import 'package:vuet_app/providers/entity_actions_provider.dart';
import 'package:vuet_app/ui/helpers/ui_helpers.dart';
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

class MainCategoriesScreen extends ConsumerWidget {
  const MainCategoriesScreen({super.key});

  void _handleCategoryTap(BuildContext context, EntityCategoryModel category, bool isUserPremium) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen.fromCategoryId(
          appCategoryId: category.appCategoryId,
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
    final categoriesAsyncValue = ref.watch(allEntityCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildModeToggle(context, ref, isProfessionalMode),
            Expanded(
              child: categoriesAsyncValue.when(
                data: (categories) => isUserPremiumAsyncValue.when(
                  data: (isUserPremium) => _buildCategoriesGrid(
                    context,
                    categories,
                    isProfessionalMode,
                    isUserPremium,
                  ),
                  loading: () => const Center(child: Text("Loading user premium status...")),
                  error: (err, stack) => Center(
                    child: Text('Error loading user premium status: $err'),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error loading categories: $err'),
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

  Widget _buildCategoriesGrid(
    BuildContext context,
    List<EntityCategoryModel> allCategories,
    bool isProfessionalMode,
    bool isUserPremium,
  ) {
    List<dynamic> gridItems = List<dynamic>.from(allCategories);

    if (!isProfessionalMode) {
      gridItems.add("Routines");
    }
    gridItems.add("References");

    if (gridItems.isEmpty) {
      return const Center(child: Text('No categories available.'));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];

        if (item is String) {
          String title = item;
          IconData icon = Icons.apps;
          Color tileColor = Colors.grey.shade200;
          bool isPremiumFeature = false;

          if (item == "Routines") {
            icon = Icons.alarm;
            tileColor = VuetColors.secondary.withOpacity(0.7);
          } else if (item == "References") {
            icon = Icons.library_books;
            tileColor = VuetColors.accent.withOpacity(0.7);
            isPremiumFeature = true;
          }

          return GestureDetector(
            onTap: () {
              if (item == "Routines") {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RoutinesScreen()));
              } else if (item == "References") {
                if (!isUserPremium) {
                  PremiumModal.show(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navigate to References screen (Not implemented yet)')),
                  );
                }
              }
            },
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              color: tileColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, size: 40, color: VuetColors.primaryDark),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: VuetColors.primaryDark,
                      ),
                    ),
                  ),
                  if (isPremiumFeature) const PremiumTag(),
                ],
              ),
            ),
          );
        } else if (item is EntityCategoryModel) {
          final category = item;
          final IconData iconData = UiHelpers.getIconFromString(category.icon);
          final Color tileColor = UiHelpers.getColorFromString(category.color).withOpacity(0.7);
          final bool isCategoryPremium = category.name == "Health & Beauty";

          return GestureDetector(
            onTap: () {
              if (isCategoryPremium && !isUserPremium) {
                PremiumModal.show(context);
              } else {
                _handleCategoryTap(context, category, isUserPremium);
              }
            },
            child: Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              color: tileColor,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(iconData, size: 40, color: VuetColors.primaryDark),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: VuetColors.primaryDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (isCategoryPremium)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: PremiumTag(),
                    ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
