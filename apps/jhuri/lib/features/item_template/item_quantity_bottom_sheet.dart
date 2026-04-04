import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../config/jhuri_constants.dart';
import '../../providers/item_selection_provider.dart';

class ItemQuantityBottomSheet extends ConsumerStatefulWidget {
  final ItemTemplate item;

  const ItemQuantityBottomSheet({
    super.key,
    required this.item,
  });

  @override
  ConsumerState<ItemQuantityBottomSheet> createState() => _ItemQuantityBottomSheetState();
}

class _ItemQuantityBottomSheetState extends ConsumerState<ItemQuantityBottomSheet> {
  late double quantity;
  late String selectedUnit;
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quantity = widget.item.defaultQuantity;
    selectedUnit = widget.item.defaultUnit;
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item header
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.item.iconIdentifier,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.nameBangla,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.nameEnglish,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
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
                Row(
                  children: [
                    // Decrease button
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (quantity > 0.1) {
                            quantity = (quantity - 0.5).clamp(0.1, 999.9);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Quantity display
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          quantity.toStringAsFixed(quantity.truncateToDouble() == quantity ? 0 : 1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Increase button
                    InkWell(
                      onTap: () {
                        setState(() {
                          quantity = (quantity + 0.5).clamp(0.1, 999.9);
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Unit selector
                Text(
                  'একক',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: JhuriConstants.fixedUnits.map((unit) {
                    final isSelected = unit == selectedUnit;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedUnit = unit;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primary : colorScheme.surface,
                          border: Border.all(
                            color: isSelected ? colorScheme.primary : colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          unit,
                          style: TextStyle(
                            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontFamily: 'NotoSansBengali',
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Price field (optional)
                Text(
                  'মূল্য (ঐচ্ছিক)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'মূল্য লিখুন',
                    prefixText: '${JhuriConstants.defaultCurrencySymbol} ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final listItem = ListItem(
                        id: DateTime.now().millisecondsSinceEpoch,
                        listId: 0, // Placeholder for new list flow
                        templateId: widget.item.id,
                        nameBangla: widget.item.nameBangla,
                        nameEnglish: widget.item.nameEnglish,
                        quantity: quantity,
                        unit: selectedUnit,
                        price: priceController.text.isNotEmpty 
                            ? double.tryParse(priceController.text) 
                            : null,
                        isBought: false,
                        sortOrder: 0,
                        addedAt: DateTime.now(),
                      );

                      ref.read(itemSelectionProvider.notifier).addItem(listItem);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'যোগ করুন',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
