// lib/features/shopping_list/widgets/home_list_card_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../l10n/jhuri_localizations.dart';
import '../home_providers.dart';

class HomeListCardWidget extends ConsumerWidget {
  final ShoppingList list;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HomeListCardWidget({
    super.key,
    required this.list,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = JhuriLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final itemsAsync = ref.watch(listItemsProvider(list.id));

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  list.title.isEmpty ? l10n.shoppingList : list.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Items preview
                Expanded(
                  child: itemsAsync.when(
                    loading: () => const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => Text(
                      l10n.error,
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.error,
                      ),
                    ),
                    data: (items) =>
                        _buildItemsPreview(items, colorScheme, l10n),
                  ),
                ),

                const SizedBox(height: 8),

                // Footer with date and completion
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Text(
                      _formatDateForDisplay(list.buyDate, l10n),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),

                    // Completion indicator
                    itemsAsync.when(
                      loading: () => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '...',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      error: (_, __) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '?',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                      data: (items) =>
                          _buildCompletionIndicator(items, colorScheme),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsPreview(
      List<ListItem> items, ColorScheme colorScheme, JhuriLocalizations l10n) {
    if (items.isEmpty) {
      return Text(
        l10n.noItems,
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      );
    }

    final displayItems = items.take(3).toList();
    final hasMore = items.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '• ${item.nameBangla}',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            )),
        if (hasMore)
          Text(l10n.moreItems.replaceAll('${0}', '${items.length - 3}')),
      ],
    );
  }

  Widget _buildCompletionIndicator(
      List<ListItem> items, ColorScheme colorScheme) {
    final boughtCount = items.where((item) => item.isBought).length;
    final totalCount = items.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$boughtCount/$totalCount',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  String _formatDateForDisplay(DateTime date, JhuriLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return l10n.today;
    } else if (checkDate.isAtSameMomentAs(tomorrow)) {
      return l10n.tomorrow;
    } else {
      return '${date.day} ${l10n.getMonthName(date.month)} ${date.year}';
    }
  }
}
