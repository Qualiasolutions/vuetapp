import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Family Category Screen - Shows all Family entity types
/// As specified in detailed guide: Birthday, Anniversary, Patient, Appointment, FamilyMember
class FamilyCategoryScreen extends StatelessWidget {
  const FamilyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Family'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _FamilyEntityTile(
            title: 'Birthdays',
            icon: Icons.cake,
            description: 'Track family birthdays',
            onTap: () => context.go('/categories/family/birthdays'),
          ),
          _FamilyEntityTile(
            title: 'Anniversaries',
            icon: Icons.favorite,
            description: 'Remember special dates',
            onTap: () => context.go('/categories/family/anniversaries'),
          ),
          _FamilyEntityTile(
            title: 'Patients',
            icon: Icons.person,
            description: 'Manage patient info',
            onTap: () => context.go('/categories/family/patients'),
          ),
          _FamilyEntityTile(
            title: 'Appointments',
            icon: Icons.event,
            description: 'Schedule appointments',
            onTap: () => context.go('/categories/family/appointments'),
          ),
          _FamilyEntityTile(
            title: 'Family Members',
            icon: Icons.family_restroom,
            description: 'Manage family contacts',
            onTap: () => context.go('/categories/family/family-members'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Family Item',
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
              'Add Family Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.cake, color: AppColors.orange),
              title: const Text('Birthday'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/birthdays/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.orange),
              title: const Text('Anniversary'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/anniversaries/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.orange),
              title: const Text('Patient'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/patients/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: AppColors.orange),
              title: const Text('Appointment'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/appointments/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom, color: AppColors.orange),
              title: const Text('Family Member'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/family-members/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyEntityTile extends StatelessWidget {
  const _FamilyEntityTile({
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
