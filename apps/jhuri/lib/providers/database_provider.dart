import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/category/data/category_repository.dart';
import '../features/item_template/data/item_template_repository.dart';
import '../features/list_item/data/list_item_repository.dart';
import '../features/shopping_list/data/shopping_list_repository.dart';
import '../services/seed_service.dart';

// Database provider
final jhuriDatabaseProvider = Provider<JhuriDatabase>((ref) {
  final db = JhuriDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Seed service provider - separate from database provider
final seedServiceProvider = Provider<SeedService>((ref) {
  final db = ref.read(jhuriDatabaseProvider);
  return SeedService(db);
});

// Repository providers
final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  return ShoppingListRepository(ref.watch(jhuriDatabaseProvider));
});

final listItemRepositoryProvider = Provider<ListItemRepository>((ref) {
  return ListItemRepository(ref.watch(jhuriDatabaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(jhuriDatabaseProvider));
});

final itemTemplateRepositoryProvider = Provider<ItemTemplateRepository>((ref) {
  return ItemTemplateRepository(ref.watch(jhuriDatabaseProvider));
});
