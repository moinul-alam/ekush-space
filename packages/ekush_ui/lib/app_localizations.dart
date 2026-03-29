/// Simple AppLocalizations interface for ekush_ui package
/// The actual app should provide the concrete implementation
abstract class AppLocalizations {
  String get languageCode;
  
  String get cancel;
  String get done;
  String get selectMonth;
  
  String getMonthName(int month);
  String localizeNumber(dynamic number);
}
