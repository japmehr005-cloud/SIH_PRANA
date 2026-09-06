import 'package:aarogya/domain/health/sensor_sample.dart';

enum LocationSource { gps, demonstration, lastKnown, unavailable }

enum LocationPermissionState { granted, denied, unavailable, prompt }

final class DeviceLocation {
  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.capturedAt,
    this.isLastKnown = false,
    this.source = LocationSource.lastKnown,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final DateTime capturedAt;
  final bool isLastKnown;
  final LocationSource source;
  final double? accuracyMeters;

  bool get isDemonstration =>
      source == LocationSource.demonstration || source == LocationSource.lastKnown;
}

abstract interface class LocationService {
  Future<DeviceLocation?> currentLocation();

  Future<LocationPermissionState> permissionState();

  Future<LocationPermissionState> requestPermission();

  void observeSample(SensorSample sample);
}
