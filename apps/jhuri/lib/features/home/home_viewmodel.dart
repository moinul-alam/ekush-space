import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/providers/jhuri_providers.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/list_item_repository.dart';

final homeViewModelProvider = NotifierProvider<HomeViewModel, ViewState>(() {
  return HomeViewModel();
});

class HomeViewModel extends BaseViewModel<List<ShoppingList>> {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  @override
  void onInit() {
    _loadLists();
  }

  void _loadLists() {
    setLoading();

    // Initial load - the actual data will be watched in the UI
    final repository = ref.read(shoppingListRepositoryProvider);
    repository.watchActiveLists().listen((lists) {
      if (lists.isEmpty) {
        setEmpty(message: 'বাজারের কোনো ফর্দ নেই');
      } else {
        setSuccess(data: lists);
      }
    });
  }

  Future<bool> deleteList(int id) async {
    return await executeAsync(
      operation: () => _shoppingListRepository.delete(id),
      successMessage: 'ফর্দটি ডিলেট করা হয়েছে',
      errorMessage: 'ফর্দ ডিলেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<bool> toggleListComplete(int id) async {
    return await executeAsync(
      operation: () => _shoppingListRepository.markComplete(id),
      errorMessage: 'ফর্দ আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<bool> archiveList(int id) async {
    return await executeAsync(
      operation: () => _shoppingListRepository.archive(id),
      successMessage: 'ফর্দটি আর্কাইভ করা হয়েছে',
      errorMessage: 'ফর্দ আর্কাইভ করতে ব্যর্থ হয়েছে',
    );
  }

  Future<ShoppingList?> getListById(int id) async {
    try {
      return await _shoppingListRepository.getById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> refresh() async {
    _loadLists();
    return true;
  }

  Future<Map<int, Map<String, int>>> getItemCounts(List<int> listIds) async {
    final Map<int, Map<String, int>> counts = {};

    for (final listId in listIds) {
      try {
        final items = await _listItemRepository.getItemsForList(listId);
        final totalItems = items.length;
        final boughtItems = items.where((item) => item.isBought).length;
        counts[listId] = {'total': totalItems, 'bought': boughtItems};
      } catch (e) {
        counts[listId] = {'total': 0, 'bought': 0};
      }
    }

    return counts;
  }

  // Group lists by date for UI
  Map<String, List<ShoppingList>> get groupedLists {
    final data = successData;
    if (data == null || data.isEmpty) return {};

    final Map<String, List<ShoppingList>> grouped = {};

    for (final list in data) {
      final dateLabel = _getDateLabel(list.buyDate);
      if (!grouped.containsKey(dateLabel)) {
        grouped[dateLabel] = [];
      }
      grouped[dateLabel]!.add(list);
    }

    return grouped;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly.isAtSameMomentAs(today)) {
      return 'আজ';
    } else if (dateOnly.isAtSameMomentAs(tomorrow)) {
      return 'আগামীকাল';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
