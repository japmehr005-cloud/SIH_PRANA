import 'package:aarogya/app/router.dart';
import 'package:aarogya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AskAssistantButton extends StatelessWidget {
  const AskAssistantButton({super.key, this.filled = false});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final child = Text(l10n.askPranaAssistant);
    final icon = const Icon(Icons.help_outline);
    void open() => context.go(AppPaths.assistant);
    if (filled) {
      return FilledButton.icon(onPressed: open, icon: icon, label: child);
    }
    return OutlinedButton.icon(onPressed: open, icon: icon, label: child);
  }
}
