import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/app/session/session_coordinator.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/core/supabase_config.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/emergency/emergency_state_machine.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/features/auth/data/local_account_repository.dart';
import 'package:aarogya/features/auth/data/local_account_service.dart';
import 'package:aarogya/features/communication/data/demo_local_transfer.dart';
import 'package:aarogya/features/communication/data/demo_peer_discovery.dart';
import 'package:aarogya/features/communication/data/in_memory_connectivity_service.dart';
import 'package:aarogya/features/communication/data/nearby_inbox_store.dart';
import 'package:aarogya/features/communication/data/nearby_relay_transport.dart';
import 'package:aarogya/features/edge_ai/domain/fall_detection_engine.dart';
import 'package:aarogya/features/edge_ai/domain/fall_window_model.dart';
import 'package:aarogya/features/edge_ai/domain/local_inference_engine.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/emergency/domain/emergency_packet_factory.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:aarogya/features/identity/data/preferences_device_identity_store.dart';
import 'package:aarogya/features/location/data/browser_location_service.dart';
import 'package:aarogya/features/location/data/composite_location_service.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:aarogya/features/location/domain/safer_location_engine.dart';
import 'package:aarogya/features/persistence/data/durable_emergency_repository.dart';
import 'package:aarogya/features/persistence/data/durable_health_repository.dart';
import 'package:aarogya/features/persistence/data/local_record_store.dart';
import 'package:aarogya/features/sensors/data/multiplex_sensor_source.dart';
import 'package:aarogya/features/sensors/data/simulated_sensor_source.dart';
import 'package:aarogya/features/sensors/data/web_bluetooth_heart_rate.dart';
import 'package:aarogya/features/sensors/data/web_motion_sensor_source.dart';
import 'package:aarogya/features/sync/data/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<AarogyaDependencies> createPlatformDependencies({
  PhysioContextModel? contextModel,
}) async {
  final preferences = await SharedPreferences.getInstance();
  final store = LocalRecordStore(preferences: preferences);
  final devices = PreferencesDeviceIdentityStore(preferences);
  final identity = await devices.current();

  final accounts = LocalAccountService(LocalAccountRepository(preferences));
  await accounts.restore();
  SupabaseClient? client;
  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
    client = Supabase.instance.client;
  }
  if (accounts.current != null) {
    await store.setScope(accounts.current!.userId);
    await devices.bindUser(accounts.current!.userId);
  }

  final clock = const SystemClock();
  final machine = EmergencyStateMachine(clock: clock);
  final healthInner = InMemoryHealthRepository();
  final emergencyInner = InMemoryEmergencyRepository();
  final connectivity = InMemoryConnectivityService();
  final memoryPreferences = InMemoryPreferenceRepository();
  final locale = preferences.getString('aarogya.locale');
  if (locale != null) {
    await memoryPreferences.setLocaleCode(locale);
  }

  late DurableHealthRepository health;
  late DurableEmergencyRepository emergency;
  SyncService? sync;
  health = DurableHealthRepository(
    inner: healthInner,
    store: store,
    onChanged: () => sync?.schedulePush() ?? Future<void>.value(),
  );
  emergency = DurableEmergencyRepository(
    inner: emergencyInner,
    store: store,
    onChanged: () => sync?.schedulePush() ?? Future<void>.value(),
  );
  await health.loadScoped();
  await emergency.loadScoped();

  if (client != null) {
    sync = SyncService(
      client: client,
      accounts: accounts,
      connectivity: connectivity,
      devices: devices,
      health: health,
      emergency: emergency,
      store: store,
    );
  }

  final inbox = NearbyInboxStore(preferences);
  final transport = NearbyRelayTransport(
    inbox,
    localUserId: accounts.current?.userId ?? '',
  );
  final peers = DemoPeerDiscovery(
    inbox,
    localUserId: accounts.current?.userId ?? '',
  );
  final localTransfer = DemoLocalTransfer(transport);
  final location = CompositeLocationService(
    gps: BrowserLocationService(),
    demonstration: SampleBackedLocationService(),
  );
  final heartRate = WebBluetoothHeartRateSource();
  final sensors = MultiplexSensorSource(
    replay: SimulatedSensorSource(),
    live: [WebMotionSensorSource(), heartRate],
  );
  final trainedFall = await FallWindowModel.tryLoadFromAssets();
  GeographicCatalog? catalog;
  RegionCatalogSet? regions;
  SaferLocationEngine? guidance;
  try {
    regions = await loadDemonstrationRegions();
    guidance = SaferLocationEngine(regions: regions);
    catalog = regions.byId('kathmandu') ??
        (regions.catalogs.isEmpty ? null : regions.catalogs.first);
  } catch (_) {}

  final runtime = AarogyaRuntime(
    machine: machine,
    health: health,
    emergency: emergency,
    inference: LocalInferenceEngine(
      contextModel: contextModel,
      fallEngine: CompositeFallDetector(
        sequence: const FallDetectionEngine(),
        trained: trainedFall,
      ),
    ),
    sensors: sensors,
    storeAndForward: StoreAndForwardService(
      repository: emergency,
      transport: transport,
      connectivity: connectivity,
    ),
    packetFactory: EmergencyPacketFactory(
      ids: const UuidGenerator(),
      clock: clock,
      originDeviceId: identity.deviceId,
      ownerUserId: accounts.current?.userId ?? '',
      originDisplayName:
          accounts.current?.displayName ?? accounts.current?.email ?? '',
    ),
    connectivity: connectivity,
    location: location,
    clock: clock,
    peers: peers,
    localTransfer: localTransfer,
    heartRateSource: heartRate,
    guidanceEngine: guidance,
    catalog: catalog,
    regions: regions,
    records: store,
  );
  final coordinator = SessionCoordinator(
    store: store,
    devices: devices,
    health: health,
    emergency: emergency,
    runtime: runtime,
    sync: sync,
  );
  if (accounts.current != null) {
    await coordinator.bind(accounts.current);
  }

  return AarogyaDependencies(
    runtime: runtime,
    preferences: _PreferenceBridge(memoryPreferences, preferences),
    accounts: accounts,
    devices: devices,
    coordinator: coordinator,
    peers: peers,
    localTransfer: localTransfer,
    disposeExtras: () async {
      await coordinator.dispose();
      await peers.dispose();
      await sensors.dispose();
    },
  );
}

final class _PreferenceBridge implements PreferenceRepository {
  _PreferenceBridge(this._memory, this._prefs);

  final InMemoryPreferenceRepository _memory;
  final SharedPreferences _prefs;

  @override
  Future<void> setLocaleCode(String languageCode) async {
    await _memory.setLocaleCode(languageCode);
    await _prefs.setString('aarogya.locale', languageCode);
  }

  @override
  Future<String?> localeCode() async {
    return await _memory.localeCode() ?? _prefs.getString('aarogya.locale');
  }
}
