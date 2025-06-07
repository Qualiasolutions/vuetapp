import 'package:flutter/material.dart';
import 'package:vuet_app/ui/navigation/education_navigator.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader and VuetCategoryTile

class EducationCategoryScreen extends StatelessWidget {
  const EducationCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Education'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          VuetCategoryTile(
            title: 'Schools',
            icon: Icons.school_outlined, // Using outlined icon for consistency
            onTap: () => EducationNavigator.navigateToSchoolList(context),
          ),
          const SizedBox(height: 16),
          VuetCategoryTile(
            title: 'Students',
            icon: Icons.person_outline, // Using outlined icon
            onTap: () => EducationNavigator.navigateToStudentList(context),
          ),
          const SizedBox(height: 16),
          VuetCategoryTile(
            title: 'Academic Plans',
            icon: Icons.assignment_outlined, // Using outlined icon
            onTap: () => EducationNavigator.navigateToAcademicPlanList(context),
          ),
          const SizedBox(height: 16),
          // TODO: Add navigation for School Terms and School Breaks
          // VuetCategoryTile(
          //   title: 'School Terms',
          //   icon: Icons.date_range_outlined,
          //   onTap: () {
          //     // TODO: Implement navigation to School Terms list screen
          //     // Example: context.go('/education/school-terms'); or SchoolTermsNavigator.navigateToSchoolTermList(context)
          //   },
          // ),
          // const SizedBox(height: 16),
          // VuetCategoryTile(
          //   title: 'School Breaks',
          //   icon: Icons.beach_access_outlined,
          //   onTap: () {
          //     // TODO: Implement navigation to School Breaks list screen
          //     // Example: context.go('/education/school-breaks'); or SchoolBreaksNavigator.navigateToSchoolBreakList(context)
          //   },
          // ),
        ],
      ),
    );
  }
}
