// lib/providers/settings_providers.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/jhuri_constants.dart';

// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided in main.dart');
});

// Theme mode provider
final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  static const String _key = 'themeMode';

  @override
  Future<ThemeMode> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return _getThemeMode(prefs);
  }

  static ThemeMode _getThemeMode(SharedPreferences prefs) {
    final value = prefs.getString(_key);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, mode.name);
    state = AsyncValue.data(mode);
  }
}

// Locale provider
final localeProvider =
    AsyncNotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends AsyncNotifier<Locale> {
  static const String _key = 'language';

  @override
  Future<Locale> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return _getLocale(prefs);
  }

  static Locale _getLocale(SharedPreferences prefs) {
    final languageCode =
        prefs.getString(_key) ?? JhuriConstants.defaultLanguage;
    return languageCode == 'en'
        ? const Locale('en', 'US')
        : const Locale('bn', 'BD');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, locale.languageCode);
    state = AsyncValue.data(locale);
  }
}

// Settings values providers (read-only)
final showPriceTotalProvider = Provider<bool>((ref) {
  return ref.read(sharedPreferencesProvider).getBool('showPriceTotal') ?? true;
});

final defaultUnitProvider = Provider<String>((ref) {
  return ref.read(sharedPreferencesProvider).getString('defaultUnit') ??
      JhuriConstants.defaultUnit;
});

final currencySymbolProvider = Provider<String>((ref) {
  return ref.read(sharedPreferencesProvider).getString('currencySymbol') ??
      JhuriConstants.defaultCurrencySymbol;
});

final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.read(sharedPreferencesProvider).getBool('notificationsEnabled') ??
      true;
});

final defaultReminderTimeProvider = Provider<String>((ref) {
  return ref.read(sharedPreferencesProvider).getString('defaultReminderTime') ??
      JhuriConstants.defaultReminderTime;
});

final listSortOrderProvider = Provider<String>((ref) {
  return ref.read(sharedPreferencesProvider).getString('listSortOrder') ??
      'dateDesc';
});

// Settings notifiers for writable values
final showPriceTotalNotifierProvider =
    AsyncNotifierProvider<ShowPriceTotalNotifier, bool>(
        ShowPriceTotalNotifier.new);

class ShowPriceTotalNotifier extends AsyncNotifier<bool> {
  static const String _key = 'showPriceTotal';

  @override
  Future<bool> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? true;
  }

  Future<void> setValue(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, value);
    state = AsyncValue.data(value);
  }
}

final defaultUnitNotifierProvider =
    AsyncNotifierProvider<DefaultUnitNotifier, String>(DefaultUnitNotifier.new);

class DefaultUnitNotifier extends AsyncNotifier<String> {
  static const String _key = 'defaultUnit';

  @override
  Future<String> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getString(_key) ?? JhuriConstants.defaultUnit;
  }

  Future<void> setValue(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, value);
    state = AsyncValue.data(value);
  }
}

final currencySymbolNotifierProvider =
    AsyncNotifierProvider<CurrencySymbolNotifier, String>(
        CurrencySymbolNotifier.new);

class CurrencySymbolNotifier extends AsyncNotifier<String> {
  static const String _key = 'currencySymbol';

  @override
  Future<String> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getString(_key) ?? JhuriConstants.defaultCurrencySymbol;
  }

  Future<void> setValue(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, value);
    state = AsyncValue.data(value);
  }
}

final notificationsEnabledNotifierProvider =
    AsyncNotifierProvider<NotificationsEnabledNotifier, bool>(
        NotificationsEnabledNotifier.new);

class NotificationsEnabledNotifier extends AsyncNotifier<bool> {
  static const String _key = 'notificationsEnabled';

  @override
  Future<bool> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_key) ?? true;
  }

  Future<void> setValue(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_key, value);
    state = AsyncValue.data(value);
  }
}

final defaultReminderTimeNotifierProvider =
    AsyncNotifierProvider<DefaultReminderTimeNotifier, String>(
        DefaultReminderTimeNotifier.new);

class DefaultReminderTimeNotifier extends AsyncNotifier<String> {
  static const String _key = 'defaultReminderTime';

  @override
  Future<String> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getString(_key) ?? JhuriConstants.defaultReminderTime;
  }

  Future<void> setValue(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, value);
    state = AsyncValue.data(value);
  }
}

final listSortOrderNotifierProvider =
    AsyncNotifierProvider<ListSortOrderNotifier, String>(
        ListSortOrderNotifier.new);

class ListSortOrderNotifier extends AsyncNotifier<String> {
  static const String _key = 'listSortOrder';

  @override
  Future<String> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getString(_key) ?? 'dateDesc';
  }

  Future<void> setValue(String value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, value);
    state = AsyncValue.data(value);
  }
}
