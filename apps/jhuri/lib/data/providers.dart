import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'repositories/shopping_list_repository.dart';
import 'repositories/list_item_repository.dart';
import 'repositories/item_template_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/app_settings_repository.dart';
import 'seeds/seed_service.dart';

final databaseProvider = Provider<JhuriDatabase>((ref) {
  return DatabaseService.instance;
});

final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  return ShoppingListRepository(ref.watch(databaseProvider));
});

final listItemRepositoryProvider = Provider<ListItemRepository>((ref) {
  return ListItemRepository(ref.watch(databaseProvider));
});

final itemTemplateRepositoryProvider = Provider<ItemTemplateRepository>((ref) {
  return ItemTemplateRepository(ref.watch(databaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(databaseProvider));
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(ref.watch(databaseProvider));
});

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(
    categoryRepository: ref.watch(categoryRepositoryProvider),
    itemTemplateRepository: ref.watch(itemTemplateRepositoryProvider),
    db: ref.watch(databaseProvider),
  );
});

final appSettingsProvider = StreamProvider<AppSettingsTableData>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watchSettings();
});
