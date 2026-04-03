// lib/config/jhuri_constants.dart

import 'package:flutter/material.dart';

class JhuriConstants {
  // Private constructor to prevent instantiation
  JhuriConstants._();

  // App Info
  static const String appName = 'ঝুড়ি';
  static const String appTitle = 'Jhuri – Smart Grocery List';
  static const String packageName = 'com.ekushlabs.jhuri';

  // Suggestions algorithm (v2)
  static const double recencyWeight7Days = 1.0;
  static const double recencyWeight30Days = 0.7;
  static const double recencyWeight90Days = 0.4;
  static const double recencyWeightOlder = 0.1;

  // UI behaviour
  static const int searchVisibleThreshold =
      10; // categories with 10+ items show search

  // Ad rules
  static const int interstitialSessionMax = 3;
  static const int interstitialMinIntervalMinutes = 5;

  // Engagement
  static const int reviewPromptAppOpenCount = 10;

  // v2+
  static const int nativeAdEveryNCards = 4;

  // Defaults
  static const String defaultReminderTime = '18:00';
  static const String defaultUnit = 'কেজি';
  static const String defaultCurrencySymbol = '৳';
  static const String defaultLanguage = 'bangla';
  static const String defaultThemeMode = 'system';

  // Fixed Unit Set
  static const List<String> fixedUnits = [
    'কেজি',
    'গ্রাম',
    'লিটার',
    'মিলিলিটার',
    'পিস',
    'হালি',
    'আঁটি',
    'ডজন',
    'প্যাকেট',
    'বোতল',
    'কৌটা',
  ];

  // Supported Locales
  static const List<Locale> supportedLocales = [
    Locale('bn', 'BD'), // Bangla (Bangladesh)
    Locale('en', 'US'), // English (US)
  ];

  // Default Locale
  static const Locale defaultLocale = Locale('bn', 'BD');

  // Language Names
  static const Map<String, String> languageNames = {
    'bangla': 'বাংলা',
    'english': 'English',
  };

  // Language Display (with flags)
  static const Map<String, String> languageDisplay = {
    'bangla': '🇧🇩 বাংলা',
    'english': '🇺🇸 English',
  };

  // Storage Keys (SharedPreferences)
  static const String storageKeyLocale = 'app_locale';
  static const String storageKeyThemeMode = 'theme_mode';
  static const String storageKeyLanguage = 'language';
  static const String storageKeyShowPriceTotal = 'show_price_total';
  static const String storageKeyDefaultUnit = 'default_unit';
  static const String storageKeyCurrencySymbol = 'currency_symbol';
  static const String storageKeyNotificationsEnabled = 'notifications_enabled';
  static const String storageKeyDefaultReminderTime = 'default_reminder_time';
  static const String storageKeyListSortOrder = 'list_sort_order';
  static const String storageKeyAppOpenCount = 'app_open_count';
  static const String storageKeyLastInterstitialShown =
      'last_interstitial_shown';
  static const String storageKeyOnboardingComplete = 'onboarding_complete';
  static const String storageKeyReviewPrompted = 'review_prompted';

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

  /// Get theme mode from string
  static ThemeMode getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Get theme mode as string
  static String getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
