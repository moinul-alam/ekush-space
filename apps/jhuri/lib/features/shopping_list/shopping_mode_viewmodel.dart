import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/database_provider.dart';
import '../../config/jhuri_constants.dart';
import '../shopping_list/data/shopping_list_repository.dart';
import '../list_item/data/list_item_repository.dart';

/// View model for shopping mode
class ShoppingModeViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  ShoppingList? _list;
  List<ListItem> _items = [];
  bool _isLoading = false;

  ShoppingList? get list => _list;
  List<ListItem> get items => _items;
  @override
  bool get isLoading => _isLoading;

  // Computed properties
  int get totalItems => _items.length;
  int get boughtItems => _items.where((item) => item.isBought).length;
  int get unboughtItems => totalItems - boughtItems;
  double get completionPercentage =>
      totalItems > 0 ? (boughtItems / totalItems) * 100 : 0.0;
  double get totalPrice => _items.fold(
      0.0, (sum, item) => sum + (item.price ?? 0.0) * item.quantity);

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  /// Load shopping list
  Future<void> loadList(int listId) async {
    _isLoading = true;
    state = ViewStateLoading();

    try {
      final list = await _shoppingListRepository.getById(listId);
      if (list == null) {
        state = ViewStateError('List not found');
        return;
      }

      final items = await _listItemRepository.getByListId(listId);

      _list = list;
      _items = items;
      _isLoading = false;
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
      state = ViewStateError(e.toString());
    }
  }

  /// Toggle item bought status
  Future<void> toggleItemBought(int itemId) async {
    try {
      await _listItemRepository.toggleBoughtStatus(itemId);
      await _loadList();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Update item quantity and unit
  Future<void> updateItem(int itemId,
      {double? quantity, String? unit, double? price}) async {
    try {
      await _listItemRepository.updateQuantityAndUnit(
          itemId, quantity ?? 1.0, unit ?? 'কেজি');
      await _loadList();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Mark list as completed
  Future<void> markListAsCompleted() async {
    if (_list == null) return;

    try {
      await _shoppingListRepository.markAsCompleted(_list!.id);
      await _loadList();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Load shopping list (private method)
  Future<void> _loadList() async {
    if (_list == null) return;

    try {
      final items = await _listItemRepository.getByListId(_list!.id);
      _items = items;
      state = ViewStateSuccess();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Delete item
  Future<void> deleteItem(int itemId) async {
    try {
      await _listItemRepository.delete(itemId);
      await _loadList();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Check if all items are bought
  bool get allItemsBought => unboughtItems == 0;

  /// Get progress text
  String get progressText {
    if (totalItems == 0) return 'কোন আইটেম নির্ব';
    return '$boughtItems/$totalItems টি আইটেম নির্ব করা হয়েছে';
  }

  /// Get status text
  String get statusText {
    if (totalItems == 0) return 'কোন আইটেম নির্ব';
    if (completionPercentage >= 100) return 'সম্পন্ন';
    if (completionPercentage >= 75) return 'প্রায় সম্পন্ন';
    if (completionPercentage >= 50) return 'অর্ধেক';
    return 'চলিছ করছেন';
  }

  /// Get status color
  String get statusColor {
    if (completionPercentage >= 100) return '#4CAF50';
    if (completionPercentage >= 75) return '#FF9800';
    if (completionPercentage >= 50) return '#FFB74D';
    return '#FFA726';
  }

  /// Get available units
  List<String> get availableUnits => JhuriConstants.fixedUnits;
}

// Provider
final shoppingModeViewModelProvider =
    NotifierProvider<ShoppingModeViewModel, ViewState>(
        () => ShoppingModeViewModel());
