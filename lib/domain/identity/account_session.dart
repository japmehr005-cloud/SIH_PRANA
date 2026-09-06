final class AccountSession {
  const AccountSession({
    required this.userId,
    required this.email,
    this.displayName,
    this.isDemonstration = false,
  });

  final String userId;
  final String email;
  final String? displayName;
  final bool isDemonstration;
}

abstract interface class AccountService {
  bool get isConfigured;
  AccountSession? get current;
  Stream<AccountSession?> watch();
  Future<AccountSession?> restore();
  Future<AccountSession> signIn({
    required String email,
    required String password,
  });
  Future<AccountSession> register({
    required String displayName,
    required String email,
    required String password,
    String locale = 'en',
  });
  Future<AccountSession> continueAsDemonstrationUser();
  Future<void> signOut();
}

final class DisabledAccountService implements AccountService {
  const DisabledAccountService();

  @override
  bool get isConfigured => false;

  @override
  AccountSession? get current => null;

  @override
  Stream<AccountSession?> watch() => Stream<AccountSession?>.value(null);

  @override
  Future<AccountSession?> restore() async => null;

  @override
  Future<AccountSession> signIn({
    required String email,
    required String password,
  }) {
    throw UnsupportedError('Account services are not configured.');
  }

  @override
  Future<AccountSession> register({
    required String displayName,
    required String email,
    required String password,
    String locale = 'en',
  }) {
    throw UnsupportedError('Account services are not configured.');
  }

  @override
  Future<AccountSession> continueAsDemonstrationUser() {
    throw UnsupportedError('Account services are not configured.');
  }

  @override
  Future<void> signOut() async {}
}
