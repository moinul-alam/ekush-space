// lib/l10n/jhuri_localizations.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ekush_core/ekush_core.dart';
import '../config/jhuri_constants.dart';

abstract class JhuriLocalizations extends AppLocalizations {
  // ═══════════════════════════════════════════════════════════
  // STATIC ACCESS METHOD
  // ═══════════════════════════════════════════════════════════

  static JhuriLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final delegate = const JhuriLocalizationsDelegate();
    return delegate.load(locale) as JhuriLocalizations;
  }

  // ═══════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════

  @override
  String get appName => 'ঝুড়ি';

  @override
  String get appTitle => 'Jhuri – Smart Grocery List';

  @override
  String get welcomeToApp => 'ঝুড়িতে স্বাগতম';

  // ═══════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════

  @override
  String get navHome => 'হোম';

  @override
  String get navCalendar => 'ক্যালেন্ডার';

  @override
  String get navHolidays => 'ছুটির দিন';

  @override
  String get navCalculator => 'ক্যালকুলেটর';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get navMore => 'আরও';

  @override
  String get navAddEvent => 'ইভেন্ট যোগ করুন';

  @override
  String get navAddReminder => 'রিমাইন্ডার যোগ করুন';

  @override
  String get navCalculatorFull => 'ক্যালকুলেটর';

  @override
  String get navSavedQuotes => 'সংরক্ষিত উক্তি';

  @override
  String get navSavedWords => 'সংরক্ষিত শব্দ';

  @override
  String get navAbout => 'সম্পর্কে';

  // ═══════════════════════════════════════════════════════════
  // COMMON ACTIONS
  // ═══════════════════════════════════════════════════════════

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get cancel => 'বাতিল';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get delete => 'মুছুন';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get add => 'যোগ করুন';

  @override
  String get search => 'অনুসন্ধান';

  @override
  String get refresh => 'রিফ্রেশ';

  @override
  String get close => 'বন্ধ';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get back => 'পিছনে';

  @override
  String get next => 'পরবর্তী';

  @override
  String get previous => 'আগে';

  @override
  String get loading => 'লোড হচ্ছে';

  @override
  String get error => 'ত্রুটি';

  @override
  String get success => 'সফল';

  @override
  String get retry => 'পুনরায় চেষ্টা';

  @override
  String get confirm => 'নিশ্চিত';

  @override
  String get reset => 'রিসেট';

  @override
  String get share => 'শেয়ার';

  @override
  String get sync => 'সিঙ্ক';

  // ═══════════════════════════════════════════════════════════
  // JHURI SPECIFIC STRINGS
  // ═══════════════════════════════════════════════════════════

  // Onboarding
  String get onboardingWelcome => 'ঝুড়িতে স্বাগতম';
  String get onboardingTagline => 'বাজারের ফর্দ, হাতের মুঠোয়';
  String get onboardingGetStarted => 'শুরু করুন';
  String get onboardingLanguageTitle => 'ভাষা নির্বাচন';
  String get onboardingNotificationTitle => 'বিজ্ঞপ্তি';
  String get onboardingNotificationMessage =>
      'বাজারের জন্য রিমাইন্ডার পেতে বিজ্ঞপ্তি অনুমতি দিন';
  String get onboardingAllow => 'অনুমতি দিন';
  String get onboardingNotNow => 'এখন না';

  // Home Screen
  String get homeTitle => 'ঝুড়ি';
  String get homeEmptyTitle => 'বাজারের কোনো ফর্দ নেই';
  String get homeEmptyMessage => '"+" বাটন চেপে নতুন ফর্দ তৈরি করুন';
  String get today => 'আজ';
  String get tomorrow => 'আগামীকাল';
  String get upcoming => 'আসন্ন';
  String get past => 'অতীত';
  String get newList => 'নতুন ফর্দ';
  String get itemsCount => 'টি আইটেম';
  String get estimatedTotal => 'আনুমানিক মোট';
  String get completionProgress => 'কেনা হয়েছে';

  // List Management
  String get createList => 'নতুন ফর্দ তৈরি করুন';
  String get editList => 'ফর্দ সম্পাদনা করুন';
  String get listTitle => 'ফর্দের শিরোনাম';
  String get listTitleHint => 'যেমন: সাপ্তাহিক বাজার';
  String get buyDate => 'কেনার তারিখ';
  String get reminder => 'রিমাইন্ডার';
  String get reminderTime => 'রিমাইন্ডারের সময়';
  String get addItem => 'আইটেম যোগ করুন';
  String get noItems => 'কোনো আইটেম নেই';
  String get atLeastOneItem => 'অন্তত একটি আইটেম যোগ করুন';
  String get runningTotal => 'মোট আনুমানিক';

  // Category Browser
  String get whatToBuy => 'কী কিনবেন?';
  String get categories => 'বিভাগ';
  String get customItem => '➕ কাস্টম';

  // Item Picker
  String get quantity => 'পরিমাণ';
  String get unit => 'একক';
  String get price => 'মূল্য';
  String get addTo => 'যোগ করুন';
  String get customItemName => 'কাস্টম আইটেমের নাম';
  String get customItemNameHint => 'আইটেমের নাম লিখুন';
  String get selectCategory => 'বিভাগ নির্বাচন করুন';

  // Shopping Mode
  String get shoppingMode => 'কেনাকাটা মোড';
  String get markAsBought => 'কেনা হয়েছে';
  String get allBought => 'সব কেনা হয়েছে! 🎉';
  String get shareList => 'ফর্দ শেয়ার করুন';

  // Settings
  String get settingsTitle => 'সেটিংস';
  String get appearance => 'প্রদর্শনী';
  String get language => 'ভাষা';
  String get theme => 'থিম';
  String get lightMode => 'লাইট মোড';
  String get darkMode => 'ডার্ক মোড';
  String get systemDefault => 'সিস্টেম ডিফল্ট';
  String get shopping => 'বাজার';
  String get showPriceTotal => 'মোট মূল্য দেখান';
  String get defaultUnit => 'ডিফল্ট একক';
  String get currencySymbol => 'মুদ্রা প্রতীক';
  String get notifications => 'বিজ্ঞপ্তি';
  String get notificationsEnabled => 'বিজ্ঞপ্তি সক্রিয়';
  String get lists => 'তালিকা';
  String get listSortOrder => 'ফর্দ সাজানো';
  String get newestFirst => 'নতুন আগে';
  String get oldestFirst => 'পুরনো আগে';

  // Messages
  String get comingSoon => 'শীঘ্রই আসছে';
  String get englishComingSoon => 'শীঘ্রই আসছে';
  String get shareError => 'শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন';
  String get appRestartRequired => 'অ্যাপ পুনরায় চালু করুন';

  // ═══════════════════════════════════════════════════════════
  // IMPLEMENTED FROM APPLOCALIZATIONS
  // ═══════════════════════════════════════════════════════════

  @override
  String get calendarShortGregorian => 'ইংরেজি';

  @override
  String get calendarShortBangla => 'বাংলা';

  @override
  String get calendarShortHijri => 'হিজরি';

  @override
  String get featureComingSoon => 'বৈশিষ্ট্য শীঘ্রই আসছে';

  @override
  String get loadingData => 'ডেটা লোড হচ্ছে';

  @override
  String get failedToLoadData => 'ডেটা লোড করতে ব্যর্থ';

  @override
  String get noDataAvailable => 'কোনো ডেটা নেই';

  @override
  String get pageNotFound => 'পৃষ্ঠা পাওয়া যায়নি';

  @override
  String get goToHome => 'হোমে যান';

  @override
  String get backToHome => 'হোমে ফিরুন';

  // Continue with all required AppLocalizations implementations...
  // For brevity, I'm implementing the essential ones for Phase 2

  @override
  String get goodMorning => 'সুপ্রভাত';

  @override
  String get goodAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get goodEvening => 'শুভ সন্ধ্যা';

  @override
  String get goodNight => 'শুভরাত্রি';

  @override
  String get todayDate => 'আজকের তারিখ';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get inDays => 'দিন পরে';

  @override
  String get daysAgo => 'দিন আগে';

  @override
  String get upcomingHolidays => 'আসন্ন ছুটির দিন';

  @override
  String get upcomingEvents => 'আসন্ন ইভেন্ট';

  @override
  String get noUpcomingEvents => 'কোনো আসন্ন ইভেন্ট নেই';

  @override
  String get noUpcomingHolidays => 'কোনো আসন্ন ছুটির দিন নেই';

  // Add minimal implementations for remaining abstract methods
  // These will be fully implemented in later phases
}

