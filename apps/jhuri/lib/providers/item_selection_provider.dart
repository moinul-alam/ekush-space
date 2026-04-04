import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';

/// State for temporary item selection during list creation
class ItemSelectionState {
  final List<ListItem> selectedItems;
  final Set<int> selectedItemIds;

  const ItemSelectionState({
    this.selectedItems = const [],
    this.selectedItemIds = const {},
  });

  ItemSelectionState copyWith({
    List<ListItem>? selectedItems,
    Set<int>? selectedItemIds,
  }) {
    return ItemSelectionState(
      selectedItems: selectedItems ?? this.selectedItems,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
    );
  }

  int get selectedCount => selectedItems.length;
}

/// Notifier for managing temporary item selection
class ItemSelectionNotifier extends Notifier<ItemSelectionState> {
  @override
  ItemSelectionState build() => const ItemSelectionState();

  /// Add an item to selection
  void addItem(ListItem item) {
    if (!state.selectedItemIds.contains(item.id)) {
      final newSelectedItems = [...state.selectedItems, item];
      final newSelectedItemIds = {...state.selectedItemIds, item.id};
      state = state.copyWith(
        selectedItems: newSelectedItems,
        selectedItemIds: newSelectedItemIds,
      );
    }
  }

  /// Remove an item from selection
  void removeItem(int itemId) {
    final newSelectedItems = state.selectedItems.where((item) => item.id != itemId).toList();
    final newSelectedItemIds = state.selectedItemIds.where((id) => id != itemId).toSet();
    state = state.copyWith(
      selectedItems: newSelectedItems,
      selectedItemIds: newSelectedItemIds,
    );
  }

  /// Toggle item selection
  void toggleItem(ListItem item) {
    if (state.selectedItemIds.contains(item.id)) {
      removeItem(item.id);
    } else {
      addItem(item);
    }
  }

  /// Clear all selections
  void clearSelections() {
    state = const ItemSelectionState();
  }

  /// Check if item is selected
  bool isItemSelected(int itemId) {
    return state.selectedItemIds.contains(itemId);
  }

  /// Get selected count for category
  int getSelectedCountForCategory(int categoryId) {
    return state.selectedItems.where((item) => item.templateId == categoryId).length;
  }
}

// Provider for item selection state
final itemSelectionProvider = NotifierProvider<ItemSelectionNotifier, ItemSelectionState>(
  () => ItemSelectionNotifier(),
);
