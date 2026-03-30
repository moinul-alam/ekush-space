// lib/l10n/ponji_localizations.dart

import 'package:flutter/material.dart';
import 'package:ekush_core/ekush_core.dart';
import 'ponji_localizations_en.dart';
import 'ponji_localizations_bn.dart';

abstract class PonjiLocalizations extends AppLocalizations {
  // ═══════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════

  @override
  String get appName;
  @override
  String get appTitle;
  @override
  String get welcomeToApp;

  // ═══════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════

  @override
  String get navHome;
  @override
  String get navCalendar;
  @override
  String get navHolidays;
  @override
  String get navCalculator;
  @override
  String get navSettings;
  @override
  String get navMore;
  @override
  String get navAddEvent;
  @override
  String get navAddReminder;
  @override
  String get navCalculatorFull;
  @override
  String get navSavedQuotes;
  @override
  String get navSavedWords;
  @override
  String get navAbout;

  // ═══════════════════════════════════════════════════════════
  // COMMON ACTIONS
  // ═══════════════════════════════════════════════════════════

  @override
  String get ok;
  @override
  String get cancel;
  @override
  String get save;
  @override
  String get delete;
  @override
  String get edit;
  @override
  String get add;
  @override
  String get search;
  @override
  String get refresh;
  @override
  String get close;
  @override
  String get done;
  @override
  String get back;
  @override
  String get next;
  @override
  String get previous;
  @override
  String get loading;
  @override
  String get error;
  @override
  String get success;
  @override
  String get retry;
  @override
  String get confirm;
  @override
  String get reset;
  @override
  String get share;
  @override
  String get sync;

  // ═══════════════════════════════════════════════════════════
  // CALENDAR SYSTEM LABELS
  // ═══════════════════════════════════════════════════════════

  @override
  String get calendarShortGregorian;
  @override
  String get calendarShortBangla;
  @override
  String get calendarShortHijri;

  // ═════════════════════════════════════════════════════════
  // MESSAGES
  // ═══════════════════════════════════════════════════════════

  @override
  String get comingSoon;
  @override
  String get featureComingSoon;
  @override
  String get loadingData;
  @override
  String get failedToLoadData;
  @override
  String get noDataAvailable;
  @override
  String get pageNotFound;
  @override
  String get goToHome;
  @override
  String get backToHome;

  // ═══════════════════════════════════════════════════════════
  // HOME SCREEN
  // ═══════════════════════════════════════════════════════════

  @override
  String get homeTitle;
  @override
  String get goodMorning;
  @override
  String get goodAfternoon;
  @override
  String get goodEvening;
  @override
  String get goodNight;
  @override
  String get todayDate;
  @override
  String get today;
  @override
  String get tomorrow;
  @override
  String get yesterday;
  @override
  String get inDays;
  @override
  String get daysAgo;
  @override
  String get upcomingHolidays;
  @override
  String get upcomingEvents;
  @override
  String get noUpcomingEvents;
  @override
  String get noUpcomingHolidays;
  @override
  String get quoteOfTheDay;
  @override
  String get wordOfTheDay;
  @override
  String get meaningEnglish;
  @override
  String get meaningBengali;
  @override
  String get synonym;
  @override
  String get example;
  @override
  String get todayIsDayName;
  @override
  String get dayDetails;

  // ═══════════════════════════════════════════════════════════
  // DRAWER
  // ═══════════════════════════════════════════════════════════

  @override
  String get welcome;
  @override
  String get profile;
  @override
  String get about;
  @override
  String get helpSupport;
  @override
  String get settings;

  // ═══════════════════════════════════════════════════════════
  // SETTINGS
  // ═══════════════════════════════════════════════════════════

  @override
  String get settingsTitle;
  @override
  String get appearance;
  @override
  String get language;
  @override
  String get languageBangla;
  @override
  String get languageEnglish;
  @override
  String get languageChanged;
  @override
  String get theme;
  @override
  String get lightMode;
  @override
  String get darkMode;
  @override
  String get systemDefault;
  @override
  String get themeChanged;
  @override
  String get appVersionSubtitle;
  @override
  String get privacyPolicy;
  @override
  String get privacyPolicySubtitle;
  @override
  String get termsOfService;
  @override
  String get termsOfServiceSubtitle;
  @override
  String get resetSettings;
  @override
  String get resetSettingsSubtitle;
  @override
  String get resetSettingsConfirmMessage;
  @override
  String get resetSettingsSuccessMessage;
  @override
  String get deleteAllData;
  @override
  String get deleteAllDataSubtitle;
  @override
  String get deleteAllDataConfirmMessage;
  @override
  String get deleteAllDataSuccessMessage;
  @override
  String get dataAndStorage;
  @override
  String get autoBackup;
  @override
  String get autoBackupSubtitle;

