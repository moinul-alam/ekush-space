import 'package:flutter/material.dart';

class JhuriThemeExtension extends ThemeExtension<JhuriThemeExtension> {
  final Color primary;
  final Color accent;
  final Color backgroundLight;
  final Color backgroundDark;
  final Color surfaceLight;
  final Color surfaceDark;
  final Color error;
  final Color textPrimaryLight;
  final Color textPrimaryDark;
  final Color textSecondary;

  const JhuriThemeExtension({
    required this.primary,
    required this.accent,
    required this.backgroundLight,
    required this.backgroundDark,
    required this.surfaceLight,
    required this.surfaceDark,
    required this.error,
    required this.textPrimaryLight,
    required this.textPrimaryDark,
    required this.textSecondary,
  });

  static const light = JhuriThemeExtension(
    primary: Color(0xFF2D6A4F),
    accent: Color(0xFFE9A23B),
    backgroundLight: Color(0xFFFDFAF4),
    backgroundDark: Color(0xFF1A1A1A),
    surfaceLight: Color(0xFFFFFFFF),
    surfaceDark: Color(0xFF242424),
    error: Color(0xFFD62828),
    textPrimaryLight: Color(0xFF1C1C1C),
    textPrimaryDark: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF6B7280),
  );

  static const dark = JhuriThemeExtension(
    primary: Color(0xFF2D6A4F),
    accent: Color(0xFFE9A23B),
    backgroundLight: Color(0xFFFDFAF4),
    backgroundDark: Color(0xFF1A1A1A),
    surfaceLight: Color(0xFFFFFFFF),
    surfaceDark: Color(0xFF242424),
    error: Color(0xFFD62828),
    textPrimaryLight: Color(0xFF1C1C1C),
    textPrimaryDark: Color(0xFFF5F5F5),
    textSecondary: Color(0xFF6B7280),
  );

  @override
  JhuriThemeExtension copyWith({
    Color? primary,
    Color? accent,
    Color? backgroundLight,
    Color? backgroundDark,
    Color? surfaceLight,
    Color? surfaceDark,
    Color? error,
    Color? textPrimaryLight,
    Color? textPrimaryDark,
    Color? textSecondary,
  }) =>
      JhuriThemeExtension(
        primary: primary ?? this.primary,
        accent: accent ?? this.accent,
        backgroundLight: backgroundLight ?? this.backgroundLight,
        backgroundDark: backgroundDark ?? this.backgroundDark,
        surfaceLight: surfaceLight ?? this.surfaceLight,
        surfaceDark: surfaceDark ?? this.surfaceDark,
        error: error ?? this.error,
        textPrimaryLight: textPrimaryLight ?? this.textPrimaryLight,
        textPrimaryDark: textPrimaryDark ?? this.textPrimaryDark,
        textSecondary: textSecondary ?? this.textSecondary,
      );

  @override
  JhuriThemeExtension lerp(JhuriThemeExtension? other, double t) {
    if (other == null) return this;
    return JhuriThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      surfaceDark: Color.lerp(surfaceDark, other.surfaceDark, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimaryLight: Color.lerp(textPrimaryLight, other.textPrimaryLight, t)!,
      textPrimaryDark: Color.lerp(textPrimaryDark, other.textPrimaryDark, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}
