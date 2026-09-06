enum RiskLevel { low, moderate, high, critical }

extension RiskLevelX on RiskLevel {
  int get rank => index;
}
