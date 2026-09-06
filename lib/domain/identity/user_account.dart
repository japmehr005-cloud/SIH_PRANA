final class UserAccount {
  const UserAccount({
    required this.userId,
    required this.loginId,
    required this.displayName,
    required this.passwordSalt,
    required this.passwordHash,
    required this.createdAt,
    this.isDemonstration = false,
  });

  final String userId;
  final String loginId;
  final String displayName;
  final String passwordSalt;
  final String passwordHash;
  final DateTime createdAt;
  final bool isDemonstration;
}
