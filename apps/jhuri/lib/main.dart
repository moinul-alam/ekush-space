// lib/main.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
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

// Simple error widgets for now
class AppErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const AppErrorWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'কিছু একটা ভুল হয়েছে।',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'An error occurred',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Restart the app
                  runApp(
                    ProviderScope(
                      child: const JhuriApp(),
                    ),
                  );
                },
                child: const Text('Restart App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppInitErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRetry;
  final String websiteUrl;

  const AppInitErrorScreen({
    super.key,
    required this.error,
    required this.stackTrace,
    required this.onRetry,
    required this.websiteUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Initialization Failed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> main() async {
  runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    // Only preserve splash on native platforms, not web
    if (kIsWeb == false) {
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    }

    // ── Set up Flutter error widget handler ───────────────
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return AppErrorWidget(details: details);
    };

    // ── Attempt core initialization ───────────────────────
    try {
      await _initializeCore();
    } catch (e, st) {
      // Remove splash before showing error screen (only on native platforms)
      if (kIsWeb == false) {
        FlutterNativeSplash.remove();
      }

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

    // Remove splash after first frame (only on native platforms)
    if (kIsWeb == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterNativeSplash.remove();
      });
    }
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

  // Remove splash after first frame (only on native platforms)
  if (kIsWeb == false) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }
}
