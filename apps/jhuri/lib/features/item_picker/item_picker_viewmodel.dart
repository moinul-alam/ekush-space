import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/providers/jhuri_providers.dart';
import '../../../data/repositories/item_template_repository.dart';
import '../../../data/repositories/list_item_repository.dart';
import '../list_create/list_create_viewmodel.dart';

// Model for selected items
class SelectedItem {
  final int templateId;
  final String nameBangla;
  final double quantity;
  final String unit;
  final double? price;

  SelectedItem({
    required this.templateId,
    required this.nameBangla,
    required this.quantity,
    required this.unit,
    this.price,
  });
}

final itemPickerViewModelProvider =
    NotifierProvider<ItemPickerViewModel, ViewState>(() {
  return ItemPickerViewModel();
});

class ItemPickerViewModel extends BaseViewModel<List<ItemTemplate>> {
  late final ItemTemplateRepository _itemRepository;
  late final ListItemRepository _listItemRepository;
  List<ItemTemplate> _allItems = [];
  List<ItemTemplate> _filteredItems = [];
  final List<SelectedItem> _selectedItems = [];
  int _currentListId = 0;

  @override
  void onSyncSetup() {
    _itemRepository = ref.read(itemTemplateRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  void loadItems(int categoryId, {int listId = 0}) {
    _currentListId = listId;
    setLoading();

    final Future<List<ItemTemplate>> fetchItems;
    if (categoryId == kFrequentlyUsedCategoryId) {
      fetchItems = _itemRepository.getFrequentlyUsed(limit: 30);
    } else {
      fetchItems = _itemRepository.getByCategory(categoryId);
    }

    fetchItems.then((items) {
      _allItems = items;
      _filteredItems = items;

      if (items.isEmpty) {
        setEmpty(message: 'এই ক্যাটাগরিতে কোনো আইটেম পাওয়া যায়নি');
      } else {
        setSuccess(data: _filteredItems);
      }
    }).catchError((error) {
      setError(error.toString());
    });
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      _filteredItems = _allItems;
    } else {
      _filteredItems = _allItems
          .where((item) =>
              item.nameBangla.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setSuccess(data: _filteredItems);
  }

  Future<List<ItemTemplate>> searchTemplates(String query) async {
    return await _itemRepository.searchTemplates(query);
  }

  // Add item to selected items (for backward compatibility)
  void addItem(ItemTemplate item, double quantity, String unit, double? price) {
    // Remove existing item with same templateId if it exists
    _selectedItems.removeWhere((selected) => selected.templateId == item.id);

    // Add the new item
    _selectedItems.add(SelectedItem(
      templateId: item.id,
      nameBangla: item.nameBangla,
      quantity: quantity,
      unit: unit,
      price: price,
    ));

    // Notify listeners by updating state
    setSuccess(data: _filteredItems);
  }

  Future<void> addToList(
      ItemTemplate item, double quantity, String unit, double? price) async {
    if (_currentListId > 0) {
      await _listItemRepository.addItem(
        listId: _currentListId,
        templateId: item.id,
        nameBangla: item.nameBangla,
        quantity: quantity,
        unit: unit,
        price: price,
        sortOrder: _selectedItems.length,
      );
    } else {
      // Update CreateListViewModel directly in create mode
      ref.read(createListViewModelProvider.notifier).addItem(
            item,
            quantity,
            unit,
            price,
          );
    }

    // Update usage count for the item
    await _itemRepository.incrementUsage(item.id);

    // Remove existing item with same templateId if it exists
    _selectedItems.removeWhere((selected) => selected.templateId == item.id);

    // Add the new item
    _selectedItems.add(SelectedItem(
      templateId: item.id,
      nameBangla: item.nameBangla,
      quantity: quantity,
      unit: unit,
      price: price,
    ));
  }

  Future<void> addCustomItem(String nameBangla, int categoryId, double quantity,
      String unit, double? price) async {
    final templateId = await _itemRepository.addCustomItem(
      nameBangla: nameBangla,
      categoryId: categoryId,
      defaultQuantity: quantity,
      defaultUnit: unit,
    );

    if (_currentListId > 0) {
      await _listItemRepository.addItem(
        listId: _currentListId,
        templateId: templateId,
        nameBangla: nameBangla,
        quantity: quantity,
        unit: unit,
        price: price,
        sortOrder: _selectedItems.length,
      );
    }
  }

  void removeItem(int templateId) {
    _selectedItems.removeWhere((selected) => selected.templateId == templateId);

    // Also update CreateListViewModel if in create mode
    if (_currentListId == 0) {
      final notifier = ref.read(createListViewModelProvider.notifier);
      final index =
          notifier.items.indexWhere((item) => item.templateId == templateId);
      if (index >= 0) {
        notifier.removeItem(index);
      }
    }
  }

  void clearSelectedItems() {
    _selectedItems.clear();
  }

  List<ItemTemplate> get items => _filteredItems;
  List<SelectedItem> get selectedItems => _selectedItems;

  // Check if an item template is already in the current list
  bool isItemInList(int templateId) {
    return _selectedItems.any((item) => item.templateId == templateId);
  }

  double get totalPrice {
    return _selectedItems.fold(
        0.0, (sum, item) => sum + (item.price ?? 0.0) * item.quantity);
  }

  @override
  Future<bool> refresh() async {
    // Refresh would need the categoryId, but we don't store it
    // This is a limitation of the current design
    return true;
  }
}
