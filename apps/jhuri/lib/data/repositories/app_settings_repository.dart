import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class AppSettingsRepository extends BaseRepository {
  AppSettingsRepository(this._db);
  final JhuriDatabase _db;

  // Always returns the singleton row (id=1, created by migration)
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
        );
    return getSettings();
  }

  Stream<AppSettingsTableData> watchSettings() {
    return (_db.select(_db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .watchSingle();
  }

  Future<void> updateSettings(AppSettingsTableCompanion companion) {
    return (_db.update(_db.appSettingsTable)
          ..where((t) => t.id.equals(1)))
        .write(companion);
  }

  Future<void> incrementAppOpenCount() async {
    final settings = await getSettings();
    await updateSettings(AppSettingsTableCompanion(
      appOpenCount: Value(settings.appOpenCount + 1),
    ));
  }

  Future<void> setOnboardingComplete() {
    return updateSettings(const AppSettingsTableCompanion(
      onboardingComplete: Value(true),
    ));
  }

  Future<bool> isOnboardingComplete() async {
    final settings = await getSettings();
    return settings.onboardingComplete;
  }
}
