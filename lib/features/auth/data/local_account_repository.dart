import 'dart:convert';

import 'package:aarogya/domain/contracts/account_repository.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/domain/identity/user_account.dart';
import 'package:aarogya/features/auth/data/login_identifier.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final class LocalAccountRepository implements AccountRepository {
  LocalAccountRepository(this._preferences);

  static const registryKey = 'aarogya.accounts.registry';
  static const sessionKey = 'aarogya.session.userId';
  static const demonstrationLoginId = 'demo@aarogya.local';

  final SharedPreferences _preferences;
  final _uuid = const Uuid();

  @override
  Future<UserAccount> register({
    required String displayName,
    required String loginId,
    required String password,
    bool isDemonstration = false,
  }) async {
    final normalized = normalizeLoginId(loginId);
    if (!isValidLoginId(normalized)) {
      throw const AccountAuthException(AccountAuthCode.invalidIdentifier);
    }
    if (await findByLoginId(normalized) != null) {
      throw const AccountAuthException(AccountAuthCode.duplicateAccount);
    }
    final salt = _uuid.v4();
    final account = UserAccount(
      userId: _uuid.v4(),
      loginId: normalized,
      displayName: displayName.trim(),
      passwordSalt: salt,
      passwordHash: hashPassword(password, salt),
      createdAt: DateTime.now().toUtc(),
      isDemonstration: isDemonstration,
    );
    final accounts = [...await _all(), account];
    await _saveAll(accounts);
    await saveSession(account.userId);
    return account;
  }

  @override
  Future<UserAccount> authenticate({
    required String loginId,
    required String password,
  }) async {
    final account = await findByLoginId(loginId);
    if (account == null) {
      throw const AccountAuthException(AccountAuthCode.invalidCredentials);
    }
    final hashed = hashPassword(password, account.passwordSalt);
    if (hashed != account.passwordHash) {
      throw const AccountAuthException(AccountAuthCode.invalidCredentials);
    }
    await saveSession(account.userId);
    return account;
  }

  @override
  Future<UserAccount?> findByLoginId(String loginId) async {
    final normalized = normalizeLoginId(loginId);
    final accounts = await _all();
    for (final account in accounts) {
      if (account.loginId == normalized) {
        return account;
      }
    }
    return null;
  }

  @override
  Future<UserAccount?> loadAccount(String userId) async {
    for (final account in await _all()) {
      if (account.userId == userId) {
        return account;
      }
    }
    return null;
  }

  @override
  Future<void> saveSession(String userId) {
    return _preferences.setString(sessionKey, userId);
  }

  @override
  Future<AccountSession?> currentSession() async {
    final userId = _preferences.getString(sessionKey);
    if (userId == null || userId.isEmpty) {
      return null;
    }
    final account = await loadAccount(userId);
    if (account == null) {
      return null;
    }
    return _session(account);
  }

  @override
  Future<void> clearSession() {
    return _preferences.remove(sessionKey);
  }

  Future<AccountSession> continueAsDemonstrationUser() async {
    var account = await findByLoginId(demonstrationLoginId);
    account ??= await register(
      displayName: 'Demonstration user',
      loginId: demonstrationLoginId,
      password: _uuid.v4(),
      isDemonstration: true,
    );
    await saveSession(account.userId);
    return _session(account);
  }

  AccountSession _session(UserAccount account) {
    return AccountSession(
      userId: account.userId,
      email: account.loginId,
      displayName: account.displayName,
      isDemonstration: account.isDemonstration,
    );
  }

  Future<List<UserAccount>> _all() async {
    final raw = _preferences.getString(registryKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list) _decode(Map<String, dynamic>.from(item as Map)),
    ];
  }

  Future<void> _saveAll(List<UserAccount> accounts) {
    return _preferences.setString(
      registryKey,
      jsonEncode([for (final account in accounts) _encode(account)]),
    );
  }

  Map<String, Object?> _encode(UserAccount account) {
    return {
      'userId': account.userId,
      'loginId': account.loginId,
      'displayName': account.displayName,
      'passwordSalt': account.passwordSalt,
      'passwordHash': account.passwordHash,
      'createdAt': account.createdAt.toIso8601String(),
      'isDemonstration': account.isDemonstration,
    };
  }

  UserAccount _decode(Map<String, dynamic> raw) {
    return UserAccount(
      userId: raw['userId']! as String,
      loginId: raw['loginId']! as String,
      displayName: raw['displayName']! as String,
      passwordSalt: raw['passwordSalt']! as String,
      passwordHash: raw['passwordHash']! as String,
      createdAt: DateTime.parse(raw['createdAt']! as String),
      isDemonstration: raw['isDemonstration'] as bool? ?? false,
    );
  }
}

String hashPassword(String password, String salt) {
  return sha256.convert(utf8.encode('$salt|$password')).toString();
}
