import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  ConsumerState<ItemQuantityBottomSheet> createState() =>
      _ItemQuantityBottomSheetState();
}

class _ItemQuantityBottomSheetState
    extends ConsumerState<ItemQuantityBottomSheet> {
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item header
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          widget.item.iconIdentifier ?? widget.item.emoji,
                          style: TextStyle(fontSize: 32.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.nameBangla,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.item.nameEnglish,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

SizedBox(height: 24.h),

                // Quantity selector
                Text(
                  'পরিমাণ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
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
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Quantity display
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          quantity.toStringAsFixed(
                              quantity.truncateToDouble() == quantity ? 0 : 1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Increase button
                    InkWell(
                      onTap: () {
                        setState(() {
                          quantity = (quantity + 0.5).clamp(0.1, 999.9);
                        });
                      },
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Unit selector
                Text(
                  'একক',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: JhuriConstants.fixedUnits.map((unit) {
                    final isSelected = unit == selectedUnit;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedUnit = unit;
                        });
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          unit,
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20.h),

                // Price field (optional)
                Text(
                  'মূল্য (ঐচ্ছিক)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'মূল্য লিখুন',
                    prefixText: '${JhuriConstants.defaultCurrencySymbol} ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),

SizedBox(height: 24.h),

                // Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final listItem = ListItem(
                        id: widget.item.id, // ← use template id, not timestamp
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

                      ref
                          .read(itemSelectionProvider.notifier)
                          .addItem(listItem);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'যোগ করুন',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
