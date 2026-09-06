import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

final class CsvSensorReplay {
  const CsvSensorReplay();

  static const String datasetVersion = 'demo-csv-v1';

  List<SensorSample> parse(String csv, {required String sourceId}) {
    final lines = csv
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      return const [];
    }

    final header = lines.first.split(',').map((part) => part.trim()).toList();
    final rows = lines.skip(1);
    return rows.map((row) {
      final values = _parseRow(row, header.length);
      final mapped = <String, String>{};
      for (var i = 0; i < header.length; i++) {
        mapped[header[i]] = values[i];
      }
      return SensorSample(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          int.parse(mapped['timestamp_ms']!),
          isUtc: true,
        ),
        heartRateBpm: _optionalDouble(mapped['hr_bpm']),
        spo2Percent: _optionalDouble(mapped['spo2']),
        temperatureC: _optionalDouble(mapped['temp_c']),
        accelMagnitude: _optionalDouble(mapped['accel_mag']),
        gyroMagnitude: _optionalDouble(mapped['gyro_mag']),
        orientationDelta: _optionalDouble(mapped['orientation_delta']),
        movement: MovementStateX.tryParse(mapped['movement']),
        batteryPercent: _optionalDouble(mapped['battery_pct']),
        latitude: _optionalDouble(mapped['lat']),
        longitude: _optionalDouble(mapped['lon']),
        isSimulation: true,
        sourceId: sourceId,
        sourceKind: SensorSourceKind.simulation,
      );
    }).toList();
  }

  List<String> _parseRow(String row, int expected) {
    final parts = row.split(',').map((part) => part.trim()).toList();
    while (parts.length < expected) {
      parts.add('');
    }
    return parts;
  }

  double? _optionalDouble(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return double.tryParse(raw);
  }
}
