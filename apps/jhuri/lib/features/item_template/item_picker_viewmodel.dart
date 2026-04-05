import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../item_template/data/item_template_repository.dart';
import '../../providers/database_provider.dart';

/// View model for item picker
class ItemPickerViewModel extends AsyncNotifier<List<ItemTemplate>> {
  late final ItemTemplateRepository _itemTemplateRepository;
  final int categoryId;

  ItemPickerViewModel(this.categoryId);

  @override
  Future<List<ItemTemplate>> build() async {
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
    return _loadItemsForCategory(categoryId);
  }

  Future<List<ItemTemplate>> _loadItemsForCategory(int categoryId) async {
    try {
      final items = await _itemTemplateRepository.getByCategoryId(categoryId);
      return items;
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }

  /// Refresh items for current category
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadItemsForCategory(categoryId));
  }

  /// Search items within the current category
  Future<void> searchItems(String query) async {
    if (query.isEmpty) {
      state = await AsyncValue.guard(() => _loadItemsForCategory(categoryId));
      return;
    }

    try {
      // Get all items for the category first, then filter by search
      final allCategoryItems = await _loadItemsForCategory(categoryId);
      final lowerQuery = query.toLowerCase();

      final filteredItems = allCategoryItems.where((item) {
        return item.nameBangla.toLowerCase().contains(lowerQuery) ||
            item.nameEnglish.toLowerCase().contains(lowerQuery) ||
            (item.phoneticName?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();

      state = AsyncValue.data(filteredItems);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Family provider
final itemPickerViewModelProvider =
    AsyncNotifierProvider.family<ItemPickerViewModel, List<ItemTemplate>, int>(
  ItemPickerViewModel.new,
);
