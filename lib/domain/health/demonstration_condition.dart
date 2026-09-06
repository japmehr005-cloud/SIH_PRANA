enum DemonstrationCondition {
  resting,
  physicalActivity,
  highLoad,
  fallImpact;

  String get id => name;

  String get assetPath => switch (this) {
    DemonstrationCondition.resting => 'assets/demo/normal.csv',
    DemonstrationCondition.physicalActivity => 'assets/demo/flood_exertion.csv',
    DemonstrationCondition.highLoad => 'assets/demo/health_deterioration.csv',
    DemonstrationCondition.fallImpact => 'assets/demo/fall.csv',
  };

  static DemonstrationCondition? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    for (final value in values) {
      if (value.id == raw) {
        return value;
      }
    }
    return null;
  }
}