class JhuriLocalizationsDelegate
    extends LocalizationsDelegate<JhuriLocalizations> {
  const JhuriLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => JhuriConstants.isLocaleSupported(locale);

  @override
  Future<JhuriLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'bn':
        return JhuriLocalizationsBn();
      case 'en':
        return JhuriLocalizationsEn();
      default:
        return JhuriLocalizationsBn();
    }
  }

  @override
  bool shouldReload(JhuriLocalizationsDelegate old) => false;
}

// Bangla Implementation
class JhuriLocalizationsBn extends JhuriLocalizations {
  @override
  Locale get locale => const Locale('bn', 'BD');

  @override
  String translate(String key) {
    // Basic translation map for Phase 2
    final translations = {
      'app_name': appName,
      'home': navHome,
      'settings': navSettings,
      'cancel': cancel,
      'save': save,
      'delete': delete,
      'add': add,
      // Add more as needed
    };
    return translations[key] ?? key;
  }

  // Implement remaining required methods with Bangla text
  // For Phase 2, minimal implementation

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get helpSupport => 'সাহায্য ও সহায়তা';

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get appearance => 'প্রদর্শনী';

  @override
  String get language => 'ভাষা';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'ভাষা পরিবর্তন হয়েছে';

  @override
  String get theme => 'থিম';

  @override
  String get lightMode => 'লাইট মোড';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get systemDefault => 'সিস্টেম ডিফল্ট';

  @override
  String get themeChanged => 'থিম পরিবর্তন হয়েছে';

  @override
  String get appVersionSubtitle => 'সংস্করণ';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get privacyPolicySubtitle => 'আমাদের গোপনীয়তা নীতি';

  @override
  String get termsOfService => 'ব্যবহারের শর্তাবলী';

  @override
  String get termsOfServiceSubtitle => 'ব্যবহারের শর্তাবলী';

  @override
  String get resetSettings => 'সেটিংস রিসেট';

  @override
  String get resetSettingsSubtitle => 'সব সেটিংস রিসেট করুন';

  @override
  String get resetSettingsConfirmMessage => 'আপনি কি সব সেটিংস রিসেট করতে চান?';

  @override
  String get resetSettingsSuccessMessage => 'সেটিংস রিসেট হয়েছে';

  @override
  String get deleteAllData => 'সব ডেটা মুছুন';

  @override
  String get deleteAllDataSubtitle => 'সব ডেটা মুছে ফেলুন';

