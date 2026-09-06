import 'dart:async';

import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/contracts/connectivity_service.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/contracts/health_repository.dart';
import 'package:aarogya/domain/contracts/sync_repository.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/domain/identity/device_identity.dart';
import 'package:aarogya/features/persistence/data/durable_emergency_repository.dart';
import 'package:aarogya/features/persistence/data/durable_health_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:aarogya/features/persistence/data/record_codecs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Pushes local records when the app is signed in and marked online.
/// Does not run inference. Gated on [ConnectivityService], not the laptop radio.
final class SyncService implements SyncRepository {
  SyncService({
    required this.client,
    required this.accounts,
    required this.connectivity,
    required this.devices,
    required this.health,
    required this.emergency,
    this.store,
  });

  final SupabaseClient client;
  final AccountService accounts;
  final ConnectivityService connectivity;
  final DeviceIdentityStore devices;
  final HealthRepository health;
  final EmergencyRepository emergency;
  final LocalRecordStore? store;
  final _uuid = const Uuid();
  Timer? _debounce;

  bool get _canSync {
    return accounts.current != null && connectivity.current.canTransmit;
  }

  Future<void> schedulePush() async {
    await store?.markOutboxPending();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      unawaited(pushAll());
    });
  }

  @override
  Future<void> pushAll() async {
    _debounce?.cancel();
    if (!_canSync) {
      await store?.markOutboxPending();
      return;
    }
    try {
      final userId = accounts.current!.userId;
      final identity = await devices.current();
      await _pushDevice(userId, identity);
      await _pushObservations(userId, identity);
      await _pushBaseline(userId);
      await _pushSnapshot(userId);
      await _pushPackets(userId);
      await store?.clearOutbox();
    } catch (_) {
      await store?.markOutboxPending();
    }
  }

  @override
  Future<void> pullIntoMemory() async {
    if (!_canSync) {
      return;
    }
    final userId = accounts.current!.userId;
    final observationRows = await client
        .from('observations')
        .select()
        .eq('user_id', userId)
        .order('recorded_at', ascending: true)
        .limit(120);
    final samples = [
      for (final row in observationRows as List<dynamic>)
        _sampleFromRow(Map<String, dynamic>.from(row as Map)),
    ];

    final baselineRows = await client
        .from('baselines')
        .select()
        .eq('user_id', userId)
        .limit(1);
    PersonalBaseline? baseline;
    if (baselineRows.isNotEmpty) {
      baseline = _baselineFromRow(
        Map<String, dynamic>.from(baselineRows.first as Map),
      );
    }

    final snapshotRows = await client
        .from('emergency_snapshots')
        .select()
        .eq('user_id', userId)
        .limit(1);
    EmergencySnapshot? snapshot;
    if (snapshotRows.isNotEmpty) {
      snapshot = decodeSnapshot(_snapshotMap(snapshotRows.first as Map));
    }

    final packetRows = await client
        .from('packets')
        .select()
        .eq('user_id', userId)
        .order('timestamp', ascending: true);
    final packets = [
      for (final row in packetRows as List<dynamic>)
        _packetFromRow(Map<String, dynamic>.from(row as Map)),
    ];

    final healthDurable = health;
    if (healthDurable is DurableHealthRepository) {
      await healthDurable.replaceSession(
        samples: samples.isEmpty ? await health.recentSamples() : samples,
        baseline: baseline ?? await health.latestBaseline(),
      );
    }
    final emergencyDurable = emergency;
    if (emergencyDurable is DurableEmergencyRepository) {
      await emergencyDurable.replaceSession(
        snapshot: snapshot ?? await emergency.loadSnapshot(),
        packets: packets.isEmpty ? await emergency.allPackets() : packets,
      );
    }
  }

  Future<void> _pushDevice(String userId, DeviceIdentity identity) async {
    await client.from('devices').upsert({
      'id': identity.deviceId,
      'user_id': userId,
      'label': identity.label,
      'platform': 'web',
      'last_seen_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> _pushObservations(String userId, DeviceIdentity identity) async {
    final now = DateTime.now();
    final samples = await health.recentSamples();
    if (samples.isEmpty) {
      return;
    }
    final rows = [
      for (final sample in samples)
        {
          'id': _uuid.v5(
            Namespace.url.value,
            '$userId|${sample.timestamp.toUtc().toIso8601String()}',
          ),
          'user_id': userId,
          'device_id': identity.deviceId,
          'recorded_at': sample.timestamp.toUtc().toIso8601String(),
          'heart_rate_bpm': sample.heartRateBpm,
          'spo2_percent': sample.spo2Percent,
          'temperature_c': sample.temperatureC,
          'movement': sample.movement?.name,
          'battery_percent': sample.batteryPercent,
          'lat': sample.latitude,
          'lon': sample.longitude,
          'is_simulation': sample.isSimulation,
          'source_id': sample.sourceId,
          'source_kind': sample.sourceKind.name,
          'updated_at': now.toUtc().toIso8601String(),
        },
    ];
    await client.from('observations').upsert(rows);
  }

  Future<void> _pushBaseline(String userId) async {
    final baseline = await health.latestBaseline();
    if (baseline == null) {
      return;
    }
    await client.from('baselines').upsert({
      'user_id': userId,
      'version': baseline.version,
      'sample_count': baseline.sampleCount,
      'computed_at': baseline.computedAt.toUtc().toIso8601String(),
      'hr_low': baseline.restingHeartRate?.low,
      'hr_high': baseline.restingHeartRate?.high,
      'hr_median': baseline.restingHeartRate?.median,
      'spo2_low': baseline.spo2?.low,
      'spo2_high': baseline.spo2?.high,
      'spo2_median': baseline.spo2?.median,
      'temp_low': baseline.temperature?.low,
      'temp_high': baseline.temperature?.high,
      'temp_median': baseline.temperature?.median,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> _pushSnapshot(String userId) async {
    final snapshot = await emergency.loadSnapshot();
    if (snapshot == null) {
      return;
    }
    await client.from('emergency_snapshots').upsert({
      'user_id': userId,
      'phase': snapshot.phase.name,
      'disaster_type': snapshot.disasterType?.name,
      'activation_source': snapshot.activationSource?.name,
      'stranded': snapshot.stranded,
      'last_event_id': snapshot.lastEventId,
      'updated_at': snapshot.updatedAt.toUtc().toIso8601String(),
    });
  }

  Future<void> _pushPackets(String userId) async {
    final packets = await emergency.allPackets();
    if (packets.isEmpty) {
      await client.from('packets').delete().eq('user_id', userId);
      return;
    }
    await client.from('packets').upsert([
      for (final packet in packets) _packetRow(userId, packet),
    ]);
  }

  Map<String, Object?> _packetRow(String userId, EmergencyPacket packet) {
    return {
      'event_id': packet.eventId,
      'user_id': userId,
      'origin_device_id': packet.originDeviceId,
      'timestamp': packet.timestamp.toUtc().toIso8601String(),
      'event_type': packet.eventType,
      'risk_level': packet.riskLevel.name,
      'fall_status': packet.fallStatus.name,
      'state': packet.state.name,
      'connectivity_at_creation': packet.connectivityAtCreation.name,
      'movement': packet.movement?.name,
      'heart_rate_bpm': packet.heartRateBpm,
      'spo2_percent': packet.spo2Percent,
      'battery_percent': packet.batteryPercent,
      'lat': packet.latitude,
      'lon': packet.longitude,
      'hop_count': packet.hopCount,
      'expires_at': packet.expiresAt?.toUtc().toIso8601String(),
      'model_version': packet.modelVersion,
      'risk_score': packet.riskScore,
      'context_label': packet.contextLabel,
      'context_confidence': packet.contextConfidence,
      'baseline_heart_rate': packet.baselineHeartRate,
      'baseline_spo2': packet.baselineSpo2,
      'window_heart_rate_mean': packet.windowHeartRateMean,
      'rules_score': packet.rulesScore,
      'model_contribution': packet.modelContribution,
      'sensor_source_id': packet.sensorSourceId,
      'sensor_source_kind': packet.sensorSourceKind,
      'fall_detection_mode': packet.fallDetectionMode,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  SensorSample _sampleFromRow(Map<String, dynamic> row) {
    return decodeSample({
      'timestamp': row['recorded_at'],
      'heartRateBpm': row['heart_rate_bpm'],
      'spo2Percent': row['spo2_percent'],
      'temperatureC': row['temperature_c'],
      'movement': row['movement'],
      'batteryPercent': row['battery_percent'],
      'latitude': row['lat'],
      'longitude': row['lon'],
      'isSimulation': row['is_simulation'],
      'sourceId': row['source_id'] ?? 'unknown',
      'sourceKind': row['source_kind'] ?? 'simulation',
    });
  }

  PersonalBaseline _baselineFromRow(Map<String, dynamic> row) {
    return decodeBaseline({
      'version': row['version'],
      'sampleCount': row['sample_count'],
      'computedAt': row['computed_at'],
      'restingHeartRate': row['hr_median'] == null
          ? null
          : {
              'low': row['hr_low'],
              'high': row['hr_high'],
              'median': row['hr_median'],
            },
      'spo2': row['spo2_median'] == null
          ? null
          : {
              'low': row['spo2_low'],
              'high': row['spo2_high'],
              'median': row['spo2_median'],
            },
      'temperature': row['temp_median'] == null
          ? null
          : {
              'low': row['temp_low'],
              'high': row['temp_high'],
              'median': row['temp_median'],
            },
    });
  }

  Map<String, dynamic> _snapshotMap(Map row) {
    return {
      'phase': row['phase'],
      'updatedAt': row['updated_at'],
      'disasterType': row['disaster_type'],
      'activationSource': row['activation_source'],
      'lastEventId': row['last_event_id']?.toString(),
      'stranded': row['stranded'],
    };
  }

  EmergencyPacket _packetFromRow(Map<String, dynamic> row) {
    return decodePacket({
      'eventId': row['event_id'].toString(),
      'timestamp': row['timestamp'],
      'eventType': row['event_type'],
      'riskLevel': row['risk_level'],
      'fallStatus': row['fall_status'],
      'state': row['state'],
      'connectivityAtCreation': row['connectivity_at_creation'],
      'movement': row['movement'],
      'heartRateBpm': row['heart_rate_bpm'],
      'spo2Percent': row['spo2_percent'],
      'batteryPercent': row['battery_percent'],
      'latitude': row['lat'],
      'longitude': row['lon'],
      'originDeviceId': row['origin_device_id'],
      'hopCount': row['hop_count'],
      'expiresAt': row['expires_at'],
      'modelVersion': row['model_version'],
      'riskScore': row['risk_score'],
      'contextLabel': row['context_label'],
      'contextConfidence': row['context_confidence'],
      'baselineHeartRate': row['baseline_heart_rate'],
      'baselineSpo2': row['baseline_spo2'],
      'windowHeartRateMean': row['window_heart_rate_mean'],
      'rulesScore': row['rules_score'],
      'modelContribution': row['model_contribution'],
      'sensorSourceId': row['sensor_source_id'],
      'sensorSourceKind': row['sensor_source_kind'],
      'fallDetectionMode': row['fall_detection_mode'],
    });
  }
}
