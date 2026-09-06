import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/health/demonstration_condition.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemonstrationConditionChips extends ConsumerWidget {
  const DemonstrationConditionChips({super.key, required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.demonstrationConditions),
        const SizedBox(height: AarogyaSpacing.sm),
        Wrap(
          spacing: AarogyaSpacing.sm,
          runSpacing: AarogyaSpacing.sm,
          children: [
            for (final condition in DemonstrationCondition.values)
              ChoiceChip(
                label: Text(demonstrationConditionLabel(l10n, condition)),
                selected: state.demonstrationCondition == condition,
                onSelected: (_) {
                  unawaited(_apply(context, ref, condition));
                },
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _apply(
    BuildContext context,
    WidgetRef ref,
    DemonstrationCondition condition,
  ) async {
    final bundle = DefaultAssetBundle.of(context);
    final csv = await bundle.loadString(condition.assetPath);
    final restingCsv = condition == DemonstrationCondition.resting
        ? null
        : await bundle.loadString(DemonstrationCondition.resting.assetPath);
    await ref.read(dependenciesProvider).runtime.applyDemonstrationCondition(
      condition,
      csv: csv,
      restingCsv: restingCsv,
    );
  }
}
