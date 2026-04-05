import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, ItemTemplates, ShoppingLists, ListItems])
class JhuriDatabase extends _$JhuriDatabase {
  JhuriDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(categories, categories.isCustom);
          }
          if (from < 3) {
            await m.addColumn(itemTemplates, itemTemplates.phoneticName);
            await m.addColumn(itemTemplates, itemTemplates.emoji);
            await m.addColumn(itemTemplates, itemTemplates.isActive);
            await m.addColumn(itemTemplates, itemTemplates.sortOrder);
            await m.addColumn(categories, categories.isActive);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'jhuri.sqlite'));
    return NativeDatabase(file);
  });
}
