import 'dart:async';

import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/core/theme/aarogya_theme.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AarogyaApp extends ConsumerStatefulWidget {
  const AarogyaApp({super.key});

  @override
  ConsumerState<AarogyaApp> createState() => _AarogyaAppState();
}

class _AarogyaAppState extends ConsumerState<AarogyaApp> {
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(accounts: ref.read(dependenciesProvider).accounts);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(localeControllerProvider.notifier).hydrate());
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildAarogyaTheme(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: _router!,
    );
  }
}
