import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/shared/widgets.dart';
import '../../../config/theme_config.dart';

/// Education Category Screen - Shows all Education entity types
/// As specified in detailed guide: School, Student, AcademicPlan, SchoolTerm, SchoolBreak
class EducationCategoryScreen extends StatelessWidget {
  const EducationCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Education'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _EducationEntityTile(
            title: 'Schools',
            icon: Icons.school,
            description: 'Manage schools',
            onTap: () => context.go('/categories/education/schools'),
          ),
          _EducationEntityTile(
            title: 'Students',
            icon: Icons.person_outline,
            description: 'Track students',
            onTap: () => context.go('/categories/education/students'),
          ),
          _EducationEntityTile(
            title: 'Academic Plans',
            icon: Icons.assignment,
            description: 'Plan academics',
            onTap: () => context.go('/categories/education/plans'),
          ),
          _EducationEntityTile(
            title: 'School Terms',
            icon: Icons.calendar_today,
            description: 'Manage terms',
            onTap: () => context.go('/categories/education/terms'),
          ),
          _EducationEntityTile(
            title: 'School Breaks',
            icon: Icons.beach_access,
            description: 'Track breaks',
            onTap: () => context.go('/categories/education/breaks'),
          ),
        ],
      ),
      floatingActionButton: VuetFAB(
        onPressed: () => _showCreateOptions(context),
        tooltip: 'Add Education Item',
      ),
    );
  }

  static void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Education Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkJungleGreen,
              ),
            ),
            const VuetDivider(),
            ListTile(
              leading: const Icon(Icons.school, color: AppColors.orange),
              title: const Text('School'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/education/schools/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.orange),
              title: const Text('Student'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/education/students/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: AppColors.orange),
              title: const Text('Academic Plan'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/education/plans/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: AppColors.orange),
              title: const Text('School Term'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/education/terms/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.beach_access, color: AppColors.orange),
              title: const Text('School Break'),
              onTap: () {
                Navigator.pop(context);
                context.go('/categories/education/breaks/create');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationEntityTile extends StatelessWidget {
  const _EducationEntityTile({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VuetCategoryTile(
      title: title,
      icon: icon,
      onTap: onTap,
    );
  }
}
