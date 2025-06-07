import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/navigation/education_navigator.dart'; // Import the navigator
import 'package:vuet_app/ui/shared/widgets.dart';

class AcademicPlanListScreen extends ConsumerWidget {
  final String? studentId; // To show plans for a specific student

  const AcademicPlanListScreen({super.key, this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsyncValue = studentId == null
        ? ref.watch(allAcademicPlansProvider)
        : ref.watch(academicPlansForStudentProvider(studentId!));

    return Scaffold(
      appBar: VuetHeader('Academic Plans'),
      body: plansAsyncValue.when(
        data: (plans) {
          if (plans.isEmpty) {
            return const Center(child: Text('No academic plans found.'));
          }
          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return ListTile(
                title: Text(plan.planName),
                subtitle: Text(plan.description ?? 'No description'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Academic Plan',
                  onPressed: () {
                    EducationNavigator.navigateToAcademicPlanForm(context, academicPlanId: plan.id, studentIdForContext: studentId);
                  },
                ),
                onTap: () {
                  // Navigate to form for editing as primary action
                  EducationNavigator.navigateToAcademicPlanForm(context, academicPlanId: plan.id, studentIdForContext: studentId);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: studentId != null ? VuetFAB( // Only show FAB if studentId is present
        tooltip: 'Add Academic Plan',
        onPressed: () {
          EducationNavigator.navigateToAcademicPlanForm(context, studentIdForContext: studentId);
        },
      ) : null, // No FAB if no studentId (global list view)
    );
  }
}
