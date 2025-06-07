import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/navigation/education_navigator.dart'; // Import the navigator
import 'package:vuet_app/ui/shared/widgets.dart'; // Assuming VuetHeader, VuetFAB etc. are here

class SchoolListScreen extends ConsumerWidget {
  const SchoolListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsAsyncValue = ref.watch(allSchoolsProvider);

    return Scaffold(
      appBar: VuetHeader('Schools'),
      body: schoolsAsyncValue.when(
        data: (schools) {
          if (schools.isEmpty) {
            return const Center(child: Text('No schools found. Add one!'));
          }
          return ListView.builder(
            itemCount: schools.length,
            itemBuilder: (context, index) {
              final school = schools[index];
              return ListTile(
                title: Text(school.name),
                subtitle: Text(school.address ?? 'No address'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.people_outline), // Icon to view students
                      tooltip: 'View Students',
                      onPressed: () {
                        // Navigate to student list for this school
                        EducationNavigator.navigateToStudentList(context, schoolId: school.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit School',
                      onPressed: () {
                        EducationNavigator.navigateToSchoolForm(context, schoolId: school.id);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to student list for this school as primary action
                  EducationNavigator.navigateToStudentList(context, schoolId: school.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: VuetFAB(
        tooltip: 'Add School',
        onPressed: () {
          EducationNavigator.navigateToSchoolForm(context);
        },
      ),
    );
  }
}
