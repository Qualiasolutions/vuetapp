import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/social_interest_models.dart';
import 'package:vuet_app/providers/social_interest_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart';
// import 'package:vuet_app/ui/navigation/social_interests_navigator.dart'; // Will be created later

class SocialPlanListScreen extends ConsumerWidget {
  const SocialPlanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialPlansAsyncValue = ref.watch(userSocialPlansProvider);

    return Scaffold(
      appBar: const VuetHeader('Social Plans'),
      body: socialPlansAsyncValue.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('No social plans yet. Add one!'));
          }
          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return ListTile(
                title: Text(plan.title),
                subtitle: Text('${MaterialLocalizations.of(context).formatShortDate(plan.planDate)} ${plan.location ?? ''}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete "${plan.title}"?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                            ),
                            TextButton(
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm == true) {
                      try {
                        await ref.read(socialPlanRepositoryProvider).deleteSocialPlan(plan.id);
                        ref.invalidate(userSocialPlansProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${plan.title}" deleted.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting social plan: $e')),
                        );
                      }
                    }
                  },
                ),
                onTap: () {
                  // SocialInterestsNavigator.navigateToSocialPlanForm(context, planId: plan.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: VuetFAB(
        onPressed: () {
          // SocialInterestsNavigator.navigateToSocialPlanForm(context);
        },
        tooltip: 'Add Social Plan',
      ),
    );
  }
}
