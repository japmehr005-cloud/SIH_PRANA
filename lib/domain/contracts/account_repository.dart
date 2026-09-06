import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/domain/identity/user_account.dart';

abstract interface class AccountRepository {
  Future<UserAccount> register({
    required String displayName,
    required String loginId,
    required String password,
    bool isDemonstration = false,
  });

  Future<UserAccount> authenticate({
    required String loginId,
    required String password,
  });

  Future<UserAccount?> findByLoginId(String loginId);

  Future<UserAccount?> loadAccount(String userId);

  Future<void> saveSession(String userId);

  Future<AccountSession?> currentSession();

  Future<void> clearSession();
}

enum AccountAuthCode { invalidCredentials, duplicateAccount, invalidIdentifier }

final class AccountAuthException implements Exception {
  const AccountAuthException(this.code);

  final AccountAuthCode code;
}
