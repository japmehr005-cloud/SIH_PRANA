import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

class MetricRow extends StatelessWidget {
  const MetricRow({
    super.key,
    required this.label,
    required this.value,
    this.icon = Icons.monitor_heart_outlined,
  });

  final String label;
  final String value;
  final IconData icon;

  static const int _longValueChars = 42;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium;
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: AarogyaColors.textPrimary,
    );
    final longValue = value.length >= _longValueChars;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AarogyaSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AarogyaColors.primary),
          const SizedBox(width: AarogyaSpacing.md),
          if (longValue)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, softWrap: true, style: labelStyle),
                  const SizedBox(height: AarogyaSpacing.xs),
                  Text(value, softWrap: true, style: valueStyle),
                ],
              ),
            )
          else ...[
            Expanded(
              flex: 2,
              child: Text(label, softWrap: true, style: labelStyle),
            ),
            const SizedBox(width: AarogyaSpacing.md),
            Expanded(
              flex: 3,
              child: Text(
                value,
                textAlign: TextAlign.end,
                softWrap: true,
                style: valueStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
