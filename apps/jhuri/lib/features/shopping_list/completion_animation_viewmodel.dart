import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import '../shopping_list/data/shopping_list_repository.dart';
import '../list_item/data/list_item_repository.dart';
import '../../providers/database_provider.dart';

/// View model for completion animations
class CompletionAnimationViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  bool _isShowingCompletion = false;
  bool _isLoading = false;

  bool get isShowingCompletion => _isShowingCompletion;
  @override
  bool get isLoading => _isLoading;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  /// Show completion animation
  void showCompletionAnimation() {
    _isShowingCompletion = true;
    state = ViewStateSuccess();
  }

  /// Hide completion animation
  void hideCompletionAnimation() {
    _isShowingCompletion = false;
    state = ViewStateSuccess();
  }

  /// Complete list with animation
  Future<void> completeListWithAnimation(int listId) async {
    _isLoading = true;
    state = ViewStateLoading();

    try {
      // Mark list as completed
      await _shoppingListRepository.markAsCompleted(listId);

      // Show animation
      showCompletionAnimation();

      // Wait for animation duration
      await Future.delayed(const Duration(seconds: 2));

      // Archive list
      await _shoppingListRepository.archive(listId);

      _isLoading = false;
      hideCompletionAnimation();
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
      state = ViewStateError(e.toString());
    }
  }

  /// Check if list is completed
  Future<bool> isListCompleted(int listId) async {
    try {
      final list = await _shoppingListRepository.getById(listId);
      return list?.isCompleted ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get completion percentage
  Future<double> getCompletionPercentage(int listId) async {
    try {
      final items = await _listItemRepository.getByListId(listId);
      if (items.isEmpty) return 0.0;

      final boughtItems = items.where((item) => item.isBought).length;
      return (boughtItems / items.length) * 100;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get completion status text
  String getCompletionStatusText(
    double percentage, {
    required String completedText,
    required String almostCompletedText,
    required String halfCompletedText,
    required String inProgressText,
  }) {
    if (percentage >= 100) return completedText;
    if (percentage >= 75) return almostCompletedText;
    if (percentage >= 50) return halfCompletedText;
    return inProgressText;
  }

  /// Get completion color
  Color getCompletionColor(double percentage) {
    if (percentage >= 100) return Colors.green;
    if (percentage >= 75) return Colors.orange;
    if (percentage >= 50) return Colors.blue;
    return Colors.red;
  }
}

// Provider
final completionAnimationViewModelProvider =
    NotifierProvider<CompletionAnimationViewModel, ViewState>(
        () => CompletionAnimationViewModel());
