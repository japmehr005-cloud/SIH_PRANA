import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AarogyaColors.surface,
        border: Border.all(color: AarogyaColors.border),
        borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AarogyaSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AarogyaColors.primary),
                  const SizedBox(width: AarogyaSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AarogyaColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AarogyaSpacing.xs),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricTileGrid extends StatelessWidget {
  const MetricTileGrid({super.key, required this.tiles});

  final List<MetricTile> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720
            ? 4
            : constraints.maxWidth >= 420
            ? 2
            : 1;
        return Column(
          children: [
            for (var i = 0; i < tiles.length; i += columns)
              Padding(
                padding: const EdgeInsets.only(bottom: AarogyaSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var j = 0; j < columns; j++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: j < columns - 1 ? AarogyaSpacing.sm : 0,
                          ),
                          child: i + j < tiles.length
                              ? tiles[i + j]
                              : const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
