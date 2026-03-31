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

  Future<bool> update(ListItemsCompanion entry) {
    return _db.update(_db.listItems).replace(entry);
  }

  Future<int> deleteItemsForList(int listId) {
    return (_db.delete(_db.listItems)
          ..where((t) => t.listId.equals(listId)))
        .go();
  }

  Future<void> markBought(int id, bool isBought) {
    return (_db.update(_db.listItems)
          ..where((t) => t.id.equals(id)))
        .write(ListItemsCompanion(isBought: Value(isBought)));
  }
}
