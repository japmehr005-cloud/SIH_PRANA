import 'dart:async';

import 'package:aarogya/core/supabase_config.dart';
import 'package:aarogya/domain/identity/account_session.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class SupabaseAccountService extends ChangeNotifier
    implements AccountService {
  SupabaseAccountService(this._client);

  final SupabaseClient _client;
  StreamSubscription<AuthState>? _authSub;
  AccountSession? _current;

  Future<void> listen() async {
    _authSub ??= _client.auth.onAuthStateChange.listen((state) {
      _current = _fromUser(state.session?.user);
      notifyListeners();
    });
  }

  @override
  bool get isConfigured => SupabaseConfig.isConfigured;

  @override
  AccountSession? get current => _current;

  @override
  Stream<AccountSession?> watch() async* {
    yield _current;
    await for (final state in _client.auth.onAuthStateChange) {
      yield _fromUser(state.session?.user);
    }
  }

  @override
  Future<AccountSession?> restore() async {
    final user = _client.auth.currentUser ?? _client.auth.currentSession?.user;
    _current = _fromUser(user);
    notifyListeners();
    return _current;
  }

  @override
  Future<AccountSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final session = _fromUser(response.user);
    if (session == null) {
      throw StateError('Sign-in did not return a user.');
    }
    _current = session;
    notifyListeners();
    return session;
  }

  @override
  Future<AccountSession> register({
    required String displayName,
    required String email,
    required String password,
    String locale = 'en',
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'display_name': displayName, 'locale': locale},
    );
    var user = response.user;
    if (response.session == null) {
      final signedIn = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      user = signedIn.user;
    }
    if (user == null) {
      throw StateError('Registration did not return a user.');
    }
    await _client.from('profiles').upsert({
      'user_id': user.id,
      'display_name': displayName,
      'locale': locale,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    final session = AccountSession(
      userId: user.id,
      email: user.email ?? email.trim(),
      displayName: displayName,
    );
    _current = session;
    notifyListeners();
    return session;
  }

  @override
  Future<AccountSession> continueAsDemonstrationUser() {
    throw UnsupportedError('Demonstration accounts are local-only.');
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
    _current = null;
    notifyListeners();
  }

  Future<void> disposeListener() async {
    await _authSub?.cancel();
  }

  AccountSession? _fromUser(User? user) {
    if (user == null) {
      return null;
    }
    final name = user.userMetadata?['display_name'] as String?;
    return AccountSession(
      userId: user.id,
      email: user.email ?? '',
      displayName: name,
    );
  }
}
