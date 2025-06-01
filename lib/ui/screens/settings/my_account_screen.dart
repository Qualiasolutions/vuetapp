import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart' hide authServiceProvider; // Hide to resolve conflict
import 'package:vuet_app/services/auth_service.dart'; // This provides the authServiceProvider we want for signOut
import 'package:vuet_app/utils/date_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // For User type

class MyAccountScreen extends ConsumerWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // currentUserProvider directly returns User?, not AsyncValue<User?>
    final User? user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: user == null
          ? const Center(
              // User is not logged in, session expired, or still loading initially
              // Consider showing a loading indicator if currentUserProvider might be initially null during auth check
              // For now, directly showing "Please log in" if null.
              // A more robust solution might involve watching authStateChangesProvider for a loading state.
              child: Text('Please log in to view your account.'),
            )
          : ListView( // User is logged in, display account details
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 8),
                _buildHeaderSection(context, user),
                const SizedBox(height: 24),
                _buildAccountSection(context, user),
                const SizedBox(height: 24),
                _buildSubscriptionSection(context, user),
                const SizedBox(height: 24),
                _buildActionButtons(context, ref),
              ],
            ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, User user) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50), // Corrected alpha
            child: Text(
              _getInitials(user.email ?? ''),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.email ?? 'Unknown User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, User user) { // Changed type to User
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              context,
              label: 'Email',
              value: user.email ?? 'No email provided',
            ),
            _buildInfoItem(
              context,
              label: 'Account Created',
              value: DateTime.tryParse(user.createdAt) != null
                  ? DateFormatter.formatDateTime(DateTime.parse(user.createdAt))
                  : 'N/A',
            ),
            _buildInfoItem(
              context,
              label: 'Last Sign In',
              value: user.lastSignInAt != null && DateTime.tryParse(user.lastSignInAt!) != null
                  ? DateFormatter.formatDateTime(DateTime.parse(user.lastSignInAt!))
                  : 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection(BuildContext context, User user) { // Changed type to User
    // Access appMetadata directly from the User object
    final isPremium = user.appMetadata['is_premium'] == true;
    final subscriptionEndDateString = user.appMetadata['subscription_end_date'] as String?;
    final subscriptionEndDate = subscriptionEndDateString != null ? DateTime.tryParse(subscriptionEndDateString) : null;


    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              context,
              label: 'Plan',
              value: isPremium ? 'Premium' : 'Free',
              isHighlighted: isPremium,
            ),
            if (isPremium && subscriptionEndDate != null)
              _buildInfoItem(
                context,
                label: 'Renewal Date',
                value: DateFormatter.formatDate(subscriptionEndDate),
              ),
            const SizedBox(height: 16),
            if (!isPremium)
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to upgrade screen
                },
                child: const Text('Upgrade to Premium'),
              ),
            if (isPremium)
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigate to subscription management
                },
                child: const Text('Manage Subscription'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.password),
          label: const Text('Change Password'),
          onPressed: () {
            // TODO: Implement change password flow
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Edit Profile'),
          onPressed: () {
            // TODO: Navigate to edit profile
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () async {
            final confirmed = await _confirmSignOut(context);
            if (confirmed && context.mounted) {
              // Use authServiceProvider for signOut, assuming it's still needed for other actions
              // or if currentUserProvider doesn't expose signOut directly.
              await ref.read(authServiceProvider).signOut();
              // Navigation should ideally be handled by watching authStateChangesProvider
              // or currentUserProvider in a higher-level widget (e.g., AuthWrapper).
            }
          },
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            _showDeleteAccountDialog(context, ref);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete Account'),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  String _getInitials(String email) {
    if (email.isEmpty) return '?';
    final username = email.split('@').first.toUpperCase();
    return username.isNotEmpty ? username[0] : '?';
  }
}
