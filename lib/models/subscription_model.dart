/// Model representing a user's subscription
class SubscriptionModel {
  /// Subscription ID
  final String id;
  
  /// User/Profile ID
  final String profileId;
  
  /// Plan ID (references subscription_plans table)
  final String planId;
  
  /// Subscription status  
  final String status;
  
  /// Plan type reference
  final String? planType;
  
  /// Billing cycle (monthly or yearly)
  final String billingCycle;
  
  /// Number of family members
  final int familyMembersCount;
  
  /// Subscription start date
  final DateTime startDate;
  
  /// Subscription end date
  final DateTime? endDate;
  
  /// Payment provider (stripe, paypal, etc.)
  final String? paymentProvider;
  
  /// Payment provider subscription ID
  final String? paymentProviderSubscriptionId;
  
  /// When the subscription was created
  final DateTime createdAt;
  
  /// When the subscription was last updated
  final DateTime updatedAt;
  
  /// Constructor
  SubscriptionModel({
    required this.id,
    required this.profileId,
    required this.planId,
    required this.status,
    this.planType,
    this.billingCycle = 'monthly',
    this.familyMembersCount = 1,
    required this.startDate,
    this.endDate,
    this.paymentProvider,
    this.paymentProviderSubscriptionId,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Create a model from JSON data
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      profileId: json['profile_id'],
      planId: json['plan_id'],
      status: json['status'],
      planType: json['plan_type'],
      billingCycle: json['billing_cycle'] ?? 'monthly',
      familyMembersCount: json['family_members_count'] ?? 1,
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      paymentProvider: json['payment_provider'],
      paymentProviderSubscriptionId: json['payment_provider_subscription_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  
  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'plan_id': planId,
      'status': status,
      'plan_type': planType,
      'billing_cycle': billingCycle,
      'family_members_count': familyMembersCount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'payment_provider': paymentProvider,
      'payment_provider_subscription_id': paymentProviderSubscriptionId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Whether the subscription is active
  bool get isActive => status == 'active';
  
  /// Whether the subscription is cancelled
  bool get isCancelled => status == 'cancelled';
  
  /// Whether the subscription is past due
  bool get isPastDue => status == 'past_due';
  
  /// Whether the subscription is trialing
  bool get isTrialing => status == 'trialing';
  
  /// Whether this is a family subscription
  bool get isFamilyPlan => familyMembersCount > 1;
  
  /// Whether this is a yearly billing cycle
  bool get isYearly => billingCycle == 'yearly';
  
  /// Whether this is a monthly billing cycle
  bool get isMonthly => billingCycle == 'monthly';
  
  /// Days until renewal/expiry
  int? get daysUntilRenewal {
    if (endDate == null) return null;
    final now = DateTime.now();
    return endDate!.difference(now).inDays;
  }
  
  /// Whether subscription expires soon (within 7 days)
  bool get expiresSoon {
    final days = daysUntilRenewal;
    return days != null && days <= 7 && days > 0;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SubscriptionModel && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
