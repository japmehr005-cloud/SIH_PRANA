import 'package:aarogya/app/providers.dart';
import 'package:aarogya/app/router.dart';
import 'package:aarogya/app/widgets/brand_mark.dart';
import 'package:aarogya/app/widgets/info_card.dart';
import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:aarogya/domain/contracts/account_repository.dart';
import 'package:aarogya/features/auth/data/login_identifier.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _loginId = TextEditingController();
  final _password = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
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
          child: ListView(
            padding: const EdgeInsets.all(AarogyaSpacing.page),
            children: [
              const SizedBox(height: AarogyaSpacing.xl),
              const Center(child: BrandMark(height: 128)),
              const SizedBox(height: AarogyaSpacing.md),
              Text(
                l10n.createAccount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              Text(
                l10n.productTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AarogyaColors.textSecondary),
              ),
              const SizedBox(height: AarogyaSpacing.sm),
              Text(l10n.publicLandingBody, textAlign: TextAlign.center),
              const SizedBox(height: AarogyaSpacing.lg),
              InfoCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: l10n.fullName),
                    ),
                    const SizedBox(height: AarogyaSpacing.md),
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
                        child: Text(l10n.register),
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(AppPaths.login),
                      child: Text(l10n.alreadyHaveAccount),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.nameRequired);
      return;
    }
    if (!isValidLoginId(_loginId.text)) {
      setState(() => _error = l10n.identifierRequired);
      return;
    }
    if (_password.text.length < 8) {
      setState(() => _error = l10n.passwordTooShort);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final deps = ref.read(dependenciesProvider);
      final locale = ref.read(localeControllerProvider).languageCode;
      final session = await deps.accounts.register(
        displayName: name,
        email: _loginId.text,
        password: _password.text,
        locale: locale,
      );
      await deps.coordinator?.bind(session);
      if (mounted) {
        context.go(AppPaths.home);
      }
    } on AccountAuthException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.code == AccountAuthCode.duplicateAccount
              ? l10n.duplicateAccount
              : l10n.registrationFailed;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = l10n.registrationFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }
}