  @override
  String get deleteAllDataConfirmMessage => 'আপনি কি সব ডেটা মুছে ফেলতে চান?';

  @override
  String get deleteAllDataSuccessMessage => 'সব ডেটা মুছে ফেলা হয়েছে';

  @override
  String get dataAndStorage => 'ডেটা ও স্টোরেজ';

  @override
  String get autoBackup => 'অটো ব্যাকআপ';

  @override
  String get autoBackupSubtitle => 'স্বয়ংক্রিয় ব্যাকআপ';

  @override
  String get dataUpdate => 'ডেটা আপডেট';

  @override
  String get updateAllData => 'সব ডেটা আপডেট';

  @override
  String get updateAllDataSubtitle => 'সব ডেটা আপডেট করুন';

  @override
  String get syncFailed => 'সিঙ্ক ব্যর্থ';

  @override
  String get syncOffline => 'অফলাইন';

  @override
  String get syncUpToDate => 'আপডেটেড';

  @override
  String syncUpdated(String list) => '$list আপডেট হয়েছে';

  @override
  String get syncDatasetHolidays => 'ছুটির দিন সিঙ্ক';

  @override
  String get syncDatasetQuotes => 'উক্তি সিঙ্ক';

  @override
  String get syncDatasetWords => 'শব্দ সিঙ্ক';

  @override
  String get lastSynced => 'সর্বশেষ সিঙ্ক';

  @override
  String get lastSyncedNever => 'কখনো না';

  @override
  String get lastSyncedJustNow => 'এইমাত্র';

  @override
  String lastSyncedMinutesAgo(int n) => '$n মিনিট আগে';

  @override
  String lastSyncedHoursAgo(int n) => '$n ঘণ্টা আগে';

  @override
  String lastSyncedDaysAgo(int n) => '$n দিন আগে';

  @override
  String get lastSyncedYesterday => 'গতকাল';

  @override
  String get lastSyncedUnknown => 'অজানা';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get notificationSubtitle => 'বিজ্ঞপ্তি সেটিংস';

  @override
  String get notificationsPermissionRequired => 'বিজ্ঞপ্তি অনুমতি প্রয়োজন';

  @override
  String get notificationPermissionTitle => 'বিজ্ঞপ্তি অনুমতি';

  @override
  String get notificationPermissionMessage => 'বিজ্ঞপ্তি পেতে অনুমতি দিন';

  @override
  String get notificationPermissionDeniedBanner => 'বিজ্ঞপ্তি অনুমতি নাকচ';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get notificationsOn => 'বিজ্ঞপ্তি চালু';

  @override
  String get notificationsOff => 'বিজ্ঞপ্তি বন্ধ';

  @override
  String get holidayNotifications => 'ছুটির দিন বিজ্ঞপ্তি';

  @override
  String get holidayNotificationsSubtitle => 'ছুটির দিনের বিজ্ঞপ্তি';

  @override
  String get holidayNotificationsTitle => 'ছুটির দিন বিজ্ঞপ্তি';

  @override
  String get holidayNotifOnMessage => 'ছুটির দিন বিজ্ঞপ্তি চালু';

  @override
  String get holidayNotifOffMessage => 'ছুটির দিন বিজ্ঞপ্তি বন্ধ';

  @override
  String get turnOn => 'চালু';

  @override
  String get turnOff => 'বন্ধ';

  @override
  String get notNow => 'এখন না';

  @override
  String get enable => 'সক্রিয়';

  @override
  String get quoteNotifications => 'উক্তি বিজ্ঞপ্তি';

  @override
  String get quoteNotificationsSubtitle => 'উক্তি বিজ্ঞপ্তি';

  @override
  String get wordNotifications => 'শব্দ বিজ্ঞপ্তি';

  @override
  String get wordNotificationsSubtitle => 'শব্দ বিজ্ঞপ্তি';

  @override
  String get allHolidays => 'সব ছুটির দিন';

  @override
  String get noHolidaysForYear => 'এই বছরে কোনো ছুটির দিন নেই';

  @override
  String get byHolidayTypes => 'ছুটির ধরন অনুযায়ী';

  @override
  String get byMonth => 'মাস অনুযায়ী';

  @override
  String get showLess => 'কম দেখান';

  @override
  String showMore(int count) => 'আরও $count টি';

  @override
  String get selectMonth => 'মাস নির্বাচন';

  @override
  String get selectYear => 'বছর নির্বাচন';

  @override
  String get calendarLegend => 'ক্যালেন্ডার লিজেন্ড';

  @override
  String get calendarHoliday => 'ছুটির দিন';

  @override
  String get calendarEvent => 'ইভেন্ট';

  @override
  String get calendarReminder => 'রিমাইন্ডার';

  @override
  String get sectionHolidays => 'ছুটির দিন';

  @override
  String get sectionEvents => 'ইভেন্ট';

  @override
  String get sectionReminders => 'রিমাইন্ডার';

  @override
  String get showDetails => 'বিস্তারিত দেখান';

  @override
  String get addEvent => 'ইভেন্ট যোগ';

  @override
  String get addReminder => 'রিমাইন্ডার যোগ';

  @override
  String get editEvent => 'ইভেন্ট সম্পাদনা';

  @override
  String get editReminder => 'রিমাইন্ডার সম্পাদনা';

  @override
  String get allDay => 'সারাদিন';

  @override
  String get passed => 'অতীত';

  @override
  String formatUpcomingEventsInMonth(String monthName) =>
      '$monthName এর আসন্ন ইভেন্ট';

  @override
  String formatUpcomingHolidaysInMonth(String monthName) =>
      '$monthName এর আসন্ন ছুটির দিন';

