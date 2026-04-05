// lib/l10n/jhuri_localizations_en.dart

import 'package:flutter/material.dart';
import 'jhuri_localizations.dart';

class JhuriLocalizationsEn extends JhuriLocalizations {
  @override
  Locale get locale => const Locale('en', 'US');

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
  // ═════════════════════════════════════════════════════════

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

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
  String get comingSoon => 'Coming Soon';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get goToHome => 'Go to Home';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get welcome => 'Welcome';

  @override
  String get profile => 'Profile';

  @override
  String get about => 'About';

  @override
  String get settings => 'Settings';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get turnOn => 'Turn On';

  @override
  String get turnOff => 'Turn Off';

  @override
  String get enable => 'Enable';

  @override
  String get notNow => 'Not Now';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsOn => 'Notifications On';

  @override
  String get notificationsOff => 'Notifications Off';

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

  // ═════════════════════════════════════════════════════════
  // APP INFO
  // ═════════════════════════════════════════════════════════

  @override
  String get appName => 'Jhuri';

  @override
  String get appTitle => 'Jhuri – Smart Grocery List';

  @override
  String get welcomeToApp => 'Welcome to Jhuri';

  // ═════════════════════════════════════════════════════════
  // NAVIGATION
  // ═════════════════════════════════════════════════════════

  @override
  String get navHome => 'Home';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navHolidays => 'Holidays';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navSettings => 'Settings';

  @override
  String get navMore => 'More';

  @override
  String get navAddEvent => 'Add Event';

  @override
  String get navAddReminder => 'Add Reminder';

  @override
  String get navCalculatorFull => 'Calculator';

  @override
  String get navSavedQuotes => 'Saved Quotes';

  @override
  String get navSavedWords => 'Saved Words';

  @override
  String get navAbout => 'About';

  // ═════════════════════════════════════════════════════════
  // CALENDAR SYSTEM LABELS
  // ═════════════════════════════════════════════════════════

  @override
  String get calendarShortGregorian => 'Gregorian';

  @override
  String get calendarShortBangla => 'Bangla';

  @override
  String get calendarShortHijri => 'Hijri';

  // ═════════════════════════════════════════════════════════
  // MESSAGES
  // ═════════════════════════════════════════════════════════

  @override
  String get featureComingSoon => 'Feature coming soon';

  @override
  String get loadingData => 'Loading data';

  @override
  String get failedToLoadData => 'Failed to load data';

  // ═════════════════════════════════════════════════════════
  // HOME SCREEN
  // ═════════════════════════════════════════════════════════

  @override
  String get homeTitle => 'Jhuri';

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
  String get quoteOfTheDay => 'Quote of the Day';

  @override
  String get wordOfTheDay => 'Word of the Day';

  @override
  String get meaningEnglish => 'English Meaning';

  @override
  String get meaningBengali => 'Bengali Meaning';

  @override
  String get synonym => 'Synonym';

  @override
  String get example => 'Example';

  @override
  String get todayIsDayName => 'Today is';

  @override
  String get dayDetails => 'Day Details';

  // ═════════════════════════════════════════════════════════
  // SETTINGS
  // ═════════════════════════════════════════════════════════

  @override
  String get settingsTitle => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get languageBangla => 'বাংলা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChanged => 'Language Changed';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

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

  // ═════════════════════════════════════════════════════════
  // DATA SYNC
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // NOTIFICATIONS (partial - common ones provided by EkushCommonLocalizations mixin)
  // ═════════════════════════════════════════════════════════

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
  String get quoteNotifications => 'Quote Notifications';

  @override
  String get quoteNotificationsSubtitle => 'Quote notifications';

  @override
  String get wordNotifications => 'Word Notifications';

  @override
  String get wordNotificationsSubtitle => 'Word notifications';

  // ═════════════════════════════════════════════════════════
  // HOLIDAYS SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALENDAR SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENTS & REMINDERS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENT CATEGORIES
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // REMINDER PRIORITY
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // QUOTES & WORDS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALCULATOR
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // MONTHS — BENGALI
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // SEASONS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // JHURI SPECIFIC STRINGS
  // ═════════════════════════════════════════════════════════

  // Onboarding
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

  // Home Screen
  @override
  String get homeEmptyTitle => 'No shopping lists';

  @override
  String get homeEmptyMessage => 'Press "+" to create a new list';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get past => 'Past';

  @override
  String get newList => 'New List';

  @override
  String get itemsCount => 'items';

  @override
  String get estimatedTotal => 'Est. Total';

  @override
  String get completionProgress => 'bought';

  // List Management
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

  // Category Browser
  @override
  String get whatToBuy => 'What to Buy?';

  @override
  String get categories => 'Categories';

  @override
  String get customItem => '➕ Custom';

  // Item Picker
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

  // Shopping Mode
  @override
  String get shoppingMode => 'Shopping Mode';

  @override
  String get markAsBought => 'Mark as Bought';

