// lib/l10n/jhuri_localizations_bn.dart

import 'package:flutter/material.dart';
import 'jhuri_localizations.dart';

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

  // ═════════════════════════════════════════════════════════
  // EKUSH COMMON LOCALIZATIONS IMPLEMENTATIONS
  // ═══════════════════════════════════════════════════════

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

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get noDataAvailable => 'কোনো ডেটা নেই';

  @override
  String get pageNotFound => 'পৃষ্ঠা পাওয়া যায়নি';

  @override
  String get goToHome => 'হোমে যান';

  @override
  String get backToHome => 'হোমে ফিরুন';

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get settings => 'সেটিংস';

  @override
  String get helpSupport => 'সাহায্য ও সহায়তা';

  @override
  String get openSettings => 'সেটিংস খুলুন';

  @override
  String get turnOn => 'চালু';

  @override
  String get turnOff => 'বন্ধ';

  @override
  String get enable => 'সক্রিয়';

  @override
  String get notNow => 'এখন না';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get notificationsOn => 'বিজ্ঞপ্তি চালু';

  @override
  String get notificationsOff => 'বিজ্ঞপ্তি বন্ধ';

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

  // ═════════════════════════════════════════════════════════
  // APP INFO
  // ═════════════════════════════════════════════════════════

  @override
  String get appName => 'ঝুড়ি';

  @override
  String get appTitle => 'Jhuri – Smart Grocery List';

  @override
  String get welcomeToApp => 'ঝুড়িতে স্বাগতম';

  // ═════════════════════════════════════════════════════════
  // NAVIGATION
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALENDAR SYSTEM LABELS
  // ═════════════════════════════════════════════════════════

  @override
  String get calendarShortGregorian => 'ইংরেজি';

  @override
  String get calendarShortBangla => 'বাংলা';

  @override
  String get calendarShortHijri => 'হিজরি';

  // ═════════════════════════════════════════════════════════
  // MESSAGES
  // ═════════════════════════════════════════════════════════

  @override
  String get featureComingSoon => 'বৈশিষ্ট্য শীঘ্রই আসছে';

  @override
  String get loadingData => 'ডেটা লোড হচ্ছে';

  @override
  String get failedToLoadData => 'ডেটা লোড করতে ব্যর্থ';

  // ═════════════════════════════════════════════════════════
  // HOME SCREEN
  // ═════════════════════════════════════════════════════════

  @override
  String get homeTitle => 'ঝুড়ি';

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
  String get today => 'আজ';

  @override
  String get tomorrow => 'আগামীকাল';

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

  @override
  String get quoteOfTheDay => 'দিনের উক্তি';

  @override
  String get wordOfTheDay => 'দিনের শব্দ';

  @override
  String get meaningEnglish => 'ইংরেজি অর্থ';

  @override
  String get meaningBengali => 'বাংলা অর্থ';

  @override
  String get synonym => 'সমার্থক শব্দ';

  @override
  String get example => 'উদাহরণ';

  @override
  String get todayIsDayName => 'আজকের দিন';

  @override
  String get dayDetails => 'দিনের বিবরণ';

  // ═════════════════════════════════════════════════════════
  // SETTINGS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // DATA SYNC
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // NOTIFICATIONS (partial - common ones provided by EkushCommonLocalizations mixin)
  // ═════════════════════════════════════════════════════════

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
  String get quoteNotifications => 'উক্তি বিজ্ঞপ্তি';

  @override
  String get quoteNotificationsSubtitle => 'উক্তি বিজ্ঞপ্তি';

  @override
  String get wordNotifications => 'শব্দ বিজ্ঞপ্তি';

  @override
  String get wordNotificationsSubtitle => 'শব্দ বিজ্ঞপ্তি';

  // ═════════════════════════════════════════════════════════
  // HOLIDAYS SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALENDAR SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENTS & REMINDERS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENT CATEGORIES
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // REMINDER PRIORITY
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // QUOTES & WORDS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALCULATOR
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // MONTHS — BENGALI
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // SEASONS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // JHURI SPECIFIC STRINGS
  // ═════════════════════════════════════════════════════════

  // Onboarding
  @override
  String get onboardingWelcome => 'ঝুড়িতে স্বাগতম';

  @override
  String get onboardingTagline => 'বাজারের ফর্দ, হাতের মুঠোয়';

  @override
  String get onboardingGetStarted => 'শুরু করুন';

  @override
  String get onboardingLanguageTitle => 'ভাষা নির্বাচন';

  @override
  String get onboardingNotificationTitle => 'বিজ্ঞপ্তি';

  @override
  String get onboardingNotificationMessage =>
      'বাজারের জন্য রিমাইন্ডার পেতে বিজ্ঞপ্তি অনুমতি দিন';

  @override
  String get onboardingAllow => 'অনুমতি দিন';

  @override
  String get onboardingNotNow => 'এখন না';

  // Home Screen
  @override
  String get homeEmptyTitle => 'বাজারের কোনো ফর্দ নেই';

  @override
  String get homeEmptyMessage => '"+" বাটন চেপে নতুন ফর্দ তৈরি করুন';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String get past => 'অতীত';

  @override
  String get newList => 'নতুন ফর্দ';

  @override
  String get itemsCount => 'টি আইটেম';

  @override
  String get estimatedTotal => 'আনুমানিক মোট';

  @override
  String get completionProgress => 'কেনা হয়েছে';

  // List Management
  @override
  String get createList => 'নতুন ফর্দ তৈরি করুন';

  @override
  String get editList => 'ফর্দ সম্পাদনা করুন';

  @override
  String get listTitle => 'ফর্দের শিরোনাম';

  @override
  String get listTitleHint => 'যেমন: সাপ্তাহিক বাজার';

  @override
  String get buyDate => 'কেনার তারিখ';

  @override
  String get reminder => 'রিমাইন্ডার';

  @override
  String get reminderTime => 'রিমাইন্ডারের সময়';

  @override
  String get addItem => 'আইটেম যোগ করুন';

  @override
  String get noItems => 'কোনো আইটেম নেই';

  @override
  String get atLeastOneItem => 'অন্তত একটি আইটেম যোগ করুন';

  @override
  String get runningTotal => 'মোট আনুমানিক';

  // Category Browser
  @override
  String get whatToBuy => 'কী কিনবেন?';

  @override
  String get categories => 'ক্যাটাগরি';

  @override
  String get customItem => '➕ কাস্টম';

  // Item Picker
  @override
  String get quantity => 'পরিমাণ';

  @override
  String get unit => 'একক';

  @override
  String get price => 'মূল্য';

  @override
  String get addTo => 'যোগ করুন';

  @override
  String get customItemName => 'কাস্টম আইটেমের নাম';

  @override
  String get customItemNameHint => 'আইটেমের নাম লিখুন';

  @override
  String get selectCategory => 'ক্যাটাগরি নির্বাচন করুন';

  // Shopping Mode
  @override
  String get shoppingMode => 'কেনাকাটা মোড';

  @override
  String get markAsBought => 'কেনা হয়েছে';

  @override
  String get allBought => 'সব কেনা হয়েছে! 🎉';

  @override
  String get shareList => 'ফর্দ শেয়ার করুন';

  // Settings (Jhuri-specific)
  @override
  String get shopping => 'বাজার';

  @override
  String get showPriceTotal => 'মোট মূল্য দেখান';

  @override
  String get showPriceTotalSubtitle => 'আইটেমের মোট মূল্য দেখান';

  @override
  String get defaultUnit => 'ডিফল্ট একক';

  @override
  String get currencySymbol => 'মুদ্রা প্রতীক';

  @override
  String get enableNotifications => 'বিজ্ঞপ্তি সক্রিয়';

  @override
  String get enableNotificationsSubtitle => 'বিজ্ঞপ্তি পান';

  @override
  String get defaultReminderTime => 'ডিফল্ট রিমাইন্ডার সময়';

  @override
  String get notificationsEnabled => 'বিজ্ঞপ্তি সক্রিয়';

  @override
  String get lists => 'তালিকা';

  @override
  String get listSortOrder => 'ফর্দ সাজানো';

  @override
  String get newestFirst => 'নতুন আগে';

  @override
  String get oldestFirst => 'পুরনো আগে';

  @override
  String get personalItems => 'ব্যক্তিগত আইটেম';

  @override
  String get manageCustomItems => 'কাস্টম আইটেম ব্যবস্থাপনা';

  @override
  String get manageCustomItemsSubtitle => 'আপনার কাস্টম আইটেম দেখুন';

  @override
  String get appVersion => 'অ্যাপ সংস্করণ';

  // Messages
  @override
  String get englishComingSoon => 'শীঘ্রই আসছে';

  @override
  String get shareError => 'শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন';

  @override
  String get appRestartRequired => 'অ্যাপ পুনরায় চালু করুন';

  // Additional Jhuri-specific methods from original file
  @override
  String get pronunciation => 'উচ্চারণ';

  @override
  String get pronunciationTitle => 'উচ্চারণ শিরোনাম';

  @override
  String get pronunciationSubtitle => 'উচ্চারণ সাবটাইটেল';

  // Missing keys from home screen and viewmodel
  @override
  String get errorOccurred => 'ত্রুটি হয়েছে';

  @override
  String get anErrorOccurred => 'একটি ত্রুটি হয়েছে';

  @override
  String get quickStart => 'দ্রুত শুরু করুন';

  @override
  String get clickButtonToCreateList => '+ বাটনে ক্লিক করে নতুন ফর্দ শুরু করুন';

  @override
  String get selectCategoryDescription =>
      'প্রয়োজনীয় আইটেমের ক্যাটাগরি বেছে নিন';

  @override
  String get createListDescription => 'সহজেই আপনার বাজারের তালিকা তৈরি করুন';

  @override
  String get shoppingList => 'বাজারের ফর্দ';

  @override
  String get moreItems => '+${0}টি আরও আইটেম';

  @override
  String get duplicateList => 'নকল করুন';

  @override
  String get listDuplicated => 'নকল করা হয়েছে';

  @override
  String get archive => 'আর্কাইভ';

  @override
  String get listArchived => 'তালিকা আর্কাইভ করা হয়েছে';

  @override
  String get errorWithMessage => 'ত্রুটি: ${0}';

  @override
  String get confirmDeleteList => 'তালিকা মুছে ফেলার নিশ্চিত্তা করুন';

  @override
  String get deleteListQuestion => 'আপনি কি "${0}" মুছতে চান?';

  @override
  String get listDeleted => 'তালিকা মুছে ফেলা হয়েছে';

  @override
  String get appTagline => 'বাজারের ফর্দ, হাতের মুঠোয়';

  @override
  String get createNewCategory => 'নতুন ক্যাটাগরি তৈরি';

  @override
  String get createNewItem => 'নতুন আইটেম তৈরি';

  @override
  String get listCopy => 'বাজারের ফর্দ (কপি)';

  @override
  String get listWithCopy => '${0} (কপি)';

  // ═════════════════════════════════════════════════════════
  // DATE PICKER IMPLEMENTATIONS
  // ═════════════════════════════════════════════════════════

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
    if (bengaliMonthNumber >= 1 && bengaliMonthNumber <= 2) {
      return 'গ্রীষ্ম';
    }
    if (bengaliMonthNumber >= 3 && bengaliMonthNumber <= 4) {
      return 'বর্ষা';
    }
    if (bengaliMonthNumber >= 5 && bengaliMonthNumber <= 6) {
      return 'শরৎ';
    }
    if (bengaliMonthNumber >= 7 && bengaliMonthNumber <= 8) {
      return 'হেমন্ত';
    }
    if (bengaliMonthNumber >= 9 && bengaliMonthNumber <= 10) {
      return 'শীত';
    }
    return 'বসন্ত';
  }

  // Create/Edit List Screen
  @override
  String get listInfo => 'ফর্দের তথ্য';

  @override
  String get listTitleOptional => 'ফর্দের নাম (ঐচ্ছিক)';

  @override
  String get timePrefix => 'সময়:';

  @override
  String get itemsHeader => 'আইটেম';

  @override
  String get clickToAddItems => 'আইটেম যোগ করতে উপরের বাটনে ক্লিক করুন';

  @override
  String get listNotFound => 'List not found';

  // Shopping Mode Screen
  @override
  String get shoppingListDefault => 'বাজারের ফর্দ';

  @override
  String get failedToLoadList => 'তালিকা লোড করতে সমস্যা হয়েছে';

  @override
  String get tryAgain => 'আবার চেষ্টা করুন';

  @override
  String get noItemsSelected => 'কোন আইটেম নির্বাচিত হয়নি';

  @override
  String get returnToList => 'ফর্দে ফিরুন';

  @override
  String get changeQuantity => 'পরিমাণ পরিবর্তন';

  @override
  String get deleteItemText => 'মুছে ফেলুন';

  @override
  String get markShoppingComplete => 'কেনাকাটা সম্পন্ন করুন';

  @override
  String get deleteConfirmation => 'মুছে ফেলার নিশ্চিততা';

  @override
  String confirmDeleteItem(String itemName) =>
      'আপনি "$itemName" মুছে ফেলার নিশ্চিততা?';

  @override
  String itemsBoughtCount(int bought, int total) =>
      '$bought/$total টি আইটেম নির্ব করা হয়েছে';

  @override
  String get shoppingCompleted => 'সম্পন্ন';

  @override
  String get shoppingAlmostComplete => 'প্রায় সম্পন্ন';

  @override
  String get shoppingHalfComplete => 'অর্ধেক';

  @override
  String get shoppingInProgress => 'চলিছ করছেন';

  @override
  String get defaultUnitKg => 'কেজি';

  // Custom Item Form
  @override
  String get createCustomItem => 'নিজের আইটেম তৈরি';

  @override
  String get itemNameBangla => 'আইটেমর নাম';

  @override
  String get itemNameBanglaHint => 'আইটেমর নাম (যেমন)';

  @override
  String get itemNameEnglish => 'আইটেমর নাম (English)';

  @override
  String get itemNameEnglishHint => 'আইটেমর নাম (English)';

  @override
  String get itemCategory => 'ক্যাটাগরি';

  @override
  String get selectItemCategory => 'ক্যাটাগরি নির্বাচন';

  @override
  String get itemQuantity => 'পরিমাণ';

  @override
  String get itemUnit => 'একক';

  @override
  String get itemIcon => 'আইকন';

  @override
  String get addCustomItem => 'আইটেম যোগ';

  @override
  String get customItemError => 'ত্রুটি হয়েছে';

  @override
  String get customItemErrorOccurred => 'একটি ত্রুটি হয়েছে';

  @override
  String get customItemTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get atLeastOneItemRequired => 'অন্তত একটি দিন';

  @override
  String get customItemAddedSuccess => 'আইটেম যোগ হয়েছে';

  @override
  String get customItemErrorWithSuffix => 'ত্রুটি হয়েছে: ';

  // Additional missing keys from create_custom_item_screen.dart
  @override
  String get itemNameRequired => 'আইটেমের নাম লিখুন';

  @override
  String get quantityHint => 'যেমন: 1';

  @override
  String get enterQuantity => 'পরিমাণ লিখুন';

  @override
  String get validQuantity => 'বৈধ পরিমাণ লিখুন';

  @override
  String get priceHint => 'যেমন: 50';

  @override
  String get validPrice => 'বৈধ মূল্য লিখুন';

  @override
  String get featureComingSoonCategory =>
      'এই ফিচারটি শীঘ্রই আসছে। অনুগ্রহ করে ক্যাটাগরি ব্রাউজার থেকে নতুন ক্যাটাগরি তৈরি করুন।';

  @override
  String get errorWithSuffix => 'ত্রুটি: ';

  // Missing keys from bottom sheet forms
  @override
  String get addNewItem => 'নতুন আইটেম যোগ করুন';

  @override
  String get itemNameBanglaRequired => 'আইটেমের বাংলা নাম লিখুন';

  @override
  String get itemNameEnglishOptional => 'আইটেমের ইংরেজি নাম (ঐচ্ছিক)';

  @override
  String get category => 'ক্যাটাগরি';

  @override
  String get quantityLabel => 'পরিমাণ';

  @override
  String get enterQuantityLabel => 'পরিমাণ লিখুন';

  @override
  String get unitLabel => 'একক';

  @override
  String get priceOptional => 'মূল্য (ঐচ্ছিক)';

  @override
  String get enterPriceLabel => 'মূল্য লিখুন';

  @override
  String get errorWithSuffixDynamic => 'ত্রুটি: ${0}';

  @override
  String get createNewCategoryForm => 'নতুন ক্যাটাগরি তৈরি করুন';

  @override
  String get categoryNameRequired => 'ক্যাটাগরির নাম লিখুন';

  @override
  String get categoryNameHint => 'যেমন: ফল, সবজি, মাছ';

  @override
  String get englishNameOptional => 'ইংরেজি নাম (ঐচ্ছিক)';

  @override
  String get englishNameHint => 'যেমন: Fish, Vegetable, Meat';

  @override
  String get emojiIcon => 'ইমোজি আইকন';

  @override
  String get addOtherEmoji => 'অন্য ইমোজি যোগ করুন';

  @override
  String get typeEmoji => 'ইমোজি টাইপ করুন';

  @override
  String get categorySavedSuccess => 'ক্যাটাগরি সফলভাবে সেভ হয়েছে';

  @override
  String get errorWithSuffixDynamicCategory => 'ত্রুটি: ${0}';

  // Additional missing keys from settings screen
  @override
  String get errorLoadingTheme => 'থিম লোড করতে সমস্যা হয়েছে';

  @override
  String get errorLoadingLanguage => 'ভাষা লোড করতে সমস্যা হয়েছে';

  @override
  String get appDescription => 'ঝুড়ি - স্মার্ট গ্রোসারি লিস্ট';

  @override
  String get developedBy => 'একুশ ল্যাবস দ্বারা তৈরি';

  @override
  String get allRightsReserved => 'সর্বস্বত্ব স্বত্ত্ব সংরক্ষিত।';

  @override
  String get resettingSettings => 'রিসেট করা হচ্ছে...';

  @override
  String get settingsResetSuccess => 'সেটিংস সফলভাবে রিসেট করা হয়েছে';

  @override
  String get settingsResetError => 'সেটিংস রিসেট করতে সমস্যা হয়েছে';

  @override
  String get linkLaunchError => 'লিংক খুলতে সমস্যা হয়েছে';

  @override
  String get settingsOpenError => 'সেটিংস খুলতে সমস্যা হয়েছে';

  // Additional missing keys from archive screen
  @override
  String get noArchivedLists => 'কোনো আর্কাইভ তালিকা নেই';

  @override
  String get noArchivedListsDescription =>
      'সম্পন্ন হওয়া তালিকাগুলো এখানে দেখাবে';

  @override
  String get loadingArchives => 'আর্কাইভ লোড হচ্ছে...';

  // Additional missing keys from category browser
  @override
  String get selectCategoryTitle => 'ক্যাটাগরি নির্বাচন করুন';

  @override
  String doneWithCount(int count) => 'সম্পন্ন ($countটি আইটেম)';

  // Additional missing keys from custom items screen
  @override
  String get errorLoadingCustomItems => 'কাস্টম আইটেম লোড করতে সমস্যা: ${0}';

  @override
  String get noCustomItems => 'কোনো কাস্টম আইটেম নেই';

  @override
  String get noCustomItemsDescription =>
      'এখনো কোনো কাস্টম আইটেম তৈরি করা হয়নি';

  // Additional missing keys from category browser
  @override
  String get errorLoadingCategories => 'ক্যাটাগরি লোড করতে সমস্যা: ${0}';

  // Additional missing keys from completion animation
  @override
  String get congratulations => 'অভিন্দোগ!';

  @override
  String get yourListCompleted => 'আপনার সম্পন্ন হয়েছে';

  @override
  String get okayLetsGo => 'ঠিক আছে, ফিরুন';

  // Additional missing keys from completion animation viewmodel
  @override
  String get completedStatus => 'সম্পন্ন';

  @override
  String get almostCompleted => 'প্রায় সম্পন্ন';

  @override
  String get halfCompleted => 'অর্ধেক';

  @override
  String get inProgress => 'চলিছ করছেন';

  // Additional missing keys from shopping mode viewmodel
  @override
  String get deleteCustomItem => 'কাস্টম আইটেম মুছে ফেলুন';

  @override
  String get deleteCustomItemConfirmation => 'আপনি কি "${0}" মুছতে চান?';

  @override
  String get customItemDeletedSuccess => 'কাস্টম আইটেম মুছে ফেলা হয়েছে';

  @override
  String get searchItems => 'আইটেম খুঁজুন...';

  @override
  String get noItemsFound => 'কোনো আইটেম পাওয়া যায়নি';

  @override
  String get tryDifferentKeywords => 'অন্য কিওয়ার্ড দিয়ে চেষ্টা করুন';

  @override
  String get selectLanguageDescription => 'আপনার পছন্দের ভাষা নির্বাচন করুন';
}
