import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ModeChip extends StatelessWidget {
  const ModeChip({super.key, required this.phase});

  final EmergencyPhase phase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = switch (phase) {
      EmergencyPhase.normal ||
      EmergencyPhase.resolved => (AarogyaColors.safeSoft, AarogyaColors.safe),
      EmergencyPhase.disasterAlert => (
        AarogyaColors.warningSoft,
        AarogyaColors.warning,
      ),
      EmergencyPhase.disasterActive => (
        AarogyaColors.warningSoft,
        AarogyaColors.warning,
      ),
      EmergencyPhase.survival || EmergencyPhase.emergencyEvent => (
        AarogyaColors.dangerSoft,
        AarogyaColors.danger,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.$1,
        border: Border.all(color: colors.$2),
        borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AarogyaSpacing.md,
          vertical: AarogyaSpacing.sm,
        ),
        child: Text(
          modeChipLabel(l10n, phase),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colors.$2,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