  @override
  String get eventTitle => 'ইভেন্ট শিরোনাম';

  @override
  String get eventSubtitle => 'ইভেন্ট সাবটাইটেল';

  @override
  String get reminderTitle => 'রিমাইন্ডার শিরোনাম';

  @override
  String get reminderSubtitle => 'রিমাইন্ডার সাবটাইটেল';

  @override
  String get location => 'অবস্থান';

  @override
  String get locationSubtitle => 'অবস্থান সাবটাইটেল';

  @override
  String get description => 'বর্ণনা';

  @override
  String get descriptionSubtitle => 'বর্ণনা সাবটাইটেল';

  @override
  String get notes => 'নোট';

  @override
  String get notesSubtitle => 'নোট সাবটাইটেল';

  @override
  String get deleteEvent => 'ইভেন্ট মুছুন';

  @override
  String get deleteEventConfirmMessage => 'ইভেন্ট মুছে ফেলবেন?';

  @override
  String get deleteReminder => 'রিমাইন্ডার মুছুন';

  @override
  String get deleteReminderConfirmMessage => 'রিমাইন্ডার মুছে ফেলবেন?';

  @override
  String get eventAddedSuccess => 'ইভেন্ট যোগ হয়েছে';

  @override
  String get eventUpdatedSuccess => 'ইভেন্ট আপডেট হয়েছে';

  @override
  String get eventDeletedSuccess => 'ইভেন্ট মুছে ফেলা হয়েছে';

  @override
  String get reminderAddedSuccess => 'রিমাইন্ডার যোগ হয়েছে';

  @override
  String get reminderUpdatedSuccess => 'রিমাইন্ডার আপডেট হয়েছে';

  @override
  String get reminderDeletedSuccess => 'রিমাইন্ডার মুছে ফেলা হয়েছে';

  @override
  String get allEvents => 'সব ইভেন্ট';

  @override
  String get allReminders => 'সব রিমাইন্ডার';

  @override
  String get categoryWork => 'কাজ';

  @override
  String get categoryPersonal => 'ব্যক্তিগত';

  @override
  String get categoryFamily => 'পরিবার';

  @override
  String get categoryHealth => 'স্বাস্থ্য';

  @override
  String get categoryEducation => 'শিক্ষা';

  @override
  String get categorySocial => 'সামাজিক';

  @override
  String get categoryOther => 'অন্যান্য';

  @override
  String get priority => 'অগ্রাধিকার';

  @override
  String get priorityLow => 'নিম্ন';

  @override
  String get priorityMedium => 'মাঝারি';

  @override
  String get priorityHigh => 'উচ্চ';

  @override
  String get priorityUrgent => 'জরুরি';

  @override
  String get savedQuotes => 'সংরক্ষিত উক্তি';

  @override
  String get savedWords => 'সংরক্ষিত শব্দ';

  @override
  String get adjustFontSize => 'ফন্ট সাইজ সমন্বয়';

  @override
  String get noSavedQuotes => 'কোনো সংরক্ষিত উক্তি নেই';

  @override
  String get noSavedWords => 'কোনো সংরক্ষিত শব্দ নেই';

  @override
  String get calculatorTitle => 'ক্যালকুলেটর';

  @override
  String get fromDate => 'শুরু তারিখ';

  @override
  String get toDate => 'শেষ তারিখ';

  @override
  String get selectDate => 'তারিখ নির্বাচন';

  @override
  String get selectFromDate => 'শুরু তারিখ নির্বাচন';

  @override
  String get selectToDate => 'শেষ তারিখ নির্বাচন';

  @override
  String get copyResult => 'ফলাফল কপি';

  @override
  String get copiedToClipboard => 'ক্লিপবোর্ডে কপি হয়েছে';

  @override
  String get invalidDateRange => 'অবৈধ তারিখ সীমা';

  @override
  String get selectDatesToSeeResults => 'ফলাফল দেখতে তারিখ নির্বাচন করুন';

  @override
  String get calculationResults => 'হিসাবের ফলাফল';

  @override
  String get yearsMonthsDays => 'বছর মাস দিন';

  @override
  String get totalDays => 'মোট দিন';

  @override
  String get weeksAndDays => 'সপ্তাহ ও দিন';

  @override
  String get year => 'বছর';

  @override
  String get years => 'বছর';

  @override
  String get month => 'মাস';

  @override
  String get months => 'মাস';

  @override
  String get day => 'দিন';

  @override
  String get days => 'দিন';

  @override
  String get week => 'সপ্তাহ';

  @override
  String get weeks => 'সপ্তাহ';

  @override
  String get monday => 'সোমবার';

  @override
  String get tuesday => 'মঙ্গলবার';

  @override
  String get wednesday => 'বুধবার';

  @override
  String get thursday => 'বৃহস্পতিবার';

  @override
  String get friday => 'শুক্রবার';

  @override
  String get saturday => 'শনিবার';

  @override
  String get sunday => 'রবিবার';

  @override
  String get shortSunday => 'রবি';

  @override
  String get shortMonday => 'সোম';

  @override
  String get shortTuesday => 'মঙ্গল';

  @override
  String get shortWednesday => 'বুধ';

  @override
  String get shortThursday => 'বৃহস্পতি';

  @override
  String get shortFriday => 'শুক্র';

  @override
  String get shortSaturday => 'শনি';

  @override
  String get january => 'জানুয়ারি';

  @override
  String get february => 'ফেব্রুয়ারি';

  @override
  String get march => 'মার্চ';

  @override
  String get april => 'এপ্রিল';

