/// Simple AppLocalizations interface for date pickers
abstract class DatePickerLocalizations {
  String get languageCode;
  String get cancel;
  String get done;
  String get selectMonth;
  String getMonthName(int month);
  String localizeNumber(dynamic number);
}
