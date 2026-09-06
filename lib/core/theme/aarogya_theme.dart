import 'package:aarogya/core/theme/aarogya_colors.dart';
import 'package:aarogya/core/theme/aarogya_spacing.dart';
import 'package:flutter/material.dart';

ThemeData buildAarogyaTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AarogyaColors.primary,
      brightness: Brightness.light,
      primary: AarogyaColors.primary,
      surface: AarogyaColors.surface,
    ),
  );
  return base.copyWith(
    scaffoldBackgroundColor: AarogyaColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AarogyaColors.surface,
      foregroundColor: AarogyaColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: AarogyaColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: AarogyaColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
        side: const BorderSide(color: AarogyaColors.border),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerColor: AarogyaColors.border,
    textTheme: base.textTheme.apply(
      bodyColor: AarogyaColors.textPrimary,
      displayColor: AarogyaColors.textPrimary,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AarogyaSpacing.buttonHeight),
        backgroundColor: AarogyaColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
        ),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AarogyaColors.surface,
      indicatorColor: AarogyaColors.primarySoft,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: AarogyaColors.surface,
      indicatorColor: AarogyaColors.primarySoft,
      selectedIconTheme: IconThemeData(color: AarogyaColors.primary),
      selectedLabelTextStyle: TextStyle(color: AarogyaColors.primary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AarogyaSpacing.buttonHeight),
        foregroundColor: AarogyaColors.primary,
        side: const BorderSide(color: AarogyaColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AarogyaSpacing.cardRadius),
        ),
      ),
    ),
  );
}
