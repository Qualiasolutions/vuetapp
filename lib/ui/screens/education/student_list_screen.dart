import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/models/education_entities.dart';
import 'package:vuet_app/providers/education_providers.dart';
import 'package:vuet_app/ui/navigation/education_navigator.dart'; // Import the navigator
import 'package:vuet_app/ui/shared/widgets.dart';

class StudentListScreen extends ConsumerWidget {
  final String? schoolId;
  const StudentListScreen({super.key, this.schoolId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If schoolId is provided, we might want a specific provider or filter.
    // For now, we fetch all and filter.
    // Consider creating studentsForSchoolProvider(schoolId) for efficiency if this list gets large.
    final studentsAsyncValue = ref.watch(allStudentsProvider);

    return Scaffold(
      appBar: VuetHeader(schoolId == null ? 'All Students' : 'Students'), // Title changes if filtered
      body: studentsAsyncValue.when(
        data: (allStudents) {
          final List<Student> studentsToShow;
          if (schoolId != null) {
            studentsToShow = allStudents.where((s) => s.schoolId == schoolId).toList();
          } else {
            studentsToShow = allStudents;
          }

          if (studentsToShow.isEmpty) {
            return Center(child: Text(schoolId == null ? 'No students found. Add one!' : 'No students found for this school. Add one!'));
          }
          return ListView.builder(
            itemCount: studentsToShow.length,
            itemBuilder: (context, index) {
              final student = studentsToShow[index];
              return ListTile(
                title: Text('${student.firstName} ${student.lastName ?? ''}'),
                subtitle: Text(student.gradeLevel ?? 'No grade level'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     IconButton(
                      icon: const Icon(Icons.assignment_outlined), // Icon for academic plans
                      tooltip: 'View Academic Plans',
                      onPressed: () {
                        EducationNavigator.navigateToAcademicPlanList(context, studentId: student.id);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit Student',
                      onPressed: () {
                        EducationNavigator.navigateToStudentForm(context, studentId: student.id, schoolIdForContext: schoolId);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to academic plans for this student as primary action
                  EducationNavigator.navigateToAcademicPlanList(context, studentId: student.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: VuetFAB(
        tooltip: 'Add Student',
        onPressed: () {
          EducationNavigator.navigateToStudentForm(context, schoolIdForContext: schoolId);
        },
      ),
    );
  }
}
