import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Health & Beauty Category Screen - Shows all Health & Beauty entity types
/// As specified in detailed guide: HealthGoal, Appointment, BeautyRoutine, Workout
class HealthBeautyCategoryScreen extends StatelessWidget {
  const HealthBeautyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Health & Beauty'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _HealthBeautyEntityTile(
            title: 'Health Goals',
            icon: Icons.favorite,
            description: 'Track health goals',
            onTap: () => context.go('/categories/health/goals'),
          ),
          _HealthBeautyEntityTile(
            title: 'Appointments',
            icon: Icons.medical_services,
            description: 'Medical appointments',
            onTap: () => context.go('/categories/health/appointments'),
          ),
          _HealthBeautyEntityTile(
            title: 'Beauty Routines',
            icon: Icons.spa,
            description: 'Beauty & skincare',
            onTap: () => context.go('/categories/health/beauty'),
          ),
          _HealthBeautyEntityTile(
            title: 'Workouts',
            icon: Icons.fitness_center,
            description: 'Exercise routines',
            onTap: () => context.go('/categories/health/workouts'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Health Item',
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
              'Add Health Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.orange),
              title: const Text('Health Goal'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/health/goals/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services, color: AppColors.orange),
              title: const Text('Appointment'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/health/appointments/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.spa, color: AppColors.orange),
              title: const Text('Beauty Routine'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/health/beauty/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppColors.orange),
              title: const Text('Workout'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/health/workouts/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthBeautyEntityTile extends StatelessWidget {
  const _HealthBeautyEntityTile({
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
