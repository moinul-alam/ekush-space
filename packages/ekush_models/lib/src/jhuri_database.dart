import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'jhuri_database.g.dart';

// ── Tables ──────────────────────────────────────────────────

class ShoppingLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get buyDate => dateTime()();
  DateTimeColumn get reminderTime => dateTime().nullable()();
  BoolColumn get isReminderOn => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get sourceListId => integer().nullable()();
}

class ListItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get listId => integer()();
  IntColumn get templateId => integer().nullable()();
  TextColumn get nameBangla => text()();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  TextColumn get unit => text()();
  RealColumn get price => real().nullable()();
  BoolColumn get isBought => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get addedAt => dateTime()();
}

class ItemTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameBangla => text()();
  TextColumn get nameEnglish => text()();
  IntColumn get categoryId => integer()();
  RealColumn get defaultQuantity => real().withDefault(const Constant(1.0))();
  TextColumn get defaultUnit => text()();
  TextColumn get iconIdentifier => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUsedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameBangla => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get imageIdentifier => text()();
  TextColumn get iconIdentifier => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class AppSettingsTable extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get language => text().withDefault(const Constant('bangla'))();
  BoolColumn get showPriceTotal => boolean().withDefault(const Constant(true))();
  TextColumn get defaultUnit => text().withDefault(const Constant('কেজি'))();
  TextColumn get currencySymbol => text().withDefault(const Constant('৳'))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get defaultReminderTime => text().withDefault(const Constant('18:00'))();
  TextColumn get listSortOrder => text().withDefault(const Constant('dateDesc'))();
  IntColumn get appOpenCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastInterstitialShown => dateTime().nullable()();
  DateTimeColumn get lastExportDate => dateTime().nullable()();
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
  BoolColumn get reviewPrompted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────────

@DriftDatabase(tables: [
  ShoppingLists,
  ListItems,
  ItemTemplates,
  Categories,
  AppSettingsTable,
])
class JhuriDatabase extends _$JhuriDatabase {
  JhuriDatabase() : super(_openConnection());

  JhuriDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Insert default AppSettings row (singleton, id=1)
      await into(appSettingsTable).insert(
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
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'jhuri.db'));
    return NativeDatabase.createInBackground(file);
  });
}
