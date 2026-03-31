class JhuriConstants {
  JhuriConstants._();

  // Suggestions algorithm weights (v1.1 — alphabetical sort in v1)
  static const double recencyWeight7Days = 1.0;
  static const double recencyWeight30Days = 0.7;
  static const double recencyWeight90Days = 0.4;
  static const double recencyWeightOlder = 0.1;

  // Search trigger threshold
  static const int searchVisibleThreshold = 10;

  // Ad rules
  static const int interstitialSessionMax = 3;
  static const int interstitialMinIntervalMinutes = 5;

  // Review prompt
  static const int reviewPromptAppOpenCount = 10;

  // List display
  static const int nativeAdEveryNCards = 4;

  // Defaults
  static const String defaultReminderTime = '18:00';
  static const String defaultUnit = 'কেজি';
  static const String defaultCurrencySymbol = '৳';
  static const String defaultThemeMode = 'system';
  static const String defaultLanguage = 'bangla';
  static const String defaultListSortOrder = 'dateDesc';

  // Available units for quantity selection
  static const List<String> availableUnits = [
    'কেজি',
    'গ্রাম',
    'লিটার',
    'মিলি',
    'পিস',
    'হালি',
    'প্যাকেট',
    'বোতল',
    'কৌটা',
    'আঁটি',
  ];
}
