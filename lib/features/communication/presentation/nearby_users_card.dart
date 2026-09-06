import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NearbyUsersCard extends ConsumerWidget {
  const NearbyUsersCard({super.key, required this.state});

  final AppSessionState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final peers = state.nearbyPeers;
    final outbound = state.latestPacket;
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.nearbySharingHint),
          const SizedBox(height: AarogyaSpacing.md),
          if (peers.isEmpty)
            Text(l10n.noNearbyUsers)
          else
            for (final peer in peers) ...[
              MetricRow(
                label: peer.label ?? l10n.appTitle,
                value: _peerHasEmergency(peer)
                    ? l10n.emergencyInformationAvailable
                    : l10n.connectedDevice,
                icon: Icons.people_outline,
              ),
              Wrap(
                spacing: AarogyaSpacing.sm,
                children: [
                  if (_peerHasEmergency(peer))
                    OutlinedButton(
                      onPressed: () {
                        unawaited(
                          ref
                              .read(dependenciesProvider)
                              .runtime
                              .receiveFromPeer(peer),
                        );
                      },
                      child: Text(l10n.receiveEmergency),
                    ),
                  if (outbound != null)
                    OutlinedButton(
                      onPressed: () {
                        unawaited(
                          ref
                              .read(dependenciesProvider)
                              .runtime
                              .forwardToPeer(outbound, peer),
                        );
                      },
                      child: Text(l10n.forwardEmergency),
                    ),
                ],
              ),
            ],
          if (state.receivedPackets.isNotEmpty) ...[
            const SizedBox(height: AarogyaSpacing.md),
            Text(l10n.receivedNearby),
            for (final item in state.receivedPackets)
              Padding(
                padding: const EdgeInsets.only(top: AarogyaSpacing.sm),
                child: Text(_receivedLine(l10n, item)),
              ),
          ],
        ],
      ),
    );
  }

  bool _peerHasEmergency(PeerDevice peer) {
    for (final packet in state.nearbySharedPackets) {
      if (peer.userId != null && packet.ownerUserId == peer.userId) {
        return true;
      }
    }
    return false;
  }

  String _receivedLine(AppLocalizations l10n, EmergencyPacket packet) {
    final name = packet.originDisplayName.isEmpty
        ? l10n.appTitle
        : packet.originDisplayName;
    return '${l10n.fromUser(name)} · ${eventTypeLabel(l10n, packet.eventType)}';
  }
}
