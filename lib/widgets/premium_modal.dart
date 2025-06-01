import 'package:flutter/material.dart';

/// A modal dialog that appears when a user tries to access a premium feature without premium access
class PremiumModal {
  /// Shows a premium feature access modal dialog
  static Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Premium Feature'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'This feature is only available with a premium subscription.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Navigation to subscription screen would go here
                    Navigator.of(context).pop();
                    // Example navigation to upgrade page
                    // Navigator.of(context).pushNamed('/subscription');
                  },
                  child: const Text('Upgrade Now'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
