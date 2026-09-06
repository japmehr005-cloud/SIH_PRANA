import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/inference_status_rows.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/app/widgets/status_panel.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/location/presentation/safer_location_map.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RescueDashboardScreen extends ConsumerWidget {
  const RescueDashboardScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);

    final body = session.when(
      loading: () => Center(child: Text(l10n.loading)),
      error: (_, _) => Center(child: Text(l10n.errorContinue)),
      data: (state) {
        return FutureBuilder<List<EmergencyPacket>>(
          key: ValueKey(
            '${state.latestPacket?.eventId}-${state.latestPacket?.state}',
          ),
          future: ref.read(dependenciesProvider).runtime.emergency.allPackets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                state.latestPacket == null &&
                snapshot.data == null) {
              return Center(child: Text(l10n.loading));
            }
            final packets = _uniquePackets([
              ...?snapshot.data,
              if (state.latestPacket != null) state.latestPacket!,
            ]);
            if (packets.isEmpty) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Padding(
                    padding: const EdgeInsets.all(AarogyaSpacing.page),
                    child: StatusPanel(
                      title: l10n.noEmergencyPackets,
                      body: l10n.rescueEmptyHint,
                      icon: Icons.inbox_outlined,
                      level: RiskLevel.low,
                    ),
                  ),
                ),
              );
            }
            final latest = packets.first;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: ListView(
                  padding: const EdgeInsets.all(AarogyaSpacing.page),
                  children: [
                    Text(
                      l10n.productTagline,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AarogyaColors.textSecondary),
                    ),
                    const SizedBox(height: AarogyaSpacing.md),
                    StatusPanel(
                      title: _statusTitle(l10n, latest.state),
                      body: packetLabel(l10n, latest.state),
                      icon: latest.state.isDelivered
                          ? Icons.verified_outlined
                          : Icons.inventory_2_outlined,
                      level: latest.state.isDelivered
                          ? RiskLevel.low
                          : RiskLevel.high,
                    ),
                    const SizedBox(height: AarogyaSpacing.lg),
                    if (packets.any((item) => !item.isReceivedNearby)) ...[
                      SectionHeader(l10n.myEmergencyInformation),
                      for (final packet in packets.where(
                        (item) => !item.isReceivedNearby,
                      )) ...[
                        const SizedBox(height: AarogyaSpacing.md),
                        _ResponderBrief(packet: packet, session: state),
                      ],
                    ],
                    if (packets.any((item) => item.isReceivedNearby)) ...[
                      const SizedBox(height: AarogyaSpacing.lg),
                      SectionHeader(l10n.receivedNearby),
                      for (final packet in packets.where(
                        (item) => item.isReceivedNearby,
                      )) ...[
                        const SizedBox(height: AarogyaSpacing.md),
                        _ResponderBrief(packet: packet, session: state),
                      ],
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (embedded) {
      return body;
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rescueDashboard)),
      body: body,
    );
  }

  List<EmergencyPacket> _uniquePackets(List<EmergencyPacket> packets) {
    final seen = <String>{};
    final unique = <EmergencyPacket>[];
    for (final packet in packets) {
      if (seen.add(packet.eventId)) {
        unique.add(packet);
      }
    }
    unique.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return unique;
  }

  String _statusTitle(AppLocalizations l10n, PacketState state) {
    return switch (state) {
      PacketState.deliveryConfirmed || PacketState.sent => l10n.packetDelivered,
      PacketState.queued ||
      PacketState.transmitting => l10n.packetPendingDelivery,
      _ => l10n.packetStoredLocally,
    };
  }
}

class _ResponderBrief extends StatelessWidget {
  const _ResponderBrief({required this.packet, required this.session});

  final EmergencyPacket packet;
  final AppSessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final focus = packet.locationAvailable
        ? DeviceLocation(
            latitude: packet.latitude!,
            longitude: packet.longitude!,
            capturedAt: packet.timestamp,
            source: LocationSource.lastKnown,
          )
        : null;
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MetricRow(
            label: l10n.personLabel,
            value: packet.originDisplayName.isEmpty
                ? l10n.appTitle
                : packet.originDisplayName,
            icon: Icons.person_outline,
          ),
          MetricRow(
            label: l10n.urgencyLabel,
            value: riskLabel(l10n, packet.riskLevel),
            icon: Icons.priority_high,
          ),
          MetricRow(
            label: l10n.whatHappened,
            value: eventTypeLabel(l10n, packet.eventType),
            icon: Icons.assignment_outlined,
          ),
          MetricRow(
            label: l10n.timeLabel,
            value: packet.timestamp.toLocal().toString(),
            icon: Icons.schedule,
          ),
          const SizedBox(height: AarogyaSpacing.md),
          SectionHeader(l10n.currentLocation),
          MetricRow(
            label: l10n.location,
            value: packet.locationAvailable
                ? '${packet.latitude!.toStringAsFixed(3)}, ${packet.longitude!.toStringAsFixed(3)}'
                : l10n.locationUnavailable,
            icon: Icons.location_on_outlined,
          ),
          SaferLocationMap(
            state: session,
            focusLocation: focus,
            showControls: false,
          ),
          const SizedBox(height: AarogyaSpacing.md),
          SectionHeader(l10n.healthSummary),
          MetricRow(
            label: l10n.heartRateNowUsual,
            value: nowVersusUsual(
              l10n,
              packet.heartRateBpm,
              packet.baselineHeartRate,
              l10n.bpmUnit,
            ),
            icon: Icons.favorite_border,
          ),
          MetricRow(
            label: l10n.spo2NowUsual,
            value: nowVersusUsual(
              l10n,
              packet.spo2Percent,
              packet.baselineSpo2,
              l10n.percentUnit,
            ),
            icon: Icons.air,
          ),
          const SizedBox(height: AarogyaSpacing.md),
          SectionHeader(l10n.howItReachedUs),
          Text(
            packet.isReceivedNearby
                ? l10n.reachedFromNearbyUser
                : l10n.reachedFromThisAccount,
          ),
          MetricRow(
            label: l10n.communicationStatus,
            value: packetLabel(l10n, packet.state),
            icon: Icons.outgoing_mail,
          ),
          MetricRow(
            label: l10n.connectivity,
            value: connectivityLabel(l10n, session.connectivity),
            icon: Icons.wifi,
          ),
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l10n.technicalInformation),
            children: [
              MetricRow(
                label: l10n.eventId,
                value: packet.eventId,
                icon: Icons.badge_outlined,
              ),
              PacketModelRows(packet: packet),
            ],
          ),
        ],
      ),
    );
  }
}
