import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/database_provider.dart';

/// Family provider for list items by list ID
final listItemsProvider =
    FutureProvider.family<List<ListItem>, int>((ref, listId) async {
  final repo = ref.watch(listItemRepositoryProvider);
  return await repo.getByListId(listId);
});

/// Provider for today's lists stream
final todayListsProvider = StreamProvider<List<ShoppingList>>((ref) {
  final repo = ref.watch(shoppingListRepositoryProvider);
  return repo.watchTodayLists();
});

/// Provider for upcoming lists stream
final upcomingListsProvider = StreamProvider<List<ShoppingList>>((ref) {
  final repo = ref.watch(shoppingListRepositoryProvider);
  return repo.watchUpcomingLists();
});

/// Provider for past incomplete lists stream
final pastIncompleteListsProvider = StreamProvider<List<ShoppingList>>((ref) {
  final repo = ref.watch(shoppingListRepositoryProvider);
  return repo.watchPastIncompleteLists();
});

/// Combined provider for all lists data
final homeListsProvider = Provider<HomeListsData>((ref) {
  final todayAsync = ref.watch(todayListsProvider);
  final upcomingAsync = ref.watch(upcomingListsProvider);
  final pastAsync = ref.watch(pastIncompleteListsProvider);

  return HomeListsData(
    todayLists: todayAsync.value ?? [],
    upcomingLists: upcomingAsync.value ?? [],
    pastIncompleteLists: pastAsync.value ?? [],
    isLoading:
        todayAsync.isLoading || upcomingAsync.isLoading || pastAsync.isLoading,
    error: todayAsync.error ?? upcomingAsync.error ?? pastAsync.error,
  );
});

/// Data class to hold all home lists data
class HomeListsData {
  final List<ShoppingList> todayLists;
  final List<ShoppingList> upcomingLists;
  final List<ShoppingList> pastIncompleteLists;
  final bool isLoading;
  final Object? error;

  const HomeListsData({
    required this.todayLists,
    required this.upcomingLists,
    required this.pastIncompleteLists,
    required this.isLoading,
    this.error,
  });

  bool get hasAnyLists =>
      todayLists.isNotEmpty ||
      upcomingLists.isNotEmpty ||
      pastIncompleteLists.isNotEmpty;
}
