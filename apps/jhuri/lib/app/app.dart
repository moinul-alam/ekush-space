// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/jhuri_constants.dart';
import '../config/jhuri_theme.dart';
import '../l10n/jhuri_localizations.dart';
import '../routing/app_router.dart';

class JhuriApp extends ConsumerWidget {
  const JhuriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: JhuriConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: JhuriTheme.lightTheme,
      darkTheme: JhuriTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),

      // Localization
      locale: ref.watch(localeProvider),
      supportedLocales: JhuriConstants.supportedLocales,
      localizationsDelegates: [
        JhuriLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Routing
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}

// Simple providers for theme and locale management
final themeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.system);
final localeProvider = Provider<Locale>((ref) => JhuriConstants.defaultLocale);
