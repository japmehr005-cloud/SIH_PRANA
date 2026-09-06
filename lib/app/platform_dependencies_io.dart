import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/domain/communication/peer_device.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/features/identity/data/memory_device_identity_store.dart';
import 'package:aarogya/app/session/aarogya_runtime.dart';
import 'package:aarogya/core/clock.dart';
import 'package:aarogya/core/id_generator.dart';
import 'package:aarogya/domain/emergency/emergency_state_machine.dart';
import 'package:aarogya/features/communication/data/in_memory_connectivity_service.dart';
import 'package:aarogya/features/communication/data/simulated_transport.dart';
import 'package:aarogya/features/edge_ai/domain/local_inference_engine.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:aarogya/features/emergency/data/drift_emergency_repository.dart';
import 'package:aarogya/features/emergency/domain/emergency_packet_factory.dart';
import 'package:aarogya/features/emergency/domain/store_and_forward_service.dart';
import 'package:aarogya/features/health/data/local/aarogya_database.dart';
import 'package:aarogya/features/health/data/local/drift_health_repository.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:aarogya/features/sensors/data/simulated_sensor_source.dart';

Future<AarogyaDependencies> createPlatformDependencies({
  PhysioContextModel? contextModel,
}) async {
  return createDiskDependencies(contextModel: contextModel);
}

AarogyaDependencies createDiskDependencies({PhysioContextModel? contextModel}) {
  const clock = SystemClock();
  final database = AarogyaDatabase.disk();
  final health = DriftHealthRepository(database);
  final emergency = DriftEmergencyRepository(database);
  final preferences = DriftPreferenceRepository(database);
  final connectivity = InMemoryConnectivityService();
  final transport = SimulatedTransport();
  final sensors = SimulatedSensorSource();
  final runtime = AarogyaRuntime(
    machine: EmergencyStateMachine(clock: clock),
    health: health,
    emergency: emergency,
    inference: LocalInferenceEngine(contextModel: contextModel),
    sensors: sensors,
    storeAndForward: StoreAndForwardService(
      repository: emergency,
      transport: transport,
      connectivity: connectivity,
    ),
    packetFactory: EmergencyPacketFactory(
      ids: const UuidGenerator(),
      clock: clock,
    ),
    connectivity: connectivity,
    location: SampleBackedLocationService(),
    clock: clock,
  );
  return AarogyaDependencies(
    runtime: runtime,
    preferences: preferences,
    accounts: const DisabledAccountService(),
    devices: MemoryDeviceIdentityStore(deviceId: 'local-device'),
    peers: const UnsupportedPeerDiscovery(),
    localTransfer: const UnsupportedLocalTransfer(),
    disposeExtras: database.close,
  );
}
