import 'dart:convert';
import 'dart:math' as math;

import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/health/personal_baseline.dart';
import 'package:aarogya/domain/health/sensor_sample.dart';
import 'package:flutter/services.dart';

final class PhysioContextPrediction {
  const PhysioContextPrediction({
    required this.rawLabel,
    required this.context,
    required this.confidence,
    required this.nonRestProbability,
  });

  final String rawLabel;
  final String context;
  final double confidence;
  final double nonRestProbability;
}

final class PhysioContextModel {
  PhysioContextModel({
    required this.featureNames,
    required this.classes,
    required this.contextMap,
    required this.imputerMedian,
    required this.scalerMean,
    required this.scalerScale,
    required this.coef,
    required this.intercept,
    required this.version,
    this.windowSeconds = 30,
    this.minSamples = 8,
  });

  final List<String> featureNames;
  final List<String> classes;
  final Map<String, String> contextMap;
  final List<double> imputerMedian;
  final List<double> scalerMean;
  final List<double> scalerScale;
  final List<List<double>> coef;
  final List<double> intercept;
  final String version;
  final int windowSeconds;
  final int minSamples;

  static Future<PhysioContextModel> loadFromAssets() async {
    final modelRaw = await rootBundle.loadString(
      'assets/models/physio_context.json',
    );
    final metaRaw = await rootBundle.loadString(
      'assets/models/physio_context.meta.json',
    );
    return fromJson(
      jsonDecode(modelRaw) as Map<String, dynamic>,
      metadata: jsonDecode(metaRaw) as Map<String, dynamic>,
    );
  }

  static PhysioContextModel fromJson(
    Map<String, dynamic> model, {
    Map<String, dynamic>? metadata,
  }) {
    final contextMap = <String, String>{};
    final rawMap = metadata?['context_map'];
    if (rawMap is Map) {
      rawMap.forEach((key, value) {
        contextMap[key.toString()] = value.toString();
      });
    }
    return PhysioContextModel(
      featureNames: List<String>.from(model['feature_names'] as List),
      classes: List<String>.from(model['classes'] as List),
      contextMap: contextMap,
      imputerMedian: List<double>.from(
        (model['imputer_median'] as List).map(
          (value) => (value as num).toDouble(),
        ),
      ),
      scalerMean: List<double>.from(
        (model['scaler_mean'] as List).map(
          (value) => (value as num).toDouble(),
        ),
      ),
      scalerScale: List<double>.from(
        (model['scaler_scale'] as List).map(
          (value) => (value as num).toDouble(),
        ),
      ),
      coef: [
        for (final row in model['coef'] as List)
          List<double>.from(
            (row as List).map((value) => (value as num).toDouble()),
          ),
      ],
      intercept: List<double>.from(
        (model['intercept'] as List).map((value) => (value as num).toDouble()),
      ),
      version: metadata?['version'] as String? ?? 'physio-context-v1',
      windowSeconds: metadata?['window_seconds'] as int? ?? 30,
    );
  }

  PhysioContextPrediction? predict(InferenceInput input) {
    final window = [...input.recent, input.current];
    if (window.length < minSamples) {
      return null;
    }
    final currentWindow = window.length <= windowSeconds
        ? window
        : window.sublist(window.length - windowSeconds);
    final previous = window.length > windowSeconds * 2
        ? window.sublist(
            window.length - windowSeconds * 2,
            window.length - windowSeconds,
          )
        : const <SensorSample>[];
    final features = extractFeatures(
      currentWindow,
      previous: previous,
      baseline: input.baseline,
    );
    if (features.every((value) => value == null)) {
      return null;
    }
    final prepared = _imputeAndScale(features);
    final logits = <double>[];
    for (var classIndex = 0; classIndex < classes.length; classIndex += 1) {
      var logit = intercept[classIndex];
      final weights = coef[classIndex];
      for (var i = 0; i < prepared.length; i += 1) {
        logit += weights[i] * prepared[i];
      }
      logits.add(logit);
    }
    final probabilities = _softmax(logits);
    var bestIndex = 0;
    for (var i = 1; i < probabilities.length; i += 1) {
      if (probabilities[i] > probabilities[bestIndex]) {
        bestIndex = i;
      }
    }
    final raw = classes[bestIndex];
    var nonRest = 0.0;
    for (var i = 0; i < classes.length; i += 1) {
      if (classes[i] != 'Relax') {
        nonRest += probabilities[i];
      }
    }
    return PhysioContextPrediction(
      rawLabel: raw,
      context: contextMap[raw] ?? raw,
      confidence: probabilities[bestIndex],
      nonRestProbability: nonRest,
    );
  }

