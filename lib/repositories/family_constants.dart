enum FamilyErrorCodes {
  networkError,
  insufficientPermissions,
  userAlreadyInFamily,
  memberLimitReached,
  unknownError,
}

class FamilyException implements Exception {
  final String message;
  final FamilyErrorCodes code;
  final dynamic originalException;

  const FamilyException(this.message, this.code, [this.originalException]);

  @override
  String toString() {
    if (originalException != null) {
      return 'FamilyException: $message (Code: $code, Original: $originalException)';
    }
    return 'FamilyException: $message (Code: $code)';
  }
}

class FamilyPermissions {
  static const String dissolveFamily = 'dissolve_family';
  static const String transferOwnership = 'transfer_ownership';
  static const String modifySettings = 'modify_settings';
  static const String manageMembers = 'manage_members';
  static const String inviteMembers = 'invite_members';
  static const String manageInvitations = 'manage_invitations';
  static const String viewMembers = 'view_members';
  static const String assignTasks = 'assign_tasks';
  static const String manageSharedContent = 'manage_shared_content';
}
