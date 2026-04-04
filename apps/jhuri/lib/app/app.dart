// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/jhuri_constants.dart';
import '../config/jhuri_theme.dart';
import '../l10n/jhuri_localizations.dart';
import '../routing/app_router.dart';
import '../providers/settings_providers.dart';

class JhuriApp extends ConsumerWidget {
  final bool onboardingComplete;
  const JhuriApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider(onboardingComplete));

    // Watch async providers with fallback values
    final themeModeAsync = ref.watch(themeModeProvider);
    final localeAsync = ref.watch(localeProvider);

    return MaterialApp.router(
      title: JhuriConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: JhuriTheme.lightTheme,
      darkTheme: JhuriTheme.darkTheme,
      themeMode: themeModeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, __) => ThemeMode.system,
      ),

      // Localization
      locale: localeAsync.when(
        data: (locale) => locale,
        loading: () => JhuriConstants.defaultLocale,
        error: (_, __) => JhuriConstants.defaultLocale,
      ),
      supportedLocales: JhuriConstants.supportedLocales,
      localizationsDelegates: [
        JhuriLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Routing
      routerConfig: router,
    );
  }
}
