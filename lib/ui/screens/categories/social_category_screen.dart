import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader
// Potentially import SocialInterestsNavigator if we want to navigate from here
// import 'package:vuet_app/ui/navigation/social_interests_navigator.dart';

class SocialCategoryScreen extends StatelessWidget {
  const SocialCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Social Interests'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Social Interests Category Screen',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Example: Navigate to the hobby list
                // This assumes SocialInterestsNavigator.hobbyListRoute is '/social-interests/hobbies'
                // and that route is defined in main.dart via SocialInterestsNavigator.routes()
                context.go('/social-interests/hobbies');
              },
              child: const Text('View Hobbies'),
            ),
            // Add more buttons for plans, events etc. if needed
          ],
        ),
      ),
    );
  }
}
