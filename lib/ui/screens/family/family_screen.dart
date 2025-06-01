import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/user_providers.dart';
// Import family providers with a prefix
import 'package:vuet_app/providers/family_providers.dart' as family_providers;
import 'package:vuet_app/ui/screens/family/create_family_screen.dart';
import 'package:vuet_app/ui/screens/family/family_members_screen.dart';
import 'package:vuet_app/ui/screens/family/family_invitations_screen.dart';
import 'package:vuet_app/ui/screens/family/invite_member_screen.dart';
import 'package:vuet_app/ui/screens/family/family_settings_screen.dart';
import 'package:vuet_app/ui/screens/family/shared_content_screen.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/models/app_user_model.dart';

/// Modern family dashboard with comprehensive collaboration features
class FamilyScreen extends ConsumerWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModelAsync = ref.watch(currentUserModelProvider);
    final currentUserFamilyAsync = ref.watch(family_providers.currentUserFamilyProvider);
    final familyMembersAsync = ref.watch(family_providers.familyMembersProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Dashboard'),
        elevation: 0,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToFamilySettings(context),
          ),
        ],
      ),
      body: currentUserModelAsync.when(
        data: (userModel) {
          if (userModel == null) {
            return _buildNotLoggedInView(context);
          }
          
          return currentUserFamilyAsync.when(
            data: (family) {
              final bool hasFamily = family != null;
              
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(currentUserModelProvider);
                  ref.invalidate(family_providers.currentUserFamilyProvider);
                  ref.invalidate(family_providers.familyMembersProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (hasFamily) ...[
                        _buildFamilyHeader(context, family, userModel),
                        _buildFamilyStats(context, familyMembersAsync),
                        _buildQuickActions(context, ref),
                        _buildSharedContent(context),
                        _buildRecentActivity(context),
                        _buildFamilyInsights(context),
                      ] else ...[
                        _buildGetStartedHero(context),
                        _buildFamilyBenefits(context),
                        _buildGetStartedActions(context),
                      ],
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
          onRetry: () => ref.invalidate(currentUserModelProvider),
        ),
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.family_restroom_outlined,
              size: 80,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Please log in to access family features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyHeader(BuildContext context, family, AppUserModel userModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    color: AppTheme.textLight,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        family.name ?? 'Family Group',
                        style: const TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome back, ${userModel.firstName ?? 'Family Member'}!',
                        style: TextStyle(
                          color: AppTheme.textLight.withValues(alpha: 0.9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Family ${userModel.familyRole?.toUpperCase() ?? 'MEMBER'}',
                style: const TextStyle(
                  color: AppTheme.textLight,
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

  Widget _buildFamilyStats(BuildContext context, AsyncValue familyMembersAsync) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Overview',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              familyMembersAsync.when(
                data: (members) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.people,
                          title: 'Members',
                          value: '${members.length}',
                          color: AppTheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.list_alt,
                          title: 'Shared Lists',
                          value: '12', // TODO: Get from actual data
                          color: AppTheme.accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          icon: Icons.task_alt,
                          title: 'Active Tasks',
                          value: '24', // TODO: Get from actual data
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (_, __) => const Text('Error loading stats'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildActionTile(
                    context,
                    icon: Icons.person_add,
                    title: 'Invite Member',
                    subtitle: 'Add family members',
                    color: AppTheme.secondary,
                    onTap: () => _navigateToInviteMember(context),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.people,
                    title: 'Manage Members',
                    subtitle: 'View & edit roles',
                    color: AppTheme.primary,
                    onTap: () => _navigateToFamilyMembers(context),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.share,
                    title: 'Shared Content',
                    subtitle: 'Lists, tasks & more',
                    color: AppTheme.accent,
                    onTap: () => _navigateToSharedContent(context),
                  ),
                  _buildActionTile(
                    context,
                    icon: Icons.mail,
                    title: 'Invitations',
                    subtitle: 'Pending invites',
                    color: AppTheme.info,
                    onTap: () => _navigateToInvitations(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shared Content',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigateToSharedContent(context),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildContentTypeRow(
                context,
                icon: Icons.list_alt,
                title: 'Shopping Lists',
                count: '5 active',
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 12),
              _buildContentTypeRow(
                context,
                icon: Icons.schedule,
                title: 'Planning Lists',
                count: '3 active',
                color: AppTheme.accent,
              ),
              const SizedBox(height: 12),
              _buildContentTypeRow(
                context,
                icon: Icons.pets,
                title: 'Shared Entities',
                count: '8 items',
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentTypeRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                count,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textSecondary,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityItem(
                context,
                avatar: 'JD',
                name: 'John Doe',
                action: 'completed "Buy groceries"',
                time: '2 hours ago',
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                context,
                avatar: 'SM',
                name: 'Sarah Miller',
                action: 'added items to Shopping List',
                time: '4 hours ago',
                color: AppTheme.accent,
              ),
              const SizedBox(height: 12),
              _buildActivityItem(
                context,
                avatar: 'MJ',
                name: 'Mike Johnson',
                action: 'joined the family',
                time: '1 day ago',
                color: AppTheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String avatar,
    required String name,
    required String action,
    required String time,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(
            avatar,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: AppTheme.textPrimary),
                  children: [
                    TextSpan(
                      text: name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: ' $action'),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyInsights(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Insights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildInsightCard(
                context,
                icon: Icons.trending_up,
                title: 'Productivity This Week',
                value: '89%',
                subtitle: 'Tasks completed on time',
                color: AppTheme.success,
              ),
              const SizedBox(height: 12),
              _buildInsightCard(
                context,
                icon: Icons.schedule,
                title: 'Average Response Time',
                value: '2.3h',
                subtitle: 'To family requests',
                color: AppTheme.info,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedHero(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primary.withValues(alpha: 0.1),
                AppTheme.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: AppTheme.textLight,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Family Collaboration',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Create or join a family group to start sharing lists, tasks, and organizing your life together.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyBenefits(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Family Benefits',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildBenefitItem(
                icon: Icons.share,
                title: 'Shared Lists & Tasks',
                description: 'Collaborate on shopping lists, chores, and planning',
              ),
              _buildBenefitItem(
                icon: Icons.schedule,
                title: 'Family Calendar',
                description: 'Keep everyone in sync with shared events and schedules',
              ),
              _buildBenefitItem(
                icon: Icons.assignment_turned_in,
                title: 'Task Assignment',
                description: 'Assign tasks to family members and track progress',
              ),
              _buildBenefitItem(
                icon: Icons.pets,
                title: 'Shared Resources',
                description: 'Manage pets, vehicles, and household items together',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.secondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Started',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToCreateFamily(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Family Group'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToInvitations(context),
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Check Invitations'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToCreateFamily(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateFamilyScreen()),
    );
  }

  void _navigateToFamilyMembers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FamilyMembersScreen()),
    );
  }

  void _navigateToInviteMember(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InviteMemberScreen()),
    );
  }

  void _navigateToInvitations(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FamilyInvitationsScreen()),
    );
  }

  void _navigateToFamilySettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FamilySettingsScreen()),
    );
  }

  void _navigateToSharedContent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SharedContentScreen()),
    );
  }
}
