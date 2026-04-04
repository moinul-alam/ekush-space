import 'package:flutter_test/flutter_test.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart' as drift;

void main() {
  // Initialize Flutter bindings for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Drift Smoke Test', () {
    late JhuriDatabase database;

    setUpAll(() async {
      database = JhuriDatabase();
      // Ensure database is ready
      await database.customSelect('SELECT 1').get();
    });

    tearDownAll(() async {
      await database.close();
    });

    test('Database can be initialized', () {
      expect(database, isNotNull);
    });

    test('Can create and query categories', () async {
      // Create a test category
      final category = CategoriesCompanion.insert(
        nameBangla: 'শাকসবজি',
        nameEnglish: 'Vegetables',
        imageIdentifier: 'vegetables',
        iconIdentifier: 'vegetables',
        sortOrder: 1,
      );

      final insertedId =
          await database.into(database.categories).insert(category);
      expect(insertedId, isA<int>());

      // Query the category
      final retrieved = await (database.select(database.categories)
            ..where((c) => c.id.equals(insertedId)))
          .getSingle();

      expect(retrieved.nameBangla, 'শাকসবজি');
      expect(retrieved.nameEnglish, 'Vegetables');
      expect(retrieved.sortOrder, 1);
    });

    test('Can create and query item templates', () async {
      // First create a category
      final category = CategoriesCompanion.insert(
        nameBangla: 'শাকসবজি',
        nameEnglish: 'Vegetables',
        imageIdentifier: 'vegetables',
        iconIdentifier: 'vegetables',
        sortOrder: 1,
      );
      final categoryId =
          await database.into(database.categories).insert(category);

      // Create an item template
      final item = ItemTemplatesCompanion.insert(
        nameBangla: 'আলু',
        nameEnglish: 'Potato',
        categoryId: categoryId,
        defaultQuantity: 1.0,
        defaultUnit: 'কেজি',
        iconIdentifier: drift.Value('vegetable_potato'),
        isCustom: const drift.Value(false),
        usageCount: const drift.Value(0),
        lastUsedAt: DateTime.now(),
      );

      final insertedId =
          await database.into(database.itemTemplates).insert(item);
      expect(insertedId, isA<int>());

      // Query the item
      final retrieved = await (database.select(database.itemTemplates)
            ..where((i) => i.id.equals(insertedId)))
          .getSingle();

      expect(retrieved.nameBangla, 'আলু');
      expect(retrieved.nameEnglish, 'Potato');
      expect(retrieved.categoryId, categoryId);
      expect(retrieved.defaultQuantity, 1.0);
      expect(retrieved.defaultUnit, 'কেজি');
    });

    test('Can create and query shopping lists', () async {
      // Create a shopping list
      final list = ShoppingListsCompanion.insert(
        title: drift.Value('সাপ্তাহিক বাজার'),
        buyDate: DateTime.now(),
        isReminderOn: const drift.Value(false),
        isCompleted: const drift.Value(false),
        isArchived: const drift.Value(false),
        createdAt: DateTime.now(),
      );

      final insertedId =
          await database.into(database.shoppingLists).insert(list);
      expect(insertedId, isA<int>());

      // Query the list
      final retrieved = await (database.select(database.shoppingLists)
            ..where((l) => l.id.equals(insertedId)))
          .getSingle();

      expect(retrieved.title, 'সাপ্তাহিক বাজার');
      expect(retrieved.isCompleted, isFalse);
      expect(retrieved.isArchived, isFalse);
    });

    test('Can create list items with foreign key relationships', () async {
      // Create category
      final category = CategoriesCompanion.insert(
        nameBangla: 'মাছ',
        nameEnglish: 'Fish',
        imageIdentifier: 'fish',
        iconIdentifier: 'fish',
        sortOrder: 2,
      );
      final categoryId =
          await database.into(database.categories).insert(category);

      // Create item template
      final item = ItemTemplatesCompanion.insert(
        nameBangla: 'রুই',
        nameEnglish: 'Rui',
        categoryId: categoryId,
        defaultQuantity: 1.0,
        defaultUnit: 'পিস',
        iconIdentifier: drift.Value('fish_rui'),
        isCustom: const drift.Value(false),
        usageCount: const drift.Value(0),
        lastUsedAt: DateTime.now(),
      );
      final templateId =
          await database.into(database.itemTemplates).insert(item);

      // Create shopping list
      final list = ShoppingListsCompanion.insert(
        title: drift.Value('বাজারের ফর্দ'),
        buyDate: DateTime.now(),
        isReminderOn: const drift.Value(false),
        isCompleted: const drift.Value(false),
        isArchived: const drift.Value(false),
        createdAt: DateTime.now(),
      );
      final listId = await database.into(database.shoppingLists).insert(list);

      // Create list item
      final listItem = ListItemsCompanion.insert(
        listId: listId,
        templateId: drift.Value(templateId),
        nameBangla: 'রুই',
        nameEnglish: 'Rui',
        quantity: drift.Value(2.0),
        unit: 'পিস',
        price: drift.Value(150.0),
        isBought: const drift.Value(false),
        sortOrder: 1,
        addedAt: DateTime.now(),
      );

      final insertedId =
          await database.into(database.listItems).insert(listItem);
      expect(insertedId, isA<int>());

      // Simple query to verify the item was created
      final retrieved = await (database.select(database.listItems)
            ..where((li) => li.id.equals(insertedId)))
          .getSingle();

      expect(retrieved.nameBangla, 'রুই');
      expect(retrieved.nameEnglish, 'Rui');
      expect(retrieved.listId, listId);
      expect(retrieved.templateId, templateId);
      expect(retrieved.price, 150.0);
    });
  });
}
