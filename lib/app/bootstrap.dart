import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/app/session/session_coordinator.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/contracts/communication_transport.dart';
import 'package:aarogya/domain/contracts/emergency_repository.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/emergency/emergency_state_machine.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/domain/identity/device_identity.dart';
import 'package:aarogya/features/communication/data/in_memory_connectivity_service.dart';
import 'package:aarogya/features/communication/data/simulated_transport.dart';
import 'package:aarogya/features/edge_ai/domain/local_inference_engine.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:aarogya/features/emergency/data/in_memory_emergency_repository.dart';
import 'package:aarogya/features/emergency/domain/emergency_packet_factory.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:aarogya/features/health/data/in_memory_health_repository.dart';
import 'package:aarogya/features/identity/data/memory_device_identity_store.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:aarogya/features/sensors/data/simulated_sensor_source.dart';

final class AarogyaDependencies {
  AarogyaDependencies({
    required this.runtime,
    required this.preferences,
    required this.accounts,
    required this.devices,
    this.coordinator,
    this.peers = const UnsupportedPeerDiscovery(),
    this.localTransfer = const UnsupportedLocalTransfer(),
    this.disposeExtras,
  });

  final AarogyaRuntime runtime;
  final PreferenceRepository preferences;
  final AccountService accounts;
  final DeviceIdentityStore devices;
  final SessionCoordinator? coordinator;
  final PeerDiscovery peers;
  final LocalTransfer localTransfer;
  final Future<void> Function()? disposeExtras;

  Future<void> dispose() async {
    await runtime.dispose();
    await disposeExtras?.call();
  }
}

AarogyaDependencies createInMemoryDependencies({
  Clock? clock,
  IdGenerator? ids,
  PhysioContextModel? contextModel,
  AccountService? accounts,
  DeviceIdentityStore? devices,
  CommunicationTransport? transport,
  PeerDiscovery? peers,
  LocalTransfer? localTransfer,
  LocationService? location,
}) {
  final resolvedClock = clock ?? const SystemClock();
  final machine = EmergencyStateMachine(clock: resolvedClock);
  final health = InMemoryHealthRepository();
  final emergency = InMemoryEmergencyRepository();
  final preferences = InMemoryPreferenceRepository();
  final connectivity = InMemoryConnectivityService();
  final resolvedTransport = transport ?? SimulatedTransport();
  final sensors = SimulatedSensorSource();
  final identity =
      devices ?? MemoryDeviceIdentityStore(deviceId: 'test-device');
  final runtime = AarogyaRuntime(
    machine: machine,
    health: health,
    emergency: emergency,
    inference: LocalInferenceEngine(contextModel: contextModel),
    sensors: sensors,
    storeAndForward: StoreAndForwardService(
      repository: emergency,
      transport: resolvedTransport,
      connectivity: connectivity,
    ),
    packetFactory: EmergencyPacketFactory(
      ids: ids ?? const UuidGenerator(),
      clock: resolvedClock,
      originDeviceId: 'test-device',
    ),
    connectivity: connectivity,
    location: location ?? SampleBackedLocationService(),
    clock: resolvedClock,
    peers: peers ?? const UnsupportedPeerDiscovery(),
    localTransfer: localTransfer ?? const UnsupportedLocalTransfer(),
  );
  return AarogyaDependencies(
    runtime: runtime,
    preferences: preferences,
    accounts: accounts ?? const DisabledAccountService(),
    devices: identity,
    peers: peers ?? const UnsupportedPeerDiscovery(),
    localTransfer: localTransfer ?? const UnsupportedLocalTransfer(),
  );
}
