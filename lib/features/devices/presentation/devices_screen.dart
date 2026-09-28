import 'dart:async';

import 'package:aarogya/app/l10n/l10n_mappers.dart';
import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/app/widgets/metric_row.dart';
import 'package:aarogya/app/widgets/section_header.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/identity/emergency_contact.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';
import 'package:aarogya/features/identity/data/emergency_contact_store.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  EmergencyContactStore? _store;
  List<EmergencyContact> _contacts = const [];
  final _name = TextEditingController();
  final _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_hydrate());
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  String get _userId =>
      ref.read(dependenciesProvider).accounts.current?.userId ?? 'local';

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    _store = EmergencyContactStore(preferences: prefs);
    final contacts = await _store!.list(_userId);
    if (mounted) {
      setState(() => _contacts = contacts);
    }
  }

  Future<void> _add() async {
    final store = _store;
    if (store == null ||
        _name.text.trim().isEmpty ||
        _phone.text.trim().isEmpty) {
      return;
    }
    await store.add(userId: _userId, name: _name.text, phone: _phone.text);
    _name.clear();
    _phone.clear();
    final contacts = await store.list(_userId);
    if (mounted) {
      setState(() => _contacts = contacts);
    }
  }

  Future<void> _remove(String id) async {
    final store = _store;
    if (store == null) {
      return;
    }
    await store.remove(userId: _userId, id: id);
    final contacts = await store.list(_userId);
    if (mounted) {
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(sessionProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        title: Row(
          children: [
            const BrandMark(height: 40, compact: true),
            const SizedBox(width: AarogyaSpacing.sm),
            Text(l10n.devicesTitle),
          ],
        ),
      ),
      body: session.when(
        loading: () => Center(child: Text(l10n.loading)),
        error: (_, _) => Center(child: Text(l10n.errorContinue)),
        data: (state) {
          final sample = state.currentSample;
          final live =
              sample?.sourceKind == SensorSourceKind.wearable ||
              sample?.sourceKind == SensorSourceKind.device;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 840),
              child: ListView(
                padding: const EdgeInsets.all(AarogyaSpacing.page),
                children: [
                  SectionHeader(l10n.thisDevice),
                  InfoCard(
                    child: Column(
                      children: [
                        MetricRow(
                          label: l10n.thisDevice,
                          value: live
                              ? l10n.sourceLive
                              : l10n.sourceDemonstration,
                          icon: Icons.smartphone_outlined,
                        ),
                        MetricRow(
                          label: l10n.heartRateAccessory,
                          value: state.heartRateConnected
                              ? l10n.accessoryConnected
                              : state.heartRateSupported
                              ? l10n.accessoryNotConnected
                              : l10n.accessoryUnsupported,
                          icon: Icons.watch_outlined,
                        ),
                        MetricRow(
                          label: l10n.sensorAvailability,
                          value: sensorSourceKindLabel(
                            l10n,
                            sample?.sourceKind,
                          ),
                          icon: Icons.sensors_outlined,
                        ),
                        MetricRow(
                          label: l10n.connectivity,
                          value: connectivityLabel(l10n, state.connectivity),
                          icon: Icons.wifi,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AarogyaSpacing.lg),
                  SectionHeader(l10n.emergencyContacts),
                  Text(l10n.contactsStayLocal),
                  const SizedBox(height: AarogyaSpacing.md),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_contacts.isEmpty) Text(l10n.noEmergencyContacts),
                        for (final contact in _contacts)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(contact.name),
                            subtitle: Text(contact.phone),
                            trailing: TextButton(
                              onPressed: () => unawaited(_remove(contact.id)),
                              child: Text(l10n.removeContact),
                            ),
                          ),
                        const SizedBox(height: AarogyaSpacing.md),
                        TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: l10n.contactName,
                          ),
                        ),
                        const SizedBox(height: AarogyaSpacing.sm),
                        TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.contactPhone,
                          ),
                        ),
                        const SizedBox(height: AarogyaSpacing.md),
                        FilledButton(
                          onPressed: () => unawaited(_add()),
                          child: Text(l10n.addEmergencyContact),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
