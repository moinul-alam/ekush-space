import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../config/jhuri_constants.dart';
import '../../providers/item_selection_provider.dart';
import '../category/category_browser_viewmodel.dart';

class CustomItemFormBottomSheet extends ConsumerStatefulWidget {
  final int? preselectedCategoryId;

  const CustomItemFormBottomSheet({super.key, this.preselectedCategoryId});

  @override
  ConsumerState<CustomItemFormBottomSheet> createState() =>
      _CustomItemFormBottomSheetState();
}

class _CustomItemFormBottomSheetState
    extends ConsumerState<CustomItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _englishNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  int _selectedCategoryId = 1; // Default to vegetables
  String _selectedUnit = JhuriConstants.defaultUnit;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedCategoryId != null) {
      _selectedCategoryId = widget.preselectedCategoryId!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _englishNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(categoryBrowserViewModelProvider);

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'নতুন আইটেম যোগ করুন',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bangla name (required)
                  Text(
                    'আইটেমের নাম (বাংলা) *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: আলু',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'আইটেমের নাম লিখুন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // English name (optional)
                  Text(
                    'আইটেমের নাম (ইংরেজি)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _englishNameController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: Potato',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category dropdown
                  Text(
                    'বিভাগ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  categoriesAsync.when(
                    data: (categories) {
                      return DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(
                              category.nameBangla,
                              style: const TextStyle(
                                  fontFamily: 'NotoSansBengali'),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value!;
                          });
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text(
                      'ত্রুটি হয়েছে',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity
                  Text(
                    'পরিমাণ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityController,
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'পরিমাণ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'পরিমাণ লিখুন';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'বৈধ পরিমাণ লিখুন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Unit chips
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
                    runSpacing: 8,
                    children: JhuriConstants.fixedUnits.map((unit) {
                      final isSelected = unit == _selectedUnit;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedUnit = unit;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.surface,
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(20),
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
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Price (optional)
                  Text(
                    'মূল্য (ঐচ্ছিক)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
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

                  // Buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'বাতিল',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NotoSansBengali',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Save button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveCustomItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'সংরক্ষণ করুন',
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _saveCustomItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Create new custom item template
      final customItem = ItemTemplate(
        id: 0, // Will be set by database
        nameBangla: _nameController.text.trim(),
        nameEnglish: _englishNameController.text.trim(),
        categoryId: _selectedCategoryId,
        defaultQuantity: double.tryParse(_quantityController.text) ?? 1.0,
        defaultUnit: _selectedUnit,
        iconIdentifier: '📦', // Default icon for custom items
        isCustom: true,
        usageCount: 0,
        lastUsedAt: DateTime.now(),
        createdAt: DateTime.now(),
      );

      // Save to database via repository
      // Note: In a real implementation, you'd use the repository
      // For now, we'll add directly to selection

      final listItem = ListItem(
        id: DateTime.now().millisecondsSinceEpoch,
        listId: 0, // Placeholder for new list flow
        templateId: customItem.id, // Will be updated after save
        nameBangla: customItem.nameBangla,
        nameEnglish: customItem.nameEnglish,
        quantity: customItem.defaultQuantity,
        unit: customItem.defaultUnit,
        price: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text)
            : null,
        isBought: false,
        sortOrder: 0,
        addedAt: DateTime.now(),
      );

      // Add to selection provider
      ref.read(itemSelectionProvider.notifier).addItem(listItem);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ত্রুটি হয়েছে: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
