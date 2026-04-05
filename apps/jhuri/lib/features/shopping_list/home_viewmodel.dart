import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'data/shopping_list_repository.dart';
import '../list_item/data/list_item_repository.dart';
import '../../providers/database_provider.dart';
import '../../services/shopping_list_notification_service.dart';

/// Home view model managing shopping lists display and interactions
class HomeViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  List<ShoppingList> _todayLists = [];
  List<ShoppingList> _upcomingLists = [];
  List<ShoppingList> _pastIncompleteLists = [];
  bool _isPastIncompleteExpanded = false;

  List<ShoppingList> get todayLists => _todayLists;
  List<ShoppingList> get upcomingLists => _upcomingLists;
  List<ShoppingList> get pastIncompleteLists => _pastIncompleteLists;
  bool get isPastIncompleteExpanded => _isPastIncompleteExpanded;

  bool get hasAnyLists =>
      _todayLists.isNotEmpty ||
      _upcomingLists.isNotEmpty ||
      _pastIncompleteLists.isNotEmpty;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  @override
  void onInit() {
    super.onInit();
    _loadLists();
  }

  Future<void> _loadLists() async {
    state = ViewStateLoading();

    try {
      final today = await _shoppingListRepository.getTodayLists();
      final upcoming = await _shoppingListRepository.getUpcomingLists();
      final past = await _shoppingListRepository.getPastIncompleteLists();

      _todayLists = today;
      _upcomingLists = upcoming;
      _pastIncompleteLists = past;

      state = ViewStateSuccess();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  @override
  Future<bool> refresh() async {
    try {
      await _loadLists();
      return true;
    } catch (e) {
      state = ViewStateError(e.toString());
      return false;
    }
  }

  void togglePastIncompleteExpanded() {
    _isPastIncompleteExpanded = !_isPastIncompleteExpanded;
    state = ViewStateSuccess();
  }

  Future<void> deleteList(int listId) async {
    try {
      // Cancel notification before deleting the list
      await ShoppingListNotificationService.cancelNotification(listId);

      await _shoppingListRepository.delete(listId);
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  Future<void> archiveList(int listId) async {
    try {
      // Cancel notification before archiving the list
      await ShoppingListNotificationService.cancelNotification(listId);

      await _shoppingListRepository.archive(listId);
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  Future<void> toggleListCompletion(int listId) async {
    try {
      final list = await _shoppingListRepository.getById(listId);
      if (list != null) {
        if (list.isCompleted) {
          await _shoppingListRepository.markAsIncomplete(listId);
        } else {
          await _shoppingListRepository.markAsCompleted(listId);
        }
        await _loadLists();
      }
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  Future<int> duplicateList(int sourceListId) async {
    try {
      final sourceList = await _shoppingListRepository.getById(sourceListId);
      if (sourceList == null) throw Exception('Source list not found');

      final now = DateTime.now();
      final newTitle = sourceList.title.isEmpty
          ? 'বাজারের ফর্দ (কপি)'
          : '${sourceList.title} (কপি)';

      final newListId = await _shoppingListRepository.duplicateList(
        sourceListId,
        newTitle,
        now,
      );

      // Duplicate items
      await _listItemRepository.duplicateItems(sourceListId, newListId);

      await _loadLists();
      return newListId;
    } catch (e) {
      state = ViewStateError(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getListStats(int listId) async {
    try {
      final totalCount = await _listItemRepository.getTotalCount(listId);
      final boughtCount = await _listItemRepository.getBoughtCount(listId);
      final totalPrice = await _listItemRepository.getTotalPrice(listId);

      return {
        'totalCount': totalCount,
        'boughtCount': boughtCount,
        'unboughtCount': totalCount - boughtCount,
        'totalPrice': totalPrice,
        'completionPercentage':
            totalCount > 0 ? (boughtCount / totalCount) * 100 : 0.0,
      };
    } catch (e) {
      return {
        'totalCount': 0,
        'boughtCount': 0,
        'unboughtCount': 0,
        'totalPrice': 0.0,
        'completionPercentage': 0.0,
      };
    }
  }

  String formatDateForDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return 'আজ';
    } else if (checkDate.isAtSameMomentAs(tomorrow)) {
      return 'আগামীকাল';
    } else {
      // Format in Bangla date format
      final months = [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}

// Provider
final homeViewModelProvider =
    NotifierProvider<HomeViewModel, ViewState>(() => HomeViewModel());
