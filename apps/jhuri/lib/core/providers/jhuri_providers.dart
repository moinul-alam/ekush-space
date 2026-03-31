import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../data/repositories/shopping_list_repository.dart';
import '../../data/repositories/app_settings_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/item_template_repository.dart';
import '../../data/repositories/list_item_repository.dart';
import '../../data/seeds/seed_service.dart';
import '../../features/home/home_viewmodel.dart';

// Database provider
final databaseProvider = Provider<JhuriDatabase>((ref) {
  return JhuriDatabase();
});

// Repository providers
final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  return ShoppingListRepository(ref.read(databaseProvider));
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository(ref.read(databaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.read(databaseProvider));
});

final itemTemplateRepositoryProvider = Provider<ItemTemplateRepository>((ref) {
  return ItemTemplateRepository(ref.read(databaseProvider));
});

final listItemRepositoryProvider = Provider<ListItemRepository>((ref) {
  return ListItemRepository(ref.read(databaseProvider));
});

final seedServiceProvider = Provider<SeedService>((ref) {
  return SeedService(
    categoryRepository: ref.read(categoryRepositoryProvider),
    itemTemplateRepository: ref.read(itemTemplateRepositoryProvider),
    db: ref.read(databaseProvider),
  );
});

// Data providers
final activeShoppingListsProvider = StreamProvider<List<ShoppingList>>((ref) {
  return ref.read(shoppingListRepositoryProvider).watchActiveLists();
});

final appSettingsProvider = StreamProvider<AppSettingsTableData>((ref) {
  return ref.read(appSettingsRepositoryProvider).watchSettings();
});

final categoryListProvider = FutureProvider<List<Category>>((ref) async {
  return ref.read(categoryRepositoryProvider).getAllSorted();
});

final itemCountsProvider =
    FutureProvider.family<Map<int, Map<String, int>>, List<int>>(
        (ref, listIds) async {
  final viewModel = ref.read(homeViewModelProvider.notifier);
  return await viewModel.getItemCounts(listIds);
});

// Note: itemsByCategoryProvider and selectedItemsProvider are handled by view models
// to maintain state during navigation between screens

// Theme mode provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsProvider).value;
  if (settings == null) return ThemeMode.system;

  switch (settings.themeMode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
});
