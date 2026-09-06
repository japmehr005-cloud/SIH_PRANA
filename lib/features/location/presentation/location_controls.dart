import 'dart:async';

import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationControls extends ConsumerWidget {
  const LocationControls({super.key, required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final runtime = ref.read(dependenciesProvider).runtime;
    final selected = state.selectedRegionId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AarogyaSpacing.sm,
          runSpacing: AarogyaSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.demonstrationAreaKathmandu),
              selected: selected == DemonstrationRegionIds.kathmandu,
              onSelected: (_) {
                unawaited(
                  runtime.selectDemonstrationRegion(
                    DemonstrationRegionIds.kathmandu,
                  ),
                );
              },
            ),
            ChoiceChip(
              label: Text(l10n.demonstrationAreaDelhi),
              selected: selected == DemonstrationRegionIds.delhi,
              onSelected: (_) {
                unawaited(
                  runtime.selectDemonstrationRegion(
                    DemonstrationRegionIds.delhi,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AarogyaSpacing.sm),
        OutlinedButton(
          onPressed: () {
            unawaited(runtime.requestLocationAccess());
          },
          child: Text(l10n.useDeviceLocation),
        ),
        if (state.deviceLocationRejected) ...[
          const SizedBox(height: AarogyaSpacing.sm),
          Text(l10n.locationOutsideDemonstration),
        ],
        if (state.inRegionSaferPlaces.isNotEmpty) ...[
          const SizedBox(height: AarogyaSpacing.sm),
          Text(l10n.selectSaferLocation),
          const SizedBox(height: AarogyaSpacing.sm),
          Wrap(
            spacing: AarogyaSpacing.sm,
            runSpacing: AarogyaSpacing.sm,
            children: [
              for (final place in state.inRegionSaferPlaces)
                ChoiceChip(
                  label: Text(place.label),
                  selected:
                      (state.selectedPlaceId ?? state.guidance?.place.id) ==
                      place.id,
                  onSelected: (_) {
                    unawaited(runtime.selectSaferPlace(place.id));
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}
