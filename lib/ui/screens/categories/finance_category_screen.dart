import 'package:flutter/material.dart';
import 'package:vuet_app/ui/shared/widgets.dart'; // For VuetHeader

class FinanceCategoryScreen extends StatelessWidget {
  const FinanceCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VuetHeader('Finance'),
      body: Center(
        child: Text(
          'Finance Category Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
