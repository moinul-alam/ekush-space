import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'package:ekush_ponji/app/providers/app_providers.dart';
import 'package:ekush_theme/ekush_theme.dart';
import 'package:ekush_ponji/features/holidays/models/holiday.dart';
import 'package:ekush_ponji/features/quotes/models/quote.dart';
import 'package:ekush_ponji/features/words/models/word.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_notifications/ekush_notifications.dart';
import 'package:ekush_ponji/core/services/background_task_dispatcher.dart';
import 'package:ekush_ponji/app/router/app_router.dart';
import 'package:ekush_ponji/app/router/route_names.dart';
import 'package:ekush_ponji/features/calendar/data/calendar_repository.dart';
import 'package:ekush_ponji/features/holidays/services/holiday_notification_prefs.dart';
import 'package:ekush_ponji/features/holidays/services/holiday_notification_service.dart';
import 'package:ekush_ponji/features/quotes/services/quote_notification_service.dart';
import 'package:ekush_ponji/features/quotes/services/quote_notification_prefs.dart';
import 'package:ekush_ponji/features/words/services/word_notification_service.dart';
import 'package:ekush_ponji/features/words/services/word_notification_prefs.dart';
import 'package:ekush_ponji/features/quotes/data/datasources/local/quotes_local_datasource.dart'
    show savedQuotesBoxName;
import 'package:ekush_ponji/features/words/data/datasources/local/words_local_datasource.dart'
    show savedWordsBoxName;
import 'package:ekush_ponji/features/quotes/quotes_viewmodel.dart'
    show quotesRepositoryProvider;
import 'package:ekush_ponji/features/words/words_viewmodel.dart'
    show wordsRepositoryProvider;

class AppInitializer {
  static late final SharedPreferences _prefs;
  static bool _adaptersRegistered = false;

  static void _log(String msg) => debugPrint('[AppInit] $msg');