  @override
  String get may => 'মে';

  @override
  String get june => 'জুন';

  @override
  String get july => 'জুলাই';

  @override
  String get august => 'আগস্ট';

  @override
  String get september => 'সেপ্টেম্বর';

  @override
  String get october => 'অক্টোবর';

  @override
  String get november => 'নভেম্বর';

  @override
  String get december => 'ডিসেম্বর';

  @override
  String get boishakh => 'বৈশাখ';

  @override
  String get jyoishtho => 'জ্যৈষ্ঠ';

  @override
  String get asharh => 'আষাঢ়';

  @override
  String get srabon => 'শ্রাবণ';

  @override
  String get bhadro => 'ভাদ্র';

  @override
  String get ashwin => 'আশ্বিন';

  @override
  String get kartik => 'কার্তিক';

  @override
  String get ogrohayon => 'অগ্রহায়ণ';

  @override
  String get poush => 'পৌষ';

  @override
  String get magh => 'মাঘ';

  @override
  String get falgun => 'ফাল্গুন';

  @override
  String get choitra => 'চৈত্র';

  @override
  String get seasonGrishmo => 'গ্রীষ্ম';

  @override
  String get seasonBorsha => 'বর্ষা';

  @override
  String get seasonSharat => 'শরৎ';

  @override
  String get seasonHemonto => 'হেমন্ত';

  @override
  String get seasonSheet => 'শীত';

  @override
  String get seasonBosonto => 'বসন্ত';

  @override
  String get seasonSpring => 'বসন্ত';

  @override
  String get seasonSummer => 'গ্রীষ্ম';

  @override
  String get seasonAutumn => 'শরৎ';

  @override
  String get seasonWinter => 'শীত';

  @override
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return january;
      case 2:
        return february;
      case 3:
        return march;
      case 4:
        return april;
      case 5:
        return may;
      case 6:
        return june;
      case 7:
        return july;
      case 8:
        return august;
      case 9:
        return september;
      case 10:
        return october;
      case 11:
        return november;
      case 12:
        return december;
      default:
        return '';
    }
  }

  @override
  String getMonthAbbreviation(int month) {
    final name = getMonthName(month);
    if (name.isEmpty) return '';
    if (name.length <= 4) return name;
    return name.substring(0, 4);
  }

  @override
  String getBanglaMonthName(int month) {
    switch (month) {
      case 1:
        return boishakh;
      case 2:
        return jyoishtho;
      case 3:
        return asharh;
      case 4:
        return srabon;
      case 5:
        return bhadro;
      case 6:
        return ashwin;
      case 7:
        return kartik;
      case 8:
        return ogrohayon;
      case 9:
        return poush;
      case 10:
        return magh;
      case 11:
        return falgun;
      case 12:
        return choitra;
      default:
        return '';
    }
  }

  @override
  String getDayName(int day) {
    switch (day) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return '';
    }
  }

  @override
  String getBengaliSeasonName(int monthNumber) {
    if (monthNumber >= 1 && monthNumber <= 2) return seasonGrishmo;
    if (monthNumber >= 3 && monthNumber <= 4) return seasonBorsha;
    if (monthNumber >= 5 && monthNumber <= 6) return seasonSharat;
    if (monthNumber >= 7 && monthNumber <= 8) return seasonHemonto;
    if (monthNumber >= 9 && monthNumber <= 10) return seasonSheet;
    return seasonBosonto;
  }

  @override
  String getGregorianSeasonName(int bengaliMonthNumber) {
    if (bengaliMonthNumber >= 1 && bengaliMonthNumber <= 2) return 'Summer';
    if (bengaliMonthNumber >= 3 && bengaliMonthNumber <= 4)
      return 'Rainy Season';
    if (bengaliMonthNumber >= 5 && bengaliMonthNumber <= 6) return 'Autumn';
    if (bengaliMonthNumber >= 7 && bengaliMonthNumber <= 8)
      return 'Late Autumn';
    if (bengaliMonthNumber >= 9 && bengaliMonthNumber <= 10) return 'Winter';
    return 'Spring';
  }

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get englishComingSoon => 'শীঘ্রই আসছে';

  @override
  String get shareError => 'শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন';

  @override
  String get appRestartRequired => 'অ্যাপ পুনরায় চালু করুন';

  @override
  String get example => 'উদাহরণ';

  @override
  String get meaningBengali => 'বাংলা অর্থ';

  @override
  String get meaningEnglish => 'ইংরেজি অর্থ';

  @override
  String get dayDetails => 'দিনের বিবরণ';

  @override
  String get pronunciation => 'উচ্চারণ';

  @override
  String get pronunciationTitle => 'উচ্চারণ শিরোনাম';

  @override
  String get pronunciationSubtitle => 'উচ্চারণ সাবটাইটেল';

  @override
  String get quoteOfTheDay => 'দিনের উক্তি';

  @override
  String get settings => 'সেটিংস';

  @override
  String get synonym => 'সমার্থক শব্দ';

  @override
  String get todayIsDayName => 'আজকের দিন';

  @override
  String get wordOfTheDay => 'দিনের শব্দ';
}

// English Implementation
class JhuriLocalizationsEn extends JhuriLocalizations {
  @override
  Locale get locale => const Locale('en', 'US');

  @override
  String get appName => 'Jhuri';

  @override
  String get appTitle => 'Jhuri – Smart Grocery List';

  @override
  String get welcomeToApp => 'Welcome to Jhuri';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get refresh => 'Refresh';

  @override
  String get close => 'Close';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get loading => 'Loading';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get retry => 'Retry';

