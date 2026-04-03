import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart';

/// Repository for managing ListItems data
class ListItemRepository extends BaseRepository<ListItem> {
  final JhuriDatabase _database;

  ListItemRepository(this._database);

  @override
  Future<List<ListItem>> getAll() async {
    return await (_database.select(_database.listItems)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  @override
  Future<ListItem?> getById(int id) async {
    return await (_database.select(_database.listItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<int> create(ListItem item) async {
    throw UnimplementedError('Use createFromCompanion instead');
  }

  /// Create using companion object
  Future<int> createFromCompanion(ListItemsCompanion item) async {
    return await _database.into(_database.listItems).insert(item);
  }

  @override
  Future<bool> update(ListItem item) async {
    throw UnimplementedError('Use updateFromCompanion instead');
  }

  /// Update using companion object
  Future<bool> updateFromCompanion(ListItemsCompanion item) async {
    return await _database.update(_database.listItems).replace(item);
  }

  @override
  Future<bool> delete(int id) async {
    final rowsAffected = await (_database.delete(_database.listItems)
          ..where((t) => t.id.equals(id)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteAll(List<int> ids) async {
    final rowsAffected = await (_database.delete(_database.listItems)
          ..where((t) => t.id.isIn(ids)))
        .go();
    return rowsAffected > 0;
  }

  @override
  Future<int> count() async {
    final query = _database.selectOnly(_database.listItems)
      ..addColumns([_database.listItems.id.count()]);
    final result = await query.getSingle();
    return result.read(_database.listItems.id) as int;
  }

  @override
  Future<bool> exists(int id) async {
    final query = _database.selectOnly(_database.listItems)
      ..addColumns([_database.listItems.id.count()])
      ..where(_database.listItems.id.equals(id));
    final result = await query.getSingle();
    return (result.read(_database.listItems.id) as int) > 0;
  }

  @override
  Future<List<ListItem>> getWithPagination({
    int limit = 20,
    int offset = 0,
    String? orderBy,
    bool ascending = true,
  }) async {
    final query = _database.select(_database.listItems);

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

  /// Get items by list ID
  Future<List<ListItem>> getByListId(int listId) async {
    return await (_database.select(_database.listItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get items by list ID grouped by category
  Future<Map<int, List<ListItem>>> getByListIdGroupedByCategory(
      int listId) async {
    final items = await getByListId(listId);
    final Map<int, List<ListItem>> grouped = {};

    for (final item in items) {
      if (item.templateId != null) {
        final categoryId = item.templateId!;
        grouped.putIfAbsent(categoryId, () => []).add(item);
      }
    }

    return grouped;
  }

  /// Get bought items for a list
  Future<List<ListItem>> getBoughtItems(int listId) async {
    return await (_database.select(_database.listItems)
          ..where((t) => t.listId.equals(listId))
          ..where((t) => t.isBought.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Get unbought items for a list
  Future<List<ListItem>> getUnboughtItems(int listId) async {
    return await (_database.select(_database.listItems)
          ..where((t) => t.listId.equals(listId))
          ..where((t) => t.isBought.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  /// Mark item as bought/unbought
  Future<bool> markAsBought(int id, bool isBought) async {
    final rowsAffected = await (_database.update(_database.listItems)
          ..where((t) => t.id.equals(id)))
        .write(ListItemsCompanion(
      isBought: Value(isBought),
    ));
    return rowsAffected > 0;
  }

  /// Toggle bought status
  Future<bool> toggleBoughtStatus(int id) async {
    final item = await getById(id);
    if (item == null) return false;

    return await markAsBought(id, !item.isBought);
  }

  /// Update item quantity and unit
  Future<bool> updateQuantityAndUnit(
      int id, double quantity, String unit) async {
    final rowsAffected = await (_database.update(_database.listItems)
          ..where((t) => t.id.equals(id)))
        .write(ListItemsCompanion(
      quantity: Value(quantity),
      unit: Value(unit),
    ));
    return rowsAffected > 0;
  }

  /// Update item price
  Future<bool> updatePrice(int id, double? price) async {
    final rowsAffected = await (_database.update(_database.listItems)
          ..where((t) => t.id.equals(id)))
        .write(ListItemsCompanion(
      price: Value(price),
    ));
    return rowsAffected > 0;
  }

  /// Get total price for a list
  Future<double> getTotalPrice(int listId) async {
    final items = await getByListId(listId);
    double total = 0.0;

    for (final item in items) {
      if (item.price != null) {
        total += item.price! * item.quantity;
      }
    }

    return total;
  }

  /// Get bought count for a list
  Future<int> getBoughtCount(int listId) async {
    final query = _database.selectOnly(_database.listItems)
      ..addColumns([_database.listItems.id.count()])
      ..where(_database.listItems.listId.equals(listId))
      ..where(_database.listItems.isBought.equals(true));
    final result = await query.getSingle();
    return result.read(_database.listItems.id) as int;
  }

  /// Get total count for a list
  Future<int> getTotalCount(int listId) async {
    final query = _database.selectOnly(_database.listItems)
      ..addColumns([_database.listItems.id.count()])
      ..where(_database.listItems.listId.equals(listId));
    final result = await query.getSingle();
    return result.read(_database.listItems.id) as int;
  }

  /// Reorder items in a list
  Future<bool> reorderItems(int listId, List<int> newOrder) async {
    await _database.transaction(() async {
      for (int i = 0; i < newOrder.length; i++) {
        await (_database.update(_database.listItems)
              ..where((t) => t.id.equals(newOrder[i])))
            .write(ListItemsCompanion(
          sortOrder: Value(i),
        ));
      }
    });
    return true;
  }

  /// Delete all items for a list
  Future<bool> deleteByListId(int listId) async {
    final rowsAffected = await (_database.delete(_database.listItems)
          ..where((t) => t.listId.equals(listId)))
        .go();
    return rowsAffected > 0;
  }

  /// Duplicate items from source list to target list
  Future<bool> duplicateItems(int sourceListId, int targetListId) async {
    final sourceItems = await getByListId(sourceListId);

    await _database.transaction(() async {
      for (final item in sourceItems) {
        final newItem = ListItemsCompanion.insert(
          listId: targetListId,
          templateId: Value(item.templateId),
          nameBangla: item.nameBangla,
          nameEnglish: item.nameEnglish,
          quantity: Value(item.quantity),
          unit: item.unit,
          price: Value(item.price),
          isBought: const Value(false),
          sortOrder: item.sortOrder,
          addedAt: DateTime.now(),
        );
        await _database.into(_database.listItems).insert(newItem);
      }
    });

    return true;
  }
}
