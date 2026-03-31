import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:ekush_models/ekush_models.dart';
import '../repositories/category_repository.dart';
import '../repositories/item_template_repository.dart';

class SeedService {
  SeedService({
    required this.categoryRepository,
    required this.itemTemplateRepository,
    required this.db,
  });

  final CategoryRepository categoryRepository;
  final ItemTemplateRepository itemTemplateRepository;
  final JhuriDatabase db;

  Future<void> seedIfNeeded() async {
    final categoryCount = await categoryRepository.countAll();
    if (categoryCount > 0) return; // already seeded

    final jsonString =
        await rootBundle.loadString('assets/data/items_seed.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;

    await db.transaction(() async {
      // Seed categories
      final categories = data['categories'] as List<dynamic>;
      for (final cat in categories) {
        await categoryRepository.insert(CategoriesCompanion.insert(
          nameBangla: cat['nameBangla'] as String,
          nameEnglish: cat['nameEnglish'] as String,
          imageIdentifier: cat['imageIdentifier'] as String,
          iconIdentifier: cat['iconIdentifier'] as String,
          sortOrder: Value(cat['sortOrder'] as int),
        ));
      }

      // Seed item templates
      final items = data['items'] as List<dynamic>;
      final now = DateTime.now();
      for (final item in items) {
        await itemTemplateRepository.insert(ItemTemplatesCompanion.insert(
          nameBangla: item['nameBangla'] as String,
          nameEnglish: item['nameEnglish'] as String,
          categoryId: item['categoryId'] as int,
          defaultQuantity: Value(item['defaultQuantity'] as double),
          defaultUnit: item['defaultUnit'] as String,
          iconIdentifier: item['iconIdentifier'] as String,
          isCustom: const Value(false),
          usageCount: const Value(0),
          lastUsedAt: now,
        ));
      }
    });
  }
}
