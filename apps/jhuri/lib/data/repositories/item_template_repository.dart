import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class ItemTemplateRepository extends BaseRepository {
  ItemTemplateRepository(this._db);
  final JhuriDatabase _db;

  Future<List<ItemTemplate>> getByCategory(int categoryId) {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.nameBangla)]))
        .get();
  }

  Future<List<ItemTemplate>> getCustomItems() {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.isCustom.equals(true)))
        .get();
  }

  Future<ItemTemplate?> getById(int id) {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insert(ItemTemplatesCompanion entry) {
    return _db.into(_db.itemTemplates).insert(entry);
  }

  Future<bool> update(ItemTemplatesCompanion entry) {
    return _db.update(_db.itemTemplates).replace(entry);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.itemTemplates)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> incrementUsage(int id) async {
    final template = await getById(id);
    if (template == null) return;
    await (_db.update(_db.itemTemplates)
          ..where((t) => t.id.equals(id)))
        .write(ItemTemplatesCompanion(
          usageCount: Value(template.usageCount + 1),
          lastUsedAt: Value(DateTime.now()),
        ));
  }

  Future<int> countAll() {
    return _db.itemTemplates.count().getSingle();
  }
}