  @override
  String get allBought => 'All Bought! 🎉';

  @override
  String get shareList => 'Share List';

  // Settings (Jhuri-specific)
  @override
  String get shopping => 'Shopping';

  @override
  String get showPriceTotal => 'Show Price Total';

  @override
  String get showPriceTotalSubtitle => 'Show total price of items';

  @override
  String get defaultUnit => 'Default Unit';

  @override
  String get currencySymbol => 'Currency Symbol';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsSubtitle => 'Receive notifications';

  @override
  String get defaultReminderTime => 'Default Reminder Time';

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
  String get personalItems => 'Personal Items';

  @override
  String get manageCustomItems => 'Manage Custom Items';

  @override
  String get manageCustomItemsSubtitle => 'View your custom items';

  @override
  String get appVersion => 'App Version';

  // Messages
  @override
  String get englishComingSoon => 'Coming Soon';

  @override
  String get shareError => 'Problem sharing. Please try again';

  @override
  String get appRestartRequired => 'Restart App';

  // Additional Jhuri-specific methods from original file
  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get pronunciationTitle => 'Pronunciation Title';

  @override
  String get pronunciationSubtitle => 'Pronunciation Subtitle';

  // Missing keys from home screen and viewmodel
  @override
  String get errorOccurred => 'Error occurred';

  @override
  String get anErrorOccurred => 'An error occurred';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get clickButtonToCreateList => 'Click + button to create new list';

  @override
  String get selectCategoryDescription => 'Select category for required items';

  @override
  String get createListDescription => 'Easily create your shopping list';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get moreItems => '+${0} more items';

  @override
  String get duplicateList => 'Duplicate';

  @override
  String get listDuplicated => 'List duplicated';

  @override
  String get archive => 'Archive';

  @override
  String get listArchived => 'List archived';

  @override
  String get errorWithMessage => 'Error: ${0}';

  @override
  String get confirmDeleteList => 'Confirm Delete List';

  @override
  String get deleteListQuestion => 'Do you want to delete "${0}"?';

  @override
  String get listDeleted => 'List deleted';

  @override
  String get appTagline => 'Plan Better. Shop Easier.';

  @override
  String get createNewCategory => 'Create New Category';

  @override
  String get createNewItem => 'Create New Item';

  @override
  String get listCopy => 'Shopping List (Copy)';

