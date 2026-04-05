// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/jhuri_constants.dart';
import '../config/jhuri_theme.dart';
import '../l10n/jhuri_localizations.dart';
import '../routing/app_router.dart';
import '../providers/settings_providers.dart';
import 'config/app_initializer.dart';

class JhuriApp extends ConsumerStatefulWidget {
  final bool onboardingComplete;
  const JhuriApp({super.key, required this.onboardingComplete});

  @override
  ConsumerState<JhuriApp> createState() => _JhuriAppState();
}

class _JhuriAppState extends ConsumerState<JhuriApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeModeAsync = ref.read(themeModeProvider);
    themeModeAsync.whenData((themeMode) {
      if (mounted) {
        JhuriAppInitializer.updateSystemUIFromTheme(context, themeMode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider(widget.onboardingComplete));

    // Watch async providers with fallback values
    final themeModeAsync = ref.watch(themeModeProvider);
    final localeAsync = ref.watch(localeProvider);

    ref.listen(themeModeProvider, (previous, next) {
      next.whenData((newThemeMode) {
        if (previous != null && mounted) {
          previous.whenData((oldThemeMode) {
            if (oldThemeMode != newThemeMode) {
              JhuriAppInitializer.updateSystemUIFromTheme(context, newThemeMode);
            }
          });
        }
      });
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: false,
      builder: (context, child) => MaterialApp.router(
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

        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
            ),
          ),
          child: widget ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
