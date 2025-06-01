import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/user_providers.dart';
import 'package:vuet_app/ui/screens/account_settings/account_details_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/contact_info_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/account_type_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/security_settings_screen.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';

class MyAccountScreen extends ConsumerWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: currentUserModelAsync.when(
        data: (userModel) {
          if (userModel == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Please log in to view your account',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return _buildAccountContent(context, userModel, theme);
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: 'Failed to load account information: $error',
          onRetry: () => ref.invalidate(currentUserModelProvider),
        ),
      ),
    );
  }

  Widget _buildAccountContent(BuildContext context, dynamic userModel, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // User Profile Header
          _buildProfileHeader(context, userModel, theme),
          
          const SizedBox(height: 24),
          
          // Account Information Cards
          _buildAccountInformation(context, userModel, theme),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic userModel, ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: userModel.avatarUrl != null
                  ? NetworkImage(userModel.avatarUrl!)
                  : null,
              child: userModel.avatarUrl == null
                  ? Text(
                      (userModel.firstName ?? 'U')[0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              '${userModel.firstName ?? ''} ${userModel.lastName ?? ''}'.trim(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (userModel.email != null) ...[
              const SizedBox(height: 8),
              Text(
                userModel.email!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                userModel.subscriptionStatus == 'premium' || userModel.subscriptionStatus == 'family'
                    ? 'Premium Account'
                    : 'Free Account',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInformation(BuildContext context, dynamic userModel, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Account Details Card
          _buildInfoCard(
            context,
            icon: Icons.person_outline,
            title: 'Account Details',
            subtitle: 'Personal information and profile settings',
            onTap: () => _navigateToAccountDetails(context),
          ),
          
          const SizedBox(height: 12),
          
          // Contact Information Card  
          _buildInfoCard(
            context,
            icon: Icons.contact_mail_outlined,
            title: 'Contact Information',
            subtitle: 'Email and phone number settings',
            onTap: () => _navigateToContactInfo(context),
          ),
          
          const SizedBox(height: 12),
          
          // Account Type Card
          _buildInfoCard(
            context,
            icon: Icons.business_outlined,
            title: 'Account Type',
            subtitle: 'Subscription and account type management',
            onTap: () => _navigateToAccountType(context),
          ),
          
          const SizedBox(height: 12),
          
          // Security Settings Card
          _buildInfoCard(
            context,
            icon: Icons.security_outlined,
            title: 'Security Settings',
            subtitle: 'Password and security preferences',
            onTap: () => _navigateToSecuritySettings(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
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
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToAccountDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountDetailsScreen()),
    );
  }

  void _navigateToContactInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactInfoScreen()),
    );
  }

  void _navigateToAccountType(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountTypeScreen()),
    );
  }

  void _navigateToSecuritySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
    );
  }
} 