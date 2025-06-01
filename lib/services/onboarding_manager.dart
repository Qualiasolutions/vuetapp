import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/setup_service.dart';
import 'package:vuet_app/constants/setup_content.dart';
import 'package:vuet_app/ui/screens/onboarding/category_introduction_screen.dart';
import 'package:vuet_app/ui/screens/onboarding/entity_type_introduction_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Comprehensive onboarding manager that handles all instructional flows
class OnboardingManager {
  final SetupService _setupService = SetupService();
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if category introduction is needed
  Future<bool> shouldShowCategoryIntroduction(String categoryId) async {
    // Check if user has completed the introduction
    final isCompleted = await _setupService.isCategorySetupCompleted(categoryId);
    
    // Also check if category has introduction content
    final hasContent = SetupContent.hasCategorySetup(categoryId);
    
    return !isCompleted && hasContent;
  }

  /// Check if entity type introduction is needed
  Future<bool> shouldShowEntityTypeIntroduction(String entityTypeName) async {
    final isCompleted = await _setupService.isEntityTypeSetupCompleted(entityTypeName);
    final hasContent = SetupContent.hasEntityTypeSetup(entityTypeName);
    
    return !isCompleted && hasContent;
  }

  /// Show category introduction if needed
  Future<bool?> showCategoryIntroductionIfNeeded(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) async {
    final shouldShow = await shouldShowCategoryIntroduction(categoryId);
    
    if (!shouldShow) return null;

    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryIntroductionScreen(
          categoryId: categoryId,
          categoryName: categoryName,
          onComplete: () {
            // Optional: Track completion analytics
            _trackIntroductionCompletion('category', categoryId);
          },
        ),
      ),
    );
  }

  /// Show entity type introduction if needed
  Future<bool?> showEntityTypeIntroductionIfNeeded(
    BuildContext context,
    String entityTypeName,
    String categoryId,
    String categoryName,
  ) async {
    final shouldShow = await shouldShowEntityTypeIntroduction(entityTypeName);
    
    if (!shouldShow) return null;

    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EntityTypeIntroductionScreen(
          entityTypeName: entityTypeName,
          categoryId: categoryId,
          categoryName: categoryName,
          onComplete: () {
            _trackIntroductionCompletion('entity_type', entityTypeName);
          },
        ),
      ),
    );
  }

  /// Get onboarding progress for a user
  Future<OnboardingProgress> getUserOnboardingProgress() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return OnboardingProgress.empty();
    }

    // Get all available categories and entity types
    final availableCategories = SetupContent.categorySetupPages.keys.toList();
    final availableEntityTypes = SetupContent.entityTypeSetupPages.keys.toList();

    // Get completion status
    final categoryStatus = await _setupService.getCategorySetupStatus(availableCategories);
    final entityTypeStatus = await _setupService.getEntityTypeSetupStatus(availableEntityTypes);

    final completedCategories = categoryStatus.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final completedEntityTypes = entityTypeStatus.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return OnboardingProgress(
      completedCategories: completedCategories,
      availableCategories: availableCategories,
      completedEntityTypes: completedEntityTypes,
      availableEntityTypes: availableEntityTypes,
      categoryCompletionStatus: categoryStatus,
      entityTypeCompletionStatus: entityTypeStatus,
    );
  }

  /// Get suggested next introductions
  Future<List<OnboardingSuggestion>> getNextSuggestions({int limit = 3}) async {
    final progress = await getUserOnboardingProgress();
    final suggestions = <OnboardingSuggestion>[];

    // Suggest incomplete categories first
    for (final category in progress.availableCategories) {
      if (!progress.categoryCompletionStatus[category]! && suggestions.length < limit) {
        suggestions.add(OnboardingSuggestion(
          type: OnboardingSuggestionType.category,
          id: category,
          title: _getCategoryDisplayName(category),
          description: 'Learn how to organize your ${_getCategoryDisplayName(category).toLowerCase()}',
          priority: _getCategoryPriority(category),
        ));
      }
    }

    // Then suggest entity types if we haven't reached the limit
    for (final entityType in progress.availableEntityTypes) {
      if (!progress.entityTypeCompletionStatus[entityType]! && suggestions.length < limit) {
        suggestions.add(OnboardingSuggestion(
          type: OnboardingSuggestionType.entityType,
          id: entityType,
          title: entityType,
          description: 'Discover how to use $entityType effectively',
          priority: _getEntityTypePriority(entityType),
        ));
      }
    }

    // Sort by priority and return
    suggestions.sort((a, b) => b.priority.compareTo(a.priority));
    return suggestions.take(limit).toList();
  }

  /// Show onboarding suggestion
  Future<void> showOnboardingSuggestion(
    BuildContext context,
    OnboardingSuggestion suggestion,
  ) async {
    switch (suggestion.type) {
      case OnboardingSuggestionType.category:
        await showCategoryIntroductionIfNeeded(
          context,
          suggestion.id,
          suggestion.title,
        );
        break;
      case OnboardingSuggestionType.entityType:
        // For entity types, we need to determine the category
        final categoryId = _getEntityTypeCategory(suggestion.id);
        final categoryName = _getCategoryDisplayName(categoryId);
        await showEntityTypeIntroductionIfNeeded(
          context,
          suggestion.id,
          categoryId,
          categoryName,
        );
        break;
    }
  }

  /// Check if user should see the general app onboarding
  Future<bool> shouldShowAppIntroduction() async {
    final progress = await getUserOnboardingProgress();
    
    // Show app intro if user hasn't completed any category introductions
    return progress.completedCategories.isEmpty;
  }

  /// Mark a category as requiring re-introduction (e.g., after major updates)
  Future<void> resetCategoryIntroduction(String categoryId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    await _supabase
        .from('category_setup_completions')
        .delete()
        .eq('user_id', userId)
        .eq('category_id', categoryId);
  }

  /// Get family-wide onboarding progress (if user is in a family)
  Future<FamilyOnboardingProgress?> getFamilyOnboardingProgress() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    // Get user's family information
    final familyResponse = await _supabase
        .from('profiles')
        .select('family_id')
        .eq('id', userId)
        .maybeSingle();

    final familyId = familyResponse?['family_id'] as String?;
    if (familyId == null) return null;

    // Get all family members
    final membersResponse = await _supabase
        .from('profiles')
        .select('id, first_name, family_role')
        .eq('family_id', familyId);

    final familyMembers = membersResponse as List;

    // Get completion status for all family members
    final allCompletions = <String, Map<String, bool>>{};
    
    for (final member in familyMembers) {
      final memberId = member['id'] as String;
      
      // Get category completions for this member
      final memberCategoryResponse = await _supabase
          .from('category_setup_completions')
          .select('category_id')
          .eq('user_id', memberId);

      final completedCategories = (memberCategoryResponse as List)
          .map((row) => row['category_id'] as String)
          .toSet();

      final memberProgress = <String, bool>{};
      for (final category in SetupContent.categorySetupPages.keys) {
        memberProgress[category] = completedCategories.contains(category);
      }
      
      allCompletions[memberId] = memberProgress;
    }

    return FamilyOnboardingProgress(
      familyId: familyId,
      members: familyMembers.map((m) => FamilyMember(
        id: m['id'] as String,
        name: m['first_name'] as String? ?? 'Family Member',
        role: m['family_role'] as String? ?? 'member',
      )).toList(),
      memberCompletions: allCompletions,
    );
  }

  // Private helper methods
  void _trackIntroductionCompletion(String type, String id) {
    // TODO: Add analytics tracking here
    print('Introduction completed: $type - $id');
  }

  String _getCategoryDisplayName(String categoryId) {
    const displayNames = {
      'pets': 'Pets',
      'social_interests': 'Social & Interests',
      'education': 'Education',
      'career': 'Career',
      'travel': 'Travel',
      'health_beauty': 'Health & Beauty',
      'home': 'Home',
      'garden': 'Garden',
      'food': 'Food',
      'laundry': 'Laundry',
      'finance': 'Finance',
      'transport': 'Transport',
    };
    return displayNames[categoryId] ?? categoryId;
  }

  int _getCategoryPriority(String categoryId) {
    // Higher numbers = higher priority
    const priorities = {
      'pets': 10,
      'social_interests': 9,
      'home': 8,
      'health_beauty': 7,
      'education': 6,
      'career': 5,
      'finance': 4,
      'travel': 3,
      'transport': 2,
      'garden': 1,
      'food': 1,
      'laundry': 1,
    };
    return priorities[categoryId] ?? 0;
  }

  int _getEntityTypePriority(String entityType) {
    const priorities = {
      'SocialPlan': 10,
      'Event': 9,
      'Hobby': 8,
      'SocialMedia': 7,
    };
    return priorities[entityType] ?? 5;
  }

  String _getEntityTypeCategory(String entityType) {
    const mapping = {
      'SocialPlan': 'social_interests',
      'SocialMedia': 'social_interests',
      'Event': 'social_interests',
      'Hobby': 'social_interests',
    };
    return mapping[entityType] ?? 'social_interests';
  }
}

