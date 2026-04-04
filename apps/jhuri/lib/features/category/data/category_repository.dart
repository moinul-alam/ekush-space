import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart';

/// Repository for managing Categories data
class CategoryRepository extends BaseRepository<Category> {
  final JhuriDatabase _database;

  CategoryRepository(this._database);

  @override
  Future<List<Category>> getAll() async {
    return await (_database.select(_database.categories)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  @override
  Future<Category?> getById(int id) async {
    return await (_database.select(_database.categories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<int> create(Category item) async {
    throw UnimplementedError('Use createFromCompanion instead');
  }

  /// Create using companion object
  Future<int> createFromCompanion(CategoriesCompanion item) async {
    return await _database.into(_database.categories).insert(item);
  }

  @override
  Future<bool> update(Category item) async {
    throw UnimplementedError('Use updateFromCompanion instead');
  }

  /// Update using companion object
  Future<bool> updateFromCompanion(CategoriesCompanion item) async {
    return await _database.update(_database.categories).replace(item);
  }

  @override
  Future<bool> delete(int id) async {
    final rowsAffected = await (_database.delete(_database.categories)
          ..where((t) => t.id.equals(id)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteAll(List<int> ids) async {
    final rowsAffected = await (_database.delete(_database.categories)
          ..where((t) => t.id.isIn(ids)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<int> count() async {
    final query = _database.selectOnly(_database.categories)
      ..addColumns([_database.categories.id.count()]);
    final result = await query.getSingle();
    return result.read(_database.categories.id) as int;
  }

  @override
  Future<bool> exists(int id) async {
    final query = _database.selectOnly(_database.categories)
      ..addColumns([_database.categories.id.count()])
      ..where(_database.categories.id.equals(id));
    final result = await query.getSingle();
    return (result.read(_database.categories.id) as int) > 0;
  }

  @override
  Future<List<Category>> getWithPagination({
    int limit = 20,
    int offset = 0,
    String? orderBy,
    bool ascending = true,
  }) async {
    final query = _database.select(_database.categories);

    if (orderBy != null) {
      if (orderBy == 'sortOrder') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.sortOrder,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      } else if (orderBy == 'nameBangla') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.nameBangla,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      }
    } else {
      query.orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    }

    query.limit(limit, offset: offset);
    return await query.get();
  }

  /// Get categories by sort order (most common use case)
  Future<List<Category>> getBySortOrder() async {
    return await getAll();
  }

  /// Get category by image identifier
  Future<Category?> getByImageIdentifier(String imageIdentifier) async {
    return await (_database.select(_database.categories)
          ..where((t) => t.imageIdentifier.equals(imageIdentifier)))
        .getSingleOrNull();
  }

  // Insert a custom category
  Future<int> createCustomCategory({
    required String nameBangla,
    required String nameEnglish,
    required String iconIdentifier,
  }) async {
    final maxSortOrder = await _getMaxSortOrder();
    return await _database.into(_database.categories).insert(
          CategoriesCompanion.insert(
            nameBangla: nameBangla,
            nameEnglish: nameEnglish,
            imageIdentifier: '', // no image for custom categories
            iconIdentifier: iconIdentifier,
            sortOrder: maxSortOrder + 1,
            isCustom: const Value(true),
          ),
        );
  }

  // Watch all categories (seeded + custom), ordered by sortOrder
  Stream<List<Category>> watchAllCategories() =>
      (_database.select(_database.categories)
            ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
          .watch();

  // Helper method to get max sort order
  Future<int> _getMaxSortOrder() async {
    final query = _database.selectOnly(_database.categories)
      ..addColumns([_database.categories.sortOrder.max()]);
    final result = await query.getSingle();
    return result.read(_database.categories.sortOrder.max()) ?? 0;
  }
}
