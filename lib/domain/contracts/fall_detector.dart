import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';

/// Sequence or model fall detector. SisFall-trained models can implement this.
abstract interface class FallDetector {
  String get version;

  /// `simulated-sequence` until a SisFall-trained detector is attached.
  String get mode;

  FallStatus detect(List<SensorSample> window);
}
