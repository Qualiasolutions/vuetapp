import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart'; // Not directly used for navigation here anymore
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';
import '../../navigation/social_interests_navigator.dart'; // Import the navigator

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
            onTap: () => SocialInterestsNavigator.navigateToHobbyList(context),
          ),
          _SocialEntityTile(
            title: 'Social Plans',
            icon: Icons.event_available,
            description: 'Plan social activities',
            onTap: () => SocialInterestsNavigator.navigateToSocialPlanList(context),
          ),
          _SocialEntityTile(
            title: 'Events',
            icon: Icons.celebration,
            description: 'Manage events',
            onTap: () => SocialInterestsNavigator.navigateToSocialEventList(context),
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
                SocialInterestsNavigator.navigateToHobbyForm(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event_available, color: AppColors.orange),
              title: const Text('Social Plan'),
              onTap: () {
                Navigator.pop(context);
                SocialInterestsNavigator.navigateToSocialPlanForm(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.celebration, color: AppColors.orange),
              title: const Text('Event'),
              onTap: () {
                Navigator.pop(context);
                SocialInterestsNavigator.navigateToSocialEventForm(context);
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
