// lib/l10n/jhuri_localizations.dart

import 'package:flutter/material.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_ui/date_picker_localizations.dart';
import 'jhuri_localizations_en.dart';
import 'jhuri_localizations_bn.dart';

abstract class JhuriLocalizations extends AppLocalizations
    with EkushCommonLocalizations
    implements DatePickerLocalizations {
  // ═════════════════════════════════════════════════════════
  // STATIC ACCESS METHOD
  // ═════════════════════════════════════════════════════════

  static JhuriLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!
        as JhuriLocalizations;
  }

  // ═════════════════════════════════════════════════════════
  // APP INFO
  // ═════════════════════════════════════════════════════════

  @override
  String get appName;
  @override
  String get appTitle;
  @override
  String get welcomeToApp;

  // ═════════════════════════════════════════════════════════
  // NAVIGATION
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALENDAR SYSTEM LABELS
  // ═════════════════════════════════════════════════════════

  @override
  String get calendarShortGregorian;
  @override
  String get calendarShortBangla;
  @override
  String get calendarShortHijri;

  // ═════════════════════════════════════════════════════════
  // MESSAGES (partial - common ones provided by EkushCommonLocalizations mixin)
  // ═════════════════════════════════════════════════════════

  @override
  String get featureComingSoon;
  @override
  String get loadingData;
  @override
  String get failedToLoadData;

  // ═════════════════════════════════════════════════════════
  // HOME SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // SETTINGS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // DATA SYNC
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // NOTIFICATIONS (partial - common ones provided by EkushCommonLocalizations mixin)
  // ═════════════════════════════════════════════════════════

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
  String get quoteNotifications;
  @override
  String get quoteNotificationsSubtitle;
  @override
  String get wordNotifications;
  @override
  String get wordNotificationsSubtitle;

  // ═════════════════════════════════════════════════════════
  // HOLIDAYS SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALENDAR SCREEN
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENTS & REMINDERS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // EVENT CATEGORIES
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // REMINDER PRIORITY
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // QUOTES & WORDS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // CALCULATOR
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // MONTHS — BENGALI
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // SEASONS
  // ═════════════════════════════════════════════════════════

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

  // ═════════════════════════════════════════════════════════
  // JHURI SPECIFIC STRINGS
  // ═════════════════════════════════════════════════════════

  // Onboarding
  String get onboardingWelcome;
  String get onboardingTagline;
  String get onboardingGetStarted;
  String get onboardingLanguageTitle;
  String get onboardingNotificationTitle;
  String get onboardingNotificationMessage;
  String get onboardingAllow;
  String get onboardingNotNow;
  String get onboardingWelcomeTitle;
  String get onboardingWelcomeSubtitle;
  String get onboardingThemeTitle;
  String get themeSystem;
  String get themeLight;
  String get themeDark;

  // Home Screen
  String get homeEmptyTitle;
  String get homeEmptyMessage;
  String get upcoming;
  String get past;
  String get newList;
  String get itemsCount;
  String get estimatedTotal;
  String get completionProgress;

  // List Management
  String get createList;
  String get editList;
  String get listTitle;
  String get listTitleHint;
  String get buyDate;
  String get reminder;
  String get reminderTime;
  String get addItem;
  String get noItems;
  String get atLeastOneItem;
  String get runningTotal;

  // Category Browser
  String get whatToBuy;
  String get categories;
  String get customItem;

  // Item Picker
  String get quantity;
  String get unit;
  String get price;
  String get addTo;
  String get customItemName;
  String get customItemNameHint;
  String get selectCategory;

  // Shopping Mode
  String get shoppingMode;
  String get markAsBought;
  String get allBought;
  String get shareList;

  // Settings (Jhuri-specific)
  String get shopping;
  String get showPriceTotal;
  String get showPriceTotalSubtitle;
  String get defaultUnit;
  String get currencySymbol;
  String get enableNotifications;
  String get enableNotificationsSubtitle;
  String get defaultReminderTime;
  String get notificationsEnabled;
  String get lists;
  String get listSortOrder;
  String get newestFirst;
  String get oldestFirst;
  String get personalItems;
  String get manageCustomItems;
  String get manageCustomItemsSubtitle;
  String get appVersion;

  // Messages
  String get englishComingSoon;
  String get shareError;
  String get appRestartRequired;

  // Additional Jhuri-specific methods from original file
  String get pronunciation;
  String get pronunciationTitle;
  String get pronunciationSubtitle;

  // Missing keys from home screen and viewmodel
  String get errorOccurred;
  String get anErrorOccurred;
  String get quickStart;
  String get clickButtonToCreateList;
  String get selectCategoryDescription;
  String get createListDescription;
  String get shoppingList;
  String get moreItems;
  String get duplicateList;
  String get listDuplicated;
  String get archive;
  String get listArchived;
  String get errorWithMessage;
  String get confirmDeleteList;
  String get deleteListQuestion;
  String get listDeleted;
  String get appTagline;
  String get createNewCategory;
  String get createNewItem;
  String get listCopy;
  String get listWithCopy;

  // Create/Edit List Screen
  String get listInfo;
  String get listTitleOptional;
  String get timePrefix;
  String get itemsHeader;
  String get clickToAddItems;
  String get listNotFound;

  // Shopping Mode Screen
  String get shoppingListDefault;
  String get failedToLoadList;
  String get tryAgain;
  String get noItemsSelected;
  String get returnToList;
  String get changeQuantity;
  String get deleteItemText;
  String get markShoppingComplete;
  String get deleteConfirmation;
  String confirmDeleteItem(String itemName);
  String itemsBoughtCount(int bought, int total);
  String get shoppingCompleted;
  String get shoppingAlmostComplete;
  String get shoppingHalfComplete;
  String get shoppingInProgress;
  String get defaultUnitKg;

  // Custom Item Form
  String get createCustomItem;
  String get itemNameBangla;
  String get itemNameBanglaHint;
  String get itemNameEnglish;
  String get itemNameEnglishHint;
  String get itemCategory;
  String get selectItemCategory;
  String get itemQuantity;
  String get itemUnit;
  String get itemIcon;
  String get addCustomItem;
  String get customItemError;
  String get customItemErrorOccurred;
  String get customItemTryAgain;
  String get atLeastOneItemRequired;
  String get customItemAddedSuccess;
  String get customItemErrorWithSuffix;

  // Additional missing keys from create_custom_item_screen.dart
  String get itemNameRequired;
  String get quantityHint;
  String get enterQuantity;
  String get validQuantity;
  String get priceHint;
  String get validPrice;
  String get featureComingSoonCategory;
  String get errorWithSuffix;

  // Missing keys from bottom sheet forms
  String get addNewItem;
  String get itemNameBanglaRequired;
  String get itemNameEnglishOptional;
  String get category;
  String get quantityLabel;
  String get enterQuantityLabel;
  String get unitLabel;
  String get priceOptional;
  String get enterPriceLabel;
  String get errorWithSuffixDynamic;
  String get createNewCategoryForm;
  String get categoryNameRequired;
  String get categoryNameHint;
  String get englishNameOptional;
  String get englishNameHint;
  String get emojiIcon;
  String get addOtherEmoji;
  String get typeEmoji;
  String get categorySavedSuccess;
  String get errorWithSuffixDynamicCategory;

  // Additional missing keys from settings screen
  String get errorLoadingTheme;
  String get errorLoadingLanguage;
  String get appDescription;
  String get developedBy;
  String get allRightsReserved;
  String get resettingSettings;
  String get settingsResetSuccess;
  String get settingsResetError;
  String get linkLaunchError;
  String get settingsOpenError;

  // Additional missing keys from archive screen
  String get noArchivedLists;
  String get noArchivedListsDescription;
  String get loadingArchives;

  // Additional missing keys from category browser
  String get selectCategoryTitle;
  String doneWithCount(int count);

  // Additional missing keys from custom items screen
  String get errorLoadingCustomItems;
  String get noCustomItems;
  String get noCustomItemsDescription;

  // Additional missing keys from category browser
  String get errorLoadingCategories;

  // Additional missing keys from completion animation
  String get congratulations;
  String get yourListCompleted;
  String get okayLetsGo;

  // Additional missing keys from completion animation viewmodel
  String get completedStatus;
  String get almostCompleted;
  String get halfCompleted;
  String get inProgress;

  // Additional missing keys from shopping mode viewmodel
  String get deleteCustomItem;
  String get deleteCustomItemConfirmation;
  String get customItemDeletedSuccess;
  String get searchItems;
  String get noItemsFound;
  String get tryDifferentKeywords;
  String get selectLanguageDescription;
}

class JhuriLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const JhuriLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'bn' || locale.languageCode == 'en';
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
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
