import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class ListItemRepository extends BaseRepository {
  ListItemRepository(this._db);
  final JhuriDatabase _db;

  Stream<List<ListItem>> watchItemsForList(int listId) {
    return (_db.select(_db.listItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<List<ListItem>> getItemsForList(int listId) {
    return (_db.select(_db.listItems)
          ..where((t) => t.listId.equals(listId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Future<int> insert(ListItemsCompanion entry) {
    return _db.into(_db.listItems).insert(entry);
  }

  Future<int> addItem({
    required int listId,
    int? templateId,
    required String nameBangla,
    required double quantity,
    required String unit,
    double? price,
    required int sortOrder,
  }) {
    return insert(ListItemsCompanion.insert(
      listId: listId,
      templateId: Value(templateId),
      nameBangla: nameBangla,
      quantity: Value(quantity),
      unit: unit,
      price: Value(price),
      sortOrder: Value(sortOrder),
      addedAt: DateTime.now(),
    ));
  }

  Future<bool> update(ListItemsCompanion entry) {
    return _db.update(_db.listItems).replace(entry);
  }

  Future<void> updateItem(ListItemsCompanion companion) {
    return update(companion).then((_) {});
  }

  Future<int> deleteItemsForList(int listId) {
    return (_db.delete(_db.listItems)..where((t) => t.listId.equals(listId)))
        .go();
  }

  Future<void> markBought(int id, bool isBought) {
    return (_db.update(_db.listItems)..where((t) => t.id.equals(id)))
        .write(ListItemsCompanion(isBought: Value(isBought)));
  }

  Future<void> toggleBought(int itemId, bool isBought) {
    return markBought(itemId, isBought);
  }

  Future<int> deleteItem(int itemId) {
    return (_db.delete(_db.listItems)..where((t) => t.id.equals(itemId))).go();
  }

  Future<void> reorderItems(int listId, List<int> orderedIds) {
    return _db.transaction(() async {
      for (int i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.listItems)
              ..where(
                  (t) => t.id.equals(orderedIds[i]) & t.listId.equals(listId)))
            .write(ListItemsCompanion(sortOrder: Value(i)));
      }
    });
  }
}
