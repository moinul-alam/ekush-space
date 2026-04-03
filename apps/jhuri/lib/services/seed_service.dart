import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart' show Value;
import 'package:shared_preferences/shared_preferences.dart';

/// Service to seed the database with initial data from JSON file
class SeedService {
  final JhuriDatabase _database;
  static const String _seedCompleteKey = 'jhuri_seed_complete';

  SeedService(this._database);

  /// Check if seed data has already been loaded
  Future<bool> get isSeedComplete async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seedCompleteKey) ?? false;
  }

  /// Load seed data from JSON and populate database tables
  Future<void> seedDatabaseIfNeeded() async {
    if (await isSeedComplete) return;

    try {
      // Load seed data from assets
      final String jsonString =
          await rootBundle.loadString('assets/data/items_seed.json');
      final Map<String, dynamic> seedData = json.decode(jsonString);

      // Use transaction to ensure all-or-nothing insertion
      await _database.transaction(() async {
        // Seed categories
        if (seedData['categories'] != null) {
          final categories = (seedData['categories'] as List)
              .map((cat) => CategoriesCompanion.insert(
                    id: Value(cat['id']),
                    nameBangla: cat['nameBangla'],
                    nameEnglish: cat['nameEnglish'],
                    imageIdentifier: cat['imageIdentifier'],
                    iconIdentifier: cat['iconIdentifier'],
                    sortOrder: cat['sortOrder'],
                  ))
              .toList();

          await _database.batch((batch) {
            batch.insertAll(_database.categories, categories);
          });
        }

        // Seed item templates
        if (seedData['itemTemplates'] != null) {
          final itemTemplates = (seedData['itemTemplates'] as List)
              .map((item) => ItemTemplatesCompanion.insert(
                    id: Value(item['id']),
                    nameBangla: item['nameBangla'],
                    nameEnglish: item['nameEnglish'],
                    categoryId: item['categoryId'],
                    defaultQuantity: item['defaultQuantity'].toDouble(),
                    defaultUnit: item['defaultUnit'],
                    iconIdentifier: item['iconIdentifier'],
                    isCustom: const Value(false),
                    usageCount: Value(item['usageCount']),
                    lastUsedAt: DateTime.now(),
                    createdAt: const Value(null), // null for seeded items
                  ))
              .toList();

          await _database.batch((batch) {
            batch.insertAll(_database.itemTemplates, itemTemplates);
          });
        }
      });

      // Mark seed as complete
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_seedCompleteKey, true);
    } catch (e) {
      throw Exception('Failed to seed database: $e');
    }
  }

  /// Reset seed status (for testing purposes)
  Future<void> resetSeedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_seedCompleteKey);
  }
}
