import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/item_template_repository.dart';

class SeedService {
  static bool _hasSeeded = false;

  static Future<void> seedIfNeeded() async {
    if (_hasSeeded) return;

    try {
      final db = JhuriDatabase();
      final categoryRepo = CategoryRepository(db);
      final itemRepo = ItemTemplateRepository(db);

      // Check if data already exists
      final categoryCount = await categoryRepo.countAll();
      final itemCount = await itemRepo.countAll();

      if (categoryCount > 0 || itemCount > 0) {
        _hasSeeded = true;
        return;
      }

      // Load seed data from assets
      final String seedData =
          await rootBundle.loadString('assets/data/items_seed.json');
      final Map<String, dynamic> data = json.decode(seedData);

      // Seed categories
      final List<dynamic> categories = data['categories'];
      for (final category in categories) {
        await categoryRepo.insert(CategoriesCompanion.insert(
          nameBangla: category['nameBangla'],
          nameEnglish: category['nameEnglish'],
          imageIdentifier: category['imageIdentifier'],
          iconIdentifier: category['iconIdentifier'],
          sortOrder: category['sortOrder'],
        ));
      }

      // Seed items
      final List<dynamic> items = data['items'];
      for (final item in items) {
        await itemRepo.insert(ItemTemplatesCompanion.insert(
          nameBangla: item['nameBangla'],
          nameEnglish: item['nameEnglish'],
          categoryId: item['categoryId'],
          defaultQuantity: item['defaultQuantity'],
          defaultUnit: item['defaultUnit'],
          iconIdentifier: item['iconIdentifier'],
          isCustom: const Value(false),
          usageCount: const Value(0),
          lastUsedAt: DateTime.now(),
        ));
      }

      _hasSeeded = true;
    } catch (e) {
      // Silently fail for now - in production, you might want to log this
      debugPrint('Failed to seed data: $e');
    }
  }
}
