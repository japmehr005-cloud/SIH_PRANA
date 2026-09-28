import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:aarogya/features/location/presentation/safer_location_map.dart';
import 'package:aarogya/app/widgets/prana_chrome.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisasterScreen extends ConsumerStatefulWidget {
  const DisasterScreen({super.key});

  @override
  ConsumerState<DisasterScreen> createState() => _DisasterScreenState();
}

class _DisasterScreenState extends ConsumerState<DisasterScreen> {
  final _note = TextEditingController();
  List<String> _notes = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadNotes());
    });
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final userId =
        ref.read(dependenciesProvider).accounts.current?.userId ?? 'local';
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('aarogya.localNotes.v1.$userId') ?? [];
    if (mounted) {
      setState(() => _notes = stored);
    }
  }

  Future<void> _saveNote() async {
    final text = _note.text.trim();
    if (text.isEmpty) {
      return;
    }
    final userId =
        ref.read(dependenciesProvider).accounts.current?.userId ?? 'local';
    final prefs = await SharedPreferences.getInstance();
    final next = [..._notes, text];
    await prefs.setStringList('aarogya.localNotes.v1.$userId', next);
    _note.clear();
    if (mounted) {
      setState(() => _notes = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    return session.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.disasterNav)),
        body: Center(child: Text(l10n.loading)),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.disasterNav)),
        body: Center(child: Text(l10n.errorContinue)),
      ),
      data: (state) {
        final disasterActive =
            state.emergency.phase.index >= EmergencyPhase.disasterAlert.index;
        final codes = DisasterGuidanceCatalog.forType(
          state.emergency.disasterType,
        );
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 76,
            title: Row(
              children: [
                const BrandMark(height: 40, compact: true),
                const SizedBox(width: AarogyaSpacing.sm),
                Text(l10n.disasterNav),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: ListView(
                padding: const EdgeInsets.all(AarogyaSpacing.page),
                children: [
                  PranaStatus(
                    text: phaseLabel(l10n, state.emergency.phase),
                    color: disasterActive
                        ? AarogyaColors.warning
                        : AarogyaColors.accent,
                  ),
                  const SizedBox(height: AarogyaSpacing.md),
                  Text(l10n.officialVsUserHint),
                  const SizedBox(height: AarogyaSpacing.lg),
                  if (!disasterActive)
                    FilledButton.icon(
                      onPressed: () {
                        unawaited(
                          ref
                              .read(dependenciesProvider)
                              .runtime
                              .activateOfficialFlood(),
                        );
                      },
                      icon: const Icon(Icons.warning_amber_outlined),
                      label: Text(l10n.activateOfficialFlood),
                    ),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.officialReports),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (disasterActive) ...[
                          Text(
                            l10n.floodWarningIssued,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: AarogyaSpacing.sm),
                          Text(l10n.officialReportsHint),
                        ] else
                          Text(l10n.noOfficialWarning),
                      ],
                    ),
                  ),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.saferPlaceHeading),
                  SaferLocationMap(state: state),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.disasterGuidanceHeading),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final code in codes)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AarogyaSpacing.sm,
                            ),
                            child: Text('• ${guidanceLabel(l10n, code)}'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.userReports),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.receivedPackets.isEmpty && _notes.isEmpty)
                          Text(l10n.noUserReports)
                        else ...[
                          for (final packet in state.receivedPackets)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AarogyaSpacing.sm,
                              ),
                              child: Text(
                                '${l10n.userReports}: ${packet.originDisplayName.isEmpty ? l10n.appTitle : packet.originDisplayName} · ${eventTypeLabel(l10n, packet.eventType)}',
                              ),
                            ),
                          if (_notes.isNotEmpty) ...[
                            Text(
                              l10n.localNotesHeading,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            for (final note in _notes)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: AarogyaSpacing.sm,
                                ),
                                child: Text(note),
                              ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.addLocalNote),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l10n.localNoteHint),
                        const SizedBox(height: AarogyaSpacing.md),
                        TextField(
                          controller: _note,
                          decoration: InputDecoration(
                            labelText: l10n.localNoteLabel,
                          ),
                        ),
                        const SizedBox(height: AarogyaSpacing.md),
                        FilledButton(
                          onPressed: _saveNote,
                          child: Text(l10n.saveLocalNote),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
