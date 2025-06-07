import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Home & Garden Category Screen - Shows all Home & Garden entity types
/// As specified in detailed guide: Home, CleaningRoutine, Garden, PlantCarePlan, FoodPlan, Food, LaundryPlan
class HomeGardenCategoryScreen extends StatelessWidget {
  const HomeGardenCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Home & Garden'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _HomeGardenEntityTile(
            title: 'Home',
            icon: Icons.home,
            description: 'Manage your home',
            onTap: () => context.go('/categories/home/home'),
          ),
          _HomeGardenEntityTile(
            title: 'Cleaning Routines',
            icon: Icons.cleaning_services,
            description: 'House cleaning plans',
            onTap: () => context.go('/categories/home/cleaning'),
          ),
          _HomeGardenEntityTile(
            title: 'Garden',
            icon: Icons.local_florist,
            description: 'Garden management',
            onTap: () => context.go('/categories/home/garden'),
          ),
          _HomeGardenEntityTile(
            title: 'Plant Care Plans',
            icon: Icons.eco,
            description: 'Plant care schedules',
            onTap: () => context.go('/categories/home/plants'),
          ),
          _HomeGardenEntityTile(
            title: 'Food Plans',
            icon: Icons.restaurant_menu,
            description: 'Meal planning',
            onTap: () => context.go('/categories/home/food-plans'),
          ),
          _HomeGardenEntityTile(
            title: 'Food Items',
            icon: Icons.fastfood,
            description: 'Food inventory',
            onTap: () => context.go('/categories/home/food'),
          ),
          _HomeGardenEntityTile(
            title: 'Laundry Plans',
            icon: Icons.local_laundry_service,
            description: 'Laundry schedules',
            onTap: () => context.go('/categories/home/laundry'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Home Item',
      ),
    );
  }

  static void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Home Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.orange),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/home/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cleaning_services, color: AppColors.orange),
              title: const Text('Cleaning Routine'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/cleaning/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_florist, color: AppColors.orange),
              title: const Text('Garden'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/garden/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.eco, color: AppColors.orange),
              title: const Text('Plant Care Plan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/plants/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: AppColors.orange),
              title: const Text('Food Plan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/food-plans/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: AppColors.orange),
              title: const Text('Food Item'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/food/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_laundry_service, color: AppColors.orange),
              title: const Text('Laundry Plan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/home/laundry/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeGardenEntityTile extends StatelessWidget {
  const _HomeGardenEntityTile({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VuetCategoryTile(
      title: title,
      icon: icon,
      onTap: onTap,
    );
  }
}