  // ═══════════════════════════════════════════════════════════
  // DATA SYNC
  // ═══════════════════════════════════════════════════════════

  @override
  String get dataUpdate;
  @override
  String get updateAllData;
  @override
  String get updateAllDataSubtitle;
  @override
  String get syncFailed;
  @override
  String get syncOffline;
  @override
  String get syncUpToDate;
  @override
  String syncUpdated(String list);
  @override
  String get syncDatasetHolidays;
  @override
  String get syncDatasetQuotes;
  @override
  String get syncDatasetWords;
  @override
  String get lastSynced;
  @override
  String get lastSyncedNever;
  @override
  String get lastSyncedJustNow;
  @override
  String lastSyncedMinutesAgo(int n);
  @override
  String lastSyncedHoursAgo(int n);
  @override
  String lastSyncedDaysAgo(int n);
  @override
  String get lastSyncedYesterday;
  @override
  String get lastSyncedUnknown;

  // ═══════════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════

  @override
  String get notifications;
  @override
  String get notificationSubtitle;
  @override
  String get notificationsPermissionRequired;
  @override
  String get notificationPermissionTitle;
  @override
  String get notificationPermissionMessage;
  @override
  String get notificationPermissionDeniedBanner;
  @override
  String get openSettings;
  @override
  String get notificationsOn;
  @override
  String get notificationsOff;
  @override
  String get holidayNotifications;
  @override
  String get holidayNotificationsSubtitle;
  @override
  String get holidayNotificationsTitle;
  @override
  String get holidayNotifOnMessage;
  @override
  String get holidayNotifOffMessage;
  @override
  String get turnOn;
  @override
  String get turnOff;
  @override
  String get enable;
  @override
  String get notNow;
  @override
  String get quoteNotifications;
  @override
  String get quoteNotificationsSubtitle;
  @override
  String get wordNotifications;
  @override
  String get wordNotificationsSubtitle;

  // ═══════════════════════════════════════════════════════════
  // HOLIDAYS SCREEN
  // ═══════════════════════════════════════════════════════════

  @override
  String get allHolidays;
  @override
  String get noHolidaysForYear;
  @override
  String get byHolidayTypes;
  @override
  String get byMonth;
  @override
  String get showLess;
  @override
  String showMore(int count);

  // ═══════════════════════════════════════════════════════════
  // CALENDAR SCREEN
  // ═══════════════════════════════════════════════════════════

  @override
  String get selectMonth;
  @override
  String get selectYear;
  @override
  String get calendarLegend;
  @override
  String get calendarHoliday;
  @override
  String get calendarEvent;
  @override
  String get calendarReminder;
  @override
  String get sectionHolidays;
  @override
  String get sectionEvents;
  @override
  String get sectionReminders;
  @override
  String get showDetails;
  @override
  String get addEvent;
  @override
  String get addReminder;
  @override
  String get editEvent;
  @override
  String get editReminder;
  @override
  String get allDay;
  @override
  String get passed;
  @override
  String formatUpcomingEventsInMonth(String monthName);
  @override
  String formatUpcomingHolidaysInMonth(String monthName);

  // ═══════════════════════════════════════════════════════════
  // EVENTS & REMINDERS
  // ═══════════════════════════════════════════════════════════

  @override
  String get eventTitle;
  @override
  String get eventSubtitle;
  @override
  String get reminderTitle;
  @override
  String get reminderSubtitle;
  @override
  String get location;
  @override
  String get locationSubtitle;
  @override
  String get description;
  @override
  String get descriptionSubtitle;
  @override
  String get notes;
  @override
  String get notesSubtitle;
  @override
  String get deleteEvent;
  @override
  String get deleteEventConfirmMessage;
  @override
  String get deleteReminder;
  @override
  String get deleteReminderConfirmMessage;
  @override
  String get eventAddedSuccess;
  @override
  String get eventUpdatedSuccess;
  @override
  String get eventDeletedSuccess;
  @override
  String get reminderAddedSuccess;
  @override
  String get reminderUpdatedSuccess;
  @override
  String get reminderDeletedSuccess;
  @override
  String get allEvents;
  @override
  String get allReminders;