  static Future<void> initializeCore() async {
    try {
      await Hive.initFlutter();
      _registerAdapters();
      // All boxes opened here so every widget finds them ready on first build
      await Future.wait([
        Hive.openBox(settingsBoxName),
        Hive.openBox('holidays'),
        Hive.openBox<QuoteModel>(savedQuotesBoxName),
        Hive.openBox<WordModel>(savedWordsBoxName),
      ]);
      await LocalNotificationService.initialize(
        onNotificationTap: (payload) {
          if (payload == null || payload.isEmpty) {
            AppRouter.router.go(RouteNames.home);
            return;
          }
          if (payload == 'holiday') {
            AppRouter.router.push(RouteNames.holidays);
            return;
          }
          if (payload.startsWith('quote:')) {
            final index = int.tryParse(payload.substring('quote:'.length)) ?? 0;
            AppRouter.router.push(RouteNames.quotes, extra: index);
            return;
          }
          if (payload.startsWith('word:')) {
            final index = int.tryParse(payload.substring('word:'.length)) ?? 0;
            AppRouter.router.push(RouteNames.words, extra: index);
            return;
          }
          if (payload.startsWith('event:')) {
            final dateStr = payload.substring('event:'.length);
            try {
              final date = DateTime.parse(dateStr);
              AppRouter.router.go(RouteNames.calendar);
              Future.delayed(const Duration(milliseconds: 300), () {
                AppRouter.router.push(RouteNames.calendarDayDetails, extra: date);
              });
            } catch (e) {
              AppRouter.router.go(RouteNames.calendar);
            }
            return;
          }
          if (payload.startsWith('reminder:')) {
            final dateStr = payload.substring('reminder:'.length);
            try {
              final date = DateTime.parse(dateStr);
              AppRouter.router.go(RouteNames.calendar);
              Future.delayed(const Duration(milliseconds: 300), () {
                AppRouter.router.push(RouteNames.calendarDayDetails, extra: date);
              });
            } catch (e) {
              AppRouter.router.go(RouteNames.calendar);
            }
            return;
          }
          AppRouter.router.go(RouteNames.home);
        },
      );
      await AppVersionCache.warmFromPlatform();
      _log('✅ Core initialization completed');
    } catch (e, st) {
      _log('❌ Core init failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  static Future<void> initializeBackground(ProviderContainer container) async {
    try {
      await _setDeviceOrientation();
      await _initializeSharedPreferences();
      await _initializeWorkManager();
      await _performDataSync(container);
      await Future.wait([
        _scheduleHolidayNotifications(container),
        _scheduleQuoteNotifications(container),
        _scheduleWordNotifications(container),
      ]);
      _log('✅ Background initialization completed');
    } catch (e, st) {
      _log('⚠️ Background init error: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<String?> getColdStartPayload() async {
    try {
      final details = await FlutterLocalNotificationsPlugin()
          .getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp == true) {
        final payload = details?.notificationResponse?.payload;
        _log('📱 Cold-start payload: $payload');
        return payload;
      }
    } catch (e) {
      _log('⚠️ Could not read cold-start payload: $e');
    }
    return null;
  }

  static void _registerAdapters() {
    if (_adaptersRegistered) return;
    Hive.registerAdapter(HolidayAdapter());
    Hive.registerAdapter(GazetteTypeAdapter());
    Hive.registerAdapter(HolidayCategoryAdapter());
    Hive.registerAdapter(QuoteModelAdapter());
    Hive.registerAdapter(WordModelAdapter());
    _adaptersRegistered = true;
  }

  static Future<void> _setDeviceOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> _initializeWorkManager() async {
    try {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      if (!(_prefs.getBool('wm_initialized') ?? false)) {
        await Future.wait([
          Workmanager().registerOneOffTask(
            kRescheduleQuoteTask,
            kRescheduleQuoteTask,
            initialDelay: const Duration(seconds: 30),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          ),
          Workmanager().registerOneOffTask(
            kRescheduleWordTask,
            kRescheduleWordTask,
            initialDelay: const Duration(seconds: 30),
            existingWorkPolicy: ExistingWorkPolicy.replace,
          ),
        ]);
        await _prefs.setBool('wm_initialized', true);
      }
    } catch (e) {
      _log('⚠️ WorkManager error: $e');
    }
  }

  static Future<void> _performDataSync(ProviderContainer container) async {
    try {
      final syncService = container.read(dataSyncServiceProvider);
      await syncService.initialize().timeout(
            const Duration(seconds: 8),
            onTimeout: () => _log('Data sync timeout → using cache'),
          );
    } catch (e) {
      _log('⚠️ Sync error: $e');
    }
  }

  static Future<void> _scheduleHolidayNotifications(
      ProviderContainer container) async {
    try {
      final prefs = await HolidayNotificationPrefs.load();
      if (!prefs.enabled) return;
      final lang = _prefs.getString('languageCode') ?? 'bn';
      final holidays = await container
          .read(calendarRepositoryProvider)
          .getUpcomingHolidays(days: 60);
      if (holidays.isEmpty) return;
      await HolidayNotificationService.scheduleAll(
        holidays: holidays.take(30).toList(),
        prefs: prefs,
        languageCode: lang,
      );
    } catch (e) {
      _log('⚠️ Holiday scheduling error: $e');
    }
  }

  static Future<void> _scheduleQuoteNotifications(
      ProviderContainer container) async {
    try {
      final prefs = await QuoteNotificationPrefs.load();
      if (!prefs.enabled) return;
      final lang = _prefs.getString('languageCode') ?? 'bn';
      await QuoteNotificationService.scheduleUpcoming(
        repository: container.read(quotesRepositoryProvider),
        prefs: prefs,
        languageCode: lang,
      );
    } catch (e) {
      _log('⚠️ Quote scheduling error: $e');
    }
  }

  static Future<void> _scheduleWordNotifications(
      ProviderContainer container) async {
    try {
      final prefs = await WordNotificationPrefs.load();
      if (!prefs.enabled) return;
      final lang = _prefs.getString('languageCode') ?? 'bn';
      await WordNotificationService.scheduleUpcoming(
        repository: container.read(wordsRepositoryProvider),
        prefs: prefs,
        languageCode: lang,
      );
    } catch (e) {
      _log('⚠️ Word scheduling error: $e');
    }
  }

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

  static Future<void> dispose() async {
    await Hive.close();
  }
}