  @override
  String get confirm => 'Confirm';

  @override
  String get reset => 'Reset';

  @override
  String get share => 'Share';

  @override
  String get sync => 'Sync';

  @override
  String get calendarShortGregorian => 'Gregorian';

  @override
  String get calendarShortBangla => 'Bangla';

  @override
  String get calendarShortHijri => 'Hijri';

  @override
  String get featureComingSoon => 'Feature coming soon';

  @override
  String get loadingData => 'Loading data';

  @override
  String get failedToLoadData => 'Failed to load data';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get goodNight => 'Good Night';

  @override
  String get todayDate => 'Today\'s Date';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get inDays => 'in days';

  @override
  String get daysAgo => 'days ago';

  @override
  String get upcomingHolidays => 'Upcoming Holidays';

  @override
  String get upcomingEvents => 'Upcoming Events';

  @override
  String get noUpcomingEvents => 'No upcoming events';

  @override
  String get noUpcomingHolidays => 'No upcoming holidays';

  @override
  String translate(String key) {
    // Basic translation map for Phase 2
    final translations = {
      'app_name': appName,
      'home': navHome,
      'settings': navSettings,
      'cancel': cancel,
      'save': save,
      'delete': delete,
      'add': add,
      // Add more as needed
    };
    return translations[key] ?? key;
  }

  // Jhuri-specific English strings
  @override
  String get onboardingWelcome => 'Welcome to Jhuri';
  @override
  String get onboardingTagline => 'Plan Better. Shop Easier.';
  @override
  String get onboardingGetStarted => 'Get Started';
  @override
  String get onboardingLanguageTitle => 'Language Selection';
  @override
  String get onboardingNotificationTitle => 'Notifications';
  @override
  String get onboardingNotificationMessage =>
      'Allow notifications to receive shopping reminders';
  @override
  String get onboardingAllow => 'Allow';
  @override
  String get onboardingNotNow => 'Not Now';

  @override
  String get homeTitle => 'Jhuri';
  @override
  String get homeEmptyTitle => 'No shopping lists';
  @override
  String get homeEmptyMessage => 'Press "+" to create a new list';
  @override
  String get newList => 'New List';
  @override
  String get itemsCount => 'items';
  @override
  String get estimatedTotal => 'Est. Total';
  @override
  String get completionProgress => 'bought';

  @override
  String get createList => 'Create New List';
  @override
  String get editList => 'Edit List';
  @override
  String get listTitle => 'List Title';
  @override
  String get listTitleHint => 'e.g., Weekly Shopping';
  @override
  String get buyDate => 'Shopping Date';
  @override
  String get reminder => 'Reminder';
  @override
  String get reminderTime => 'Reminder Time';
  @override
  String get addItem => 'Add Item';
  @override
  String get noItems => 'No items';
  @override
  String get atLeastOneItem => 'Add at least one item';
  @override
  String get runningTotal => 'Running Total';

  @override
  String get whatToBuy => 'What to Buy?';
  @override
  String get categories => 'Categories';
  @override
  String get customItem => '➕ Custom';

  @override
  String get quantity => 'Quantity';
  @override
  String get unit => 'Unit';
  @override
  String get price => 'Price';
  @override
  String get addTo => 'Add';
  @override
  String get customItemName => 'Custom Item Name';
  @override
  String get customItemNameHint => 'Enter item name';
  @override
  String get selectCategory => 'Select Category';

  @override
  String get shoppingMode => 'Shopping Mode';
  @override
  String get markAsBought => 'Mark as Bought';
  @override
  String get allBought => 'All Bought! 🎉';
  @override
  String get shareList => 'Share List';

  @override
  String get settingsTitle => 'Settings';
  @override
  String get appearance => 'Appearance';
  @override
  String get language => 'Language';
  @override
  String get theme => 'Theme';
  @override
  String get lightMode => 'Light Mode';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get systemDefault => 'System Default';
  @override
  String get shopping => 'Shopping';
  @override
  String get showPriceTotal => 'Show Price Total';
  @override
  String get defaultUnit => 'Default Unit';
  @override
  String get currencySymbol => 'Currency Symbol';
  @override
  String get notifications => 'Notifications';
  @override
  String get notificationsEnabled => 'Notifications Enabled';
  @override
  String get lists => 'Lists';
  @override
  String get listSortOrder => 'List Sort Order';
  @override
  String get newestFirst => 'Newest First';
  @override
  String get oldestFirst => 'Oldest First';

  @override
  String get comingSoon => 'Coming Soon';
  @override
  String get englishComingSoon => 'Coming Soon';
  @override
  String get shareError => 'Problem sharing. Please try again';

  @override
  String get appRestartRequired => 'Restart App';

  // Add minimal implementations for remaining abstract methods

  @override
  String get welcome => 'Welcome';

  @override
  String get profile => 'Profile';

  @override
  String get about => 'About';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'Language Changed';

  @override
  String get themeChanged => 'Theme Changed';

  @override
  String get appVersionSubtitle => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Our Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Terms of Service';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get resetSettingsSubtitle => 'Reset all settings';

  @override
  String get resetSettingsConfirmMessage => 'Reset all settings?';

  @override
  String get resetSettingsSuccessMessage => 'Settings reset';

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get deleteAllDataSubtitle => 'Delete all data';

  @override
  String get deleteAllDataConfirmMessage => 'Delete all data?';

  @override
  String get deleteAllDataSuccessMessage => 'All data deleted';

  @override
  String get dataAndStorage => 'Data & Storage';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get autoBackupSubtitle => 'Automatic backup';

