import 'package:flutter/material.dart';
import '../../../models/lana/lana_feature_model.dart';

class FeatureCard extends StatelessWidget {
  final LanaFeature feature;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.feature,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(feature.icon, size: 24.0, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      feature.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                feature.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