  // ═══════════════════════════════════════════════════════════
  // EVENT CATEGORIES
  // ═══════════════════════════════════════════════════════════

  @override
  String get categoryWork;
  @override
  String get categoryPersonal;
  @override
  String get categoryFamily;
  @override
  String get categoryHealth;
  @override
  String get categoryEducation;
  @override
  String get categorySocial;
  @override
  String get categoryOther;

  // ═══════════════════════════════════════════════════════════
  // REMINDER PRIORITY
  // ═══════════════════════════════════════════════════════════

  @override
  String get priority;
  @override
  String get priorityLow;
  @override
  String get priorityMedium;
  @override
  String get priorityHigh;
  @override
  String get priorityUrgent;

  // ═══════════════════════════════════════════════════════════
  // QUOTES & WORDS
  // ═══════════════════════════════════════════════════════════

  @override
  String get savedQuotes;
  @override
  String get savedWords;
  @override
  String get adjustFontSize;
  @override
  String get noSavedQuotes;
  @override
  String get noSavedWords;

  // ═══════════════════════════════════════════════════════════
  // CALCULATOR
  // ═══════════════════════════════════════════════════════════

  @override
  String get calculatorTitle;
  @override
  String get fromDate;
  @override
  String get toDate;
  @override
  String get selectDate;
  @override
  String get selectFromDate;
  @override
  String get selectToDate;
  @override
  String get copyResult;
  @override
  String get copiedToClipboard;
  @override
  String get invalidDateRange;
  @override
  String get selectDatesToSeeResults;
  @override
  String get calculationResults;
  @override
  String get yearsMonthsDays;
  @override
  String get totalDays;
  @override
  String get weeksAndDays;

  // ═══════════════════════════════════════════════════════════
  // TIME UNITS
  // ═══════════════════════════════════════════════════════════

  @override
  String get year;
  @override
  String get years;
  @override
  String get month;
  @override
  String get months;
  @override
  String get day;
  @override
  String get days;
  @override
  String get week;
  @override
  String get weeks;

  // ═══════════════════════════════════════════════════════════
  // DAYS OF WEEK
  // ═══════════════════════════════════════════════════════════

  @override
  String get monday;
  @override
  String get tuesday;
  @override
  String get wednesday;
  @override
  String get thursday;
  @override
  String get friday;
  @override
  String get saturday;
  @override
  String get sunday;
  @override
  String get shortSunday;
  @override
  String get shortMonday;
  @override
  String get shortTuesday;
  @override
  String get shortWednesday;
  @override
  String get shortThursday;
  @override
  String get shortFriday;
  @override
  String get shortSaturday;

  // ═══════════════════════════════════════════════════════════
  // MONTHS — GREGORIAN
  // ═══════════════════════════════════════════════════════════

  @override
  String get january;
  @override
  String get february;
  @override
  String get march;
  @override
  String get april;
  @override
  String get may;
  @override
  String get june;
  @override
  String get july;
  @override
  String get august;
  @override
  String get september;
  @override
  String get october;
  @override
  String get november;
  @override
  String get december;

  // ═══════════════════════════════════════════════════════════
  // MONTHS — BENGALI
  // ═══════════════════════════════════════════════════════════

  @override
  String get boishakh;
  @override
  String get jyoishtho;
  @override
  String get asharh;
  @override
  String get srabon;
  @override
  String get bhadro;
  @override
  String get ashwin;
  @override
  String get kartik;
  @override
  String get ogrohayon;
  @override
  String get poush;
  @override
  String get magh;
  @override
  String get falgun;
  @override
  String get choitra;

  // ═══════════════════════════════════════════════════════════
  // SEASONS
  // ═══════════════════════════════════════════════════════════

  @override
  String get seasonGrishmo;
  @override
  String get seasonBorsha;
  @override
  String get seasonSharat;
  @override
  String get seasonHemonto;
  @override
  String get seasonSheet;
  @override
  String get seasonBosonto;
  @override
  String get seasonSpring;
  @override
  String get seasonSummer;
  @override
  String get seasonAutumn;
  @override
  String get seasonWinter;
}

class PonjiLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const PonjiLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'bn':
        return PonjiLocalizationsBn();
      case 'en':
        return PonjiLocalizationsEn();
      default:
        return PonjiLocalizationsBn();
    }
  }

  @override
  bool shouldReload(PonjiLocalizationsDelegate old) => false;
}
