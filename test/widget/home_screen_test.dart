import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vuet_app/ui/screens/calendar/calendar_screen.dart';
import 'package:table_calendar/table_calendar.dart'; // Import TableCalendar

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('should display basic calendar screen elements', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Check for basic elements that should be present
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Check for calendar elements
      expect(find.byType(TableCalendar), findsOneWidget);
      
      // Check for floating action button for adding events
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should handle navigation if present', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if floating action button is present
      final fabFinder = find.byType(FloatingActionButton);
      expect(fabFinder, findsOneWidget);
    });

    testWidgets('should display loading state initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CalendarScreen(),
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
            home: CalendarScreen(),
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
            home: CalendarScreen(),
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
            home: CalendarScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
