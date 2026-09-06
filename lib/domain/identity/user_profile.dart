final class UserProfile {
  const UserProfile({
    required this.userId,
    required this.displayName,
    this.email,
    this.locale = 'en',
    this.consentSync = true,
    this.consentEmergencyShare = true,
  });

  final String userId;
  final String displayName;
  final String? email;
  final String locale;
  final bool consentSync;
  final bool consentEmergencyShare;
}
