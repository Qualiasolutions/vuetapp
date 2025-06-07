import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Pets Category Screen - Shows all Pets entity types
/// As specified in detailed guide: Pet, PetAppointment
class PetsCategoryScreen extends StatelessWidget {
  const PetsCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Pets'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _PetsEntityTile(
            title: 'Pets',
            icon: Icons.pets,
            description: 'Manage your pets',
            onTap: () => context.go('/categories/pets/pets'),
          ),
          _PetsEntityTile(
            title: 'Pet Appointments',
            icon: Icons.medical_services,
            description: 'Schedule vet visits',
            onTap: () => context.go('/categories/pets/appointments'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Pet Item',
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
              'Add Pet Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.pets, color: AppColors.orange),
              title: const Text('Pet'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/pets/pets/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services, color: AppColors.orange),
              title: const Text('Pet Appointment'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/pets/appointments/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PetsEntityTile extends StatelessWidget {
  const _PetsEntityTile({
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
