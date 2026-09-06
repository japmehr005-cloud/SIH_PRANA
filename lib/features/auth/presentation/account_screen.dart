import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final deps = ref.watch(dependenciesProvider);
    final session = deps.accounts.current;
    final health = ref.watch(sessionProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myAccount)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            children: [
              SectionHeader(l10n.myAccount),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (session?.isDemonstration == true) ...[
                      Text(
                        l10n.demonstrationAccount,
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: AarogyaColors.warning),
                      ),
                      const SizedBox(height: AarogyaSpacing.sm),
                    ],
                    MetricRow(
                      label: l10n.fullName,
                      value: session?.displayName ?? l10n.unavailable,
                      icon: Icons.person_outline,
                    ),
                    MetricRow(
                      label: l10n.accountIdentifier,
                      value: session?.email ?? l10n.unavailable,
                      icon: Icons.badge_outlined,
                    ),
                    FutureBuilder(
                      future: deps.devices.current(),
                      builder: (context, snapshot) {
                        return MetricRow(
                          label: l10n.deviceId,
                          value: snapshot.data?.deviceId ?? l10n.unavailable,
                          icon: Icons.smartphone_outlined,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.healthDataStatus),
              health.when(
                loading: () => InfoCard(child: Text(l10n.loading)),
                error: (_, _) => InfoCard(child: Text(l10n.errorContinue)),
                data: (state) => InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.baseline?.isEstablished == true
                            ? l10n.baselineReadyShort
                            : l10n.baselineNotReadyShort,
                      ),
                      const SizedBox(height: AarogyaSpacing.sm),
                      FutureBuilder(
                        future: deps.runtime.health.recentSamples(),
                        builder: (context, snapshot) {
                          return Text(
                            l10n.readingCount(snapshot.data?.length ?? 0),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              SectionHeader(l10n.emergencyRecords),
              FutureBuilder(
                future: deps.runtime.emergency.allPackets(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.length ?? 0;
                  return InfoCard(child: Text(l10n.packetCount(count)));
                },
              ),
              const SizedBox(height: AarogyaSpacing.lg),
              OutlinedButton(
                onPressed: () => _signOut(context, ref),
                child: Text(l10n.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final deps = ref.read(dependenciesProvider);
    await deps.coordinator?.flushRemote();
    await deps.accounts.signOut();
    await deps.coordinator?.bind(null);
    if (context.mounted) {
      context.go(AppPaths.login);
    }
  }
}
