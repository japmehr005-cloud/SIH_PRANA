import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AarogyaSpacing.md),
        child: child,
      ),
    );
  }
}
