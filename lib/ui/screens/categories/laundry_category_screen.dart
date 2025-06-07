import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class LaundryCategoryScreen extends StatelessWidget {
  const LaundryCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Laundry'),
      body: Center(
        child: Text(
          'Laundry Category Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
