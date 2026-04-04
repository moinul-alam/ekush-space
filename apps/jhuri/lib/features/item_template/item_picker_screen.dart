import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/item_selection_provider.dart';

class ItemPickerScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;
  final int listId;

  const ItemPickerScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.listId,
  });

  @override
  ConsumerState<ItemPickerScreen> createState() => _ItemPickerScreenState();
}

class _ItemPickerScreenState extends ConsumerState<ItemPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemsAsync =
        ref.watch(itemPickerViewModelProvider(widget.categoryId));
    final itemSelection = ref.watch(itemSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansBengali',
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(itemsAsync, itemSelection, colorScheme),
    );
  }

  Widget _buildBody(AsyncValue<List<ItemTemplate>> itemsAsync,
      ItemSelectionState itemSelection, ColorScheme colorScheme) {
    return itemsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (items) => _buildItemsGrid(items, itemSelection, colorScheme),
    );
  }

  Widget _buildItemsGrid(List<ItemTemplate> items,
      ItemSelectionState itemSelection, ColorScheme colorScheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = itemSelection.isItemSelected(item.id);

        return GestureDetector(
          onTap: () {
            ref.read(itemSelectionProvider.notifier).toggleItem(
                  ListItem(
                    id: DateTime.now().millisecondsSinceEpoch,
                    listId: widget.listId,
                    templateId: item.id,
                    nameBangla: item.nameBangla,
                    nameEnglish: item.nameEnglish,
                    quantity: item.defaultQuantity,
                    unit: item.defaultUnit,
                    price: null,
                    isBought: false,
                    sortOrder: 0,
                    addedAt: DateTime.now(),
                  ),
                );
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: colorScheme.primary, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  item.iconIdentifier,
                  style: TextStyle(
                    fontSize: 32,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item.nameBangla,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
