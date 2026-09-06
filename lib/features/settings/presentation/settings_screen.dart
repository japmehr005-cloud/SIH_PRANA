import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/inference_status_rows.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/mode_chip.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/features/demo/application/demo_controller.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeControllerProvider);
    final session = ref.watch(sessionProvider);
    final deps = ref.watch(dependenciesProvider);
    final accounts = deps.accounts;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            children: [
              if (accounts.isConfigured || accounts.current != null) ...[
                SectionHeader(l10n.accountSection),
                _AccountCard(accounts: accounts),
                const SizedBox(height: AarogyaSpacing.lg),
              ],
              SectionHeader(l10n.language),
              InfoCard(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.english),
                      selected: locale.languageCode == 'en',
                      trailing: locale.languageCode == 'en'
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        unawaited(
                          ref
                              .read(localeControllerProvider.notifier)
                              .setLocale(const Locale('en')),
                        );
                      },
                    ),
                    ListTile(
                      title: Text(l10n.hindi),
                      selected: locale.languageCode == 'hi',
                      trailing: locale.languageCode == 'hi'
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        unawaited(
                          ref
                              .read(localeControllerProvider.notifier)
                              .setLocale(const Locale('hi')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.demoSessionState),
              session.when(
                loading: () => InfoCard(child: Text(l10n.loading)),
                error: (_, _) => InfoCard(child: Text(l10n.errorContinue)),
                data: (state) => InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ModeChip(phase: state.emergency.phase),
                      const SizedBox(height: AarogyaSpacing.sm),
                      Text(phaseLabel(l10n, state.emergency.phase)),
                      MetricRow(
                        label: l10n.connectivity,
                        value: connectivityLabel(l10n, state.connectivity),
                        icon: Icons.wifi,
                      ),
                      Text(
                        l10n.simulatedConnectivity,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AarogyaColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AarogyaSpacing.md),
              FilledButton(
                onPressed: () {
                  unawaited(
                    ref
                        .read(demoControllerProvider.notifier)
                        .reset(ref.read(dependenciesProvider).runtime),
                  );
                },
                child: Text(l10n.demoResetFull),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.technicalInformation),
              session.when(
                loading: () => InfoCard(child: Text(l10n.loading)),
                error: (_, _) => InfoCard(child: Text(l10n.errorContinue)),
                data: (state) => InfoCard(
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    title: Text(l10n.technicalInformation),
                    subtitle: Text(l10n.technicalInformationHint),
                    children: [
                      FutureBuilder(
                        future: deps.devices.current(),
                        builder: (context, snapshot) {
                          return TechnicalInformationRows(
                            state: state,
                            userId: accounts.current?.userId,
                            deviceId: snapshot.data?.deviceId,
                          );
                        },
                      ),
                      const SizedBox(height: AarogyaSpacing.sm),
                      Text(
                        l10n.peerNetworkNotActive,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AarogyaColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.aboutAarogya),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MetricRow(
                      label: l10n.appVersionLabel,
                      value: l10n.appVersionValue,
                      icon: Icons.info_outline,
                    ),
                    Text(l10n.presentationTarget),
                    const SizedBox(height: AarogyaSpacing.sm),
                    Text(l10n.medicalDisclaimerShort),
                    const SizedBox(height: AarogyaSpacing.sm),
                    Text(l10n.dataStaysOnDevice),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.accounts});

  final AccountService accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget card() {
      final l10n = AppLocalizations.of(context);
      final current = accounts.current;
      return InfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (current != null) ...[
              Text(
                '${l10n.signedInAs} ${current.displayName ?? current.email}',
              ),
              Text(
                current.email,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AarogyaColors.textSecondary),
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              Text(l10n.sessionPersistsHint),
              const SizedBox(height: AarogyaSpacing.md),
              OutlinedButton(
                onPressed: () => _signOut(context, ref),
                child: Text(l10n.signOut),
              ),
            ] else ...[
              Text(l10n.authRequiredHint),
              const SizedBox(height: AarogyaSpacing.md),
              FilledButton(
                onPressed: () => context.go(AppPaths.login),
                child: Text(l10n.signIn),
              ),
            ],
          ],
        ),
      );
    }

    if (accounts is Listenable) {
      return ListenableBuilder(
        listenable: accounts as Listenable,
        builder: (context, _) => card(),
      );
    }
    return card();
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final deps = ref.read(dependenciesProvider);
    await deps.coordinator?.flushRemote();
    await deps.accounts.signOut();
    await deps.coordinator?.bind(null);
    if (context.mounted && deps.accounts.isConfigured) {
      context.go(AppPaths.login);
    }
  }
}
