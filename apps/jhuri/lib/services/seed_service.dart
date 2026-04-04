import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart';
import '../features/item_template/data/item_template_repository.dart';

/// Service to seed the database with initial data from JSON file
class SeedService {
  final JhuriDatabase _database;

  SeedService(this._database);

  /// Load seed data from JSON and populate database tables
  Future<void> seedDatabaseIfNeeded() async {
    // Check if item templates table is empty - this is the definitive gate
    final itemRepository = ItemTemplateRepository(_database);
    final existingCount = await itemRepository.count();
    if (existingCount > 0) {
      // Items already exist, no need to seed
      return;
    }

    try {
      // Load seed data from assets
      final String jsonString =
          await rootBundle.loadString('assets/data/items_seed.json');
      final Map<String, dynamic> seedData = json.decode(jsonString);

      // Use transaction to ensure all-or-nothing insertion
      await _database.transaction(() async {
        // Seed categories first
        Map<int, int> categoryIdMap = {}; // Maps old ID -> new auto-assigned ID

        if (seedData['categories'] != null) {
          final categories = (seedData['categories'] as List)
              .map((cat) => CategoriesCompanion.insert(
                    nameBangla: cat['nameBangla'],
                    nameEnglish: cat['nameEnglish'],
                    imageIdentifier: cat['imageIdentifier'],
                    iconIdentifier: cat['iconIdentifier'],
                    sortOrder: cat['sortOrder'],
                    isActive: Value(cat['isActive'] ?? true),
                  ))
              .toList();

          // Insert categories and get their auto-assigned IDs
          for (int i = 0; i < categories.length; i++) {
            final category = categories[i];
            final oldId = (seedData['categories'] as List)[i]['id'] as int;
            final newId =
                await _database.into(_database.categories).insert(category);
            categoryIdMap[oldId] = newId;
          }

          debugPrint('✅ Seeded ${categories.length} categories');
        }

        // Seed item templates with new category IDs
        if (seedData['itemTemplates'] != null) {
          final itemTemplates = (seedData['itemTemplates'] as List).map((item) {
            final oldCategoryId = item['categoryId'] as int;
            final newCategoryId = categoryIdMap[oldCategoryId] ??
                (throw Exception(
                    'Category ID mapping not found for old ID: $oldCategoryId'));

            return ItemTemplatesCompanion.insert(
              nameBangla: item['nameBangla'],
              nameEnglish: item['nameEnglish'],
              phoneticName: Value(item['phoneticName']),
              categoryId: newCategoryId,
              defaultQuantity: item['defaultQuantity'].toDouble(),
              defaultUnit: item['defaultUnit'],
              iconIdentifier: Value(item['iconIdentifier']),
              emoji: Value(item['emoji'] ?? '🛒'),
              isCustom: const Value(false),
              isActive: Value(item['isActive'] ?? true),
              usageCount: Value(item['usageCount']),
              sortOrder: Value(item['sortOrder']),
              lastUsedAt: DateTime.now(),
              createdAt: const Value(null), // null for seeded items
            );
          }).toList();

          await _database.batch((batch) {
            batch.insertAll(_database.itemTemplates, itemTemplates);
          });

          debugPrint('✅ Seeded ${itemTemplates.length} item templates');
        }
      });
    } catch (e) {
      throw Exception('Failed to seed database: $e');
    }
  }
}
