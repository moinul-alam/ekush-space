import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'category_repository.dart';

class ItemTemplateRepository extends BaseRepository {
  ItemTemplateRepository(this._db);
  final JhuriDatabase _db;

  Stream<List<ItemTemplate>> watchTemplatesByCategory(int categoryId) {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.desc(t.lastUsedAt),
            (t) => OrderingTerm.asc(t.nameBangla),
          ]))
        .watch();
  }

  Future<List<Category>> getAllCategories() async {
    final categoryRepo = CategoryRepository(_db);
    return categoryRepo.getAllSorted();
  }

  Future<List<ItemTemplate>> getByCategory(int categoryId) {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.desc(t.lastUsedAt),
            (t) => OrderingTerm.asc(t.nameBangla),
          ]))
        .get();
  }

  Future<List<ItemTemplate>> getFrequentlyUsed({int limit = 15}) {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.usageCount.isBiggerThanValue(0))
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.desc(t.lastUsedAt),
          ])
          ..limit(limit))
        .get();
  }

  Future<List<ItemTemplate>> getCustomItems() {
    return (_db.select(_db.itemTemplates)
          ..where((t) => t.isCustom.equals(true)))
        .get();
  }

  Future<ItemTemplate?> getById(int id) {
    return (_db.select(_db.itemTemplates)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insert(ItemTemplatesCompanion entry) {
    return _db.into(_db.itemTemplates).insert(entry);
  }

  Future<bool> update(ItemTemplatesCompanion entry) {
    return _db.update(_db.itemTemplates).replace(entry);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.itemTemplates)..where((t) => t.id.equals(id))).go();
  }

  Future<void> incrementUsage(int id) async {
    final template = await getById(id);
    if (template == null) return;
    await (_db.update(_db.itemTemplates)..where((t) => t.id.equals(id)))
        .write(ItemTemplatesCompanion(
      usageCount: Value(template.usageCount + 1),
      lastUsedAt: Value(DateTime.now()),
    ));
  }

  Future<int> addCustomItem({
    required String nameBangla,
    required int categoryId,
    required double defaultQuantity,
    required String defaultUnit,
  }) {
    return insert(ItemTemplatesCompanion.insert(
      nameBangla: nameBangla,
      nameEnglish: nameBangla, // Use Bangla name as English for custom items
      categoryId: categoryId,
      defaultQuantity: Value(defaultQuantity),
      defaultUnit: defaultUnit,
      iconIdentifier: 'custom_item', // Default icon for custom items
      isCustom: const Value(true),
      usageCount: const Value(0),
      lastUsedAt: DateTime.now(),
      createdAt: Value(DateTime.now()),
    ));
  }

  Future<int> deleteCustomItem(int templateId) {
    return delete(templateId);
  }

  Future<List<ItemTemplate>> searchTemplates(String query) {
    return (_db.select(_db.itemTemplates)
          ..where((t) =>
              t.nameBangla.contains(query) | t.nameEnglish.contains(query))
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.nameBangla)
          ]))
        .get();
  }

  Future<int> countAll() {
    return _db.itemTemplates.count().getSingle();
  }
}
