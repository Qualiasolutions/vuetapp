import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:vuet_app/ui/screens/social_interests/hobby_list_screen.dart';
import 'package:vuet_app/ui/screens/social_interests/hobby_form_screen.dart';
import 'package:vuet_app/ui/screens/social_interests/social_plan_list_screen.dart';
import 'package:vuet_app/ui/screens/social_interests/social_plan_form_screen.dart';
import 'package:vuet_app/ui/screens/social_interests/social_event_list_screen.dart';
import 'package:vuet_app/ui/screens/social_interests/social_event_form_screen.dart';

class SocialInterestsNavigator {
  static const String hobbyListRoute = '/social-interests/hobbies';
  static const String hobbyFormRoute = '/social-interests/hobbies/form'; // Path param for ID
  static const String socialPlanListRoute = '/social-interests/social-plans';
  static const String socialPlanFormRoute = '/social-interests/social-plans/form';
  static const String socialEventListRoute = '/social-interests/social-events';
  static const String socialEventFormRoute = '/social-interests/social-events/form';

  static List<GoRoute> routes() {
    return [
      // Hobby Routes
      GoRoute(
        path: hobbyListRoute,
        builder: (context, state) => const HobbyListScreen(),
      ),
      GoRoute(
        path: '$hobbyFormRoute/:id?', // Optional ID for editing
        builder: (context, state) {
          final hobbyId = state.pathParameters['id'];
          return HobbyFormScreen(hobbyId: hobbyId);
        },
      ),
      // Social Plan Routes
      GoRoute(
        path: socialPlanListRoute,
        builder: (context, state) => const SocialPlanListScreen(),
      ),
      GoRoute(
        path: '$socialPlanFormRoute/:id?',
        builder: (context, state) {
          final planId = state.pathParameters['id'];
          return SocialPlanFormScreen(socialPlanId: planId);
        },
      ),
      // Social Event Routes
      GoRoute(
        path: socialEventListRoute,
        builder: (context, state) => const SocialEventListScreen(),
      ),
      GoRoute(
        path: '$socialEventFormRoute/:id?',
        builder: (context, state) {
          final eventId = state.pathParameters['id'];
          return SocialEventFormScreen(socialEventId: eventId);
        },
      ),
    ];
  }

  // Navigation methods
  static void navigateToHobbyList(BuildContext context) {
    context.go(hobbyListRoute);
  }

  static void navigateToHobbyForm(BuildContext context, {String? hobbyId}) {
    if (hobbyId != null) {
      context.go('$hobbyFormRoute/$hobbyId');
    } else {
      context.go(hobbyFormRoute);
    }
  }

  static void navigateToSocialPlanList(BuildContext context) {
    context.go(socialPlanListRoute);
  }

  static void navigateToSocialPlanForm(BuildContext context, {String? planId}) {
    if (planId != null) {
      context.go('$socialPlanFormRoute/$planId');
    } else {
      context.go(socialPlanFormRoute);
    }
  }

  static void navigateToSocialEventList(BuildContext context) {
    context.go(socialEventListRoute);
  }

  static void navigateToSocialEventForm(BuildContext context, {String? eventId}) {
    if (eventId != null) {
      context.go('$socialEventFormRoute/$eventId');
    } else {
      context.go(socialEventFormRoute);
    }
  }
}
