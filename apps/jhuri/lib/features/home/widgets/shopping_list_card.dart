import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/utils/bangla_date_formatter.dart';
import '../../../core/providers/jhuri_providers.dart';

class ShoppingListCard extends ConsumerStatefulWidget {
  final ShoppingList list;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;

  const ShoppingListCard({
    super.key,
    required this.list,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDuplicate,
    required this.onArchive,
  });

  @override
  ConsumerState<ShoppingListCard> createState() => _ShoppingListCardState();
}

class _ShoppingListCardState extends ConsumerState<ShoppingListCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(_slideAnimation),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Dismissible(
              key: ValueKey(widget.list.id),
              direction: DismissDirection.horizontal,
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.7,
                DismissDirection.endToStart: 0.7,
              },
              background: _buildSwipeBackground(true),
              secondaryBackground: _buildSwipeBackground(false),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  widget.onDelete();
                } else if (direction == DismissDirection.startToEnd) {
                  widget.onToggleComplete();
                }
              },
              child: GestureDetector(
                onLongPress: _showContextMenu,
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: widget.onEdit,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.list.title.isEmpty
                                          ? 'বাজারের ফর্দ'
                                          : widget.list.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            decoration: widget.list.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      BanglaDateFormatter.getRelativeDateLabel(
                                          widget.list.buyDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildCompletionRing(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Consumer(
                                builder: (context, ref, child) {
                                  final itemCountsAsync = ref.watch(
                                      itemCountsProvider([widget.list.id]));
                                  return itemCountsAsync.when(
                                    data: (counts) {
                                      final count =
                                          counts[widget.list.id]?['total'] ?? 0;
                                      return Text(
                                        '$countটি আইটেম',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      );
                                    },
                                    loading: () => Text(
                                      '০টি আইটেম',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    error: (_, __) => Text(
                                      '০টি আইটেম',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              if (widget.list.isReminderOn) ...[
                                Icon(
                                  Icons.notifications_active_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'রিমাইন্ডার',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeBackground(bool isRightSwipe) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isRightSwipe
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isRightSwipe ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isRightSwipe ? Icons.check_circle : Icons.delete,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            isRightSwipe ? 'সম্পন্ন' : 'ডিলেট',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionRing() {
    return Consumer(
      builder: (context, ref, child) {
        final itemCountsAsync = ref.watch(itemCountsProvider([widget.list.id]));
        return itemCountsAsync.when(
          data: (counts) {
            final totalItems = counts[widget.list.id]?['total'] ?? 0;
            final completedItems = counts[widget.list.id]?['bought'] ?? 0;
            final progress = totalItems > 0 ? completedItems / totalItems : 0.0;

            return SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.list.isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    strokeWidth: 3,
                  ),
                  Center(
                    child: Text(
                      '$completedItems/$totalItems',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  strokeWidth: 3,
                ),
                Center(
                  child: Text(
                    '0/0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          error: (_, __) => SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: 0.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  strokeWidth: 3,
                ),
                Center(
                  child: Text(
                    '0/0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('এডিট করুন'),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onEdit();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.copy_outlined),
                    title: const Text('ডুপ্লিকেট করুন'),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onDuplicate();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.archive_outlined),
                    title: const Text('আর্কাইভ করুন'),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onArchive();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline,
                        color: Color(0xFFD62828)),
                    title: const Text('ডিলেট করুন',
                        style: TextStyle(color: Color(0xFFD62828))),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onDelete();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
