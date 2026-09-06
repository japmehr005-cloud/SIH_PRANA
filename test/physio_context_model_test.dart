import 'dart:convert';
import 'dart:io';

import 'package:aarogya/domain/contracts/inference_engine.dart';
import 'package:aarogya/domain/emergency/emergency_phase.dart';
import 'package:aarogya/domain/health/movement_state.dart';
import 'package:aarogya/features/edge_ai/domain/local_inference_engine.dart';
import 'package:aarogya/features/edge_ai/domain/physio_context_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/sample_factory.dart';

PhysioContextModel loadBundledModel() {
  final model = jsonDecode(
    File('assets/models/physio_context.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final meta = jsonDecode(
    File('assets/models/physio_context.meta.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  return PhysioContextModel.fromJson(model, metadata: meta);
}

void main() {
  test('missing SpO2 stays unavailable and is not treated as zero', () {
    final model = loadBundledModel();
    final start = DateTime.utc(2026, 9, 6);
    final window = List.generate(12, (index) {
      return sample(
        at: start.add(Duration(seconds: index)),
        hr: 70,
        spo2: null,
        temp: 32.1,
        accel: 1.1,
        movement: MovementState.low,
      );
    });
    final features = model.extractFeatures(
      window,
      previous: const [],
      baseline: null,
    );
    expect(features[4], isNull);
    expect(features[5], isNull);
    expect(features[6], isNull);
  });

  test('trained model returns a context probability for a sensor window', () {
    final model = loadBundledModel();
    final start = DateTime.utc(2026, 9, 6);
    final recent = restingSeries(start: start, count: 16);
    final prediction = model.predict(
      InferenceInput(
        current: recent.last,
        recent: recent.sublist(0, recent.length - 1),
        phase: EmergencyPhase.normal,
      ),
    );
    expect(prediction, isNotNull);
    expect(prediction!.confidence, inInclusiveRange(0, 1));
    expect(prediction.nonRestProbability, inInclusiveRange(0, 1));
    expect(prediction.context, isNotEmpty);
  });

  test(
    'inference engine still returns risk and fall status with the model',
    () {
      final engine = LocalInferenceEngine(contextModel: loadBundledModel());
      final start = DateTime.utc(2026, 9, 6);
      final recent = restingSeries(start: start, count: 16);
      final result = engine.infer(
        InferenceInput(
          current: recent.last,
          recent: recent.sublist(0, recent.length - 1),
          phase: EmergencyPhase.normal,
        ),
      );
      expect(result.engineVersion, 'physio-context-v1');
      expect(result.risk.usedTrainedModel, isTrue);
      expect(result.risk.comparison, isNotNull);
      expect(result.risk.comparison!.recentHeartRates, isNotEmpty);
      expect(result.fallStatus.name, isNotEmpty);
    },
  );
}
