/// Model representing a subscription plan
class SubscriptionPlanModel {
  /// Plan ID
  final String id;
  
  /// Plan name
  final String name;
  
  /// Plan type (personal or professional)
  final String type;
  
  /// Monthly price
  final double priceMonthly;
  
  /// Yearly price
  final double priceYearly;
  
  /// Plan features
  final Map<String, dynamic> features;
  
  /// When the plan was created
  final DateTime createdAt;
  
  /// When the plan was last updated
  final DateTime updatedAt;
  
  /// Constructor
  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.type,
    required this.priceMonthly,
    required this.priceYearly,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
  });
  
  /// Create a model from JSON data
  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      priceMonthly: double.parse(json['price_monthly'].toString()),
      priceYearly: double.parse(json['price_yearly'].toString()),
      features: Map<String, dynamic>.from(json['features'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  
  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price_monthly': priceMonthly,
      'price_yearly': priceYearly,
      'features': features,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  /// Whether this plan supports flexible tasks
  bool get supportsFlexibleTasks => features['tasks'] == 'fixed_and_flexible';
  
  /// Whether this plan supports references
  bool get supportsReferences => features['references'] == true;
  
  /// Whether this plan supports routines
  bool get supportsRoutines => features['routines'] == true;
  
  /// Number of past event months supported
  int get pastEventMonths => features['past_events_months'] ?? 3;
  
  /// Whether this plan supports AI assistant
  bool get supportsAI => features['ai_assistant'] == true;
  
  /// Whether this plan supports automation packages
  bool get supportsAutomation => features['automation_packages'] == true;
  
  /// Maximum family members for this plan
  int get maxFamilyMembers => features['max_family_members'] ?? 1;
  
  /// Whether this is a family plan
  bool get isFamilyPlan => maxFamilyMembers > 1;
  
  /// Yearly savings compared to monthly
  double get yearlySavings => (priceMonthly * 12) - priceYearly;
  
  /// Yearly savings percentage
  double get yearlySavingsPercent => (yearlySavings / (priceMonthly * 12)) * 100;
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is SubscriptionPlanModel && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