  @override
  String get listWithCopy => '${0} (Copy)';

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
      return 'Summer';
    }
    if (bengaliMonthNumber >= 3 && bengaliMonthNumber <= 4) {
      return 'Rainy Season';
    }
    if (bengaliMonthNumber >= 5 && bengaliMonthNumber <= 6) {
      return 'Autumn';
    }
    if (bengaliMonthNumber >= 7 && bengaliMonthNumber <= 8) {
      return 'Late Autumn';
    }
    if (bengaliMonthNumber >= 9 && bengaliMonthNumber <= 10) {
      return 'Winter';
    }
    return 'Spring';
  }

  // Create/Edit List Screen
  @override
  String get listInfo => 'List Information';

  @override
  String get listTitleOptional => 'List Title (Optional)';

  @override
  String get timePrefix => 'Time:';

  @override
  String get itemsHeader => 'Items';

  @override
  String get clickToAddItems => 'Click the button above to add items';

  @override
  String get listNotFound => 'List not found';

  // Shopping Mode Screen
  @override
  String get shoppingListDefault => 'Shopping List';

  @override
  String get failedToLoadList => 'Failed to load list';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noItemsSelected => 'No items selected';

  @override
  String get returnToList => 'Return to List';

  @override
  String get changeQuantity => 'Change Quantity';

  @override
  String get deleteItemText => 'Delete';

  @override
  String get markShoppingComplete => 'Mark Shopping Complete';

  @override
  String get deleteConfirmation => 'Delete Confirmation';

  @override
  String confirmDeleteItem(String itemName) =>
      'Are you sure you want to delete "$itemName"?';

  @override
  String itemsBoughtCount(int bought, int total) =>
      '$bought/$total items bought';

  @override
  String get shoppingCompleted => 'Completed';

  @override
  String get shoppingAlmostComplete => 'Almost Complete';

  @override
  String get shoppingHalfComplete => 'Half Complete';

  @override
  String get shoppingInProgress => 'In Progress';

  @override
  String get defaultUnitKg => 'kg';

  // Custom Item Form
  @override
  String get createCustomItem => 'Create Custom Item';

  @override
  String get itemNameBangla => 'Item Name (Bangla)';

  @override
  String get itemNameBanglaHint => 'Item name (e.g.)';

  @override
  String get itemNameEnglish => 'Item Name (English)';

  @override
  String get itemNameEnglishHint => 'Item name (English)';

  @override
  String get itemCategory => 'Category';

  @override
  String get selectItemCategory => 'Select Category';

  @override
  String get itemQuantity => 'Quantity';

  @override
  String get itemUnit => 'Unit';

  @override
  String get itemIcon => 'Icon';

  @override
  String get addCustomItem => 'Add Item';

  @override
  String get customItemError => 'Error occurred';

  @override
  String get customItemErrorOccurred => 'An error occurred';

  @override
  String get customItemTryAgain => 'Try Again';

  @override
  String get atLeastOneItemRequired => 'At least one item required';

  @override
  String get customItemAddedSuccess => 'Item added successfully';

  @override
  String get customItemErrorWithSuffix => 'Error: ';

  // Additional missing keys from create_custom_item_screen.dart
  @override
  String get itemNameRequired => 'Enter item name';

  @override
  String get quantityHint => 'e.g., 1';

  @override
  String get enterQuantity => 'Enter quantity';

  @override
  String get validQuantity => 'Enter valid quantity';

  @override
  String get priceHint => 'e.g., 50';

  @override
  String get validPrice => 'Enter valid price';

  @override
  String get featureComingSoonCategory =>
      'This feature is coming soon. Please create new categories from the category browser.';

  @override
  String get errorWithSuffix => 'Error: ';

  // Missing keys from bottom sheet forms
  @override
  String get addNewItem => 'Add New Item';

  @override
  String get itemNameBanglaRequired => 'Enter item name';

  @override
  String get itemNameEnglishOptional => 'English name (optional)';

  @override
  String get category => 'Category';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get enterQuantityLabel => 'Enter quantity';

  @override
  String get unitLabel => 'Unit';

  @override
  String get priceOptional => 'Price (optional)';

  @override
  String get enterPriceLabel => 'Enter price';

  @override
  String get errorWithSuffixDynamic => 'Error: ${0}';

  @override
  String get createNewCategoryForm => 'Create New Category';

  @override
  String get categoryNameRequired => 'Category name required';

  @override
  String get categoryNameHint => 'e.g., Fruits, Vegetables';

  @override
  String get englishNameOptional => 'English name (optional)';

  @override
  String get englishNameHint => 'e.g., Fish, Vegetable, Meat';

  @override
  String get emojiIcon => 'Emoji Icon';

  @override
  String get addOtherEmoji => 'Add other emoji';

  @override
  String get typeEmoji => 'Type emoji';

  @override
  String get categorySavedSuccess => 'Category saved successfully';

  @override
  String get errorWithSuffixDynamicCategory => 'Error: ${0}';

  // Additional missing keys from settings screen
  @override
  String get errorLoadingTheme => 'Error loading theme';

  @override
  String get errorLoadingLanguage => 'Error loading language';

  @override
  String get appDescription => 'Jhuri - Smart Grocery List';

  @override
  String get developedBy => 'Developed by Ekush Labs';

  @override
  String get allRightsReserved => ' 2026 Ekush Labs. All rights reserved.';

  @override
  String get resettingSettings => 'Resetting...';

  @override
  String get settingsResetSuccess => 'Settings reset successfully';

  @override
  String get settingsResetError => 'Failed to reset settings';

  @override
  String get linkLaunchError => 'Failed to launch link';

  @override
  String get settingsOpenError => 'Failed to open settings';

  // Additional missing keys from archive screen
  @override
  String get noArchivedLists => 'No archived lists';

  @override
  String get noArchivedListsDescription => 'Completed lists will appear here';

  @override
  String get loadingArchives => 'Loading archives...';

  // Additional missing keys from category browser
  @override
  String get selectCategoryTitle => 'Select category to create';

  @override
  String doneWithCount(int count) => 'Done ($count items)';

  // Additional missing keys from custom items screen
  @override
  String get errorLoadingCustomItems => 'Error loading custom items: ${0}';

  @override
  String get noCustomItems => 'No custom items';

  @override
  String get noCustomItemsDescription => 'No custom items created yet';

  // Additional missing keys from category browser
  @override
  String get errorLoadingCategories => 'Error loading categories: ${0}';

  // Additional missing keys from completion animation
  @override
  String get congratulations => 'Congratulations!';

  @override
  String get yourListCompleted => 'Your list is completed';

  @override
  String get okayLetsGo => 'Okay, Let\'s Go';

  // Additional missing keys from completion animation viewmodel
  @override
  String get completedStatus => 'Completed';

  @override
  String get almostCompleted => 'Almost completed';

  @override
  String get halfCompleted => 'Half completed';

  @override
  String get inProgress => 'In progress';

  // Additional missing keys from shopping mode viewmodel
  @override
  String get deleteCustomItem => 'Delete Custom Item';

  @override
  String get deleteCustomItemConfirmation => 'Do you want to delete "${0}"?';

  @override
  String get customItemDeletedSuccess => 'Custom item deleted successfully';

  @override
  String get searchItems => 'Search items...';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get tryDifferentKeywords => 'Try different keywords';

  @override
  String get selectLanguageDescription => 'Select your preferred language';
}
