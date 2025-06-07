import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme_config.dart';
import '../shared/widgets.dart';

/// Family Category Screen - Shows all Family entity types
/// Following detailed guide: Birthday, Anniversary, Patient, Appointment, FamilyMember
class FamilyCategoryScreen extends StatelessWidget {
  const FamilyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Family'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Birthday entities
          _EntityTypeCard(
            title: 'Birthdays',
            subtitle: 'Family member birthdays',
            icon: Icons.cake,
            onTap: () => context.go('/categories/family/birthdays'),
          ),
          
          const SizedBox(height: 12),
          
          // Anniversary entities
          _EntityTypeCard(
            title: 'Anniversaries',
            subtitle: 'Special dates and milestones',
            icon: Icons.favorite,
            onTap: () => context.go('/categories/family/anniversaries'),
          ),
          
          const SizedBox(height: 12),
          
          // Patient entities
          _EntityTypeCard(
            title: 'Patients',
            subtitle: 'Family medical information',
            icon: Icons.medical_information,
            onTap: () => context.go('/categories/family/patients'),
          ),
          
          const SizedBox(height: 12),
          
          // Appointment entities
          _EntityTypeCard(
            title: 'Appointments',
            subtitle: 'Medical and other appointments',
            icon: Icons.event,
            onTap: () => context.go('/categories/family/appointments'),
          ),
          
          const SizedBox(height: 12),
          
          // Family Member entities
          _EntityTypeCard(
            title: 'Family Members',
            subtitle: 'Family member details',
            icon: Icons.people,
            onTap: () => context.go('/categories/family/members'),
          ),
        ],
      ),
      
      // FAB for quick add - shows entity type selection
      floatingActionButton: VuetFAB(
        onPressed: () => _showAddEntityDialog(context),
        tooltip: 'Add Family Entity',
      ),
    );
  }

  void _showAddEntityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Family Entity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              leading: const Icon(Icons.medical_information, color: AppColors.orange),
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
              leading: const Icon(Icons.people, color: AppColors.orange),
              title: const Text('Family Member'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/family/members/create');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Entity Type Card widget for category screens
class _EntityTypeCard extends StatelessWidget {
  const _EntityTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.steel, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.darkJungleGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkJungleGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.steel,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.steel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