  List<double?> extractFeatures(
    List<SensorSample> window, {
    required List<SensorSample> previous,
    PersonalBaseline? baseline,
  }) {
    final hr = [for (final sample in window) sample.heartRateBpm];
    final spo2 = [for (final sample in window) sample.spo2Percent];
    final temp = [for (final sample in window) sample.temperatureC];
    final eda = [for (final sample in window) sample.edaMicrosiemens];
    final accel = [for (final sample in window) sample.accelMagnitude];
    final hrMean = _mean(hr);
    final spo2Mean = _mean(spo2);
    final tempMean = _mean(temp);
    final edaMean = _mean(eda);
    final accelMean = _mean(accel);
    final prevHr = _mean([for (final sample in previous) sample.heartRateBpm]);
    final prevAccel = _mean([
      for (final sample in previous) sample.accelMagnitude,
    ]);
    return [
      hrMean,
      _std(hr),
      _delta(hrMean, prevHr),
      _delta(hrMean, baseline?.restingHeartRate?.median),
      spo2Mean,
      _min(spo2),
      _delta(spo2Mean, baseline?.spo2?.median),
      tempMean,
      _slope(temp),
      _delta(tempMean, baseline?.temperature?.median),
      edaMean,
      null,
      accelMean,
      _std(accel),
      _delta(accelMean, prevAccel),
    ];
  }

  List<double> _imputeAndScale(List<double?> features) {
    final prepared = <double>[];
    for (var i = 0; i < featureNames.length; i += 1) {
      final raw = features[i];
      final filled = raw ?? imputerMedian[i];
      final scale = scalerScale[i] == 0 ? 1.0 : scalerScale[i];
      prepared.add((filled - scalerMean[i]) / scale);
    }
    return prepared;
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);
    final exps = [for (final logit in logits) math.exp(logit - maxLogit)];
    final sum = exps.fold(0.0, (total, value) => total + value);
    return [for (final value in exps) value / sum];
  }

  double? _mean(List<double?> values) {
    final finite = [
      for (final value in values)
        if (value != null && value.isFinite) value,
    ];
    if (finite.isEmpty) {
      return null;
    }
    return finite.reduce((a, b) => a + b) / finite.length;
  }

  double? _std(List<double?> values) {
    final finite = [
      for (final value in values)
        if (value != null && value.isFinite) value,
    ];
    if (finite.length < 2) {
      return null;
    }
    final mean = finite.reduce((a, b) => a + b) / finite.length;
    final variance =
        finite
            .map((value) => (value - mean) * (value - mean))
            .reduce((a, b) => a + b) /
        (finite.length - 1);
    return math.sqrt(variance);
  }

  double? _min(List<double?> values) {
    final finite = [
      for (final value in values)
        if (value != null && value.isFinite) value,
    ];
    if (finite.isEmpty) {
      return null;
    }
    return finite.reduce(math.min);
  }

  double? _slope(List<double?> values) {
    final finite = [
      for (final value in values)
        if (value != null && value.isFinite) value,
    ];
    if (finite.length < 2) {
      return null;
    }
    var sumX = 0.0;
    var sumY = 0.0;
    var sumXY = 0.0;
    var sumXX = 0.0;
    for (var i = 0; i < finite.length; i += 1) {
      final x = i.toDouble();
      final y = finite[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumXX += x * x;
    }
    final n = finite.length.toDouble();
    final denom = n * sumXX - sumX * sumX;
    if (denom == 0) {
      return null;
    }
    return (n * sumXY - sumX * sumY) / denom;
  }

  double? _delta(double? current, double? reference) {
    if (current == null || reference == null) {
      return null;
    }
    return current - reference;
  }
}
