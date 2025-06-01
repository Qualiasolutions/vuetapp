import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/screens/account_settings/account_details_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/account_settings_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/account_type_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/contact_info_screen.dart';
import 'package:vuet_app/ui/screens/account_settings/security_settings_screen.dart';
import 'package:vuet_app/ui/screens/family/family_members_screen.dart';
import 'package:vuet_app/ui/screens/family/family_invitations_screen.dart';

/// Navigator for account settings screens
class AccountSettingsNavigator {
  static const String rootPath = '/account-settings';
  static const String detailsPath = 'details';
  static const String typePath = 'type';
  static const String contactPath = 'contact';
  static const String securityPath = 'security';
  static const String familyMembersPath = 'family-members';
  static const String familyInvitationsPath = 'family-invitations';

  /// Add routes to GoRouter configuration
  static List<RouteBase> routes() {
    return [
      GoRoute(
        path: rootPath,
        builder: (BuildContext context, GoRouterState state) {
          return const AccountSettingsScreen();
        },
        routes: [
          GoRoute(
            path: detailsPath,
            builder: (BuildContext context, GoRouterState state) {
              return const AccountDetailsScreen();
            },
          ),
          GoRoute(
            path: typePath,
            builder: (BuildContext context, GoRouterState state) {
              return const AccountTypeScreen();
            },
          ),
          GoRoute(
            path: contactPath,
            builder: (BuildContext context, GoRouterState state) {
              return const ContactInfoScreen();
            },
          ),
          GoRoute(
            path: securityPath,
            builder: (BuildContext context, GoRouterState state) {
              return const SecuritySettingsScreen();
            },
          ),
          GoRoute(
            path: familyMembersPath,
            builder: (BuildContext context, GoRouterState state) {
              return const FamilyMembersScreen();
            },
          ),
          GoRoute(
            path: familyInvitationsPath,
            builder: (BuildContext context, GoRouterState state) {
              return const FamilyInvitationsScreen();
            },
          ),
        ],
      ),
    ];
  }

  /// Navigate to account settings root
  static void navigateToAccountSettings(BuildContext context) {
    GoRouter.of(context).go(rootPath);
  }

  /// Navigate to account details settings
  static void navigateToAccountDetails(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$detailsPath');
  }

  /// Navigate to account type settings
  static void navigateToAccountType(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$typePath');
  }

  /// Navigate to contact info settings
  static void navigateToContactInfo(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$contactPath');
  }

  /// Navigate to security settings
  static void navigateToSecuritySettings(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$securityPath');
  }
  
  /// Navigate to family members screen
  static void navigateToFamilyMembers(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$familyMembersPath');
  }
  
  /// Navigate to family invitations screen
  static void navigateToFamilyInvitations(BuildContext context) {
    GoRouter.of(context).go('$rootPath/$familyInvitationsPath');
  }
}