  @override
  String get dataUpdate => 'Data Update';

  @override
  String get updateAllData => 'Update All Data';

  @override
  String get updateAllDataSubtitle => 'Update all data';

  @override
  String get syncFailed => 'Sync Failed';

  @override
  String get syncOffline => 'Offline';

  @override
  String get syncUpToDate => 'Up to Date';

  @override
  String syncUpdated(String list) => '$list updated';

  @override
  String get syncDatasetHolidays => 'Holiday Sync';

  @override
  String get syncDatasetQuotes => 'Quote Sync';

  @override
  String get syncDatasetWords => 'Word Sync';

  @override
  String get lastSynced => 'Last Sync';

  @override
  String get lastSyncedNever => 'Never';

  @override
  String get lastSyncedJustNow => 'Just Now';

  @override
  String lastSyncedMinutesAgo(int n) => '$n minutes ago';

  @override
  String lastSyncedHoursAgo(int n) => '$n hours ago';

  @override
  String lastSyncedDaysAgo(int n) => '$n days ago';

  @override
  String get lastSyncedYesterday => 'Yesterday';

  @override
  String get lastSyncedUnknown => 'Unknown';

  @override
  String get notificationSubtitle => 'Notification Settings';

  @override
  String get notificationsPermissionRequired =>
      'Notification Permission Required';

  @override
  String get notificationPermissionTitle => 'Notification Permission';

  @override
  String get notificationPermissionMessage => 'Allow notifications';

  @override
  String get notificationPermissionDeniedBanner =>
      'Notification Permission Denied';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get notificationsOn => 'Notifications On';

  @override
  String get notificationsOff => 'Notifications Off';

  @override
  String get holidayNotifications => 'Holiday Notifications';

  @override
  String get holidayNotificationsSubtitle => 'Holiday notifications';

  @override
  String get holidayNotificationsTitle => 'Holiday Notifications';

  @override
  String get holidayNotifOnMessage => 'Holiday notifications on';

  @override
  String get holidayNotifOffMessage => 'Holiday notifications off';

  @override
  String get turnOn => 'Turn On';

  @override
  String get turnOff => 'Turn Off';

  @override
  String get notNow => 'Not Now';

  @override
  String get enable => 'Enable';

  @override
  String get quoteNotifications => 'Quote Notifications';

  @override
  String get quoteNotificationsSubtitle => 'Quote notifications';

  @override
  String get wordNotifications => 'Word Notifications';

  @override
  String get wordNotificationsSubtitle => 'Word notifications';

  @override
  String get allHolidays => 'All Holidays';

  @override
  String get noHolidaysForYear => 'No holidays for this year';

  @override
  String get byHolidayTypes => 'By Holiday Types';

  @override
  String get byMonth => 'By Month';

  @override
  String get showLess => 'Show Less';

  @override
  String showMore(int count) => '$count more';

  @override
  String get selectMonth => 'Select Month';

  @override
  String get selectYear => 'Select Year';

  @override
  String get calendarLegend => 'Calendar Legend';

  @override
  String get calendarHoliday => 'Holiday';

  @override
  String get calendarEvent => 'Event';

  @override
  String get calendarReminder => 'Reminder';

  @override
  String get sectionHolidays => 'Holidays';

  @override
  String get sectionEvents => 'Events';

  @override
  String get sectionReminders => 'Reminders';

  @override
  String get showDetails => 'Show Details';

  @override
  String get addEvent => 'Add Event';

  @override
  String get addReminder => 'Add Reminder';

  @override
  String get editEvent => 'Edit Event';

  @override
  String get editReminder => 'Edit Reminder';

  @override
  String get allDay => 'All Day';

  @override
  String get passed => 'Passed';

  @override
  String formatUpcomingEventsInMonth(String monthName) =>
      'Upcoming Events in $monthName';

  @override
  String formatUpcomingHolidaysInMonth(String monthName) =>
      'Upcoming Holidays in $monthName';

  @override
  String get eventTitle => 'Event Title';

  @override
  String get eventSubtitle => 'Event Subtitle';

  @override
  String get reminderTitle => 'Reminder Title';

  @override
  String get reminderSubtitle => 'Reminder Subtitle';

  @override
  String get location => 'Location';

  @override
  String get locationSubtitle => 'Location Subtitle';

  @override
  String get description => 'Description';

  @override
  String get descriptionSubtitle => 'Description Subtitle';

  @override
  String get notes => 'Notes';

  @override
  String get notesSubtitle => 'Notes Subtitle';

  @override
  String get deleteEvent => 'Delete Event';

  @override
  String get deleteEventConfirmMessage => 'Delete event?';

  @override
  String get deleteReminder => 'Delete Reminder';

  @override
  String get deleteReminderConfirmMessage => 'Delete reminder?';

  @override
  String get eventAddedSuccess => 'Event added';

  @override
  String get eventUpdatedSuccess => 'Event updated';

  @override
  String get eventDeletedSuccess => 'Event deleted';

  @override
  String get reminderAddedSuccess => 'Reminder added';

  @override
  String get reminderUpdatedSuccess => 'Reminder updated';

  @override
  String get reminderDeletedSuccess => 'Reminder deleted';

  @override
  String get allEvents => 'All Events';

  @override
  String get allReminders => 'All Reminders';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryFamily => 'Family';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categorySocial => 'Social';

  @override
  String get categoryOther => 'Other';

  @override
  String get priority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityUrgent => 'Urgent';

  @override
  String get savedQuotes => 'Saved Quotes';

  @override
  String get savedWords => 'Saved Words';

