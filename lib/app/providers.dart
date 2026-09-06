import 'package:aarogya/app/bootstrap.dart';
import 'package:aarogya/app/session/app_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dependenciesProvider = Provider<AarogyaDependencies>((ref) {
  throw UnimplementedError('AarogyaDependencies must be provided at startup.');
});

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  Future<void> hydrate() async {
    final stored = await ref
        .read(dependenciesProvider)
        .preferences
        .localeCode();
    if (stored == 'hi' || stored == 'en') {
      state = Locale(stored!);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await ref
        .read(dependenciesProvider)
        .preferences
        .setLocaleCode(locale.languageCode);
  }
}

final sessionProvider = StreamProvider<AppSessionState>((ref) async* {
  final runtime = ref.watch(dependenciesProvider).runtime;
  yield runtime.state;
  yield* runtime.states;
});
