import 'package:flutter/material.dart';
import 'package:vuet_app/utils/schema_utils.dart';
import 'package:vuet_app/utils/logger.dart';

// A simple widget/method to call backend fixes
// You can add this as a debug button or call it programmatically
class BackendFixHelper {
  // Main method to call from anywhere in your app
  static Future<void> performBackendFixes(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Performing backend fixes...'),
          ],
        ),
      ),
    );

    try {
      log('[BackendFix] Starting backend fixes...', name: 'BackendFixHelper');

      // Perform all the fixes
      final success = await SchemaUtils.performPhase1BackendFixes();

      // Test basic queries
      await SchemaUtils.testBasicQueries();

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show result
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(success ? '✅ Success' : '❌ Issues Found'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(success
                    ? 'Backend fixes completed successfully!'
                    : 'Some backend fixes had issues. Check logs for details.'),
                const SizedBox(height: 16),
                const Text('Next steps:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text('• Test Categories screen'),
                const Text('• Test Routines & Timeblocks screens'),
                const Text('• Check console logs for details'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e, stackTrace) {
      log('[BackendFix] Error during backend fixes: $e',
          name: 'BackendFixHelper',
          error: e,
          stackTrace: stackTrace,
          level: LogLevel.error);

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show error
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('❌ Error'),
            content: Text('Backend fixes failed: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Method to just add the is_professional column
  static Future<void> addIsProfessionalColumnOnly(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Adding is_professional column...'),
          ],
        ),
      ),
    );

    try {
      final success = await SchemaUtils.addIsProfessionalColumn();

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(success ? '✅ Success' : '❌ Failed'),
            content: Text(success
                ? 'is_professional column added successfully!'
                : 'Failed to add is_professional column. Check logs.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('❌ Error'),
            content: Text('Error: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Debug method to analyze RLS policies
  static Future<void> analyzeRlsPolicies(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Analyzing RLS policies...'),
          ],
        ),
      ),
    );

    try {
      await SchemaUtils.analyzeRlsPolicies();

      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('✅ Analysis Complete'),
            content: Text(
                'RLS policy analysis complete. Check console logs for details.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('❌ Error'),
            content: Text('Analysis failed: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}

// Debug widget you can add temporarily to any screen
class DebugBackendFixButton extends StatelessWidget {
  const DebugBackendFixButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => BackendFixHelper.performBackendFixes(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('🔧 Fix Backend Issues'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () =>
              BackendFixHelper.addIsProfessionalColumnOnly(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('➕ Add is_professional Column'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => BackendFixHelper.analyzeRlsPolicies(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('🔍 Analyze RLS Policies'),
        ),
      ],
    );
  }
}
