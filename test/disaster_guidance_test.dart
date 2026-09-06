import 'package:aarogya/domain/emergency/disaster_type.dart';
import 'package:aarogya/features/disaster/domain/disaster_guidance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'flood guidance is structured and does not treat altitude as sufficient',
    () {
      final codes = DisasterGuidanceCatalog.forType(DisasterType.flood);
      expect(codes, contains(DisasterGuidanceCode.moveSafer));
      expect(codes, contains(DisasterGuidanceCode.avoidWater));
      expect(codes, contains(DisasterGuidanceCode.doNotAssumeAltitude));
      expect(codes, contains(DisasterGuidanceCode.conserveBattery));
    },
  );
}
