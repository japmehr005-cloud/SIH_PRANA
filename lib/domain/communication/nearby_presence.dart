final class NearbyPresence {
  const NearbyPresence({
    required this.deviceId,
    required this.userId,
    required this.displayName,
    required this.updatedAt,
  });

  final String deviceId;
  final String userId;
  final String displayName;
  final DateTime updatedAt;
}
