// lib/app/config/app_initializer.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_theme/ekush_theme.dart';
import '../../config/jhuri_constants.dart';
import '../../services/seed_service.dart';

/// Initialization result containing all required instances
class InitializationResult {
  final SharedPreferences sharedPreferences;
  final JhuriDatabase database;
  final bool onboardingComplete;

  const InitializationResult({
    required this.sharedPreferences,
    required this.database,
    required this.onboardingComplete,
  });
}

class JhuriAppInitializer {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  static void _log(String msg) => debugPrint('[JhuriAppInit] $msg');

  /// Initialize core app components with retry logic
  /// 
  /// Initialization order: timezone → SharedPreferences → JhuriDatabase → SeedService
  /// Returns InitializationResult with all required instances
  static Future<InitializationResult> initializeCore() async {
    int attempt = 0;
    
    while (attempt < _maxRetries) {
      attempt++;
      _log('🚀 Initialization attempt $attempt/$_maxRetries');
      
      try {
        // Step 1: Initialize timezone database
        await _initializeTimezone();
        _log('✅ Timezone initialized');
        
        // Step 2: Initialize SharedPreferences
        final prefs = await _initializeSharedPreferences();
        _log('✅ SharedPreferences initialized');
        
        // Step 3: Initialize JhuriDatabase
        final db = await _initializeDatabase();
        _log('✅ JhuriDatabase initialized');
        
        // Step 4: Run seed service
        await _runSeedService(db);
        _log('✅ Seed service completed');
        
        // Get onboarding status
        final onboardingComplete = 
            prefs.getBool(JhuriConstants.storageKeyOnboardingComplete) ?? false;
        
        _log('🎉 Initialization completed successfully on attempt $attempt');
        
        return InitializationResult(
          sharedPreferences: prefs,
          database: db,
          onboardingComplete: onboardingComplete,
        );
        
      } catch (e, stackTrace) {
        _log('❌ Initialization attempt $attempt failed: $e');
        debugPrintStack(stackTrace: stackTrace);
        
        if (attempt >= _maxRetries) {
          _log('🔥 All $_maxRetries attempts exhausted. Giving up.');
          rethrow;
        }
        
        _log('⏳ Waiting $_retryDelay before retry...');
        await Future.delayed(_retryDelay);
      }
    }
    
    throw Exception('Initialization failed after $_maxRetries attempts');
  }

  /// Initialize timezone database with Asia/Dhaka as default
  static Future<void> _initializeTimezone() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Dhaka'));
    } catch (e) {
      throw Exception('Timezone initialization failed: $e');
    }
  }

  /// Initialize SharedPreferences
  static Future<SharedPreferences> _initializeSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs;
    } catch (e) {
      throw Exception('SharedPreferences initialization failed: $e');
    }
  }

  /// Initialize JhuriDatabase
  static Future<JhuriDatabase> _initializeDatabase() async {
    try {
      final db = JhuriDatabase();
      return db;
    } catch (e) {
      throw Exception('JhuriDatabase initialization failed: $e');
    }
  }

  /// Run seed service to populate initial data if needed
  static Future<void> _runSeedService(JhuriDatabase db) async {
    try {
      final seedService = SeedService(db);
      await seedService.seedDatabaseIfNeeded();
    } catch (e) {
      throw Exception('Seed service failed: $e');
    }
  }

  /// Update system UI based on theme (mirrors Ponji's pattern)
  static void updateSystemUIFromTheme(
      BuildContext context, ThemeMode themeMode) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);
    final colorScheme = isDark
        ? AppTheme.darkTheme.colorScheme
        : AppTheme.lightTheme.colorScheme;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: colorScheme.surface,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
  }

  /// Dispose resources and close database connection
  static Future<void> dispose(JhuriDatabase database) async {
    try {
      await database.close();
      _log('✅ Database connection closed');
    } catch (e) {
      _log('⚠️ Error closing database: $e');
    }
  }
}
