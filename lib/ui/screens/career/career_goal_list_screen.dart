import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/career_entities.dart';
import 'package:vuet_app/providers/career_providers.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader, VuetFAB
import 'package:vuet_app/ui/navigation/career_navigator.dart'; // For navigation
import 'package:vuet_app/config/theme_config.dart'; // For AppColors

class CareerGoalListScreen extends ConsumerWidget {
  const CareerGoalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careerGoalsAsync = ref.watch(userCareerGoalsProvider);

    return Scaffold(
      appBar: const VuetHeader('Career Goals'),
      body: careerGoalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('No career goals yet. Add one!'));
          }
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return ListTile(
                title: Text(goal.title),
                subtitle: Text(goal.status ?? 'No status'),
                trailing: Text(goal.targetDate != null ? '${goal.targetDate!.toLocal()}'.split(' ')[0] : 'No target date'),
                onTap: () => CareerNavigator.navigateToCareerGoalForm(context, careerGoalId: goal.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => CareerNavigator.navigateToCareerGoalForm(context),
      ),
    );
  }
}
