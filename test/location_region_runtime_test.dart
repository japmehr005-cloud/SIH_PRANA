import 'dart:io';

import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/location/location_preference.dart';
import 'package:aarogya/domain/location/safer_location_guidance.dart';
import 'package:aarogya/features/location/data/composite_location_service.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:aarogya/features/location/domain/safer_location_engine.dart';
import 'package:flutter_test/flutter_test.dart';

final class _GrantedGps implements LocationService {
  _GrantedGps(this.fix);

  final DeviceLocation fix;

  @override
  Future<DeviceLocation?> currentLocation() async => fix;

  @override
  void observeSample(SensorSample sample) {}

  @override
  Future<LocationPermissionState> permissionState() async =>
      LocationPermissionState.granted;

  @override
  Future<LocationPermissionState> requestPermission() async =>
      LocationPermissionState.granted;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final kathmandu = parseGeographicCatalog(
    File('assets/geo/kathmandu_demo.geojson').readAsStringSync(),
  );
  final now = DateTime.utc(2026, 9, 6, 15);

  test('out-of-region GPS is rejected and Kathmandu guidance stays local', () async {
    final demo = SampleBackedLocationService();
    final deps = createInMemoryDependencies(
      location: CompositeLocationService(
        gps: _GrantedGps(
          DeviceLocation(
            latitude: 28.6,
            longitude: 77.2,
            capturedAt: now,
            source: LocationSource.gps,
          ),
        ),
        demonstration: demo,
      ),
    );
    deps.runtime.regions = RegionCatalogSet([kathmandu]);
    deps.runtime.guidanceEngine = SaferLocationEngine(
      regions: deps.runtime.regions!,
    );
    deps.runtime.catalog = kathmandu;
    await deps.runtime.start();

    expect(deps.runtime.state.deviceLocation?.latitude, closeTo(27.717, 0.02));
    expect(
      deps.runtime.state.guidance?.distanceMeters ?? 0,
      lessThan(20000),
    );

    await deps.runtime.requestLocationAccess();
    expect(deps.runtime.state.deviceLocationRejected, isTrue);
    expect(deps.runtime.state.usingGps, isFalse);
    expect(deps.runtime.state.deviceLocation?.latitude, closeTo(27.717, 0.02));
    expect(deps.runtime.state.guidance?.place.id, isNotEmpty);
    expect(deps.runtime.state.guidance?.catalogId, 'kathmandu');
    expect(deps.runtime.state.guidance?.distanceMeters, lessThan(20000));
    await deps.runtime.dispose();
  });

  test('demonstration region chips change the active coordinates', () async {
    final delhi = parseGeographicCatalog(
      File('assets/geo/delhi_demo.geojson').readAsStringSync(),
    );
    final deps = createInMemoryDependencies();
    deps.runtime.regions = RegionCatalogSet([kathmandu, delhi]);
    deps.runtime.guidanceEngine = SaferLocationEngine(
      regions: deps.runtime.regions!,
    );
    await deps.runtime.start();
    await deps.runtime.selectDemonstrationRegion(DemonstrationRegionIds.delhi);
    expect(deps.runtime.state.selectedRegionId, DemonstrationRegionIds.delhi);
    expect(deps.runtime.state.deviceLocation?.latitude, closeTo(28.6139, 0.02));
    expect(deps.runtime.state.guidance?.catalogId, 'delhi');
    expect(deps.runtime.state.guidance?.place.id, isNot('tudikhel'));
    await deps.runtime.dispose();
  });
}
