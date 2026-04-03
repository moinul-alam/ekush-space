import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../item_template/data/item_template_repository.dart';
import '../../providers/database_provider.dart';

/// View model for item picker
class ItemPickerViewModel extends BaseViewModel {
  late final ItemTemplateRepository _itemTemplateRepository;

  List<ItemTemplate> _items = [];
  final List<ListItem> _selectedItems = [];
  final Set<int> _selectedItemIds = {};
  bool _isLoading = false;
  String _searchQuery = '';
  bool _showSearch = false;

  List<ItemTemplate> get items => _items;
  List<ListItem> get selectedItems => _selectedItems;
  @override
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get showSearch => _showSearch;

  @override
  void onSyncSetup() {
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
  }

  /// Load items for a specific category
  Future<void> loadItemsForCategory(int categoryId) async {
    _isLoading = true;
    state = ViewStateLoading();

    try {
      final items = await _itemTemplateRepository.getByCategoryId(categoryId);
      _items = items;
      _isLoading = false;
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
      state = ViewStateError(e.toString());
    }
  }

  /// Search items
  Future<void> searchItems(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _showSearch = false;
      return;
    }

    _isLoading = true;
    state = ViewStateLoading();

    try {
      final items = await _itemTemplateRepository.searchByName(query);
      _items = items;
      _isLoading = false;
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
      state = ViewStateError(e.toString());
    }
  }

  /// Toggle search visibility
  void toggleSearch() {
    _showSearch = !_showSearch;
    if (!_showSearch) {
      _searchQuery = '';
      loadItemsForCategory(0); // Load all items when search is hidden
    }
    state = ViewStateSuccess();
  }

  /// Add item to selection
  void addItemToList(ListItem item) {
    if (!_selectedItemIds.contains(item.id)) {
      _selectedItems.add(item);
      _selectedItemIds.add(item.id);
      state = ViewStateSuccess();
    }
  }

  /// Remove item from selection
  void removeItemFromList(int itemId) {
    _selectedItems.removeWhere((item) => item.id == itemId);
    _selectedItemIds.remove(itemId);
    state = ViewStateSuccess();
  }

  /// Check if item is selected
  bool isItemSelected(int itemId) {
    return _selectedItemIds.contains(itemId);
  }

  /// Toggle item selection
  void toggleItemSelection(int itemId) {
    if (_selectedItemIds.contains(itemId)) {
      removeItemFromList(itemId);
    } else {
      // Create a temporary ListItem for selection
      final item = _items.firstWhere((item) => item.id == itemId);
      final listItem = ListItem(
        id: DateTime.now().millisecondsSinceEpoch,
        listId: 0, // Will be updated
        templateId: item.id,
        nameBangla: item.nameBangla,
        nameEnglish: item.nameEnglish,
        quantity: item.defaultQuantity,
        unit: item.defaultUnit,
        price: null,
        isBought: false,
        sortOrder: 0,
        addedAt: DateTime.now(),
      );
      addItemToList(listItem);
    }
  }

  /// Clear all selections
  void clearSelections() {
    _selectedItems.clear();
    _selectedItemIds.clear();
    state = ViewStateSuccess();
  }

  /// Get selected count for category
  int getSelectedCountForCategory(int categoryId) {
    return _selectedItems.where((item) => item.templateId == categoryId).length;
  }

  /// Get available units
  List<String> get availableUnits => [
        'কেজি',
        'গ্রাম',
        'লিটার',
        'মিলিলিটার',
        'পিস',
        'হালি',
        'আঁটি',
        'ডজন',
        'প্যাকেট',
        'বোতল',
        'কৌটা',
        'আঁটি'
      ];
}

// Provider
final itemPickerViewModelProvider =
    NotifierProvider<ItemPickerViewModel, ViewState>(
        () => ItemPickerViewModel());
