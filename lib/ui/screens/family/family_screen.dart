import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/auth_providers.dart';
import 'package:vuet_app/providers/app_user_providers.dart';
// Import family providers with a prefix
import 'package:vuet_app/providers/family_providers.dart' as family_providers;
import 'package:vuet_app/ui/screens/family/create_family_screen.dart';
import 'package:vuet_app/ui/screens/family/family_members_screen.dart';
import 'package:vuet_app/ui/screens/family/family_invitations_screen.dart';
import 'package:vuet_app/ui/screens/family/invite_member_screen.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/models/app_user_model.dart';

/// Main family screen that shows family overview and navigation
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Supabase User from auth_providers
    final supabaseUserAsync = ref.watch(currentUserProvider);
    // Watch the AppUserModel from app_user_providers
    final currentUserModelAsync = ref.watch(currentAppUserProvider);
    
    // Use prefixed providers to avoid conflicts
    final currentUserFamilyAsync = ref.watch(family_providers.currentUserFamilyProvider);
    final familyMembersAsync = ref.watch(family_providers.familyMembersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family'),
        elevation: 0,
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
          
          // Now we have the AppUserModel, proceed with family data
          return currentUserFamilyAsync.when(
            data: (family) {
              final bool hasFamily = family != null;
          
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(currentAppUserProvider);
                  ref.invalidate(family_providers.currentUserFamilyProvider);
                  ref.invalidate(family_providers.familyMembersProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Family Status Card
                      _buildFamilyStatusCard(context, userModel, hasFamily, family),
                      
                      const SizedBox(height: 24),
                      
                      if (hasFamily) ...[
                        // Family Members Overview
                        _buildFamilyMembersOverview(context, ref, familyMembersAsync),
                        
                        const SizedBox(height: 24),
                        
                        // Quick Actions
                        _buildQuickActions(context),
                      ] else ...[
                        // No Family - Show Options
                        _buildNoFamilyOptions(context),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Family Features Info
                      _buildFamilyFeaturesInfo(context),
                    ],
                  ),
                ),
              );
            },
            loading: () => const LoadingIndicator(),
            error: (error, _) => ErrorView(
              message: 'Failed to load family information: $error',
              onRetry: () => ref.invalidate(family_providers.currentUserFamilyProvider),
            ),
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
  
  Widget _buildFamilyStatusCard(BuildContext context, AppUserModel user, bool hasFamily, family) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasFamily ? Icons.family_restroom : Icons.person,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasFamily ? 'Family Member' : 'Individual Account',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        hasFamily 
                            ? 'You\'re part of a family group'
                            : 'Create or join a family to share features',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasFamily) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatusChip(
                    context,
                    'Premium',
                    user.isPremium,
                    user.isPremium ? Colors.amber : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(
                    context,
                    user.accountType.toUpperCase(),
                    true,
                    Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusChip(BuildContext context, String label, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha((0.1 * 255).round()) : Colors.grey.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? color : Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildFamilyMembersOverview(BuildContext context, WidgetRef ref, AsyncValue familyMembersAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Family Members',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FamilyMembersScreen(),
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        familyMembersAsync.when(
          data: (members) {
            if (members.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No family members yet'),
                ),
              );
            }
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${members.length} member${members.length == 1 ? '' : 's'}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: members.length > 5 ? 5 : members.length,
                        itemBuilder: (context, index) {
                          if (index == 4 && members.length > 5) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: Text(
                                '+${members.length - 4}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          
                          final member = members[index];
                          Color? avatarColor;
                          
                          if (member.memberColor.startsWith('#')) {
                            final colorHex = member.memberColor.replaceFirst('#', '');
                            try {
                              avatarColor = Color(int.parse('0xFF$colorHex'));
                            } catch (e) {
                              avatarColor = Colors.grey;
                            }
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundColor: avatarColor ?? Colors.blue,
                              foregroundColor: Colors.white,
                              backgroundImage: member.avatarUrl != null 
                                  ? NetworkImage(member.avatarUrl!) 
                                  : null,
                              child: member.avatarUrl == null
                                  ? Text((member.firstName ?? 'U')[0].toUpperCase())
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: LoadingIndicator(),
            ),
          ),
          error: (error, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error loading members: $error'),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.person_add,
                title: 'Invite Member',
                subtitle: 'Add family members',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FamilyMembersScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.mail,
                title: 'Invitations',
                subtitle: 'Manage invites',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FamilyInvitationsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildNoFamilyOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get Started with Family',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          icon: Icons.family_restroom,
          title: 'Create Family Group',
          subtitle: 'Start inviting family members',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InviteMemberScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActionCard(
          context,
          icon: Icons.mail_outline,
          title: 'Check Invitations',
          subtitle: 'See if you have pending invites',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateFamilyScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFamilyFeaturesInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Family Features',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(context, 'Share lists and tasks with family members'),
            _buildFeatureItem(context, 'Assign tasks to specific family members'),
            _buildFeatureItem(context, 'Collaborative shopping and planning lists'),
            _buildFeatureItem(context, 'Family calendar and event sharing'),
            _buildFeatureItem(context, 'Shared premium benefits for all members'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
