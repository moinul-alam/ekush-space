import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'home_viewmodel.dart';
import 'widgets/simple_list_card.dart';
import 'widgets/empty_state_widget.dart';

class MinimalHomeScreen extends ConsumerStatefulWidget {
  const MinimalHomeScreen({super.key});

  @override
  ConsumerState<MinimalHomeScreen> createState() => _MinimalHomeScreenState();
}

class _MinimalHomeScreenState extends ConsumerState<MinimalHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ঝুড়ি'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
      ),
      body: _buildBody(context, ref),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/list/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(homeViewModelProvider);

    if (viewState is ViewStateError) {
      return Center(
        child: Text('Error: ${viewState.message}'),
      );
    }

    if (viewState is ViewStateEmpty) {
      return const EmptyStateWidget();
    }

    final viewModel = ref.watch(homeViewModelProvider.notifier);
    final groupedLists = viewModel.groupedLists;

    if (groupedLists.isEmpty) {
      return const EmptyStateWidget();
    }

    return ListView.builder(
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
            ...lists.map((list) => SimpleListCard(
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
    );
  }

  void _deleteList(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ফর্দ ডিলেট করুন'),
        content: const Text('আপনি কি নিশ্চিত যে এই ফর্দটি ডিলেট করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('বাতিল করুন'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ডিলেট করুন'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(homeViewModelProvider.notifier).deleteList(id);
    }
  }

  void _toggleComplete(int id) async {
    context.go('/shopping/$id');
  }

  void _editList(ShoppingList list) {
    context.go('/list/create', extra: list);
  }

  void _duplicateList(ShoppingList list) {
    context.go('/list/create', extra: {'duplicate': list});
  }

  void _archiveList(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ফর্দ আর্কাইভ করুন'),
        content: const Text('আপনি কি নিশ্চিত যে এই ফর্দটি আর্কাইভ করতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('বাতিল করুন'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('আর্কাইভ করুন'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(homeViewModelProvider.notifier).archiveList(id);
    }
  }
}
