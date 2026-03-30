// lib/core/constants/app_constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  // ═══════════════════════════════════════════════════════════
  // LOCALIZATION
  // ═══════════════════════════════════════════════════════════

  static const List<Locale> supportedLocales = [
    Locale('bn', 'BD'),
    Locale('en', 'US'),
  ];

  static const Locale defaultLocale = Locale('bn', 'BD');
}
