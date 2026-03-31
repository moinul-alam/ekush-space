import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'core/theme/jhuri_theme.dart';
import 'core/providers/jhuri_providers.dart';
import 'core/services/seed_service.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseService.initialize();
  await SeedService.seedIfNeeded();
  await AppVersionCache.warmFromPlatform();

  runApp(
    const ProviderScope(
      child: JhuriApp(),
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
