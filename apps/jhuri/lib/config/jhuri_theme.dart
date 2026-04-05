// lib/config/jhuri_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_theme/core/themes/app_theme_extensions.dart';

/// Jhuri-specific theme configuration
/// Extends the base ekush_theme with Jhuri's unique color palette
class JhuriTheme {
  JhuriTheme._();

  // Jhuri Color Palette (from Section 4 of JHURI_CONST.md)
  static const Color primary = Color(0xFF2D6A4F); // deep sap green
  static const Color accent = Color(0xFFE9A23B); // warm turmeric orange
  static const Color backgroundLight = Color(0xFFFDFAF4); // soft cream
  static const Color backgroundDark = Color(0xFF1A1A1A); // deep charcoal
  static const Color surface = Color(0xFFFFFFFF); // cards surface
  static const Color surfaceDark = Color(0xFF242424); // dark cards surface
  static const Color error = Color(0xFFD62828); // error color
  static const Color textPrimary = Color(0xFF1C1C1C); // light mode text
  static const Color textSecondary = Color(0xFF6B7280); // secondary text
  static const Color textPrimaryDark = Color(0xFFF5F5F5); // dark mode text

  // Light Color Scheme for Jhuri
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE8F5E8),
    onPrimaryContainer: primary,
    secondary: accent,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFF3E0),
    onSecondaryContainer: Color(0xFF8A5A00),
    tertiary: Color(0xFF5D4037),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFE0B2),
    onTertiaryContainer: Color(0xFF3E2723),
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFFFE5E5),
    onErrorContainer: Color(0xFFB71C1C),
    surface: backgroundLight,
    onSurface: textPrimary,
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: textSecondary,
    outline: Color(0xFFE0E0E0),
    outlineVariant: Color(0xFFF0F0F0),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF2E2E2E),
    onInverseSurface: Colors.white,
    inversePrimary: accent,
    surfaceTint: primary,
  );

  // Dark Color Scheme for Jhuri
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF4CAF50),
    onPrimary: Color(0xFF1B5E20),
    primaryContainer: Color(0xFF2E7D32),
    onPrimaryContainer: Color(0xFFE8F5E8),
    secondary: accent,
    onSecondary: Color(0xFF5D4037),
    secondaryContainer: Color(0xFF795548),
    onSecondaryContainer: Color(0xFFFFE0B2),
    tertiary: Color(0xFF8D6E63),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF5D4037),
    onTertiaryContainer: Color(0xFFFFE0B2),
    error: error,
    onError: Colors.white,
    errorContainer: Color(0xFFB71C1C),
    onErrorContainer: Color(0xFFFFE5E5),
    surface: backgroundDark,
    onSurface: textPrimaryDark,
    surfaceContainerHighest: Color(0xFF2A2A2A),
    onSurfaceVariant: Color(0xFFB0B0B0),
    outline: Color(0xFF424242),
    outlineVariant: Color(0xFF2A2A2A),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Colors.black,
    inversePrimary: primary,
    surfaceTint: Color(0xFF4CAF50),
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HindSiliguri',
      colorScheme: lightColorScheme,
      textTheme:
          _buildTextTheme(Brightness.light).apply(fontFamily: 'HindSiliguri'),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      floatingActionButtonTheme: _buildFabTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      dialogTheme: _buildDialogTheme(),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.light),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.light),
      extensions: const [
        AppThemeExtension.light,
      ],
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'HindSiliguri',
      colorScheme: darkColorScheme,
      textTheme:
          _buildTextTheme(Brightness.dark).apply(fontFamily: 'HindSiliguri'),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      floatingActionButtonTheme: _buildFabTheme(),
      snackBarTheme: _buildSnackBarTheme(),
      dialogTheme: _buildDialogTheme(),
      bottomNavigationBarTheme: _buildBottomNavTheme(Brightness.dark),
      navigationBarTheme: _buildNavigationBarTheme(Brightness.dark),
      extensions: const [
        AppThemeExtension.dark,
      ],
    );
  }

  // Typography (from Section 4 of JHURI_CONST.md)
  static TextTheme _buildTextTheme(Brightness brightness) {
    final textColor =
        brightness == Brightness.light ? textPrimary : textPrimaryDark;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 57.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 45.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 36.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final colorScheme =
        brightness == Brightness.light ? lightColorScheme : darkColorScheme;

    return AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  static FloatingActionButtonThemeData _buildFabTheme() {
    return FloatingActionButtonThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    );
  }

  static DialogThemeData _buildDialogTheme() {
    return DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavTheme(
      Brightness brightness) {
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(
      Brightness brightness) {
    return NavigationBarThemeData(
      elevation: 2,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 80.h,
      indicatorShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }
}
