import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/education/school_list_screen.dart';
import 'package:vuet_app/ui/screens/education/school_form_screen.dart';
import 'package:vuet_app/ui/screens/education/student_list_screen.dart';
import 'package:vuet_app/ui/screens/education/student_form_screen.dart';
import 'package:vuet_app/ui/screens/education/academic_plan_list_screen.dart';
import 'package:vuet_app/ui/screens/education/academic_plan_form_screen.dart';
// Import SchoolTerm and SchoolBreak screens if they are managed here too
// import 'package:vuet_app/ui/screens/school_terms/school_term_list_screen.dart'; // Example
// import 'package:vuet_app/ui/screens/school_terms/school_term_form_screen.dart'; // Example

class EducationNavigator {
  static const String schoolListRoute = '/education/schools';
  static const String schoolFormRoute = '/education/school-form'; // Path segment for form
  static const String studentListRoute = '/education/students';
  static const String studentFormRoute = '/education/student-form';
  static const String academicPlanListRoute = '/education/academic-plans';
  static const String academicPlanFormRoute = '/education/academic-plan-form';
  // Add routes for SchoolTerm, SchoolBreak if needed

  static List<GoRoute> routes = [
    GoRoute(
      path: schoolListRoute,
      builder: (context, state) => const SchoolListScreen(),
    ),
    GoRoute(
      path: '$schoolFormRoute/:id?', // :id is optional for create
      builder: (context, state) => SchoolFormScreen(schoolId: state.pathParameters['id']),
    ),
    GoRoute(
      path: studentListRoute,
      builder: (context, state) {
        final schoolId = state.uri.queryParameters['schoolId'];
        return StudentListScreen(schoolId: schoolId);
      }
    ),
    GoRoute(
      path: '$studentFormRoute/:id?',
      builder: (context, state) {
        final studentId = state.pathParameters['id'];
        final schoolIdForContext = state.uri.queryParameters['schoolId'];
        return StudentFormScreen(studentId: studentId, schoolIdForContext: schoolIdForContext);
      }
    ),
    GoRoute(
      path: academicPlanListRoute,
       builder: (context, state) {
        final studentId = state.uri.queryParameters['studentId'];
        return AcademicPlanListScreen(studentId: studentId);
      }
    ),
    GoRoute(
      path: '$academicPlanFormRoute/:id?',
      builder: (context, state) {
        final academicPlanId = state.pathParameters['id'];
        final studentIdForContext = state.uri.queryParameters['studentId'];
        return AcademicPlanFormScreen(academicPlanId: academicPlanId, studentIdForContext: studentIdForContext);
      }
    ),
    // Add GoRoute entries for SchoolTerm, SchoolBreak screens
  ];

  // Navigation methods
  static void navigateToSchoolList(BuildContext context) {
    context.go(schoolListRoute);
  }

  static void navigateToSchoolForm(BuildContext context, {String? schoolId}) {
    if (schoolId != null) {
      context.go('$schoolFormRoute/$schoolId');
    } else {
      context.go(schoolFormRoute);
    }
  }

  static void navigateToStudentList(BuildContext context, {String? schoolId}) {
    Map<String, String> queryParams = {};
    if (schoolId != null) {
      queryParams['schoolId'] = schoolId;
    }
    final uri = Uri(path: studentListRoute, queryParameters: queryParams.isNotEmpty ? queryParams : null);
    context.go(uri.toString());
  }

  static void navigateToStudentForm(BuildContext context, {String? studentId, String? schoolIdForContext}) {
    String path = studentId != null ? '$studentFormRoute/$studentId' : studentFormRoute;
    Map<String, String> queryParams = {};
    if (schoolIdForContext != null) {
      queryParams['schoolId'] = schoolIdForContext;
    }
    // Use Uri.encodeComponent for query parameter values if they might contain special characters.
    // For IDs, it's usually not an issue but good practice.
    final uri = Uri(path: path, queryParameters: queryParams.isNotEmpty ? queryParams : null);
    context.go(uri.toString());
  }
  
  static void navigateToAcademicPlanList(BuildContext context, {String? studentId}) {
     Map<String, String> queryParams = {};
    if (studentId != null) {
      queryParams['studentId'] = studentId;
    }
    final uri = Uri(path: academicPlanListRoute, queryParameters: queryParams.isNotEmpty ? queryParams : null);
    context.go(uri.toString());
  }

  static void navigateToAcademicPlanForm(BuildContext context, {String? academicPlanId, String? studentIdForContext}) {
    String path = academicPlanId != null ? '$academicPlanFormRoute/$academicPlanId' : academicPlanFormRoute;
    Map<String, String> queryParams = {};
    if (studentIdForContext != null) {
      queryParams['studentId'] = studentIdForContext;
    }
    final uri = Uri(path: path, queryParameters: queryParams.isNotEmpty ? queryParams : null);
    context.go(uri.toString());
  }
}
