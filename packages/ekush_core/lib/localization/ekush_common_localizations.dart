// lib/localization/ekush_common_localizations.dart

/// Common localization strings that can be reused across all Ekush Labs apps.
/// 
/// This mixin defines the contract for universal strings that are commonly
/// needed in any mobile application, such as action words, status messages,
/// and basic UI elements.
/// 
/// Apps should implement this mixin to provide their own translations
/// for these common strings.
mixin EkushCommonLocalizations {
  // ═══════════════════════════════════════════════════════════
  // UNIVERSAL ACTION WORDS
  // ═══════════════════════════════════════════════════════════

  String get ok;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get search;
  String get refresh;
  String get close;
  String get done;
  String get back;
  String get next;
  String get previous;
  String get retry;
  String get confirm;
  String get reset;
  String get share;
  String get sync;

  // ═══════════════════════════════════════════════════════════
  // UNIVERSAL STATUS WORDS
  // ═══════════════════════════════════════════════════════════

  String get loading;
  String get error;
  String get success;

  // ═══════════════════════════════════════════════════════════
  // UNIVERSAL UI MESSAGES
  // ═══════════════════════════════════════════════════════════

  String get comingSoon;
  String get noDataAvailable;
  String get pageNotFound;
  String get goToHome;
  String get backToHome;

  // ═══════════════════════════════════════════════════════════
  // UNIVERSAL NAVIGATION & SETTINGS
  // ═══════════════════════════════════════════════════════════

  String get welcome;
  String get profile;
  String get about;
  String get settings;
  String get helpSupport;
  String get openSettings;
  String get turnOn;
  String get turnOff;
  String get enable;
  String get notNow;

  // ═══════════════════════════════════════════════════════════
  // UNIVERSAL DATA & NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  String get notifications;
  String get notificationsOn;
  String get notificationsOff;

  // ═══════════════════════════════════════════════════════════
  // TIME UNITS (UNIVERSAL)
  // ═══════════════════════════════════════════════════════════

  String get year;
  String get years;
  String get month;
  String get months;
  String get day;
  String get days;
  String get week;
  String get weeks;

  // ═══════════════════════════════════════════════════════════
  // DAYS OF WEEK (UNIVERSAL)
  // ═══════════════════════════════════════════════════════════

  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;
  String get shortSunday;
  String get shortMonday;
  String get shortTuesday;
  String get shortWednesday;
  String get shortThursday;
  String get shortFriday;
  String get shortSaturday;

  // ═══════════════════════════════════════════════════════════
  // MONTHS - GREGORIAN (UNIVERSAL)
  // ═══════════════════════════════════════════════════════════

  String get january;
  String get february;
  String get march;
  String get april;
  String get may;
  String get june;
  String get july;
  String get august;
  String get september;
  String get october;
  String get november;
  String get december;
}
