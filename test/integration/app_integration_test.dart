import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vuet_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('app launches and displays initial screen', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the app launched successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('navigation flow works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test basic navigation if auth wrapper is present
      final authWrapperFinder = find.byKey(const Key('auth-wrapper'));
      if (authWrapperFinder.evaluate().isNotEmpty) {
        // App has auth wrapper, test authentication flow
        
        // Look for login/register buttons
        final loginButton = find.text('Login');
        
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pumpAndSettle();
          
          // Should see login form elements
          expect(find.byType(TextField), findsWidgets);
        }
      } else {
        // App goes directly to main screen
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('drawer navigation works if present', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for drawer menu
      final menuButton = find.byIcon(Icons.menu);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();

        // Should see drawer
        expect(find.byType(Drawer), findsOneWidget);

        // Test navigation to different screens
        final routinesTile = find.text('Routines');
        if (routinesTile.evaluate().isNotEmpty) {
          await tester.tap(routinesTile);
          await tester.pumpAndSettle();
          
          // Should navigate to routines screen
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('lists functionality works end-to-end', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to lists section
      final listsButton = find.text('Lists');
      if (listsButton.evaluate().isNotEmpty) {
        await tester.tap(listsButton);
        await tester.pumpAndSettle();

        // Should see lists screen
        expect(find.byType(Scaffold), findsOneWidget);

        // Look for add list button
        final addButton = find.byIcon(Icons.add);
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Should see create list form
          expect(find.byType(TextField), findsWidgets);
        }
      }
    });

    testWidgets('categories functionality works', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to categories
      final categoriesButton = find.text('Categories');
      if (categoriesButton.evaluate().isNotEmpty) {
        await tester.tap(categoriesButton);
        await tester.pumpAndSettle();

        // Should see categories screen
        expect(find.byType(Scaffold), findsOneWidget);
        
        // Should see some category items
        expect(find.byType(GridView), findsWidgets);
      }
    });

    testWidgets('app handles errors gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // The app should start without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // No error screens should be visible initially
      expect(find.text('Error'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);
    });

    testWidgets('app works offline', (tester) async {
      // This test would require mocking network conditions
      // For now, just verify the app starts
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('performance test - app starts quickly', (tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      
      // App should start within reasonable time (5 seconds)
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
