import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../list_create/list_create_screen.dart';
import 'home_viewmodel.dart';
import 'widgets/shopping_list_card.dart';
import 'widgets/empty_state_widget.dart';
import '../../shared/widgets/jhuri_app_bar.dart';
import '../../shared/widgets/jhuri_drawer.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  BaseScreenState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  NotifierProvider<HomeViewModel, ViewState> get viewModelProvider =>
      homeViewModelProvider;

  @override
  bool get enablePullToRefresh => true;

  @override
  Future<void> onRefresh() async {
    await ref.read(homeViewModelProvider.notifier).refresh();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return JhuriAppBar(
      title: 'ঝুড়ি',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            context.go('/settings');
          },
        ),
      ],
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          builder: (context) => const ListCreateScreen(),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget? buildDrawer(BuildContext context, WidgetRef ref) {
    return const JhuriDrawer();
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(homeViewModelProvider);

    if (viewState is ViewStateError) {
      return buildErrorWidget(viewState);
    }

    if (viewState is ViewStateEmpty) {
      return const EmptyStateWidget();
    }

    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final groupedLists = viewModel.groupedLists;

    if (groupedLists.isEmpty) {
      return const EmptyStateWidget();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: groupedLists.keys.length,
            itemBuilder: (context, index) {
              final dateLabel = groupedLists.keys.elementAt(index);
              final lists = groupedLists[dateLabel]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  ...lists.map((list) => ShoppingListCard(
                        key: ValueKey(list.id),
                        list: list,
                        onDelete: () => _deleteList(list.id),
                        onToggleComplete: () => _toggleComplete(list.id),
                        onEdit: () => _editList(list),
                        onDuplicate: () => _duplicateList(list),
                        onArchive: () => _archiveList(list.id),
                      )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _deleteList(int id) async {
    final confirmed = await showConfirmDialog(
      title: 'ফর্দ ডিলেট করুন',
      message: 'আপনি কি নিশ্চিত যে এই ফর্দটি ডিলেট করতে চান?',
      confirmText: 'ডিলেট করুন',
      cancelText: 'বাতিল করুন',
      isDestructive: true,
    );

    if (confirmed) {
      await ref.read(homeViewModelProvider.notifier).deleteList(id);
    }
  }

  void _toggleComplete(int id) async {
    // Navigate to shopping mode instead of just toggling complete
    context.go('/shopping/$id');
  }

  void _editList(ShoppingList list) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => ListCreateScreen(list: list),
    );
  }

  void _duplicateList(ShoppingList list) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => ListCreateScreen(duplicateFrom: list),
    );
  }

  void _archiveList(int id) async {
    final confirmed = await showConfirmDialog(
      title: 'ফর্দ আর্কাইভ করুন',
      message: 'আপনি কি নিশ্চিত যে এই ফর্দটি আর্কাইভ করতে চান?',
      confirmText: 'আর্কাইভ করুন',
      cancelText: 'বাতিল করুন',
    );

    if (confirmed) {
      await ref.read(homeViewModelProvider.notifier).archiveList(id);
    }
  }
}
