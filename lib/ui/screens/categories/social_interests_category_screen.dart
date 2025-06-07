import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Social Interests Category Screen - Shows all Social Interests entity types
/// As specified in detailed guide: Hobby, SocialPlan, Event
class SocialInterestsCategoryScreen extends StatelessWidget {
  const SocialInterestsCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Social Interests'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _SocialEntityTile(
            title: 'Hobbies',
            icon: Icons.sports_esports,
            description: 'Track your hobbies',
            onTap: () => context.go('/categories/social/hobbies'),
          ),
          _SocialEntityTile(
            title: 'Social Plans',
            icon: Icons.event_available,
            description: 'Plan social activities',
            onTap: () => context.go('/categories/social/plans'),
          ),
          _SocialEntityTile(
            title: 'Events',
            icon: Icons.celebration,
            description: 'Manage events',
            onTap: () => context.go('/categories/social/events'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Social Item',
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
              'Add Social Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.sports_esports, color: AppColors.orange),
              title: const Text('Hobby'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/social/hobbies/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available, color: AppColors.orange),
              title: const Text('Social Plan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/social/plans/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.celebration, color: AppColors.orange),
              title: const Text('Event'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/social/events/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialEntityTile extends StatelessWidget {
  const _SocialEntityTile({
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
