import 'package:aarogya/domain/communication/connectivity_status.dart';
import 'package:aarogya/domain/communication/emergency_packet.dart';
import 'package:aarogya/domain/communication/packet_state.dart';
import 'package:aarogya/domain/contracts/account_repository.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/risk/risk_assessment.dart';
import 'package:aarogya/domain/risk/risk_level.dart';
import 'package:aarogya/features/auth/data/local_account_repository.dart';
import 'package:aarogya/features/auth/data/local_account_service.dart';
import 'package:aarogya/features/auth/data/login_identifier.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:aarogya/features/persistence/data/durable_emergency_repository.dart';
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

  test('register and sign-in verify the password', () async {
    final preferences = await SharedPreferences.getInstance();
    final accounts = LocalAccountService(LocalAccountRepository(preferences));
    final created = await accounts.register(
      displayName: 'User A',
      email: 'a@example.com',
      password: 'correct-password',
    );
    expect(created.email, 'a@example.com');
    expect(created.isDemonstration, isFalse);

    await accounts.signOut();
    expect(accounts.current, isNull);

    await expectLater(
      accounts.signIn(email: 'a@example.com', password: 'wrong-password'),
      throwsA(
        isA<AccountAuthException>().having(
          (error) => error.code,
          'code',
          AccountAuthCode.invalidCredentials,
        ),
      ),
    );

    final signedIn = await accounts.signIn(
      email: 'a@example.com',
      password: 'correct-password',
    );
    expect(signedIn.userId, created.userId);
  });

  test('session restore after refresh keeps the same user', () async {
    final preferences = await SharedPreferences.getInstance();
    final first = LocalAccountService(LocalAccountRepository(preferences));
    await first.register(
      displayName: 'User A',
      email: '9876543210',
      password: 'password1',
    );

    final restored = LocalAccountService(LocalAccountRepository(preferences));
    final session = await restored.restore();
    expect(session?.email, '9876543210');
    expect(session?.displayName, 'User A');
  });

  test('demonstration user is a real persistent account', () async {
    final preferences = await SharedPreferences.getInstance();
    final accounts = LocalAccountService(LocalAccountRepository(preferences));
    final first = await accounts.continueAsDemonstrationUser();
    expect(first.isDemonstration, isTrue);
    expect(first.email, LocalAccountRepository.demonstrationLoginId);
    await accounts.signOut();
    final second = await accounts.continueAsDemonstrationUser();
    expect(second.userId, first.userId);
  });

  test('user A and user B keep isolated health and packets', () async {
    final preferences = await SharedPreferences.getInstance();
    final store = LocalRecordStore(preferences: preferences);
    final health = DurableHealthRepository(
      inner: InMemoryHealthRepository(),
      store: store,
    );
    final emergency = DurableEmergencyRepository(
      inner: InMemoryEmergencyRepository(),
      store: store,
    );
    final accounts = LocalAccountService(LocalAccountRepository(preferences));

    final userA = await accounts.register(
      displayName: 'User A',
      email: 'a@example.com',
      password: 'password-a',
    );
    await store.setScope(userA.userId);
    await health.saveSample(
      sample(at: DateTime.utc(2026, 9, 6, 10), hr: 68, spo2: 98),
    );
    await health.saveBaseline(
      PersonalBaseline(
        version: 'v1',
        sampleCount: 20,
        computedAt: DateTime.utc(2026, 9, 6, 10),
        restingHeartRate: const MetricRange(low: 62, high: 72, median: 67),
      ),
    );
    await emergency.savePacket(
      EmergencyPacket(
        eventId: 'evt-a',
        timestamp: DateTime.utc(2026, 9, 6, 10),
        eventType: 'possible_fall',
        riskLevel: RiskLevel.high,
        fallStatus: FallStatus.possible,
        state: PacketState.stored,
        connectivityAtCreation: ConnectivityStatus.offline,
        ownerUserId: userA.userId,
      ),
    );

    final userB = await accounts.register(
      displayName: 'User B',
      email: 'b@example.com',
      password: 'password-b',
    );
    await store.setScope(userB.userId);
    await health.loadScoped();
    await emergency.loadScoped();
    expect(await health.recentSamples(), isEmpty);
    expect(await health.latestBaseline(), isNull);
    expect(await emergency.allPackets(), isEmpty);

    await health.saveSample(
      sample(at: DateTime.utc(2026, 9, 6, 11), hr: 80, spo2: 96),
    );

    await store.setScope(userA.userId);
    await health.loadScoped();
    await emergency.loadScoped();
    expect((await health.recentSamples()).single.heartRateBpm, 68);
    expect((await health.latestBaseline())?.restingHeartRate?.median, 67);
    final packets = await emergency.allPackets();
    expect(packets.single.eventId, 'evt-a');
    expect(packets.single.ownerUserId, userA.userId);
    expect(packets.single.ownerUserId, isNot(userB.userId));
  });

  test('last assessment is stored only in the current user scope', () async {
    final preferences = await SharedPreferences.getInstance();
    final store = LocalRecordStore(preferences: preferences);
    final accounts = LocalAccountService(LocalAccountRepository(preferences));
    final userA = await accounts.register(
      displayName: 'User A',
      email: 'a@example.com',
      password: 'password-a',
    );
    await store.setScope(userA.userId);
    await store.saveAssessment(
      RiskAssessment(
        level: RiskLevel.moderate,
        score: 42,
        reasons: const [],
        timestamp: DateTime.utc(2026, 9, 6, 10),
        modelVersion: 'physio-context-v1',
      ),
    );

    final userB = await accounts.register(
      displayName: 'User B',
      email: 'b@example.com',
      password: 'password-b',
    );
    await store.setScope(userB.userId);
    expect(await store.assessment(), isNull);

    await store.setScope(userA.userId);
    expect((await store.assessment())?.score, 42);
  });

  test('login identifiers accept email or mobile', () {
    expect(isValidLoginId('person@example.com'), isTrue);
    expect(isValidLoginId('9876543210'), isTrue);
    expect(isValidLoginId('not-an-id'), isFalse);
    expect(normalizeLoginId('  Person@Example.com '), 'person@example.com');
  });
}
