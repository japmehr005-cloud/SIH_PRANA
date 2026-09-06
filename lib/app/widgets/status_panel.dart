import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:flutter/material.dart';

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    this.level,
  });

  final String title;
  final String body;
  final IconData icon;
  final RiskLevel? level;

  @override
  Widget build(BuildContext context) {
    final colors = switch (level) {
      RiskLevel.critical => (AarogyaColors.dangerSoft, AarogyaColors.danger),
      RiskLevel.high => (AarogyaColors.warningSoft, AarogyaColors.warning),
      RiskLevel.moderate => (AarogyaColors.warningSoft, AarogyaColors.warning),
      RiskLevel.low || null => (AarogyaColors.safeSoft, AarogyaColors.safe),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        border: Border.all(color: colors.$2),
        borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AarogyaSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.$2),
            const SizedBox(width: AarogyaSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.$2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AarogyaSpacing.xs),
                  Text(body, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
