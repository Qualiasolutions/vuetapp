import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/auth_service.dart';
import 'package:vuet_app/ui/screens/settings/my_account_screen.dart';
import 'package:vuet_app/ui/screens/settings/settings_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final user = authService.currentUser;
    final userEmail = user?.email ?? 'Unknown User';
    final userInitial = userEmail.isNotEmpty ? userEmail[0].toUpperCase() : '?';
    final isPremium = user?.appMetadata['is_premium'] == true;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context, userInitial, userEmail, isPremium),
          _buildDrawerItem(
            context,
            icon: Icons.person,
            title: 'My Account',
            onTap: () => _navigateToMyAccount(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => _navigateToSettings(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.family_restroom,
            title: 'Family',
            onTap: () => _navigateToFamily(context),
          ),
          const Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () => _navigateToHelpSupport(context),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_outline,
            title: 'About',
            onTap: () => _showAboutDialog(context),
          ),
          if (!isPremium) const Divider(),
          if (!isPremium)
            _buildPremiumUpgrade(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    String userInitial,
    String userEmail,
    bool isPremium,
  ) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Text(
                  userInitial,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'PREMIUM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            userEmail,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPremium ? 'Premium Member' : 'Free Account',
            style: TextStyle(
              color: Colors.white.withAlpha((0.8 * 255).round()),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isHighlighted
            ? Theme.of(context).colorScheme.secondary
            : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
          color: isHighlighted ? Theme.of(context).colorScheme.secondary : null,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildPremiumUpgrade(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        color: Colors.amber.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Get access to premium features:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('Personal AI Assistant'),
              _buildFeatureItem('Time Blocks & Routines'),
              _buildFeatureItem('Advanced Analytics'),
              _buildFeatureItem('Unlimited Integrations'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to premium upgrade screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Upgrade Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Text(feature, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _navigateToMyAccount(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyAccountScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToFamily(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(context, '/family');
  }

  void _navigateToHelpSupport(BuildContext context) {
    Navigator.pop(context); // Close drawer
    // TODO: Implement help & support screen
  }

  void _showAboutDialog(BuildContext context) {
    Navigator.pop(context); // Close drawer
    
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Vuet',
        applicationVersion: '2.0.0',
        applicationIcon: const FlutterLogo(size: 40),
        children: [
          const Text(
            'Vuet is your all-in-one life management app for tasks, lists, entities, and more.',
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 Vuet App. All rights reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
