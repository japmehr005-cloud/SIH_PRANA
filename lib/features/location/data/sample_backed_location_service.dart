import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

final class SampleBackedLocationService implements LocationService {
  SampleBackedLocationService({
    this.fallbackLatitude = 27.717,
    this.fallbackLongitude = 85.324,
  });

  final double fallbackLatitude;
  final double fallbackLongitude;
  DeviceLocation? _lastKnown;
  bool ignoreSamples = false;

  void setFix(DeviceLocation fix) {
    _lastKnown = fix;
  }

  @override
  void observeSample(SensorSample sample) {
    if (ignoreSamples || !sample.hasLocation) {
      return;
    }
    _lastKnown = DeviceLocation(
      latitude: sample.latitude!,
      longitude: sample.longitude!,
      capturedAt: sample.timestamp,
      isLastKnown: true,
      source: LocationSource.demonstration,
    );
  }

  @override
  Future<DeviceLocation?> currentLocation() async {
    return _lastKnown ??
        DeviceLocation(
          latitude: fallbackLatitude,
          longitude: fallbackLongitude,
          capturedAt: DateTime.now().toUtc(),
          isLastKnown: true,
          source: LocationSource.demonstration,
        );
  }

  @override
  Future<LocationPermissionState> permissionState() async =>
      LocationPermissionState.unavailable;

  @override
  Future<LocationPermissionState> requestPermission() async =>
      LocationPermissionState.unavailable;
}
