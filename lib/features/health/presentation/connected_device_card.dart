import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/metric_tile.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/health/presentation/demonstration_condition_chips.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectedDeviceCard extends ConsumerWidget {
  const ConnectedDeviceCard({super.key, required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sample = state.currentSample;
    final source = _sourceLabel(l10n, sample);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MetricTileGrid(
          tiles: [
            MetricTile(
              label: l10n.heartRate,
              value: _number(sample?.heartRateBpm, l10n.bpmUnit, l10n),
              icon: Icons.favorite_border,
            ),
            MetricTile(
              label: l10n.bloodOxygen,
              value: _number(sample?.spo2Percent, l10n.percentUnit, l10n),
              icon: Icons.air,
            ),
            MetricTile(
              label: l10n.temperature,
              value: _number(sample?.temperatureC, l10n.celsiusUnit, l10n),
              icon: Icons.thermostat,
            ),
            MetricTile(
              label: l10n.activity,
              value: movementLabel(l10n, sample?.movement),
              icon: Icons.directions_walk,
            ),
          ],
        ),
        const SizedBox(height: AarogyaSpacing.md),
        InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricRow(
                label: l10n.sourceLabel,
                value: source,
                icon: Icons.sensors,
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              DemonstrationConditionChips(state: state),
              if (state.heartRateSupported) ...[
                const SizedBox(height: AarogyaSpacing.sm),
                Text(l10n.heartRateBrowserOnly),
                const SizedBox(height: AarogyaSpacing.sm),
                OutlinedButton(
                  onPressed: () {
                    unawaited(
                      ref.read(dependenciesProvider).runtime.connectHeartRate(),
                    );
                  },
                  child: Text(l10n.connectHeartRate),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _sourceLabel(AppLocalizations l10n, SensorSample? sample) {
    if (sample == null) {
      return l10n.unavailable;
    }
    if (sample.sourceKind == SensorSourceKind.device ||
        sample.sourceKind == SensorSourceKind.wearable) {
      return l10n.sensorSourceDevice;
    }
    return l10n.sensorSourceSimulation;
  }

  String _number(double? value, String unit, AppLocalizations l10n) {
    if (value == null) {
      return l10n.unavailable;
    }
    return '${value.toStringAsFixed(0)} $unit';
  }
}
