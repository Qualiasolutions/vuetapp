import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/career/career_goal_list_screen.dart';
import 'package:vuet_app/ui/screens/career/career_goal_form_screen.dart';
import 'package:vuet_app/ui/screens/career/employee_list_screen.dart';
import 'package:vuet_app/ui/screens/career/employee_form_screen.dart';

class CareerNavigator {
  static const String careerGoalsListPath = '/career/goals';
  static const String careerGoalFormPath = '/career/goal-form'; // Path for new
  static const String careerGoalEditFormPath = '/career/goal-form/:id'; // Path for edit

  static const String employeesListPath = '/career/employees';
  static const String employeeFormPath = '/career/employee-form'; // Path for new
  static const String employeeEditFormPath = '/career/employee-form/:id'; // Path for edit

  static List<GoRoute> routes = [
    GoRoute(
      path: careerGoalsListPath,
      builder: (context, state) => const CareerGoalListScreen(),
    ),
    GoRoute(
      path: careerGoalFormPath, // New goal
      builder: (context, state) => const CareerGoalFormScreen(),
    ),
    GoRoute(
      path: careerGoalEditFormPath, // Edit goal
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CareerGoalFormScreen(careerGoalId: id);
      },
    ),
    GoRoute(
      path: employeesListPath,
      builder: (context, state) => const EmployeeListScreen(),
    ),
    GoRoute(
      path: employeeFormPath, // New employee
      builder: (context, state) => const EmployeeFormScreen(),
    ),
    GoRoute(
      path: employeeEditFormPath, // Edit employee
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return EmployeeFormScreen(employeeId: id);
      },
    ),
  ];

  static void navigateToCareerGoalList(BuildContext context) {
    context.go(careerGoalsListPath);
  }

  static void navigateToCareerGoalForm(BuildContext context, {String? careerGoalId}) {
    if (careerGoalId == null) {
      context.go(careerGoalFormPath);
    } else {
      // Corrected path construction for edit:
      String path = careerGoalEditFormPath.replaceFirst(':id', careerGoalId);
      context.go(path);
    }
  }

  static void navigateToEmployeeList(BuildContext context) {
    context.go(employeesListPath);
  }

  static void navigateToEmployeeForm(BuildContext context, {String? employeeId}) {
    if (employeeId == null) {
      context.go(employeeFormPath);
    } else {
      String path = employeeEditFormPath.replaceFirst(':id', employeeId);
      context.go(path);
    }
  }
}
