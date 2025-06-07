import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Charity & Religion Category Screen - Shows all Charity & Religion entity types
/// As specified in detailed guide: CharityDonation, ReligiousEvent, VolunteerWork, Prayer
class CharityReligionCategoryScreen extends StatelessWidget {
  const CharityReligionCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Charity & Religion'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _CharityReligionEntityTile(
            title: 'Charity Donations',
            icon: Icons.volunteer_activism,
            description: 'Track donations',
            onTap: () => context.go('/categories/charity/donations'),
          ),
          _CharityReligionEntityTile(
            title: 'Religious Events',
            icon: Icons.event,
            description: 'Religious occasions',
            onTap: () => context.go('/categories/charity/events'),
          ),
          _CharityReligionEntityTile(
            title: 'Volunteer Work',
            icon: Icons.handshake,
            description: 'Volunteer activities',
            onTap: () => context.go('/categories/charity/volunteer'),
          ),
          _CharityReligionEntityTile(
            title: 'Prayers',
            icon: Icons.self_improvement,
            description: 'Prayer schedules',
            onTap: () => context.go('/categories/charity/prayers'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Charity Item',
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
              'Add Charity Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: AppColors.orange),
              title: const Text('Charity Donation'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/charity/donations/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event, color: AppColors.orange),
              title: const Text('Religious Event'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/charity/events/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.handshake, color: AppColors.orange),
              title: const Text('Volunteer Work'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/charity/volunteer/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.self_improvement, color: AppColors.orange),
              title: const Text('Prayer'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/charity/prayers/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CharityReligionEntityTile extends StatelessWidget {
  const _CharityReligionEntityTile({
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
