// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_ui/ekush_ui.dart';
import 'package:ekush_theme/ekush_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'app/app.dart';
import 'config/jhuri_constants.dart';
import 'l10n/jhuri_localizations.dart';

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
      await _initializeCore();
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
          websiteUrl: 'https://ekushlabs.com',
        ),
      );
      return;
    }

    runApp(
      ProviderScope(
        child: const JhuriApp(),
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

Future<void> _initializeCore() async {
  // Initialize SharedPreferences
  await SharedPreferences.getInstance();
  
  // Initialize Drift database
  // Note: Database will be initialized through ekush_models in Phase 3
  // For now, we just ensure the basic setup is ready
  
  // Initialize any other core services
  await Future.delayed(const Duration(milliseconds: 100)); // Placeholder
}

/// Called by AppInitErrorScreen retry button.
/// Re-runs the full initialization sequence and relaunches the app.
Future<void> _retryInit() async {
  await _initializeCore();

  runApp(
    ProviderScope(
      child: const JhuriApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterNativeSplash.remove();
  });
}
