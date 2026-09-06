import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:geolocator/geolocator.dart';

final class BrowserLocationService implements LocationService {
  DeviceLocation? _lastGps;

  @override
  void observeSample(SensorSample sample) {}

  @override
  Future<LocationPermissionState> permissionState() async {
    final service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      return LocationPermissionState.unavailable;
    }
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationPermissionState> requestPermission() async {
    final service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      return LocationPermissionState.unavailable;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _map(permission);
  }

  @override
  Future<DeviceLocation?> currentLocation() async {
    final permission = await permissionState();
    if (permission != LocationPermissionState.granted) {
      return _lastGps;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
      _lastGps = DeviceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        capturedAt: position.timestamp,
        isLastKnown: false,
        source: LocationSource.gps,
        accuracyMeters: position.accuracy,
      );
      return _lastGps;
    } catch (_) {
      return _lastGps;
    }
  }

  LocationPermissionState _map(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse => LocationPermissionState.granted,
      LocationPermission.denied => LocationPermissionState.prompt,
      LocationPermission.deniedForever => LocationPermissionState.denied,
      _ => LocationPermissionState.denied,
    };
  }
}