  @override
  String get adjustFontSize => 'Adjust Font Size';

  @override
  String get noSavedQuotes => 'No saved quotes';

  @override
  String get noSavedWords => 'No saved words';

  @override
  String get calculatorTitle => 'Calculator';

  @override
  String get fromDate => 'From Date';

  @override
  String get toDate => 'To Date';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectFromDate => 'Select From Date';

  @override
  String get selectToDate => 'Select To Date';

  @override
  String get copyResult => 'Copy Result';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get invalidDateRange => 'Invalid date range';

  @override
  String get selectDatesToSeeResults => 'Select dates to see results';

  @override
  String get calculationResults => 'Calculation Results';

  @override
  String get yearsMonthsDays => 'Years Months Days';

  @override
  String get totalDays => 'Total Days';

  @override
  String get weeksAndDays => 'Weeks and Days';

  @override
  String get year => 'Year';

  @override
  String get years => 'Years';

  @override
  String get month => 'Month';

  @override
  String get months => 'Months';

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String get week => 'Week';

  @override
  String get weeks => 'Weeks';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get shortSunday => 'Sun';

  @override
  String get shortMonday => 'Mon';

  @override
  String get shortTuesday => 'Tue';

  @override
  String get shortWednesday => 'Wed';

  @override
  String get shortThursday => 'Thu';

  @override
  String get shortFriday => 'Fri';

  @override
  String get shortSaturday => 'Sat';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get boishakh => 'Boishakh';

  @override
  String get jyoishtho => 'Jyoishtho';

  @override
  String get asharh => 'Asharh';

  @override
  String get srabon => 'Srabon';

  @override
  String get bhadro => 'Bhadro';

  @override
  String get ashwin => 'Ashwin';

  @override
  String get kartik => 'Kartik';

  @override
  String get ogrohayon => 'Ogrohayon';

  @override
  String get poush => 'Poush';

  @override
  String get magh => 'Magh';

  @override
  String get falgun => 'Falgun';

  @override
  String get choitra => 'Choitra';

  @override
  String get seasonGrishmo => 'Summer';

  @override
  String get seasonBorsha => 'Rainy Season';

  @override
  String get seasonSharat => 'Autumn';

  @override
  String get seasonHemonto => 'Late Autumn';

  @override
  String get seasonSheet => 'Winter';

  @override
  String get seasonBosonto => 'Spring';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get seasonAutumn => 'Autumn';

  @override
  String get seasonWinter => 'Winter';

  @override
  String getMonthName(int month) {
    switch (month) {
      case 1:
        return january;
      case 2:
        return february;
      case 3:
        return march;
      case 4:
        return april;
      case 5:
        return may;
      case 6:
        return june;
      case 7:
        return july;
      case 8:
        return august;
      case 9:
        return september;
      case 10:
        return october;
      case 11:
        return november;
      case 12:
        return december;
      default:
        return '';
    }
  }

  @override
  String getMonthAbbreviation(int month) {
    final name = getMonthName(month);
    if (name.isEmpty) return '';
    if (name.length <= 4) return name;
    return name.substring(0, 4);
  }

  @override
  String getBanglaMonthName(int month) {
    switch (month) {
      case 1:
        return boishakh;
      case 2:
        return jyoishtho;
      case 3:
        return asharh;
      case 4:
        return srabon;
      case 5:
        return bhadro;
      case 6:
        return ashwin;
      case 7:
        return kartik;
      case 8:
        return ogrohayon;
      case 9:
        return poush;
      case 10:
        return magh;
      case 11:
        return falgun;
      case 12:
        return choitra;
      default:
        return '';
    }
  }

  @override
  String getDayName(int day) {
    switch (day) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return '';
    }
  }

  @override
  String getBengaliSeasonName(int monthNumber) {
    if (monthNumber >= 1 && monthNumber <= 2) return seasonGrishmo;
    if (monthNumber >= 3 && monthNumber <= 4) return seasonBorsha;
    if (monthNumber >= 5 && monthNumber <= 6) return seasonSharat;
    if (monthNumber >= 7 && monthNumber <= 8) return seasonHemonto;
    if (monthNumber >= 9 && monthNumber <= 10) return seasonSheet;
    return seasonBosonto;
  }

  @override
  String getGregorianSeasonName(int bengaliMonthNumber) {
    if (bengaliMonthNumber >= 1 && bengaliMonthNumber <= 2) return 'Summer';
    if (bengaliMonthNumber >= 3 && bengaliMonthNumber <= 4)
      return 'Rainy Season';
    if (bengaliMonthNumber >= 5 && bengaliMonthNumber <= 6) return 'Autumn';
    if (bengaliMonthNumber >= 7 && bengaliMonthNumber <= 8)
      return 'Late Autumn';
    if (bengaliMonthNumber >= 9 && bengaliMonthNumber <= 10) return 'Winter';
    return 'Spring';
  }

  // Add missing methods for quotes and words
  @override
  String get example => 'Example';

  @override
  String get meaningBengali => 'Bengali Meaning';

  @override
  String get meaningEnglish => 'English Meaning';

  @override
  String get dayDetails => 'Day Details';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get pronunciationTitle => 'Pronunciation Title';

  @override
  String get pronunciationSubtitle => 'Pronunciation Subtitle';

  @override
  String get quoteOfTheDay => 'Quote of the Day';

  @override
  String get settings => 'Settings';

  @override
  String get synonym => 'Synonym';

  @override
  String get todayIsDayName => 'Today is';

  @override
  String get wordOfTheDay => 'Word of the Day';
}
