import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../data/repositories/item_template_repository.dart';

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
  List<ItemTemplate> _allItems = [];
  List<ItemTemplate> _filteredItems = [];
  final List<SelectedItem> _selectedItems = [];

  @override
  void onSyncSetup() {
    _itemRepository = ItemTemplateRepository(JhuriDatabase());
  }

  void loadItems(int categoryId) {
    setLoading();

    _itemRepository.getByCategory(categoryId).then((items) {
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

    // Update usage count for the item
    _itemRepository.incrementUsage(item.id);
  }

  void removeItem(int templateId) {
    _selectedItems.removeWhere((selected) => selected.templateId == templateId);
  }

  void clearSelectedItems() {
    _selectedItems.clear();
  }

  List<ItemTemplate> get items => _filteredItems;
  List<SelectedItem> get selectedItems => _selectedItems;

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
