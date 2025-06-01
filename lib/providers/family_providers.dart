import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/family_invitation_model.dart';
import 'package:vuet_app/models/family_model.dart';
import 'package:vuet_app/repositories/family_repository.dart';
import 'package:vuet_app/repositories/supabase_family_repository.dart';
import 'package:vuet_app/services/realtime_subscription_manager.dart';
import 'package:vuet_app/providers/auth_providers.dart'; // Import auth_providers

/// Provider for the FamilyRepository
final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  final subscriptionManager = ref.watch(realtimeSubscriptionManagerProvider);
  return SupabaseFamilyRepository(subscriptionManager: subscriptionManager);
});

/// Provider for the current user's family
final currentUserFamilyProvider = FutureProvider<FamilyModel?>((ref) async {
  final supabaseUser = ref.watch(currentUserProvider);

  if (supabaseUser == null) {
    return null;
  }
  final familyRepository = ref.read(familyRepositoryProvider);
  return await familyRepository.getCurrentUserFamily();
});

/// Provider for the current user's family members
final familyMembersProvider =
    FutureProvider<List<FamilyMemberModel>>((ref) async {
  final familyAsync = ref.watch(currentUserFamilyProvider);

  return familyAsync.when(
    data: (family) async {
      if (family == null) {
        return [];
      }
      final familyRepository = ref.read(familyRepositoryProvider);
      return await familyRepository.getFamilyMembers(family.id);
    },
    loading: () => [],
    error: (err, stack) {
      // Optionally log error: print('Error fetching family members: $err');
      return [];
    },
  );
});

/// Provider for the current user's sent invitations
final sentInvitationsProvider =
    FutureProvider<List<FamilyInvitationModel>>((ref) async {
  final familyRepository = ref.read(familyRepositoryProvider);
  return await familyRepository.getSentInvitations();
});

/// Provider for the current user's received invitations
final receivedInvitationsProvider =
    FutureProvider<List<FamilyInvitationModel>>((ref) async {
  final familyRepository = ref.read(familyRepositoryProvider);
  return await familyRepository.getReceivedInvitations();
});

/// Provider to check if the current user is the family owner
final isFamilyOwnerProvider = FutureProvider<bool>((ref) async {
  final supabaseUser = ref.watch(currentUserProvider);
  final familyAsync = ref.watch(currentUserFamilyProvider);

  if (supabaseUser == null) {
    return false;
  }

  return familyAsync.when(
    data: (family) {
      if (family == null) {
        return false;
      }
      return family.ownerId == supabaseUser.id;
    },
    loading: () => false,
    error: (err, stack) {
      // Optionally log error: print('Error fetching family for ownership check: $err');
      return false;
    },
  );
});

/// Controller for family invitation actions
class FamilyInvitationNotifier extends StateNotifier<AsyncValue<void>> {
  final FamilyRepository _familyRepository;

  FamilyInvitationNotifier(this._familyRepository)
      : super(const AsyncValue.data(null));

  /// Send an invitation to join the family
  Future<bool> inviteFamilyMember(String email) async {
    state = const AsyncValue.loading();
    try {
      // Get current user's family
      final family = await _familyRepository.getCurrentUserFamily();
      if (family == null) {
        state = AsyncValue.error('No family found', StackTrace.current);
        return false;
      }

      await _familyRepository.sendFamilyInvitation(
        email: email,
        familyId: family.id,
      );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Cancel a pending invitation
  Future<bool> cancelInvitation(String invitationId) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await _familyRepository.cancelFamilyInvitation(invitationId);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Accept a family invitation
  Future<bool> acceptInvitation(String invitationId) async {
    state = const AsyncValue.loading();
    try {
      final result =
          await _familyRepository.acceptFamilyInvitation(invitationId);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Provider for family invitation actions controller
final familyInvitationControllerProvider =
    StateNotifierProvider<FamilyInvitationNotifier, AsyncValue<void>>((ref) {
  final familyRepository = ref.read(familyRepositoryProvider);
  return FamilyInvitationNotifier(familyRepository);
});

/// Controller for general family actions (create, remove member, leave, delete)
class FamilyActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final FamilyRepository _familyRepository;

  FamilyActionsNotifier(this._familyRepository)
      : super(const AsyncValue.data(null));

  Future<bool> createFamily(String name) async {
    state = const AsyncValue.loading();
    try {
      await _familyRepository.createFamily(name: name);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Remove a family member
  Future<bool> removeFamilyMember(String memberId) async {
    state = const AsyncValue.loading();
    try {
      // Get current user's family
      final family = await _familyRepository.getCurrentUserFamily();
      if (family == null) {
        state = AsyncValue.error('No family found', StackTrace.current);
        return false;
      }

      final result =
          await _familyRepository.removeFamilyMember(family.id, memberId);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  /// Leave the family group
  Future<bool> leaveFamilyGroup() async {
    state = const AsyncValue.loading();
    try {
      final result = await _familyRepository.leaveFamilyGroup();
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<bool> deleteFamily(String familyId) async {
    state = const AsyncValue.loading();
    try {
      final result = await _familyRepository.deleteFamily(familyId);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
}

/// Provider for general family actions controller
final familyActionsControllerProvider =
    StateNotifierProvider<FamilyActionsNotifier, AsyncValue<void>>((ref) {
  final familyRepository = ref.read(familyRepositoryProvider);
  return FamilyActionsNotifier(familyRepository);
});
