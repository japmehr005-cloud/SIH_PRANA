import 'dart:async';

import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/domain/identity/device_identity.dart';
import 'package:aarogya/domain/identity/user_profile.dart';
import 'package:aarogya/features/persistence/data/durable_emergency_repository.dart';
import 'package:aarogya/features/persistence/data/durable_health_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:aarogya/features/sync/data/sync_service.dart';

final class SessionCoordinator {
  SessionCoordinator({
    required this.store,
    required this.devices,
    required this.health,
    required this.emergency,
    required this.runtime,
    this.sync,
  }) {
    _onlineSub = runtime.connectivity.watch().listen((status) {
      if (status.canTransmit) {
        unawaited(sync?.pushAll());
      }
    });
    _stateSub = runtime.states.listen((state) {
      if (state.risk != null) {
        unawaited(store.saveAssessment(state.risk));
      }
    });
  }

  final LocalRecordStore store;
  final DeviceIdentityStore devices;
  final HealthRepository health;
  final EmergencyRepository emergency;
  final AarogyaRuntime runtime;
  final SyncService? sync;
  StreamSubscription<ConnectivityStatus>? _onlineSub;
  StreamSubscription<dynamic>? _stateSub;

  Future<void> flushRemote() => sync?.pushAll() ?? Future<void>.value();

  Future<void> bind(AccountSession? session) async {
    await sync?.pushAll();
    await store.setScope(session?.userId ?? 'local');
    await devices.bindUser(session?.userId);
    runtime.packetFactory.ownerUserId = session?.userId ?? '';
    final durableHealth = health;
    if (durableHealth is DurableHealthRepository) {
      await durableHealth.loadScoped();
    }
    final durableEmergency = emergency;
    if (durableEmergency is DurableEmergencyRepository) {
      await durableEmergency.loadScoped();
    }
    if (session != null) {
      await store.saveProfile(
        UserProfile(
          userId: session.userId,
          displayName: session.displayName ?? session.email,
          email: session.email,
        ),
      );
      await sync?.pullIntoMemory();
      if (durableHealth is DurableHealthRepository) {
        await durableHealth.persist();
      }
      if (durableEmergency is DurableEmergencyRepository) {
        await durableEmergency.persist();
      }
    }
    await runtime.restorePersisted(risk: await store.assessment());
    final identity = await devices.current();
    await runtime.bindSession(
      userId: session?.userId ?? '',
      displayName: session?.displayName ?? session?.email ?? '',
      deviceId: identity.deviceId,
    );
  }

  Future<void> dispose() async {
    await _onlineSub?.cancel();
    await _stateSub?.cancel();
  }
}
