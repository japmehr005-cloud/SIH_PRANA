import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

class StageStrip extends StatelessWidget {
  const StageStrip({
    super.key,
    required this.labels,
    required this.focusedStage,
    required this.completedThrough,
  });

  final List<String> labels;
  final int focusedStage;
  final int completedThrough;

  static const double _minNodeWidth = 112;
  static const double _connectorWidth = 10;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AarogyaColors.surface,
        border: Border.all(color: AarogyaColors.border),
        borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AarogyaSpacing.md,
          vertical: AarogyaSpacing.sm,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final count = labels.length;
            final connectors = count > 1 ? count - 1 : 0;
            final needed = count * _minNodeWidth + connectors * _connectorWidth;
            final row = _StageRow(
              labels: labels,
              focusedStage: focusedStage,
              completedThrough: completedThrough,
              minNodeWidth: _minNodeWidth,
              connectorWidth: _connectorWidth,
            );
            if (constraints.maxWidth >= needed) {
              return row;
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: needed, child: row),
            );
          },
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({
    required this.labels,
    required this.focusedStage,
    required this.completedThrough,
    required this.minNodeWidth,
    required this.connectorWidth,
  });

  final List<String> labels;
  final int focusedStage;
  final int completedThrough;
  final double minNodeWidth;
  final double connectorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: connectorWidth,
                child: const ColoredBox(
                  color: AarogyaColors.border,
                  child: SizedBox(height: 1),
                ),
              ),
            ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: minNodeWidth),
              child: _StageNode(
                index: i + 1,
                label: labels[i],
                focused: focusedStage == i + 1,
                completed: completedThrough >= i + 1,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({
    required this.index,
    required this.label,
    required this.focused,
    required this.completed,
  });

  final int index;
  final String label;
  final bool focused;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final color = focused
        ? AarogyaColors.primary
        : completed
        ? AarogyaColors.safe
        : AarogyaColors.textSecondary;
    final weight = focused || completed ? FontWeight.w600 : FontWeight.w400;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          index.toString().padLeft(2, '0'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: color, fontWeight: weight),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: color, fontWeight: weight, height: 1.25),
        ),
      ],
    );
  }
}
