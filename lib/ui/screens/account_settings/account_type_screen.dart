import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/user_model.dart';
import 'package:vuet_app/providers/user_providers.dart'; // Import user_providers

/// Screen for viewing and managing account type/subscription
class AccountTypeScreen extends ConsumerWidget {
  /// Constructor
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider); // Use currentUserModelProvider
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Type'),
      ),
      body: currentUserModelAsync.when( // Use currentUserModelAsync
        data: (user) => _buildContent(context, user, ref),
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
  
  Widget _buildContent(BuildContext context, UserModel? user, WidgetRef ref) {
    if (user == null) {
      return const Center(
        child: Text('You need to be signed in to view your account type.'),
      );
    }
    
    final isStandardUser = user.subscriptionStatus == 'free';
    final isFamilyUser = user.subscriptionStatus == 'family';
    
    final subscriptionRenewal = null; // TODO: Get from subscription provider
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Plan Summary
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Plan: ${_formatSubscriptionType(user.subscriptionStatus)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  
                  if (subscriptionRenewal != null) ...[
                    Text(
                      'Renews on: ${subscriptionRenewal.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Plan Features
                  const Text('Plan Features:', style: TextStyle(fontWeight: FontWeight.bold)),
                  
                  _buildFeatureRow(
                    context, 
                    'Tasks', 
                    isStandardUser ? 'Fixed only' : 'Fixed and Flexible',
                  ),
                  _buildFeatureRow(
                    context, 
                    'References', 
                    isStandardUser ? 'No' : 'Yes',
                  ),
                  _buildFeatureRow(
                    context, 
                    'Routines', 
                    isStandardUser ? 'No' : 'Yes',
                  ),
                  _buildFeatureRow(
                    context, 
                    'Past Events', 
                    isStandardUser ? '3 months' : '7 years',
                  ),
                  _buildFeatureRow(
                    context, 
                    'AI Assistant', 
                    isStandardUser ? 'No' : 'Yes plus',
                  ),
                  
                  if (isFamilyUser)
                    _buildFeatureRow(
                      context, 
                      'Family Members', 
                      'Up to 6 members',
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Manage Subscription Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _launchSubscriptionManagement(context),
              child: const Text('Manage Subscription'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Upgrade Plan Button (for standard users)
          if (isStandardUser)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _launchUpgradePage(context),
                child: const Text('Upgrade Plan'),
              ),
            ),
            
          // Show family members button (for family plan users)
          if (isFamilyUser)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _viewFamilyMembers(context, ref, user),
                  child: const Text('View Family Members'),
                ),
              ),
            ),
            
          // Plan Pricing Information
          const SizedBox(height: 24),
          const Text(
            'Plan Pricing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Premium: £1.99 per month or £12.99 per year'),
          const Text('Family (up to 6 members): £4.99 per month or £49.99 per year'),
          const Text('Additional family members: £0.99 per month or £9.99 per year'),
        ],
      ),
    );
  }
  
  Widget _buildFeatureRow(BuildContext context, String feature, String availability) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16),
          const SizedBox(width: 8),
          Text(feature, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            availability,
            style: TextStyle(
              color: availability == 'No' ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatSubscriptionType(String? type) {
    if (type == null || type == 'free') {
      return 'Standard';
    } else if (type == 'family') {
      return 'Family';
    } else {
      return 'Premium';
    }
  }
  
  Future<void> _launchSubscriptionManagement(BuildContext context) async {
    // Placeholder for opening subscription management page
    // In a real implementation, this would open a web view or external link
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subscription management will be implemented in a future update.'),
      ),
    );
  }
  
  Future<void> _launchUpgradePage(BuildContext context) async {
    // Placeholder for opening upgrade page
    // In a real implementation, this would open a web view or external link
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Plan upgrade will be implemented in a future update.'),
      ),
    );
  }
  
  Future<void> _viewFamilyMembers(BuildContext context, WidgetRef ref, UserModel user) async {
    // Placeholder for viewing family members
    // In a real implementation, this would show a modal or navigate to a new screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Family member management will be implemented in a future update.'),
      ),
    );
  }
}
