import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader, VuetCategoryTile
import 'package:vuet_app/ui/navigation/career_navigator.dart'; // For navigation

class CareerCategoryScreen extends StatelessWidget {
  const CareerCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Career'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: <Widget>[
            VuetCategoryTile(
              title: 'Career Goals',
              icon: Icons.flag_circle_outlined, // Example icon
              onTap: () => CareerNavigator.navigateToCareerGoalList(context),
            ),
            VuetCategoryTile(
              title: 'Employment',
              icon: Icons.work_history_outlined, // Example icon
              onTap: () => CareerNavigator.navigateToEmployeeList(context),
            ),
            // Add more tiles if other sub-entities are defined for Career
          ],
        ),
      ),
    );
  }
}
