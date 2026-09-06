import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/features/auth/data/login_identifier.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginId = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _loginId.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AarogyaSpacing.xl),
                const BrandMark(height: 128),
                const SizedBox(height: AarogyaSpacing.md),
                Text(
                  l10n.appTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  l10n.productTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AarogyaColors.textSecondary),
                ),
                const SizedBox(height: AarogyaSpacing.sm),
                Text(
                  l10n.publicLandingBody,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AarogyaSpacing.lg),
                InfoCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: _loginId,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.emailOrMobile,
                        ),
                      ),
                      const SizedBox(height: AarogyaSpacing.md),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(labelText: l10n.password),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AarogyaSpacing.md),
                        Text(
                          _error!,
                          style: const TextStyle(color: AarogyaColors.danger),
                        ),
                      ],
                      const SizedBox(height: AarogyaSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        height: AarogyaSpacing.buttonHeight,
                        child: FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: Text(l10n.signIn),
                        ),
                      ),
                      const SizedBox(height: AarogyaSpacing.sm),
                      Text(l10n.dontHaveAccount),
                      TextButton(
                        onPressed: () => context.go(AppPaths.register),
                        child: Text(l10n.createAccount),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AarogyaSpacing.lg),
                OutlinedButton(
                  onPressed: _busy ? null : _continueDemo,
                  child: Text(l10n.continueAsDemoUser),
                ),
                const SizedBox(height: AarogyaSpacing.sm),
                Text(
                  l10n.demoAccountHint,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AarogyaColors.textSecondary),
                ),
                const SizedBox(height: AarogyaSpacing.md),
                Text(
                  l10n.dataStaysOnDevice,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AarogyaColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!isValidLoginId(_loginId.text)) {
      setState(() => _error = l10n.identifierRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final deps = ref.read(dependenciesProvider);
      final session = await deps.accounts.signIn(
        email: _loginId.text,
        password: _password.text,
      );
      await deps.coordinator?.bind(session);
      if (mounted) {
        context.go(AppPaths.home);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = l10n.invalidCredentials);
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _continueDemo() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final deps = ref.read(dependenciesProvider);
      final session = await deps.accounts.continueAsDemonstrationUser();
      await deps.coordinator?.bind(session);
      if (mounted) {
        context.go(AppPaths.home);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = l10n.invalidCredentials);
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }
}
