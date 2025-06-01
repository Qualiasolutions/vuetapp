import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/app_user_model.dart';
import 'package:vuet_app/providers/user_providers.dart';
import 'package:vuet_app/ui/navigation/account_settings_navigator.dart';

/// Main screen for account settings
class AccountSettingsScreen extends ConsumerWidget {
  /// Constructor
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: currentUserModelAsync.when(
        data: (user) => _buildContent(context, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading user data: ${error.toString()}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppUserModel? user) {
    if (user == null) {
      return const Center(
        child: Text('You need to be signed in to view account settings.'),
      );
    }

    return ListView(
      children: [
        // User profile summary
        _buildProfileSummary(context, user),

        const Divider(),

        // Account settings options
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Account Details'),
          subtitle: const Text('Name, profile picture, date of birth'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => AccountSettingsNavigator.navigateToAccountDetails(context),
        ),

        ListTile(
          leading: const Icon(Icons.credit_card_outlined),
          title: const Text('Account Type'),
          subtitle: Text(
            'Your plan: ${_formatSubscriptionType(user.subscriptionStatus)}',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => AccountSettingsNavigator.navigateToAccountType(context),
        ),

        ListTile(
          leading: const Icon(Icons.contact_phone_outlined),
          title: const Text('Contact Information'),
          subtitle: Text('Email: ${user.email ?? ''}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => AccountSettingsNavigator.navigateToContactInfo(context),
        ),

        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('Security'),
          subtitle: const Text('Password, privacy settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => AccountSettingsNavigator.navigateToSecuritySettings(context),
        ),

        // Family section - only shown for users with premium subscription
        if (user.isPremium) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(
              'FAMILY',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Family Members'),
            subtitle: const Text('Manage family members'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => AccountSettingsNavigator.navigateToFamilyMembers(context),
          ),
          
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Family Invitations'),
            subtitle: const Text('View invitations'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => AccountSettingsNavigator.navigateToFamilyInvitations(context),
          ),
        ],

        const Divider(),

        // Sign out button
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          onTap: () => _confirmSignOut(context),
        ),

        // Delete account button (with warning)
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Delete Account', 
            style: TextStyle(color: Colors.red),
          ),
          onTap: () => _confirmAccountDeletion(context),
        ),
      ],
    );
  }

  Widget _buildProfileSummary(BuildContext context, AppUserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            user.email ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (user.isPremium)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Text(
                '${_formatSubscriptionType(user.subscriptionStatus)} Member',
                style: TextStyle(color: Colors.amber.shade800),
              ),
            ),
        ],
      ),
    );
  }

  String _formatSubscriptionType(String? type) {
    if (type == null || type == 'standard') {
      return 'Standard';
    } else if (type == 'family') {
      return 'Family';
    } else {
      return 'Premium';
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result ?? false) {
      // Handle sign out - to be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
        // Navigate to login screen or home
      }
    }
  }

  Future<void> _confirmAccountDeletion(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? '
          'This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );

    if (result ?? false) {
      // Handle account deletion - to be implemented
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deletion initiated')),
        );
        // Navigate to login screen or home
      }
    }
  }
}