/// Progress tracking models
class OnboardingProgress {
  final List<String> completedCategories;
  final List<String> availableCategories;
  final List<String> completedEntityTypes;
  final List<String> availableEntityTypes;
  final Map<String, bool> categoryCompletionStatus;
  final Map<String, bool> entityTypeCompletionStatus;

  const OnboardingProgress({
    required this.completedCategories,
    required this.availableCategories,
    required this.completedEntityTypes,
    required this.availableEntityTypes,
    required this.categoryCompletionStatus,
    required this.entityTypeCompletionStatus,
  });

  factory OnboardingProgress.empty() {
    return const OnboardingProgress(
      completedCategories: [],
      availableCategories: [],
      completedEntityTypes: [],
      availableEntityTypes: [],
      categoryCompletionStatus: {},
      entityTypeCompletionStatus: {},
    );
  }

  double get overallProgress {
    final totalItems = availableCategories.length + availableEntityTypes.length;
    final completedItems = completedCategories.length + completedEntityTypes.length;
    
    if (totalItems == 0) return 0.0;
    return completedItems / totalItems;
  }

  double get categoryProgress {
    if (availableCategories.isEmpty) return 0.0;
    return completedCategories.length / availableCategories.length;
  }

  double get entityTypeProgress {
    if (availableEntityTypes.isEmpty) return 0.0;
    return completedEntityTypes.length / availableEntityTypes.length;
  }
}

