import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader
import 'package:vuet_app/ui/navigation/family_navigator.dart'; // Import FamilyNavigator
import 'package:vuet_app/config/theme_config.dart'; // For AppColors if needed

class FamilyCategoryScreen extends StatelessWidget {
  const FamilyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of family-related sub-categories or entity types
    // Each item could be a model or a simple map for display and navigation
    final List<Map<String, dynamic>> familySubEntities = [
      {
        'title': 'Family Members',
        'icon': Icons.people_outline,
        'onTap': () => FamilyNavigator.navigateToFamilyMemberList(context),
      },
      {
        'title': 'Birthdays',
        'icon': Icons.cake_outlined,
        'onTap': () => FamilyNavigator.navigateToBirthdayList(context),
      },
      // TODO: Add other entities like Anniversaries, etc.
      // {
      //   'title': 'Anniversaries',
      //   'icon': Icons.cake_outlined,
      //   'onTap': () { /* context.go(FamilyNavigator.birthdayListRoute); */ },
      // },
      // {
      //   'title': 'Anniversaries',
      //   'icon': Icons.celebration_outlined,
      //   'onTap': () { /* context.go(FamilyNavigator.anniversaryListRoute); */ },
      // },
    ];

    return Scaffold(
      appBar: const VuetHeader('Family'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: familySubEntities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = familySubEntities[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: AppColors.steel.withAlpha((255 * 0.2).round()),
                width: 0.5,
              ),
            ),
            child: ListTile(
              leading: Icon(item['icon'] as IconData, color: AppColors.mediumTurquoise, size: 28),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.darkJungleGreen,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.steel),
              onTap: item['onTap'] as VoidCallback,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          );
        },
      ),
    );
  }
}
