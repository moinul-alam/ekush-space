import 'package:flutter/material.dart';

class PonjiConstants {
  // Private constructor to prevent instantiation
  PonjiConstants._();

  // Date & Time Formats
  static const String bengaliDateFormat = 'dd MMMM yyyy'; // Will be localized

  // Limits
  static const int maxRemindersPerDay = 10;
  static const int maxCustomEvents = 100;
  static const int maxReminderMessageLength = 200;
  static const int maxEventTitleLength = 100;
  static const int maxEventDescriptionLength = 500;

  // Default Values
  static const String defaultLanguage = 'bn'; // Bengali
  static const String fallbackLanguage = 'en'; // English
  static const bool defaultNotificationsEnabled = true;
  static const bool defaultDarkModeEnabled = false;

  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('bn', 'BD'), // Bangla (Bangladesh)
    Locale('en', 'US'), // English (US)
  ];

  // Default Locale
  static const Locale defaultLocale = Locale('bn', 'BD');

  // Language Names
  static const Map<String, String> languageNames = {
    'bn': 'বাংলা',
    'en': 'English',
  };

  // Language Display (with flags)
  static const Map<String, String> languageDisplay = {
    'bn': '🇧🇩 বাংলা',
    'en': '🇺🇸 English',
  };

  // Storage Keys
  static const String storageKeyLocale = 'app_locale';
  static const String storageKeyThemeMode = 'theme_mode';
  static const String storageKeyFirstLaunch = 'first_launch';

  // ========== HELPER METHODS ==========

  /// Get language name by code
  static String getLanguageName(String code) {
    return languageNames[code] ?? 'Unknown';
  }

  /// Get language display by code
  static String getLanguageDisplay(String code) {
    return languageDisplay[code] ?? 'Unknown';
  }

  /// Check if locale is supported
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }
}
