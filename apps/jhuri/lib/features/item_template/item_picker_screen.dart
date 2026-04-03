import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../item_template/item_picker_viewmodel.dart';

class ItemPickerScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final int listId;

  const ItemPickerScreen({
    super.key,
    required this.categoryId,
    required this.listId,
  });

  @override
  ConsumerState<ItemPickerScreen> createState() => _ItemPickerScreenState();
}

class _ItemPickerScreenState extends ConsumerState<ItemPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.read(itemPickerViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'আইটেম বেছন করুন',
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
        actions: [
          IconButton(
            onPressed: () => viewModel.toggleSearch(),
            icon: Icon(viewModel.showSearch ? Icons.close : Icons.search),
            color: Colors.white,
          ),
        ],
      ),
      body: _buildBody(viewModel, colorScheme),
    );
  }

  Widget _buildBody(ItemPickerViewModel viewModel, ColorScheme colorScheme) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.hasError) {
      return Center(
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
              viewModel.hasError ? 'ত্রুটি হয়েছে' : 'একটি ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search bar
        if (viewModel.showSearch) ...[
          Container(
            margin: const EdgeInsets.all(16),
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
            child: TextField(
              onChanged: (value) => viewModel.searchItems(value),
              decoration: InputDecoration(
                hintText: 'আইটেম খুঁজ করুন...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                filled: true,
                fillColor: colorScheme.surface,
              ),
            ),
          ),
        ],

        // Items grid
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await viewModel.refresh(),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return _buildItemCard(item, viewModel, colorScheme);
              },
            ),
          ),
        ),

        // Bottom actions
        _buildBottomActions(context, viewModel, colorScheme),
      ],
    );
  }

  Widget _buildItemCard(ItemTemplate item, ItemPickerViewModel viewModel,
      ColorScheme colorScheme) {
    final isSelected = viewModel.isItemSelected(item.id);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
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
          onTap: () =>
              _showQuantityBottomSheet(context, item, viewModel, colorScheme),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item icon and name
                Row(
                  children: [
                    // Selection checkbox
                    GestureDetector(
                      onTap: () => viewModel.toggleItemSelection(item.id),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: isSelected
                            ? Icon(Icons.check_circle,
                                color: colorScheme.primary, size: 16)
                            : const Icon(Icons.circle_outlined,
                                color: Colors.grey, size: 16),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Item icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.iconIdentifier.isEmpty
                            ? Icons.shopping_bag_outlined
                            : IconData(int.parse(item.iconIdentifier)),
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Item name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nameBangla,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                          if (item.nameEnglish != item.nameBangla) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.nameEnglish,
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontFamily: 'NotoSansBengali',
                              ),
                            ),
                          ],
                        ],
                      ),
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

  void _showQuantityBottomSheet(BuildContext context, ItemTemplate item,
      ItemPickerViewModel viewModel, ColorScheme colorScheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.iconIdentifier.isEmpty
                        ? Icons.shopping_bag_outlined
                        : IconData(int.parse(item.iconIdentifier)),
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nameBangla,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      if (item.nameEnglish != item.nameBangla) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.nameEnglish,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            fontFamily: 'NotoSansBengali',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quantity selector
            Text(
              'পরিমাণ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 12),

            // Quantity buttons
            Row(
              children: [
                // Minus button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // Add to list with default quantity
                    final listItem = ListItem(
                      id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
                      listId: 0, // Will be updated
                      templateId: item.id,
                      nameBangla: item.nameBangla,
                      nameEnglish: item.nameEnglish,
                      quantity: item.defaultQuantity,
                      unit: item.defaultUnit,
                      price: null,
                      isBought: false,
                      sortOrder: 0,
                      addedAt: DateTime.now(),
                    );
                    viewModel.addItemToList(listItem);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.remove,
                        color: colorScheme.primary, size: 24),
                  ),
                ),

                const SizedBox(width: 12),

                // Quantity display
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '${item.defaultQuantity.toStringAsFixed(1)} ${item.defaultUnit}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Plus button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    // Add to list with default quantity + 1
                    final listItem = ListItem(
                      id: DateTime.now().millisecondsSinceEpoch +
                          1, // Temporary ID
                      listId: 0, // Will be updated
                      templateId: item.id,
                      nameBangla: item.nameBangla,
                      nameEnglish: item.nameEnglish,
                      quantity: item.defaultQuantity + 1,
                      unit: item.defaultUnit,
                      price: null,
                      isBought: false,
                      sortOrder: 0,
                      addedAt: DateTime.now(),
                    );
                    viewModel.addItemToList(listItem);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(Icons.add, color: colorScheme.primary, size: 24),
                  ),
                ),
              ],
            ),

            // Unit chips
            const SizedBox(height: 16),
            Text(
              'একক',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: viewModel.availableUnits.map((unit) {
                return ActionChip(
                  label: Text(unit),
                  onPressed: () {
                    // Update selected item with new unit
                    Navigator.pop(context);
                  },
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontFamily: 'NotoSansBengali',
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context,
      ItemPickerViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected items count
          if (viewModel.selectedItems.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${viewModel.selectedItems.length} টি আইটেম নির্ব করা হয়েছে',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'সম্পন্ন',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, viewModel.selectedItems);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'যোগ করুন (${viewModel.selectedItems.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
