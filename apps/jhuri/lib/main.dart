import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_ui/ekush_ui.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'core/theme/jhuri_theme.dart';
import 'core/providers/jhuri_providers.dart';
import 'core/router/app_router.dart';
import 'data/repositories/app_settings_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/item_template_repository.dart';
import 'data/seeds/seed_service.dart';

Future<void> main() async {
  debugPrint('🚀 App Starting...');
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('✅ WidgetsBinding initialized');

    // Show a loading screen immediately while we initialize
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('প্রস্তুত করা হচ্ছে... / Initializing...',
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );

    // ── Attempt initialization with global timeout ─────────
    try {
      await Future.any([
        _performInitialization(databaseProvider, const JhuriApp()),
        Future.delayed(const Duration(seconds: 45)).then((_) {
          throw TimeoutException('Global initialization timed out (45s)');
        }),
      ]);
    } catch (e, st) {
      debugPrint('🔥 Initialization failed: $e');
      debugPrintStack(stackTrace: st);

      // Show error screen if initialization fails
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AppInitErrorScreen(
            error: e,
            stackTrace: st,
            onRetry: () => main(),
          ),
        ),
      );
    }
  }, (error, stack) {
    debugPrint('🔥 Uncaught App Error: $error');
    debugPrintStack(stackTrace: stack);
  });
}

Future<void> _performInitialization(
    Provider<JhuriDatabase> databaseProvider, Widget app) async {
  debugPrint('📦 Initializing Database...');
  DatabaseService.initialize();
  final database = DatabaseService.instance;
  debugPrint('✅ Database instance created');

  // Initialize app settings
  debugPrint('⚙️ Initializing Settings...');
  final appSettingsRepo = AppSettingsRepository(database);
  await appSettingsRepo.initSettings().timeout(const Duration(seconds: 10),
      onTimeout: () {
    debugPrint('⚠️ Settings initialization timed out!');
    throw TimeoutException('Settings initialization timed out');
  });
  debugPrint('✅ Settings initialized');

  // Seed data if needed
  debugPrint('🌱 Checking Seeding...');
  final seedService = SeedService(
    categoryRepository: CategoryRepository(database),
    itemTemplateRepository: ItemTemplateRepository(database),
    db: database,
  );
  await seedService.seedIfNeeded().timeout(const Duration(seconds: 30),
      onTimeout: () {
    debugPrint('⚠️ Seeding timed out!');
    throw TimeoutException('Seeding timed out');
  });
  debugPrint('✅ Seeding checked');

  // Increment app open count
  debugPrint('📈 Incrementing open count...');
  await appSettingsRepo
      .incrementAppOpenCount()
      .timeout(const Duration(seconds: 5), onTimeout: () {
    debugPrint('⚠️ Increment open count timed out');
  });
  debugPrint('✅ Open count incremented');

  // Warm up version cache
  debugPrint('🏷️ Warming up version cache...');
  await AppVersionCache.warmFromPlatform().timeout(const Duration(seconds: 5),
      onTimeout: () {
    debugPrint('⚠️ Version cache warmup timed out');
  });
  debugPrint('✅ Version cache warmed');

  debugPrint('🏁 Initialization complete. Launching app...');
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        adServiceProvider.overrideWith((ref) {
          const config = EkushAdConfig(
            bannerAdUnitId: 'ca-app-pub-3940256099942544/6300978111',
            interstitialAdUnitId: 'ca-app-pub-3940256099942544/1033173712',
            nativeAdUnitId: 'ca-app-pub-3940256099942544/2247696110',
          );
          final service = AdService(ref, config);
          ref.onDispose(service.dispose);
          return service;
        }),
      ],
      child: app,
    ),
  );
}

class JhuriApp extends ConsumerWidget {
  const JhuriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'ঝুড়ি',
      debugShowCheckedModeBanner: false,
      theme: JhuriTheme.lightTheme,
      darkTheme: JhuriTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
