import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_invitation_model.freezed.dart';
part 'family_invitation_model.g.dart';

/// Model representing a family invitation in the application
@freezed
class FamilyInvitationModel with _$FamilyInvitationModel {
  const factory FamilyInvitationModel({
    /// Unique ID of the invitation
    required String id,
    
    /// ID of the user who sent the invitation
    required String inviterId,
    
    /// Email address of the invitee
    required String inviteeEmail,
    
    /// ID of the family this invitation is for
    required String familyId,
    
    /// When the invitation was created
    required DateTime createdAt,
    
    /// When the invitation expires
    required DateTime expiresAt,
    
    /// Status of the invitation
    @Default(FamilyInvitationStatus.pending) FamilyInvitationStatus status,
    
    /// Optional message from the inviter
    String? message,
    
    /// Details about the inviter (populated when needed)
    String? inviterName,
    String? inviterEmail,
    
    /// Details about the family (populated when needed)
    String? familyName,
    String? familyImageUrl,
    
    /// When the invitation was responded to (accepted/declined)
    DateTime? respondedAt,
  }) = _FamilyInvitationModel;

  factory FamilyInvitationModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyInvitationModelFromJson(json);
}

/// Enum representing the status of a family invitation
enum FamilyInvitationStatus {
  /// Invitation is pending response
  pending,
  
  /// Invitation has been accepted
  accepted,
  
  /// Invitation has been declined
  declined,
  
  /// Invitation has been cancelled by sender
  cancelled,
  
  /// Invitation has expired
  expired;

  /// Display name for the status
  String get displayName {
    switch (this) {
      case FamilyInvitationStatus.pending:
        return 'Pending';
      case FamilyInvitationStatus.accepted:
        return 'Accepted';
      case FamilyInvitationStatus.declined:
        return 'Declined';
      case FamilyInvitationStatus.cancelled:
        return 'Cancelled';
      case FamilyInvitationStatus.expired:
        return 'Expired';
    }
  }

  /// Whether this status indicates the invitation is still actionable
  bool get isActionable {
    return this == FamilyInvitationStatus.pending;
  }

  /// Whether this status indicates a final state
  bool get isFinal {
    return this != FamilyInvitationStatus.pending;
  }
}

/// Extension to add helpful methods to FamilyInvitationModel
extension FamilyInvitationModelExtension on FamilyInvitationModel {
  /// Whether the invitation is expired based on expiration date
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  /// Whether the invitation is pending and not expired
  bool get isPending => status == FamilyInvitationStatus.pending && !isExpired;
  
  /// Whether the invitation has been accepted
  bool get isAccepted => status == FamilyInvitationStatus.accepted;
  
  /// Whether the invitation has been declined
  bool get isDeclined => status == FamilyInvitationStatus.declined;
  
  /// Whether the invitation has been cancelled
  bool get isCancelled => status == FamilyInvitationStatus.cancelled;
  
  /// Whether the invitation can still be responded to
  bool get canRespond => isPending;
  
  /// Whether the invitation can still be cancelled by the sender
  bool get canCancel => status == FamilyInvitationStatus.pending;
  
  /// Get the current effective status (considering expiration)
  FamilyInvitationStatus get effectiveStatus {
    if (status == FamilyInvitationStatus.pending && isExpired) {
      return FamilyInvitationStatus.expired;
    }
    return status;
  }
  
  /// Get a display-friendly expiration time
  String get expirationDescription {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);
    
    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inDays > 0) {
      return 'Expires in ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return 'Expires in ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else {
      return 'Expires soon';
    }
  }
  
  /// Get a summary text for the invitation
  String get summaryText {
    final family = familyName ?? 'a family';
    final inviter = inviterName ?? inviterEmail ?? 'Someone';
    return '$inviter invited you to join $family';
  }
}
