import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_categories.dart';
import '../../config/theme_config.dart';
import '../shared/widgets.dart';

/// Category Grid Screen - Main navigation for all 13 categories
/// Following the detailed guide specifications with Modern Palette colors
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Categories'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          // Family (ID: 1)
          VuetCategoryTile(
            title: 'Family',
            icon: Icons.family_restroom,
            onTap: () => context.go('/categories/family'),
          ),
          
          // Pets (ID: 2)
          VuetCategoryTile(
            title: 'Pets',
            icon: Icons.pets,
            onTap: () => context.go('/categories/pets'),
          ),
          
          // Social Interests (ID: 3)
          VuetCategoryTile(
            title: 'Social Interests',
            icon: Icons.people,
            onTap: () => context.go('/categories/social'),
          ),
          
          // Education (ID: 4)
          VuetCategoryTile(
            title: 'Education',
            icon: Icons.school,
            onTap: () => context.go('/categories/education'),
          ),
          
          // Career (ID: 5)
          VuetCategoryTile(
            title: 'Career',
            icon: Icons.work,
            onTap: () => context.go('/categories/career'),
          ),
          
          // Travel (ID: 6)
          VuetCategoryTile(
            title: 'Travel',
            icon: Icons.flight,
            onTap: () => context.go('/categories/travel'),
          ),
          
          // Health & Beauty (ID: 7)
          VuetCategoryTile(
            title: 'Health & Beauty',
            icon: Icons.favorite,
            onTap: () => context.go('/categories/health'),
          ),
          
          // Home (ID: 8)
          VuetCategoryTile(
            title: 'Home',
            icon: Icons.home,
            onTap: () => context.go('/categories/home'),
          ),
          
          // Garden (ID: 9)
          VuetCategoryTile(
            title: 'Garden',
            icon: Icons.local_florist,
            onTap: () => context.go('/categories/garden'),
          ),
          
          // Food (ID: 10)
          VuetCategoryTile(
            title: 'Food',
            icon: Icons.restaurant,
            onTap: () => context.go('/categories/food'),
          ),
          
          // Laundry (ID: 11)
          VuetCategoryTile(
            title: 'Laundry',
            icon: Icons.local_laundry_service,
            onTap: () => context.go('/categories/laundry'),
          ),
          
          // Finance (ID: 12)
          VuetCategoryTile(
            title: 'Finance',
            icon: Icons.account_balance,
            onTap: () => context.go('/categories/finance'),
          ),
          
          // Transport (ID: 13)
          VuetCategoryTile(
            title: 'Transport',
            icon: Icons.directions_car,
            onTap: () => context.go('/categories/transport'),
          ),
          
          // Charity & Religion (ID: 14)
          VuetCategoryTile(
            title: 'Charity & Religion',
            icon: Icons.volunteer_activism,
            onTap: () => context.go('/categories/charity'),
          ),
        ],
      ),
      
      // Professional mode toggle in top-right corner
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 80),
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Implement professional mode toggle
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Professional mode coming soon')),
            );
          },
          backgroundColor: AppColors.darkJungleGreen,
          foregroundColor: AppColors.white,
          icon: const Icon(Icons.business),
          label: const Text('Pro Mode'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
