import 'dart:async';

import 'package:aarogya/domain/contracts/sensor_source.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/domain/sensors/sensor_source_kind.dart';

/// Parses processed research-window CSVs. Not the synthetic demo CSVs.
final class DatasetWindowReplay {
  const DatasetWindowReplay();

  List<SensorSample> parse(String csv) {
    final lines = csv
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    if (lines.length < 2) {
      return const [];
    }
    final header = lines.first.split(',').map((part) => part.trim()).toList();
    return lines.skip(1).map((row) {
      final values = row.split(',').map((part) => part.trim()).toList();
      while (values.length < header.length) {
        values.add('');
      }
      final mapped = <String, String>{};
      for (var i = 0; i < header.length; i += 1) {
        mapped[header[i]] = values[i];
      }
      return SensorSample(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(mapped['timestamp_ms'] ?? '') ?? 0,
          isUtc: true,
        ),
        heartRateBpm: _optionalDouble(mapped['hr_bpm']),
        spo2Percent: _optionalDouble(mapped['spo2']),
        temperatureC: _optionalDouble(mapped['temp_c']),
        accelMagnitude: _optionalDouble(mapped['accel_mag']),
        edaMicrosiemens: _optionalDouble(mapped['eda']),
        isSimulation: false,
        sourceId: mapped['source_id']?.isNotEmpty == true
            ? mapped['source_id']!
            : 'dataset:unknown',
        sourceKind: SensorSourceKind.dataset,
      );
    }).toList();
  }

  double? _optionalDouble(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return double.tryParse(raw);
  }
}

final class DatasetReplaySensorSource implements SensorSource {
  DatasetReplaySensorSource({
    required this.samples,
    this.sourceId = 'dataset-replay',
  });

  final List<SensorSample> samples;
  final String sourceId;

  final StreamController<SensorSample> _controller =
      StreamController<SensorSample>.broadcast();

  @override
  String get id => sourceId;

  @override
  bool get isSimulation => false;

  @override
  SensorSourceKind get kind => SensorSourceKind.dataset;

  @override
  Stream<SensorSample> watch() => _controller.stream;

  @override
  Future<void> start() async {
    for (final sample in samples) {
      _controller.add(sample);
    }
  }

  @override
  Future<void> stop() async {}
}
