import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart';

/// Repository for managing ShoppingLists data
class ShoppingListRepository extends SoftDeleteRepository<ShoppingList> {
  final JhuriDatabase _database;

  ShoppingListRepository(this._database);

  @override
  Future<List<ShoppingList>> getAll() async {
    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .get();
  }

  @override
  Future<ShoppingList?> getById(int id) async {
    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<int> create(ShoppingList item) async {
    throw UnimplementedError('Use createFromCompanion instead');
  }

  /// Create using companion object
  Future<int> createFromCompanion(ShoppingListsCompanion item) async {
    return await _database.into(_database.shoppingLists).insert(item);
  }

  @override
  Future<bool> update(ShoppingList item) async {
    throw UnimplementedError('Use updateFromCompanion instead');
  }

  /// Update using companion object
  Future<bool> updateFromCompanion(ShoppingListsCompanion item) async {
    return await _database.update(_database.shoppingLists).replace(item);
  }

  @override
  Future<bool> delete(int id) async {
    return await archive(id);
  }

  @override
  Future<bool> deleteAll(List<int> ids) async {
    final rowsAffected = await (_database.update(_database.shoppingLists)
          ..where((t) => t.id.isIn(ids)))
        .write(ShoppingListsCompanion(
      isArchived: const Value(true),
    ));
    return rowsAffected > 0;
  }

  @override
  Future<int> count() async {
    final query = _database.selectOnly(_database.shoppingLists)
      ..addColumns([_database.shoppingLists.id.count()])
      ..where(_database.shoppingLists.isArchived.equals(false));
    final result = await query.getSingle();
    return result.read(_database.shoppingLists.id) as int;
  }

  @override
  Future<bool> exists(int id) async {
    final query = _database.selectOnly(_database.shoppingLists)
      ..addColumns([_database.shoppingLists.id.count()])
      ..where(_database.shoppingLists.id.equals(id));
    final result = await query.getSingle();
    return (result.read(_database.shoppingLists.id) as int) > 0;
  }

  @override
  Future<List<ShoppingList>> getWithPagination({
    int limit = 20,
    int offset = 0,
    String? orderBy,
    bool ascending = true,
  }) async {
    final query = _database.select(_database.shoppingLists)
      ..where((t) => t.isArchived.equals(false));

    if (orderBy != null) {
      if (orderBy == 'buyDate') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.buyDate,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      } else if (orderBy == 'title') {
        query.orderBy([
          (t) => OrderingTerm(
                expression: t.title,
                mode: ascending ? OrderingMode.asc : OrderingMode.desc,
              )
        ]);
      }
    } else {
      query.orderBy([(t) => OrderingTerm.desc(t.buyDate)]);
    }

    query.limit(limit, offset: offset);
    return await query.get();
  }

  @override
  Future<List<ShoppingList>> getActive() async {
    return await getAll();
  }

  @override
  Future<List<ShoppingList>> getArchived() async {
    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.isArchived.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  @override
  Future<bool> archive(int id) async {
    final rowsAffected = await (_database.update(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
      isArchived: const Value(true),
    ));
    return rowsAffected > 0;
  }

  @override
  Future<bool> restore(int id) async {
    final rowsAffected = await (_database.update(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
      isArchived: const Value(false),
    ));
    return rowsAffected > 0;
  }

  @override
  Future<bool> permanentDelete(int id) async {
    final rowsAffected = await (_database.delete(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .go();
    return rowsAffected > 0;
  }

  /// Get lists by date range
  Future<List<ShoppingList>> getByDateRange(
      DateTime start, DateTime end) async {
    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.buyDate.isBetweenValues(start, end))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .get();
  }

  /// Get today's lists
  Future<List<ShoppingList>> getTodayLists() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return await getByDateRange(today, tomorrow);
  }

  /// Get upcoming lists (future dates)
  Future<List<ShoppingList>> getUpcomingLists() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.buyDate.isBiggerOrEqualValue(tomorrow))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.buyDate)]))
        .get();
  }

  /// Get past incomplete lists
  Future<List<ShoppingList>> getPastIncompleteLists() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return await (_database.select(_database.shoppingLists)
          ..where((t) => t.buyDate.isSmallerThanValue(today))
          ..where((t) => t.isCompleted.equals(false))
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .get();
  }

  /// Mark list as completed
  Future<bool> markAsCompleted(int id) async {
    final rowsAffected = await (_database.update(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
      isCompleted: const Value(true),
      completedAt: Value(DateTime.now()),
    ));
    return rowsAffected > 0;
  }

  /// Mark list as incomplete (reopen)
  Future<bool> markAsIncomplete(int id) async {
    final rowsAffected = await (_database.update(_database.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
      isCompleted: const Value(false),
      completedAt: const Value(null),
    ));
    return rowsAffected > 0;
  }

  /// Duplicate a list
  Future<int> duplicateList(
      int sourceListId, String newTitle, DateTime newBuyDate) async {
    final sourceList = await getById(sourceListId);
    if (sourceList == null) throw Exception('Source list not found');

    final newList = ShoppingListsCompanion.insert(
      title: Value(newTitle),
      buyDate: newBuyDate,
      sourceListId: Value(sourceListId),
      createdAt: DateTime.now(),
    );

    return await _database.into(_database.shoppingLists).insert(newList);
  }
}
