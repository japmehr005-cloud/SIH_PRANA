import 'dart:convert';
import 'dart:math' as math;

import 'package:aarogya/domain/contracts/fall_detector.dart';
import 'package:aarogya/domain/health/fall_status.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:aarogya/features/edge_ai/domain/fall_detection_engine.dart';
import 'package:flutter/services.dart';

/// Window-feature logistic fall detector. Requires a trained JSON asset.
final class FallWindowModel implements FallDetector {
  FallWindowModel({
    required this.featureNames,
    required this.coef,
    required this.intercept,
    required this.imputerMedian,
    required this.scalerMean,
    required this.scalerScale,
    required this.version,
    this.threshold = 0.5,
    this.minSamples = 8,
  });

  final List<String> featureNames;
  final List<double> coef;
  final double intercept;
  final List<double> imputerMedian;
  final List<double> scalerMean;
  final List<double> scalerScale;
  @override
  final String version;
  final double threshold;
  final int minSamples;

  @override
  String get mode => 'trained-window';

  static Future<FallWindowModel?> tryLoadFromAssets() async {
    try {
      final modelRaw = await rootBundle.loadString(
        'assets/models/fall_window.json',
      );
      final metaRaw = await rootBundle.loadString(
        'assets/models/fall_window.meta.json',
      );
      return fromJson(
        jsonDecode(modelRaw) as Map<String, dynamic>,
        metadata: jsonDecode(metaRaw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  static FallWindowModel fromJson(
    Map<String, dynamic> model, {
    Map<String, dynamic>? metadata,
  }) {
    return FallWindowModel(
      featureNames: List<String>.from(model['feature_names'] as List),
      coef: _flattenCoef(model['coef']),
      intercept: _scalar(model['intercept']),
      imputerMedian: List<double>.from(
        (model['imputer_median'] as List).map(
          (value) => (value as num).toDouble(),
        ),
      ),
      scalerMean: List<double>.from(
        (model['scaler_mean'] as List).map((value) => (value as num).toDouble()),
      ),
      scalerScale: List<double>.from(
        (model['scaler_scale'] as List).map((value) => (value as num).toDouble()),
      ),
      version: metadata?['version'] as String? ?? 'fall-window-v1',
      threshold: (metadata?['threshold'] as num?)?.toDouble() ?? 0.5,
    );
  }

  bool looksLikeImuWindow(List<SensorSample> window) {
    if (window.length < minSamples) {
      return false;
    }
    final span = window.last.timestamp.difference(window.first.timestamp);
    if (span.inMilliseconds <= 0) {
      return false;
    }
    final hz = window.length / (span.inMilliseconds / 1000);
    return hz >= 8;
  }

  @override
  FallStatus detect(List<SensorSample> window) {
    if (!looksLikeImuWindow(window)) {
      return FallStatus.none;
    }
    final features = extract(window);
    var logit = intercept;
    for (var i = 0; i < coef.length; i += 1) {
      var value = features[i] ?? imputerMedian[i];
      value = (value - scalerMean[i]) / (scalerScale[i] == 0 ? 1 : scalerScale[i]);
      logit += coef[i] * value;
    }
    final probability = 1 / (1 + math.exp(-logit));
    return probability >= threshold ? FallStatus.possible : FallStatus.none;
  }

  List<double?> extract(List<SensorSample> window) {
    final mag = [
      for (final sample in window)
        if (sample.accelMagnitude != null) sample.accelMagnitude!,
    ];
    final gyro = [
      for (final sample in window)
        if (sample.gyroMagnitude != null) sample.gyroMagnitude!,
    ];
    if (mag.isEmpty) {
      return List<double?>.filled(featureNames.length, null);
    }
    final mean = mag.reduce((a, b) => a + b) / mag.length;
    final max = mag.reduce(math.max);
    final min = mag.reduce(math.min);
    var variance = 0.0;
    for (final value in mag) {
      variance += (value - mean) * (value - mean);
    }
    final std = math.sqrt(variance / mag.length);
    final peakIndex = mag.indexOf(max);
    final tail = mag.sublist((peakIndex + 1).clamp(0, mag.length));
    final postPeak = tail.isEmpty
        ? null
        : tail.reduce((a, b) => a + b) / tail.length;
    final gyroMean = gyro.isEmpty
        ? null
        : gyro.reduce((a, b) => a + b) / gyro.length;
    final byName = <String, double?>{
      'smv_max': max,
      'smv_mean': mean,
      'smv_std': std,
      'smv_min': min,
      'post_peak_mean': postPeak,
      'gyro_mean': gyroMean,
    };
    return [for (final name in featureNames) byName[name]];
  }

  static List<double> _flattenCoef(Object? raw) {
    if (raw is List && raw.isNotEmpty && raw.first is List) {
      return [
        for (final value in raw.first as List) (value as num).toDouble(),
      ];
    }
    return [for (final value in raw as List) (value as num).toDouble()];
  }

  static double _scalar(Object? raw) {
    if (raw is List) {
      return (raw.first as num).toDouble();
    }
    return (raw as num).toDouble();
  }
}

final class CompositeFallDetector implements FallDetector {
  CompositeFallDetector({required this.sequence, this.trained});

  final FallDetector sequence;
  final FallWindowModel? trained;
  String _lastMode = FallDetectionEngine.detectorMode;

  @override
  String get version =>
      _lastMode == trained?.mode ? trained!.version : sequence.version;

  @override
  String get mode => _lastMode;

  @override
  FallStatus detect(List<SensorSample> window) {
    if (trained != null && trained!.looksLikeImuWindow(window)) {
      _lastMode = trained!.mode;
      return trained!.detect(window);
    }
    _lastMode = sequence.mode;
    return sequence.detect(window);
  }
}
