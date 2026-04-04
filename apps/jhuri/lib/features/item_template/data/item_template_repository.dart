import 'package:flutter/foundation.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart';

/// Repository for managing ItemTemplates data
class ItemTemplateRepository extends BaseRepository<ItemTemplate> {
  final JhuriDatabase _database;

  ItemTemplateRepository(this._database);

  @override
  Future<List<ItemTemplate>> getAll() async {
    return await (_database.select(_database.itemTemplates)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nameBangla)]))
        .get();
  }

  @override
  Future<ItemTemplate?> getById(int id) async {
    return await (_database.select(_database.itemTemplates)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<int> create(ItemTemplate item) async {
    throw UnimplementedError('Use createFromCompanion instead');
  }

  /// Create using companion object
  Future<int> createFromCompanion(ItemTemplatesCompanion item) async {
    return await _database.into(_database.itemTemplates).insert(item);
  }

  @override
  Future<bool> update(ItemTemplate item) async {
    throw UnimplementedError('Use updateFromCompanion instead');
  }

  /// Update using companion object
  Future<bool> updateFromCompanion(ItemTemplatesCompanion item) async {
    return await _database.update(_database.itemTemplates).replace(item);
  }

  @override
  Future<bool> delete(int id) async {
    final rowsAffected = await (_database.delete(_database.itemTemplates)
          ..where((t) => t.id.equals(id)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteAll(List<int> ids) async {
    final rowsAffected = await (_database.delete(_database.itemTemplates)
          ..where((t) => t.id.isIn(ids)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<int> count() async {
    final count = _database.itemTemplates.id.count();
    final query = _database.selectOnly(_database.itemTemplates)
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  @override
  Future<bool> exists(int id) async {
    final query = _database.selectOnly(_database.itemTemplates)
      ..addColumns([_database.itemTemplates.id.count()])
      ..where(_database.itemTemplates.id.equals(id));
    final result = await query.getSingle();
    return (result.read(_database.itemTemplates.id) as int) > 0;
  }

  @override
  Future<List<ItemTemplate>> getWithPagination({
    int limit = 20,
    int offset = 0,
    String? orderBy,
    bool ascending = true,
  }) async {
    final query = _database.select(_database.itemTemplates);

    if (orderBy != null) {
      if (orderBy == 'nameBangla') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.nameBangla,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      } else if (orderBy == 'usageCount') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.usageCount,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      }
    } else {
      query.orderBy([(t) => OrderingTerm.asc(t.nameBangla)]);
    }

    query.limit(limit, offset: offset);
    return await query.get();
  }

  /// Get item templates by category ID
  Future<List<ItemTemplate>> getByCategoryId(int categoryId) async {
    final items = await (_database.select(_database.itemTemplates)
          ..where(
              (t) => t.categoryId.equals(categoryId) & t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    debugPrint('🔍 Found ${items.length} items for categoryId $categoryId');
    if (categoryId == 1) {
      debugPrint(
          '🔍 Items for category 1 (Vegetables): ${items.map((i) => i.nameBangla).join(', ')}');
    }

    return items;
  }

  /// Get custom items only
  Future<List<ItemTemplate>> getCustomItems() async {
    return await (_database.select(_database.itemTemplates)
          ..where((t) => t.isCustom.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nameBangla)]))
        .get();
  }

  /// Get seeded items only
  Future<List<ItemTemplate>> getSeededItems() async {
    return await (_database.select(_database.itemTemplates)
          ..where((t) => t.isCustom.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.nameBangla)]))
        .get();
  }

  /// Increment usage count for an item template
  Future<bool> incrementUsageCount(int id) async {
    final query = _database.update(_database.itemTemplates)
      ..where((t) => t.id.equals(id));

    final rowsAffected = await query.write(
      ItemTemplatesCompanion(
        usageCount: const Value(1),
        lastUsedAt: Value(DateTime.now()),
      ),
    );
    return rowsAffected > 0;
  }

  /// Search item templates by name (Bangla, English, and phonetic)
  Future<List<ItemTemplate>> searchByName(String searchTerm) async {
    final lowerSearchTerm = searchTerm.toLowerCase();
    return await (_database.select(_database.itemTemplates)
          ..where((t) =>
              (t.nameBangla.contains(searchTerm) |
                  t.nameEnglish.contains(searchTerm) |
                  t.phoneticName.contains(lowerSearchTerm)) &
              t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nameBangla)]))
        .get();
  }

  /// Create a custom item template
  Future<int> createCustomItem({
    required String nameBangla,
    required String nameEnglish,
    required String phoneticName,
    required int categoryId,
    required double defaultQuantity,
    required String defaultUnit,
    required String emoji,
    required int sortOrder,
  }) {
    return _database.into(_database.itemTemplates).insert(
          ItemTemplatesCompanion.insert(
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            phoneticName: Value(phoneticName),
            categoryId: categoryId,
            defaultQuantity: defaultQuantity,
            defaultUnit: defaultUnit,
            emoji: Value(emoji),
            iconIdentifier: const Value(null),
            isCustom: const Value(true),
            isActive: const Value(true),
            usageCount: const Value(0),
            sortOrder: Value(sortOrder),
            lastUsedAt: DateTime.now(),
            createdAt: Value(DateTime.now()),
          ),
        );
  }
}
