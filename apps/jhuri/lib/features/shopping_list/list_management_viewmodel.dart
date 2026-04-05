import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../shopping_list/data/shopping_list_repository.dart';
import '../../providers/database_provider.dart';

/// View model for list management features
class ListManagementViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;

  List<ShoppingList> _lists = [];
  bool _isLoading = false;

  List<ShoppingList> get lists => _lists;
  @override
  bool get isLoading => _isLoading;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
  }

  @override
  void onInit() {
    super.onInit();
    _loadLists();
  }

  /// Load all lists
  Future<void> _loadLists() async {
    _isLoading = true;
    state = ViewStateLoading();

    try {
      final lists = await _shoppingListRepository.getAll();
      _lists = lists;
      _isLoading = false;
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
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

  /// Archive list
  Future<void> archiveList(int listId) async {
    try {
      await _shoppingListRepository.archive(listId);
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Restore list
  Future<void> restoreList(int listId) async {
    try {
      await _shoppingListRepository.restore(listId);
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Delete list
  Future<void> deleteList(int listId) async {
    try {
      await _shoppingListRepository.delete(listId);
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Duplicate list
  Future<void> duplicateList(int listId) async {
    try {
      await _shoppingListRepository.duplicateList(
        listId,
        'Copy of ${DateTime.now().millisecondsSinceEpoch}',
        DateTime.now(),
      );
      await _loadLists();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Toggle list completion
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

  /// Get active lists
  List<ShoppingList> get activeLists =>
      _lists.where((list) => !list.isArchived).toList();

  /// Get archived lists
  List<ShoppingList> get archivedLists =>
      _lists.where((list) => list.isArchived).toList();

  /// Get completed lists
  List<ShoppingList> get completedLists =>
      _lists.where((list) => list.isCompleted).toList();

  /// Get pending lists
  List<ShoppingList> get pendingLists =>
      _lists.where((list) => !list.isCompleted && !list.isArchived).toList();
}

// Provider
final listManagementViewModelProvider =
    NotifierProvider<ListManagementViewModel, ViewState>(
        () => ListManagementViewModel());
