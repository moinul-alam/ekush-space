// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ekush_ponji/app/app.dart';
import 'package:ekush_ponji/app/config/app_initializer.dart';
import 'package:ekush_ponji/app/config/ad_config.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'package:ekush_ui/ekush_ui.dart';
import 'package:ekush_ponji/features/about/about_content.dart';

String? pendingNotificationPayload;

Future<void> main() async {
  runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // ── Set up Flutter error widget handler ───────────────
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return AppErrorWidget(details: details);
    };

    // ── Attempt core initialization ───────────────────────
    try {
      await AppInitializer.initializeCore();
    } catch (e, st) {
      // Remove splash before showing error screen
      FlutterNativeSplash.remove();

      debugPrint('🔥 Core initialization failed: $e');
      debugPrintStack(stackTrace: st);

      runApp(
        AppInitErrorScreen(
          error: e,
          stackTrace: st,
          onRetry: () => _retryInit(),
          websiteUrl: AboutContent.websiteUrl,
        ),
      );
      return;
    }

    pendingNotificationPayload = await AppInitializer.getColdStartPayload();

    runApp(
      ProviderScope(
        overrides: [
          adServiceProvider.overrideWith((ref) {
            final service = AdService(ref, AdConfig.toEkushAdConfig());
            ref.onDispose(service.dispose);
            return service;
          }),
        ],
        child: const EkushPonjiApp(),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }, (error, stack) {
    debugPrint('🔥 Uncaught App Error: $error');
    debugPrintStack(stackTrace: stack);
  });
}

/// Called by AppInitErrorScreen retry button.
/// Re-runs the full initialization sequence and relaunches the app.
Future<void> _retryInit() async {
  await AppInitializer.initializeCore();

  final payload = await AppInitializer.getColdStartPayload();
  pendingNotificationPayload = payload;

  runApp(
    ProviderScope(
      overrides: [
        adServiceProvider.overrideWith((ref) {
          final service = AdService(ref, AdConfig.toEkushAdConfig());
          ref.onDispose(service.dispose);
          return service;
        }),
      ],
      child: const EkushPonjiApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}


