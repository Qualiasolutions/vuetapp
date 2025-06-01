import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/app_user_providers.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Supabase User from auth_providers
    final supabaseUserAsync = ref.watch(currentUserProvider);
    // Watch the AppUserModel from app_user_providers
    final currentUserModelAsync = ref.watch(currentAppUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: currentUserModelAsync.when(
        data: (userModel) {
          if (userModel == null) {
            // If AppUserModel is null, it means the user is not fully set up or logged in
            if (supabaseUserAsync == null) { // Directly check if User is null
              return const ErrorView(
                message: 'User not logged in',
                onRetry: null, // No retry if not logged in
              );
            } else {
              return const ErrorView(
                message: 'User profile not found', // User logged in but no profile
                onRetry: null, // Profile creation might be needed elsewhere
              );
            }
          }

          final isPremium = userModel.subscriptionStatus == 'premium' || userModel.subscriptionStatus == 'family';

          return ListView(
            children: [
              const SizedBox(height: 16),
              _buildSettingsButton(
                context,
                title: 'Family Settings',
                icon: Icons.family_restroom,
                onTap: () => _navigateToFamilySettings(context),
              ),
              _buildSettingsButton(
                context,
                title: 'Integrations',
                icon: Icons.integration_instructions,
                onTap: () => _navigateToIntegrations(context),
              ),
              _buildSettingsButton(
                context,
                title: 'Personal Assistant',
                icon: Icons.person_outline,
                onTap: isPremium ? () => _navigateToPersonalAssistant(context) : null,
                isPremium: true,
                isDisabled: !isPremium,
              ),
              _buildSettingsButton(
                context,
                title: 'Routines and Time Blocks',
                icon: Icons.schedule,
                onTap: isPremium ? () => _navigateToRoutinesAndTimeBlocks(context) : null,
                isPremium: true,
                isDisabled: !isPremium,
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: 'Failed to load user profile: $error',
          onRetry: () => ref.invalidate(currentAppUserProvider),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    bool isPremium = false,
    bool isDisabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(
            icon,
            color: isDisabled ? Colors.grey : Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? Colors.grey : null,
                ),
              ),
              if (isPremium) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary,
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
                ),
              ],
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }

  void _navigateToFamilySettings(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Family Settings')),
          body: const Center(child: Text('Family Settings - Coming Soon!')),
        ),
      ),
    );
  }

  void _navigateToIntegrations(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Integrations')),
          body: const Center(child: Text('Integrations - Coming Soon!')),
        ),
      ),
    );
  }

  void _navigateToPersonalAssistant(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Personal Assistant')),
          body: const Center(child: Text('Personal Assistant - Coming Soon!')),
        ),
      ),
    );
  }

  void _navigateToRoutinesAndTimeBlocks(BuildContext context) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Routines and Time Blocks')),
          body: const Center(child: Text('Routines and Time Blocks - Coming Soon!')),
        ),
      ),
    );
  }
}
