import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/emergency/emergency_snapshot.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:aarogya/features/persistence/data/durable_health_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/sample_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('scoped records do not leak between users', () async {
    final preferences = await SharedPreferences.getInstance();
    final store = LocalRecordStore(preferences: preferences, scope: 'user-a');
    final now = DateTime.utc(2026, 9, 6, 10);
    await store.saveObservations([sample(at: now, hr: 68, spo2: 98)]);
    await store.saveBaseline(
      PersonalBaseline(
        version: 'v1',
        sampleCount: 20,
        computedAt: now,
        restingHeartRate: const MetricRange(low: 62, high: 72, median: 67),
      ),
    );
    await store.savePackets([
      EmergencyPacket(
        eventId: 'evt-a',
        timestamp: now,
        eventType: 'possible_fall',
        riskLevel: RiskLevel.high,
        fallStatus: FallStatus.possible,
        state: PacketState.stored,
        connectivityAtCreation: ConnectivityStatus.offline,
        originDeviceId: 'device-a',
      ),
    ]);
    await store.saveSnapshot(
      EmergencySnapshot(
        phase: EmergencyPhase.survival,
        updatedAt: now,
        stranded: true,
        lastEventId: 'evt-a',
      ),
    );

    await store.setScope('user-b');
    expect(await store.observations(), isEmpty);
    expect(await store.baseline(), isNull);
    expect(await store.packets(), isEmpty);
    expect(await store.snapshot(), isNull);

    await store.setScope('user-a');
    final restored = await store.observations();
    expect(restored.single.heartRateBpm, 68);
    expect((await store.packets()).single.eventId, 'evt-a');
    expect((await store.snapshot())?.phase, EmergencyPhase.survival);
    expect((await store.baseline())?.restingHeartRate?.median, 67);
  });

  test('durable health repository reloads the scoped snapshot', () async {
    final preferences = await SharedPreferences.getInstance();
    final store = LocalRecordStore(preferences: preferences, scope: 'user-a');
    final first = DurableHealthRepository(
      inner: InMemoryHealthRepository(),
      store: store,
    );
    await first.saveSample(
      sample(at: DateTime.utc(2026, 9, 6, 11), hr: 70, spo2: 97),
    );

    final second = DurableHealthRepository(
      inner: InMemoryHealthRepository(),
      store: store,
    );
    await second.loadScoped();
    final samples = await second.recentSamples();
    expect(samples.single.heartRateBpm, 70);
  });
}
