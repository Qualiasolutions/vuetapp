import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/home/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should display basic home screen elements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Check for basic elements that should be present
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Check for search functionality
      expect(find.byType(TextField), findsAtLeastNWidgets(1));
      expect(find.text('Search tasks...'), findsOneWidget);
      
      // Check for calendar section
      expect(find.text('Calendar'), findsOneWidget);
      
      // Check for floating action button
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should handle navigation drawer if present', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if drawer is present
      final drawerFinder = find.byType(Drawer);
      if (drawerFinder.evaluate().isNotEmpty) {
        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        // Verify drawer is open
        expect(find.byType(Drawer), findsOneWidget);
      }
    });

    testWidgets('should display loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Before pumpAndSettle, we might see loading indicators
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('should be responsive to different screen sizes', (tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(800, 600)); // Tablet size
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // Test with phone size
      await tester.binding.setSurfaceSize(const Size(375, 667)); // iPhone size
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle theme changes', (tester) async {
      // Test with light theme
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);

      // Test with dark theme
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
