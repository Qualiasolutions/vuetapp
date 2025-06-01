import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/family_providers.dart';
import 'package:vuet_app/providers/user_providers.dart'; // Import user_providers
import 'package:vuet_app/ui/screens/family/create_family_screen.dart';
import 'package:vuet_app/ui/screens/family/invite_member_screen.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/models/user_model.dart'; // Import UserModel

/// Screen for managing family members
class FamilyMembersScreen extends ConsumerStatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  ConsumerState<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends ConsumerState<FamilyMembersScreen> {

  @override
  Widget build(BuildContext context) {
    final currentUserFamilyAsync = ref.watch(currentUserFamilyProvider);
    final familyMembersAsync = ref.watch(familyMembersProvider);
    final isFamilyOwnerAsync = ref.watch(isFamilyOwnerProvider);
    final currentUserModelAsync = ref.watch(currentUserModelProvider); // Watch currentUserModelProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Members'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(familyMembersProvider);
          ref.invalidate(currentUserFamilyProvider);
          ref.invalidate(currentUserModelProvider); // Invalidate currentUserModelProvider
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Family Info Card
              currentUserFamilyAsync.when(
                data: (family) {
                  if (family == null) {
                    return _buildNoFamilyCard(context);
                  }
                  return _buildFamilyInfoCard(context, family);
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
                    child: Text('Error loading family: $error'),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Invite Member Section
              isFamilyOwnerAsync.when(
                data: (isOwner) {
                  if (isOwner) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInviteMemberButton(context),
                        const SizedBox(height: 24),
                      ],
                    );
                  }
                  return const SizedBox();
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              // Family Members List
              Text(
                'Family Members',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              familyMembersAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No family members yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Invite family members to start collaborating',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: members.map((member) {
                      return _buildMemberCard(context, ref, member, currentUserModelAsync.value); // Pass currentUserModel
                    }).toList(),
                  );
                },
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorView(
                  message: 'Failed to load family members: $error',
                  onRetry: () => ref.invalidate(familyMembersProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoFamilyCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.family_restroom,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Family Group',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re not part of a family group yet. Create one or accept an invitation to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _showCreateFamilyDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Create Family Group'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyInfoCard(BuildContext context, family) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        family.name ?? 'Family Group',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (family.description != null)
                        Text(
                          family.description!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(family.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMemberCard(BuildContext context, WidgetRef ref, member, UserModel? currentUser) { // Accept UserModel
    final isCurrentUser = member.userId == currentUser?.id;
    final isFamilyOwner = ref.watch(isFamilyOwnerProvider).value ?? false;

    Color? avatarColor;
    if (member.memberColor.startsWith('#')) {
      final colorHex = member.memberColor.replaceFirst('#', '');
      try {
        avatarColor = Color(int.parse('0xFF$colorHex'));
      } catch (e) {
        avatarColor = Colors.grey;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor ?? Colors.blue,
          foregroundColor: Colors.white,
          backgroundImage: member.profileImageUrl != null
              ? NetworkImage(member.profileImageUrl!)
              : null,
          child: member.profileImageUrl == null
              ? Text((member.firstName ?? 'U')[0].toUpperCase())
              : null,
        ),
        title: Text('${member.firstName ?? ''} ${member.lastName ?? ''}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email ?? ''),
            if (member.role != null)
              Text(
                member.role!.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: member.role == 'owner'
                      ? Colors.amber[700]
                      : Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: isCurrentUser
            ? Chip(
                label: const Text('You'),
                backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
              )
            : (isFamilyOwner && !isCurrentUser)
                ? PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            Icon(Icons.remove_circle, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Remove from family'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'remove') {
                        _confirmRemoveMember(context, ref, member);
                      }
                    },
                  )
                : null,
      ),
    );
  }

  Widget _buildInviteMemberButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InviteMemberScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Invite New Member'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _showCreateFamilyDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateFamilyScreen(),
      ),
    );
  }

  void _confirmRemoveMember(BuildContext context, WidgetRef ref, member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text(
          'Are you sure you want to remove ${member.firstName} ${member.lastName} from the family?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final controller = ref.read(familyActionsControllerProvider.notifier);
                final success = await controller.removeFamilyMember(member.userId);
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Family member removed')),
                  );
                  ref.invalidate(familyMembersProvider);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to remove member: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return 'Today';
    }
  }
}
