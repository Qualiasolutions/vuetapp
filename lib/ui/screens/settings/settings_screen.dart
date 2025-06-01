import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/user_providers.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/ui/screens/account_settings/account_details_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/security_settings_screen.dart';
import 'package:vuet_app/ui/screens/family/family_settings_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabaseUserAsync = ref.watch(currentUserProvider);
    final currentUserModelAsync = ref.watch(currentUserModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () => _showHelp(context),
                tooltip: 'Help',
              ),
            ],
          ),
          SliverFillRemaining(
            child: currentUserModelAsync.when(
              data: (userModel) {
                if (userModel == null) {
                  if (supabaseUserAsync == null) {
                    return const ErrorView(
                      message: 'User not logged in',
                      onRetry: null,
                    );
                  } else {
                    return const ErrorView(
                      message: 'User profile not found',
                      onRetry: null,
                    );
                  }
                }

                return _buildSettingsContent(context, ref, userModel, theme);
              },
              loading: () => const LoadingIndicator(),
              error: (error, _) => ErrorView(
                message: 'Failed to load user profile: $error',
                onRetry: () => ref.invalidate(currentUserModelProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, dynamic userModel, ThemeData theme) {
    final isPremium = userModel.subscriptionStatus == 'premium' || userModel.subscriptionStatus == 'family';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Card
          _buildUserProfileCard(context, userModel, theme),
          const SizedBox(height: 24),

          // Account Settings Section
          _buildSectionHeader('Account', theme),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Account Details',
                subtitle: 'Manage your personal information',
                icon: Icons.person_outline,
                onTap: () => _navigateToAccountDetails(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Security Settings',
                subtitle: 'Password, 2FA, and security options',
                icon: Icons.security_outlined,
                onTap: () => _navigateToSecuritySettings(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Privacy & Data',
                subtitle: 'Control your data and privacy settings',
                icon: Icons.privacy_tip_outlined,
                onTap: () => _showComingSoon(context, 'Privacy & Data'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Family & Collaboration Section
          _buildSectionHeader('Family & Collaboration', theme),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Family Settings',
                subtitle: 'Manage family members and sharing',
                icon: Icons.family_restroom,
                onTap: () => _navigateToFamilySettings(context),
                trailing: userModel.familyId != null 
                    ? _buildStatusBadge('Connected', Colors.green)
                    : _buildStatusBadge('Not Connected', Colors.orange),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Sharing & Permissions',
                subtitle: 'Control who can see your content',
                icon: Icons.share_outlined,
                onTap: () => _showComingSoon(context, 'Sharing & Permissions'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Productivity Features Section
          _buildSectionHeader('Productivity Features', theme),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Personal Assistant (LANA)',
                subtitle: 'AI assistant settings and preferences',
                icon: Icons.psychology_outlined,
                onTap: isPremium ? () => _showComingSoon(context, 'Personal Assistant (LANA)') : null,
                isDisabled: !isPremium,
                isPremium: true,
                trailing: isPremium 
                    ? _buildStatusBadge('Active', Colors.green)
                    : _buildPremiumBadge(),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Routines & Time Blocks',
                subtitle: 'Automated workflows and scheduling',
                icon: Icons.schedule_outlined,
                onTap: isPremium ? () => _showComingSoon(context, 'Routines & Time Blocks') : null,
                isDisabled: !isPremium,
                isPremium: true,
                trailing: isPremium 
                    ? null
                    : _buildPremiumBadge(),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Integrations',
                subtitle: 'Connect with external services',
                icon: Icons.integration_instructions_outlined,
                onTap: () => _showComingSoon(context, 'Integrations'),
                trailing: _buildStatusBadge('Configure', Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // App Settings Section
          _buildSectionHeader('App Settings', theme),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Notifications',
                subtitle: 'Manage alerts and reminders',
                icon: Icons.notifications_outlined,
                onTap: () => _showComingSoon(context, 'Notifications'),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Appearance',
                subtitle: 'Theme, colors, and display options',
                icon: Icons.palette_outlined,
                onTap: () => _showComingSoon(context, 'Appearance'),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Language & Region',
                subtitle: 'Language, timezone, and formats',
                icon: Icons.language_outlined,
                onTap: () => _showComingSoon(context, 'Language & Region'),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Data & Storage',
                subtitle: 'Backup, sync, and storage options',
                icon: Icons.storage_outlined,
                onTap: () => _showComingSoon(context, 'Data & Storage'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Support & About Section
          _buildSectionHeader('Support & About', theme),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                icon: Icons.help_outline,
                onTap: () => _showHelpAndSupport(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'What\'s New',
                subtitle: 'Latest features and updates',
                icon: Icons.new_releases_outlined,
                onTap: () => _showWhatsNew(context),
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'About Vuet',
                subtitle: 'Version info and legal',
                icon: Icons.info_outline,
                onTap: () => _showAbout(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Danger Zone
          _buildSectionHeader('Account Management', theme, color: Colors.red),
          const SizedBox(height: 12),
          _buildModernSettingsCard(
            context,
            children: [
              _buildSettingsItem(
                context,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                icon: Icons.logout,
                onTap: () => _confirmSignOut(context, ref),
                textColor: Colors.red,
              ),
              _buildDivider(),
              _buildSettingsItem(
                context,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                icon: Icons.delete_forever,
                onTap: () => _confirmDeleteAccount(context, ref),
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context, dynamic userModel, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: theme.colorScheme.primary,
            backgroundImage: userModel.profileImageUrl != null
                ? NetworkImage(userModel.profileImageUrl!)
                : null,
            child: userModel.profileImageUrl == null
                ? Text(
                    (userModel.firstName ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userModel.firstName ?? ''} ${userModel.lastName ?? ''}'.trim(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userModel.email != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    userModel.email!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _buildStatusBadge(
                  userModel.subscriptionStatus == 'premium' || userModel.subscriptionStatus == 'family'
                      ? 'Premium'
                      : 'Free Plan',
                  userModel.subscriptionStatus == 'premium' || userModel.subscriptionStatus == 'family'
                      ? Colors.amber
                      : Colors.blue,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToAccountDetails(context),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, {Color? color}) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildModernSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    bool isDisabled = false,
    bool isPremium = false,
    Widget? trailing,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    final effectiveTextColor = isDisabled 
        ? theme.colorScheme.onSurface.withOpacity(0.4)
        : (textColor ?? theme.colorScheme.onSurface);

    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDisabled
                    ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
                    : (textColor?.withOpacity(0.1) ?? theme.colorScheme.primary.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDisabled
                    ? theme.colorScheme.onSurface.withOpacity(0.4)
                    : (textColor ?? theme.colorScheme.primary),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: effectiveTextColor,
                          ),
                        ),
                      ),
                      if (isPremium && isDisabled) _buildPremiumBadge(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDisabled
                          ? theme.colorScheme.onSurface.withOpacity(0.3)
                          : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (trailing != null) 
              trailing
            else if (onTap != null && !isDisabled)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'PREMIUM',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Navigation methods with proper implementations
  void _navigateToAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AccountDetailsScreen(),
      ),
    );
  }

  void _navigateToSecuritySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsScreen(),
      ),
    );
  }

  void _navigateToFamilySettings(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const FamilySettingsScreen(),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(featureName),
        content: Text('$featureName functionality is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome to Vuet Settings!'),
              SizedBox(height: 16),
              Text('Here you can:'),
              SizedBox(height: 8),
              Text('• Manage your account and profile'),
              Text('• Configure family sharing'),
              Text('• Set up productivity features'),
              Text('• Customize app appearance'),
              Text('• Manage integrations'),
              SizedBox(height: 16),
              Text('Premium features are marked with a gold badge. Upgrade to unlock advanced functionality.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showHelpAndSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with Vuet?'),
            SizedBox(height: 16),
            Text('• Check our FAQ'),
            Text('• Contact support'),
            Text('• View documentation'),
            Text('• Report issues'),
            SizedBox(height: 16),
            Text('This feature will be fully implemented soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showWhatsNew(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What\'s New'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latest Updates:'),
            SizedBox(height: 16),
            Text('✓ Improved settings interface'),
            Text('✓ Enhanced family features'),
            Text('✓ Better navigation'),
            Text('✓ Performance improvements'),
            SizedBox(height: 16),
            Text('More features coming soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Vuet'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vuet App'),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('A productivity app for families and individuals.'),
            SizedBox(height: 16),
            Text('Built with Flutter and Supabase.'),
            SizedBox(height: 16),
            Text('© 2025 Vuet Team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to sign out: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted. Are you absolutely sure?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteAccountConfirmation(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context, WidgetRef ref) {
    final TextEditingController confirmController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type "DELETE" to confirm account deletion:'),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: 'Type DELETE',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          StatefulBuilder(
            builder: (context, setState) {
              return TextButton(
                onPressed: confirmController.text == 'DELETE'
                    ? () async {
                        Navigator.pop(context);
                        // Implement actual account deletion logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account deletion requested. This feature will be implemented in a future update.'),
                          ),
                        );
                      }
                    : null,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('DELETE ACCOUNT'),
              );
            },
          ),
        ],
      ),
    );
  }
}
