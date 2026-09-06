import 'package:aarogya/domain/emergency/disaster_type.dart';

enum DisasterGuidanceCode {
  moveSafer,
  avoidWater,
  avoidElectrical,
  followOfficial,
  doNotAssumeAltitude,
  avoidBridges,
  conserveBattery,
  keepCommunication,
}

abstract final class DisasterGuidanceCatalog {
  static List<DisasterGuidanceCode> forType(DisasterType? type) {
    return switch (type) {
      DisasterType.flood => const [
        DisasterGuidanceCode.moveSafer,
        DisasterGuidanceCode.avoidWater,
        DisasterGuidanceCode.avoidElectrical,
        DisasterGuidanceCode.avoidBridges,
        DisasterGuidanceCode.followOfficial,
        DisasterGuidanceCode.conserveBattery,
        DisasterGuidanceCode.keepCommunication,
        DisasterGuidanceCode.doNotAssumeAltitude,
      ],
      _ => const [DisasterGuidanceCode.followOfficial],
    };
  }
}
