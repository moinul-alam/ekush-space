import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class ShoppingListRepository extends BaseRepository {
  ShoppingListRepository(this._db);
  final JhuriDatabase _db;

  // Watch all non-archived lists ordered by buyDate desc
  Stream<List<ShoppingList>> watchActiveLists() {
    return (_db.select(_db.shoppingLists)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .watch();
  }

  // Watch lists for a specific date
  Stream<List<ShoppingList>> watchListsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.shoppingLists)
          ..where((t) =>
              t.buyDate.isBiggerOrEqualValue(start) &
              t.buyDate.isSmallerThanValue(end) &
              t.isArchived.equals(false)))
        .watch();
  }

  Future<ShoppingList?> getById(int id) {
    return (_db.select(_db.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insert(ShoppingListsCompanion entry) {
    return _db.into(_db.shoppingLists).insert(entry);
  }

  Future<bool> update(ShoppingListsCompanion entry) {
    return _db.update(_db.shoppingLists).replace(entry);
  }

  Future<int> delete(int id) {
    return (_db.delete(_db.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<void> markComplete(int id) {
    return (_db.update(_db.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
          isCompleted: const Value(true),
          completedAt: Value(DateTime.now()),
        ));
  }

  Future<void> archive(int id) {
    return (_db.update(_db.shoppingLists)
          ..where((t) => t.id.equals(id)))
        .write(const ShoppingListsCompanion(
          isArchived: Value(true),
        ));
  }
}
