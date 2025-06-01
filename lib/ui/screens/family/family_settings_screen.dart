import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';

/// Family settings and configuration screen
class FamilySettingsScreen extends ConsumerWidget {
  const FamilySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserFamilyAsync = ref.watch(currentUserFamilyProvider);
    final isFamilyOwnerAsync = ref.watch(isFamilyOwnerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textLight,
      ),
      body: currentUserFamilyAsync.when(
        data: (family) {
          if (family == null) {
            return const Center(
              child: Text('No family group found'),
            );
          }
          
          return isFamilyOwnerAsync.when(
            data: (isOwner) => _buildSettingsContent(context, ref, family, isOwner),
            loading: () => const LoadingIndicator(),
            error: (error, _) => ErrorView(
              message: 'Error loading permissions: $error',
              onRetry: () => ref.invalidate(isFamilyOwnerProvider),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorView(
          message: 'Error loading family: $error',
          onRetry: () => ref.invalidate(currentUserFamilyProvider),
        ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, WidgetRef ref, family, bool isOwner) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFamilyInfo(context, family),
          const SizedBox(height: 24),
          _buildGeneralSettings(context, ref),
          const SizedBox(height: 24),
          _buildPermissionsSettings(context, ref, isOwner),
          const SizedBox(height: 24),
          _buildNotificationSettings(context, ref),
          const SizedBox(height: 24),
          if (isOwner) ...[
            _buildAdminSettings(context, ref, family),
            const SizedBox(height: 24),
            _buildDangerZone(context, ref, family),
          ],
        ],
      ),
    );
  }

  Widget _buildFamilyInfo(BuildContext context, family) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    color: AppTheme.textLight,
                    size: 24,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Created ${_formatDate(family.createdAt)}',
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
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingTile(
              context,
              icon: Icons.visibility,
              title: 'Show my activity',
              subtitle: 'Let family members see your recent activity',
              value: true,
              onChanged: (value) {
                // TODO: Implement setting toggle
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.location_on,
              title: 'Share location',
              subtitle: 'Allow family to see your location',
              value: false,
              onChanged: (value) {
                // TODO: Implement setting toggle
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.auto_awesome,
              title: 'Smart suggestions',
              subtitle: 'Get AI-powered family activity suggestions',
              value: true,
              onChanged: (value) {
                // TODO: Implement setting toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSettings(BuildContext context, WidgetRef ref, bool isOwner) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permissions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildPermissionTile(
              context,
              icon: Icons.list_alt,
              title: 'Create shared lists',
              subtitle: 'Allow members to create lists shared with family',
              enabled: isOwner,
            ),
            _buildPermissionTile(
              context,
              icon: Icons.task_alt,
              title: 'Assign tasks',
              subtitle: 'Allow members to assign tasks to others',
              enabled: isOwner,
            ),
            _buildPermissionTile(
              context,
              icon: Icons.pets,
              title: 'Manage entities',
              subtitle: 'Allow editing of shared family entities',
              enabled: isOwner,
            ),
            _buildPermissionTile(
              context,
              icon: Icons.calendar_today,
              title: 'Calendar events',
              subtitle: 'Allow creating family calendar events',
              enabled: isOwner,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingTile(
              context,
              icon: Icons.task_alt,
              title: 'Task assignments',
              subtitle: 'Notify when tasks are assigned to you',
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.list_alt,
              title: 'List updates',
              subtitle: 'Notify when shared lists are modified',
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
            _buildSettingTile(
              context,
              icon: Icons.person_add,
              title: 'New members',
              subtitle: 'Notify when someone joins the family',
              value: true,
              onChanged: (value) {
                // TODO: Implement notification toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSettings(BuildContext context, WidgetRef ref, family) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionTile(
              context,
              icon: Icons.edit,
              title: 'Edit family name',
              subtitle: 'Change your family group name',
              onTap: () => _showEditFamilyNameDialog(context, ref, family),
            ),
            _buildActionTile(
              context,
              icon: Icons.people,
              title: 'Manage member roles',
              subtitle: 'Change member permissions and roles',
              onTap: () => _navigateToMemberRoles(context),
            ),
            _buildActionTile(
              context,
              icon: Icons.transfer_within_a_station,
              title: 'Transfer ownership',
              subtitle: 'Transfer family ownership to another member',
              onTap: () => _showTransferOwnershipDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, WidgetRef ref, family) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDangerActionTile(
              context,
              icon: Icons.delete_forever,
              title: 'Delete family group',
              subtitle: 'Permanently delete this family and all shared data',
              onTap: () => _showDeleteFamilyDialog(context, ref, family),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
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
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: enabled ? AppTheme.success : AppTheme.textSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              enabled ? 'Allowed' : 'Restricted',
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.accent, size: 20),
            ),
            const SizedBox(width: 16),
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
                    subtitle,
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
        ),
      ),
    );
  }

  Widget _buildDangerActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.red.shade700, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.red.shade600,
            ),
          ],
        ),
      ),
    );
  }

  // Dialog and navigation methods
  void _showEditFamilyNameDialog(BuildContext context, WidgetRef ref, family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Family Name'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Family Name',
            hintText: 'Enter new family name',
          ),
          controller: TextEditingController(text: family.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement family name update
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showTransferOwnershipDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer Ownership'),
        content: const Text(
          'Are you sure you want to transfer ownership? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement ownership transfer
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFamilyDialog(BuildContext context, WidgetRef ref, family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Family Group'),
        content: const Text(
          'This will permanently delete your family group and all shared data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement family deletion
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToMemberRoles(BuildContext context) {
    // TODO: Navigate to member roles management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member roles management coming soon')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 