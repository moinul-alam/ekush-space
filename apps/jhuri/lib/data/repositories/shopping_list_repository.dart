import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';

class ShoppingListRepository extends BaseRepository {
  ShoppingListRepository(this._db);
  final JhuriDatabase _db;

  // Watch all lists (including archived) ordered by buyDate desc
  Stream<List<ShoppingList>> watchAllLists() {
    return (_db.select(_db.shoppingLists)
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .watch();
  }

  // Watch active lists for a specific date
  Stream<List<ShoppingList>> watchActiveListsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.shoppingLists)
          ..where((t) =>
              t.buyDate.isBiggerOrEqualValue(start) &
              t.buyDate.isSmallerThanValue(end) &
              t.isArchived.equals(false)))
        .watch();
  }

  Future<ShoppingList?> getListById(int id) {
    return (_db.select(_db.shoppingLists)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Backward compatibility method
  Future<ShoppingList?> getById(int id) {
    return getListById(id);
  }

  Future<int> createList({
    required DateTime buyDate,
    String? title,
    DateTime? reminderTime,
    bool? isReminderOn,
  }) {
    return insert(ShoppingListsCompanion.insert(
      title: Value(title ?? ''),
      buyDate: buyDate,
      reminderTime: Value(reminderTime),
      isReminderOn: Value(isReminderOn ?? false),
      createdAt: DateTime.now(),
    ));
  }

  Future<int> insert(ShoppingListsCompanion entry) {
    return _db.into(_db.shoppingLists).insert(entry);
  }

  Future<bool> update(ShoppingListsCompanion entry) {
    return _db.update(_db.shoppingLists).replace(entry);
  }

  Future<void> updateList(ShoppingListsCompanion companion) {
    return update(companion).then((_) {});
  }

  Future<int> deleteList(int id) {
    return (_db.delete(_db.shoppingLists)..where((t) => t.id.equals(id))).go();
  }

  Future<void> markComplete(int id) {
    return (_db.update(_db.shoppingLists)..where((t) => t.id.equals(id)))
        .write(ShoppingListsCompanion(
      isCompleted: const Value(true),
      completedAt: Value(DateTime.now()),
    ));
  }

  Future<void> archive(int id) {
    return (_db.update(_db.shoppingLists)..where((t) => t.id.equals(id)))
        .write(const ShoppingListsCompanion(
      isArchived: Value(true),
    ));
  }

  // Watch all non-archived lists ordered by buyDate desc (for backward compatibility)
  Stream<List<ShoppingList>> watchActiveLists() {
    return (_db.select(_db.shoppingLists)
          ..where((t) => t.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.buyDate)]))
        .watch();
  }

  Future<void> markListComplete(int id) {
    return markComplete(id);
  }

  Future<void> archiveList(int id) {
    return archive(id);
  }

  Future<int> duplicateList(int sourceId) async {
    final sourceList = await getListById(sourceId);
    if (sourceList == null) throw Exception('Source list not found');

    return _db.transaction(() async {
      // 1. Create the new list
      final newListId = await insert(ShoppingListsCompanion.insert(
        title: Value('${sourceList.title} (কপি)'),
        buyDate: DateTime.now(),
        reminderTime: Value(sourceList.reminderTime),
        isReminderOn: Value(sourceList.isReminderOn),
        createdAt: DateTime.now(),
        sourceListId: Value(sourceId),
      ));

      // 2. Fetch all items from source list
      final sourceItems = await (_db.select(_db.listItems)
            ..where((t) => t.listId.equals(sourceId)))
          .get();

      // 3. Duplicate each item for the new list
      for (final item in sourceItems) {
        await _db.into(_db.listItems).insert(ListItemsCompanion.insert(
              listId: newListId,
              templateId: Value(item.templateId),
              nameBangla: item.nameBangla,
              quantity: Value(item.quantity),
              unit: item.unit,
              price: Value(item.price),
              isBought: const Value(false), // Reset status
              sortOrder: Value(item.sortOrder),
              addedAt: DateTime.now(),
            ));
      }

      return newListId;
    });
  }
}
