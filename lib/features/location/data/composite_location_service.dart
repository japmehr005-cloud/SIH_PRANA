import 'package:aarogya/domain/contracts/location_service.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

final class CompositeLocationService implements LocationService {
  CompositeLocationService({required this.gps, required this.demonstration});

  final LocationService gps;
  final LocationService demonstration;

  @override
  void observeSample(SensorSample sample) {
    gps.observeSample(sample);
    demonstration.observeSample(sample);
  }

  @override
  Future<LocationPermissionState> permissionState() => gps.permissionState();

  @override
  Future<LocationPermissionState> requestPermission() => gps.requestPermission();

  @override
  Future<DeviceLocation?> currentLocation() async {
    final fix = await gpsFix();
    if (fix != null) {
      return fix;
    }
    return demonstration.currentLocation();
  }

  Future<DeviceLocation?> gpsFix() async {
    final permission = await gps.permissionState();
    if (permission != LocationPermissionState.granted) {
      return null;
    }
    final fix = await gps.currentLocation();
    if (fix != null && fix.source == LocationSource.gps) {
      return fix;
    }
    return null;
  }
}
