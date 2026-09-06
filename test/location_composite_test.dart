import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/features/location/data/composite_location_service.dart';
import 'package:aarogya/features/location/data/sample_backed_location_service.dart';
import 'package:flutter_test/flutter_test.dart';

final class _DeniedGps implements LocationService {
  @override
  Future<DeviceLocation?> currentLocation() async => null;

  @override
  void observeSample(SensorSample sample) {}

  @override
  Future<LocationPermissionState> permissionState() async =>
      LocationPermissionState.denied;

  @override
  Future<LocationPermissionState> requestPermission() async =>
      LocationPermissionState.denied;
}

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
  test('GPS denial keeps the labeled demonstration location', () async {
    final demo = SampleBackedLocationService();
    final composite = CompositeLocationService(
      gps: _DeniedGps(),
      demonstration: demo,
    );
    final fix = await composite.currentLocation();
    expect(fix, isNotNull);
    expect(fix!.source, LocationSource.demonstration);
    expect(fix.latitude, 27.717);
    expect(fix.longitude, 85.324);
    expect(fix.isDemonstration, isTrue);
  });

  test('granted GPS wins over demonstration coordinates', () async {
    final now = DateTime.utc(2026, 9, 6);
    final composite = CompositeLocationService(
      gps: _GrantedGps(
        DeviceLocation(
          latitude: 28.6,
          longitude: 77.2,
          capturedAt: now,
          source: LocationSource.gps,
        ),
      ),
      demonstration: SampleBackedLocationService(),
    );
    final fix = await composite.currentLocation();
    expect(fix!.source, LocationSource.gps);
    expect(fix.latitude, 28.6);
  });
}
