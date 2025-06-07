import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/family/family_member_list_screen.dart';
import 'package:vuet_app/ui/family/family_member_form_screen.dart';
import 'package:vuet_app/ui/family/birthday_list_screen.dart';
import 'package:vuet_app/ui/family/birthday_form_screen.dart';
// Import other family-related screens if they exist, e.g., AnniversaryListScreen

class FamilyNavigator {
  // Base path for family category specific entities
  static const String _baseFamilyPath = '/categories/family';

  // Family Member routes
  static const String familyMemberListRoute = '$_baseFamilyPath/family-members';
  static const String familyMemberFormRoute = '$_baseFamilyPath/family-members/form';

  // Birthday routes
  static const String birthdayListRoute = '$_baseFamilyPath/birthdays';
  static const String birthdayFormRoute = '$_baseFamilyPath/birthdays/form';

  // TODO: Add routes for Anniversary, Patient, Appointment if they have dedicated list/form screens

  static List<GoRoute> routes = [
    // Family Member Routes
    GoRoute(
      path: familyMemberListRoute,
      builder: (context, state) => const FamilyMemberListScreen(),
    ),
    GoRoute(
      path: '$familyMemberFormRoute/:familyMemberId?', // :familyMemberId is optional for create
      builder: (context, state) => FamilyMemberFormScreen(familyMemberId: state.pathParameters['familyMemberId']),
    ),

    // Birthday Routes
    GoRoute(
      path: birthdayListRoute,
      builder: (context, state) => const BirthdayListScreen(),
    ),
    GoRoute(
      path: '$birthdayFormRoute/:birthdayId?',
      builder: (context, state) => BirthdayFormScreen(birthdayId: state.pathParameters['birthdayId']),
    ),
    
    // TODO: Add GoRoute entries for Anniversary, Patient, Appointment screens
  ];

  // Navigation helper methods
  static void navigateToFamilyMemberList(BuildContext context) {
    context.go(familyMemberListRoute);
  }

  static void navigateToFamilyMemberForm(BuildContext context, {String? familyMemberId}) {
    if (familyMemberId != null) {
      context.go('$familyMemberFormRoute/$familyMemberId');
    } else {
      // Navigating to the path without an ID will match '$familyMemberFormRoute/:familyMemberId?'
      // where familyMemberId will be null.
      context.go(familyMemberFormRoute);
    }
  }

  static void navigateToBirthdayList(BuildContext context) {
    context.go(birthdayListRoute);
  }

  static void navigateToBirthdayForm(BuildContext context, {String? birthdayId}) {
    if (birthdayId != null) {
      context.go('$birthdayFormRoute/$birthdayId');
    } else {
      context.go(birthdayFormRoute);
    }
  }
  // TODO: Add navigation helpers for other family entities
}
