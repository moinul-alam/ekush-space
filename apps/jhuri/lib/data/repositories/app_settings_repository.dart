import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class AppSettingsRepository extends BaseRepository {
  AppSettingsRepository(this._db);
  final JhuriDatabase _db;

  // Always returns singleton row (id=1, created by migration)
  Future<AppSettingsTableData> getSettings() async {
    final result = await (_db.select(_db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    if (result != null) return result;

    // Fallback: insert default if somehow missing
    await _db.into(_db.appSettingsTable).insert(
          AppSettingsTableCompanion.insert(
            id: const Value(1),
            themeMode: const Value('system'),
            language: const Value('bangla'),
            showPriceTotal: const Value(true),
            defaultUnit: const Value('কেজি'),
            currencySymbol: const Value('৳'),
            notificationsEnabled: const Value(true),
            defaultReminderTime: const Value('18:00'),
            listSortOrder: const Value('dateDesc'),
            appOpenCount: const Value(0),
            onboardingComplete: const Value(false),
            reviewPrompted: const Value(false),
          ),
          mode: InsertMode.insertOrReplace,
        );

    // After insert, fetch it again once. No recursion.
    final finalResult = await (_db.select(_db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .getSingleOrNull();
    
    if (finalResult == null) {
      throw StateError('Failed to create or retrieve app settings');
    }
    return finalResult;
  }

  // Backward compatibility method
  Future<AppSettingsTableData> getSettingsData() async {
    return getSettings();
  }

  Stream<AppSettingsTableData> watchSettings() {
    return (_db.select(_db.appSettingsTable)..where((t) => t.id.equals(1)))
        .watchSingle();
  }

  Future<void> updateSettings(AppSettingsTableCompanion companion) {
    return (_db.update(_db.appSettingsTable)..where((t) => t.id.equals(1)))
        .write(companion);
  }

  Future<void> updateThemeMode(String mode) {
    return updateSettings(AppSettingsTableCompanion(themeMode: Value(mode)));
  }

  Future<void> updateDefaultUnit(String unit) {
    return updateSettings(AppSettingsTableCompanion(defaultUnit: Value(unit)));
  }

  Future<void> updateNotificationsEnabled(bool enabled) {
    return updateSettings(
        AppSettingsTableCompanion(notificationsEnabled: Value(enabled)));
  }

  Future<void> updateDefaultReminderTime(String time) {
    return updateSettings(
        AppSettingsTableCompanion(defaultReminderTime: Value(time)));
  }

  Future<void> updateListSortOrder(String order) {
    return updateSettings(
        AppSettingsTableCompanion(listSortOrder: Value(order)));
  }

  Future<void> incrementAppOpenCount() async {
    final settings = await getSettingsData();
    await updateSettings(AppSettingsTableCompanion(
      appOpenCount: Value(settings.appOpenCount + 1),
    ));
  }

  Future<void> markOnboardingComplete() {
    return updateSettings(const AppSettingsTableCompanion(
      onboardingComplete: Value(true),
    ));
  }

  Future<void> setOnboardingComplete() {
    return markOnboardingComplete();
  }

  Future<void> markReviewPrompted() {
    return updateSettings(const AppSettingsTableCompanion(
      reviewPrompted: Value(true),
    ));
  }

  Future<void> updateLastInterstitialShown(DateTime time) {
    return updateSettings(AppSettingsTableCompanion(
      lastInterstitialShown: Value(time),
    ));
  }

  Future<void> initSettings() async {
    // This will insert the default settings if they don't exist
    await getSettings();
  }
}
