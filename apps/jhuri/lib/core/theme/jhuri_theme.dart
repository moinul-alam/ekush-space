import 'package:flutter/material.dart';
import 'jhuri_theme_extension.dart';

class JhuriTheme {
  JhuriTheme._();

  // Font family
  static const String _fontFamily = 'HindSiliguri';

  // ── Light Theme ────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colors = const ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xFF2D6A4F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE8F5E8),
      onPrimaryContainer: Color(0xFF1A1A1A),
      secondary: Color(0xFFE9A23B),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFDF4E3),
      onSecondaryContainer: Color(0xFF1A1A1A),
      error: Color(0xFFD62828),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1C1C1C),
      outline: Color(0xFFE0E0E0),
      shadow: Color(0x1F000000),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: const Color(0xFFFDFAF4),
      fontFamily: _fontFamily,
      textTheme: _buildTextTheme(),
      appBarTheme: _lightAppBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme(colors),
      outlinedButtonTheme: _outlinedButtonTheme(colors),
      textButtonTheme: _textButtonTheme(colors),
      inputDecorationTheme: _inputDecorationTheme(colors),
      floatingActionButtonTheme: _fabTheme(colors),
      snackBarTheme: _snackBarTheme,
      dialogTheme: _dialogTheme,
      bottomSheetTheme: _bottomSheetTheme,
      extensions: const [JhuriThemeExtension.light],
    );
  }

  // ── Dark Theme ─────────────────────────────────────────────
  static ThemeData get darkTheme {
    final colors = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF2D6A4F),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF1A3D2E),
      onPrimaryContainer: Color(0xFFF5F5F5),
      secondary: Color(0xFFE9A23B),
      onSecondary: Color(0xFF1A1A1A),
      secondaryContainer: Color(0xFF3D2E1A),
      onSecondaryContainer: Color(0xFFF5F5F5),
      error: Color(0xFFD62828),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFF242424),
      onSurface: Color(0xFFF5F5F5),
      outline: Color(0xFF424242),
      shadow: Color(0x3F000000),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      fontFamily: _fontFamily,
      textTheme: _buildTextTheme(),
      appBarTheme: _darkAppBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme(colors),
      outlinedButtonTheme: _outlinedButtonTheme(colors),
      textButtonTheme: _textButtonTheme(colors),
      inputDecorationTheme: _inputDecorationTheme(colors),
      floatingActionButtonTheme: _fabTheme(colors),
      snackBarTheme: _snackBarTheme,
      dialogTheme: _dialogTheme,
      bottomSheetTheme: _bottomSheetTheme,
      extensions: const [JhuriThemeExtension.dark],
    );
  }

  // ── Text Style Helper ──────────────────────────────────────
  static TextStyle _s({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  // ── Text Theme ─────────────────────────────────────────────
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge:
          _s(fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -0.25),
      displayMedium: _s(fontSize: 45, fontWeight: FontWeight.w700),
      displaySmall: _s(fontSize: 36, fontWeight: FontWeight.w700),
      headlineLarge: _s(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: _s(fontSize: 28, fontWeight: FontWeight.w700),
      headlineSmall: _s(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: _s(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium:
          _s(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall:
          _s(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge:
          _s(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium:
          _s(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall:
          _s(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge:
          _s(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      labelMedium:
          _s(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall:
          _s(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────
  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: Color(0xFFFDFAF4),
    foregroundColor: Color(0xFF1C1C1C),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 1,
    backgroundColor: Color(0xFF1A1A1A),
    foregroundColor: Color(0xFFF5F5F5),
  );

  // ── Card ───────────────────────────────────────────────────
  static CardThemeData get _cardTheme => CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      );

  // ── Buttons ────────────────────────────────────────────────
  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colors) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colors) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static TextButtonThemeData _textButtonTheme(ColorScheme colors) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  // ── Input ──────────────────────────────────────────────────
  static InputDecorationTheme _inputDecorationTheme(ColorScheme colors) =>
      InputDecorationTheme(
        filled: true,
        fillColor: colors.brightness == Brightness.light
            ? const Color(0xFFF5F5F5)
            : colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        hintStyle:
            TextStyle(color: colors.onSurfaceVariant.withValues(alpha: 0.6)),
      );

  // ── FAB ────────────────────────────────────────────────────
  static FloatingActionButtonThemeData _fabTheme(ColorScheme colors) =>
      FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  // ── SnackBar ───────────────────────────────────────────────
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );

  // ── Dialog ─────────────────────────────────────────────────
  static DialogThemeData get _dialogTheme => DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  // ── Bottom Sheet ───────────────────────────────────────────
  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
      );
}