class OnboardingSuggestion {
  final OnboardingSuggestionType type;
  final String id;
  final String title;
  final String description;
  final int priority;

  const OnboardingSuggestion({
    required this.type,
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
  });
}

enum OnboardingSuggestionType { category, entityType }

class FamilyOnboardingProgress {
  final String familyId;
  final List<FamilyMember> members;
  final Map<String, Map<String, bool>> memberCompletions;

  const FamilyOnboardingProgress({
    required this.familyId,
    required this.members,
    required this.memberCompletions,
  });

  double getFamilyProgress() {
    if (members.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final member in members) {
      final memberProgress = memberCompletions[member.id];
      if (memberProgress != null) {
        final completed = memberProgress.values.where((v) => v).length;
        final total = memberProgress.length;
        totalProgress += total > 0 ? completed / total : 0.0;
      }
    }
    
    return totalProgress / members.length;
  }

  Map<String, double> getCategoryProgress() {
    final categoryProgress = <String, double>{};
    
    for (final category in SetupContent.categorySetupPages.keys) {
      int completed = 0;
      for (final member in members) {
        final memberProgress = memberCompletions[member.id];
        if (memberProgress?[category] == true) {
          completed++;
        }
      }
      categoryProgress[category] = members.isNotEmpty ? completed / members.length : 0.0;
    }
    
    return categoryProgress;
  }
}

class FamilyMember {
  final String id;
  final String name;
  final String role;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
  });
}

/// Provider for the onboarding manager
final onboardingManagerProvider = Provider<OnboardingManager>((ref) {
  return OnboardingManager();
});

/// Provider for user onboarding progress
final userOnboardingProgressProvider = FutureProvider<OnboardingProgress>((ref) async {
  final manager = ref.read(onboardingManagerProvider);
  return manager.getUserOnboardingProgress();
});

/// Provider for onboarding suggestions
final onboardingSuggestionsProvider = FutureProvider<List<OnboardingSuggestion>>((ref) async {
  final manager = ref.read(onboardingManagerProvider);
  return manager.getNextSuggestions();
});

/// Provider for family onboarding progress
final familyOnboardingProgressProvider = FutureProvider<FamilyOnboardingProgress?>((ref) async {
  final manager = ref.read(onboardingManagerProvider);
  return manager.getFamilyOnboardingProgress();
}); 