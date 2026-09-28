import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SampleSparkline extends StatelessWidget {
  const SampleSparkline({super.key, required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return const SizedBox.shrink();
    }
    return LineChart(
      LineChartData(
        minY: values.reduce((a, b) => a < b ? a : b) - 1,
        maxY: values.reduce((a, b) => a > b ? a : b) + 1,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ],
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

class HeartRateTrendChart extends StatelessWidget {
  const HeartRateTrendChart({super.key, required this.samples});

  final List<SensorSample> samples;

  @override
  Widget build(BuildContext context) {
    final points = [
      for (final sample in samples)
        if (sample.heartRateBpm != null) sample.heartRateBpm!,
    ];
    if (points.length < 2) {
      return Text(
        AppLocalizations.of(context).chartNeedsReadings,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AarogyaColors.textSecondary),
      );
    }
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: points.reduce((a, b) => a < b ? a : b) - 4,
          maxY: points.reduce((a, b) => a > b ? a : b) + 4,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AarogyaColors.border, strokeWidth: 1),
          ),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i]),
              ],
              isCurved: true,
              color: AarogyaColors.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AarogyaColors.primarySoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovementMixChart extends StatelessWidget {
  const MovementMixChart({super.key, required this.samples});

  final List<SensorSample> samples;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    var rest = 0;
    var usual = 0;
    var high = 0;
    var irregular = 0;
    for (final sample in samples) {
      switch (sample.movement) {
        case MovementState.high:
          high++;
        case MovementState.irregular:
          irregular++;
        case MovementState.normal:
          usual++;
        case MovementState.low:
        case MovementState.none:
        case null:
          rest++;
      }
    }
    final total = rest + usual + high + irregular;
    if (total == 0) {
      return Text(
        l10n.chartNeedsReadings,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AarogyaColors.textSecondary),
      );
    }
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 36,
          sections: [
            _section(rest, total, AarogyaColors.primary, l10n.movementLow),
            _section(usual, total, AarogyaColors.blue, l10n.movementNormal),
            _section(high, total, AarogyaColors.warning, l10n.movementHigh),
            _section(
              irregular,
              total,
              AarogyaColors.danger,
              l10n.movementIrregular,
            ),
          ].where((section) => section.value > 0).toList(),
        ),
      ),
    );
  }

  PieChartSectionData _section(
    int count,
    int total,
    Color color,
    String label,
  ) {
    final percent = (count / total) * 100;
    return PieChartSectionData(
      value: count.toDouble(),
      color: color,
      radius: 48,
      title: '${percent.round()}%\n$label',
      titleStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}
