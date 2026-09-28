import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

class PranaCard extends StatelessWidget {
  const PranaCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AarogyaColors.surface,
      elevation: 2,
      shadowColor: AarogyaColors.shadow,
      borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
          border: Border.all(color: AarogyaColors.border),
        ),
        child: child,
      ),
    );
  }
}

class PranaStatus extends StatelessWidget {
  const PranaStatus({
    super.key,
    required this.text,
    this.color = AarogyaColors.accent,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PranaMetricCard extends StatelessWidget {
  const PranaMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.icon,
    required this.accent,
    this.chart,
  });

  final String title;
  final String value;
  final String unit;
  final String status;
  final IconData icon;
  final Color accent;
  final Widget? chart;

  @override
  Widget build(BuildContext context) {
    return PranaCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 21),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AarogyaColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (chart != null) ...[
            SizedBox(height: 42, child: chart),
            const SizedBox(height: 8),
          ],
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AarogyaColors.textPrimary,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: AarogyaColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          PranaStatus(text: status, color: accent),
        ],
      ),
    );
  }
}
