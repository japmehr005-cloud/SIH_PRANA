import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/features/communication/presentation/nearby_users_card.dart';
import 'package:aarogya/features/rescue/presentation/rescue_dashboard_screen.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurvivalScreen extends ConsumerWidget {
  const SurvivalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: Row(
          children: [
            const BrandMark(height: 40, compact: true),
            const SizedBox(width: AarogyaSpacing.sm),
            Text(l10n.survivalTitle),
          ],
        ),
      ),
      body: session.when(
        loading: () => Center(child: Text(l10n.loading)),
        error: (_, _) => Center(child: Text(l10n.errorContinue)),
        data: (state) {
          return Column(
            children: [
              if (state.fallStatus == FallStatus.awaitingConfirmation)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AarogyaSpacing.page,
                    AarogyaSpacing.md,
                    AarogyaSpacing.page,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(fallLabel(l10n, state.fallStatus)),
                      const SizedBox(height: AarogyaSpacing.sm),
                      FilledButton(
                        onPressed: () {
                          unawaited(
                            ref.read(dependenciesProvider).runtime.userIsOk(),
                          );
                        },
                        child: Text(l10n.iAmOk),
                      ),
                      const SizedBox(height: AarogyaSpacing.sm),
                      OutlinedButton(
                        onPressed: () {
                          unawaited(
                            ref
                                .read(dependenciesProvider)
                                .runtime
                                .userNeedsHelp(),
                          );
                        },
                        child: Text(l10n.iNeedHelp),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AarogyaSpacing.page,
                  AarogyaSpacing.md,
                  AarogyaSpacing.page,
                  0,
                ),
                child: NearbyUsersCard(state: state),
              ),
              const Expanded(child: RescueDashboardScreen(embedded: true)),
            ],
          );
        },
      ),
    );
  }
}
