import 'package:aarogya/domain/identity/account_session.dart';
import 'package:aarogya/features/auth/data/local_account_repository.dart';
import 'package:flutter/foundation.dart';

final class LocalAccountService extends ChangeNotifier
    implements AccountService {
  LocalAccountService(this._repository);

  final LocalAccountRepository _repository;
  AccountSession? _current;

  @override
  bool get isConfigured => true;

  @override
  AccountSession? get current => _current;

  @override
  Stream<AccountSession?> watch() async* {
    yield _current;
  }

  @override
  Future<AccountSession?> restore() async {
    _current = await _repository.currentSession();
    notifyListeners();
    return _current;
  }

  @override
  Future<AccountSession> signIn({
    required String email,
    required String password,
  }) async {
    final account = await _repository.authenticate(
      loginId: email,
      password: password,
    );
    _current = AccountSession(
      userId: account.userId,
      email: account.loginId,
      displayName: account.displayName,
      isDemonstration: account.isDemonstration,
    );
    notifyListeners();
    return _current!;
  }

  @override
  Future<AccountSession> register({
    required String displayName,
    required String email,
    required String password,
    String locale = 'en',
  }) async {
    final account = await _repository.register(
      displayName: displayName,
      loginId: email,
      password: password,
    );
    _current = AccountSession(
      userId: account.userId,
      email: account.loginId,
      displayName: account.displayName,
      isDemonstration: account.isDemonstration,
    );
    notifyListeners();
    return _current!;
  }

  @override
  Future<AccountSession> continueAsDemonstrationUser() async {
    _current = await _repository.continueAsDemonstrationUser();
    notifyListeners();
    return _current!;
  }

  @override
  Future<void> signOut() async {
    await _repository.clearSession();
    _current = null;
    notifyListeners();
  }
}
