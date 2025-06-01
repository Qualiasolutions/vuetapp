import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/services/onboarding_manager.dart';
import 'package:vuet_app/ui/theme/app_theme.dart';
import 'package:vuet_app/ui/widgets/loading_indicator.dart';
import 'package:vuet_app/ui/widgets/error_view.dart';

/// Modern onboarding dashboard that shows all available introductions
class OnboardingDashboardScreen extends ConsumerWidget {
  const OnboardingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userOnboardingProgressProvider);
    final suggestionsAsync = ref.watch(onboardingSuggestionsProvider);
    final familyProgressAsync = ref.watch(familyOnboardingProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Center'),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.textLight,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userOnboardingProgressProvider);
          ref.invalidate(onboardingSuggestionsProvider);
          ref.invalidate(familyOnboardingProgressProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeroSection(context),
              progressAsync.when(
                data: (progress) => _buildProgressSection(context, progress),
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorView(
                  message: 'Failed to load progress: $error',
                  onRetry: () => ref.invalidate(userOnboardingProgressProvider),
                ),
              ),
              suggestionsAsync.when(
                data: (suggestions) => _buildSuggestionsSection(context, ref, suggestions),
                loading: () => const LoadingIndicator(),
                error: (error, _) => ErrorView(
                  message: 'Failed to load suggestions: $error',
                  onRetry: () => ref.invalidate(onboardingSuggestionsProvider),
                ),
              ),
              familyProgressAsync.when(
                data: (familyProgress) => familyProgress != null 
                    ? _buildFamilyProgressSection(context, familyProgress)
                    : const SizedBox(),
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
              _buildAllCategoriesSection(context, ref),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
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
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.secondary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school,
                color: AppTheme.textLight,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Learning Center',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Discover how to make the most of Vuet with guided introductions for every category and feature.',
              style: TextStyle(
                color: AppTheme.textLight.withValues(alpha: 0.9),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, OnboardingProgress progress) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your Learning Progress',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildProgressBar(
                context,
                'Overall Progress',
                progress.overallProgress,
                AppTheme.primary,
              ),
              const SizedBox(height: 16),
              _buildProgressBar(
                context,
                'Categories',
                progress.categoryProgress,
                AppTheme.secondary,
              ),
              const SizedBox(height: 16),
              _buildProgressBar(
                context,
                'Entity Types',
                progress.entityTypeProgress,
                AppTheme.accent,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Completed',
                      '${progress.completedCategories.length + progress.completedEntityTypes.length}',
                      AppTheme.success,
                      Icons.check_circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Remaining',
                      '${(progress.availableCategories.length + progress.availableEntityTypes.length) - (progress.completedCategories.length + progress.completedEntityTypes.length)}',
                      AppTheme.info,
                      Icons.pending,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
            label,
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

  Widget _buildSuggestionsSection(BuildContext context, WidgetRef ref, List<OnboardingSuggestion> suggestions) {
    if (suggestions.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.celebration,
                  size: 64,
                  color: AppTheme.success,
                ),
                const SizedBox(height: 16),
                Text(
                  'Congratulations!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'ve completed all available introductions. You\'re a Vuet expert!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: AppTheme.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Suggested Next Steps',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...suggestions.map((suggestion) => _buildSuggestionCard(context, ref, suggestion)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, WidgetRef ref, OnboardingSuggestion suggestion) {
    final manager = ref.read(onboardingManagerProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          await manager.showOnboardingSuggestion(context, suggestion);
          // Refresh progress after completion
          ref.invalidate(userOnboardingProgressProvider);
          ref.invalidate(onboardingSuggestionsProvider);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  suggestion.type == OnboardingSuggestionType.category
                      ? Icons.category
                      : Icons.extension,
                  color: AppTheme.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.description,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
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
      ),
    );
  }

  Widget _buildFamilyProgressSection(BuildContext context, FamilyOnboardingProgress familyProgress) {
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
                children: [
                  Icon(
                    Icons.family_restroom,
                    color: AppTheme.secondary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Family Learning Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Overall Family Progress: ${(familyProgress.getFamilyProgress() * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: familyProgress.getFamilyProgress(),
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondary),
                minHeight: 8,
              ),
              const SizedBox(height: 16),
              Text(
                'Family Members',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...familyProgress.members.map((member) {
                final memberProgress = familyProgress.memberCompletions[member.id];
                final completedCount = memberProgress?.values.where((v) => v).length ?? 0;
                final totalCount = memberProgress?.length ?? 0;
                final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.secondary,
                        child: Text(
                          member.name.isNotEmpty ? member.name[0].toUpperCase() : 'M',
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${(progress * 100).round()}% complete',
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
                          color: AppTheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          member.role,
                          style: TextStyle(
                            color: AppTheme.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesSection(BuildContext context, WidgetRef ref) {
    final categories = [
      {'id': 'pets', 'name': 'Pets', 'icon': Icons.pets, 'color': AppTheme.accent},
      {'id': 'social_interests', 'name': 'Social & Interests', 'icon': Icons.people, 'color': AppTheme.secondary},
      {'id': 'education', 'name': 'Education', 'icon': Icons.school, 'color': AppTheme.info},
      {'id': 'career', 'name': 'Career', 'icon': Icons.work, 'color': AppTheme.primary},
      {'id': 'travel', 'name': 'Travel', 'icon': Icons.flight, 'color': const Color(0xFF9C27B0)},
      {'id': 'health_beauty', 'name': 'Health & Beauty', 'icon': Icons.favorite, 'color': const Color(0xFFE91E63)},
      {'id': 'home', 'name': 'Home', 'icon': Icons.home, 'color': const Color(0xFF795548)},
      {'id': 'garden', 'name': 'Garden', 'icon': Icons.local_florist, 'color': const Color(0xFF4CAF50)},
      {'id': 'food', 'name': 'Food', 'icon': Icons.restaurant, 'color': const Color(0xFFFF9800)},
      {'id': 'laundry', 'name': 'Laundry', 'icon': Icons.local_laundry_service, 'color': const Color(0xFF607D8B)},
      {'id': 'finance', 'name': 'Finance', 'icon': Icons.account_balance, 'color': const Color(0xFF3F51B5)},
      {'id': 'transport', 'name': 'Transport', 'icon': Icons.directions_car, 'color': const Color(0xFF9E9E9E)},
    ];

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
                children: [
                  Icon(
                    Icons.grid_view,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'All Category Introductions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(context, ref, category);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, WidgetRef ref, Map<String, dynamic> category) {
    final manager = ref.read(onboardingManagerProvider);
    
    return InkWell(
      onTap: () async {
        await manager.showCategoryIntroductionIfNeeded(
          context,
          category['id'] as String,
          category['name'] as String,
        );
        // Refresh progress after completion
        ref.invalidate(userOnboardingProgressProvider);
        ref.invalidate(onboardingSuggestionsProvider);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (category['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: (category['color'] as Color).withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              category['name'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Learn basics',
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
} 