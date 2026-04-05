import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/jhuri_constants.dart';
import '../../providers/database_provider.dart';
import '../category/category_browser_viewmodel.dart';
import 'item_picker_viewmodel.dart';

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
  final _quantityController = TextEditingController(text: '1');
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: double.infinity,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'নতুন আইটেম যোগ করুন',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Bangla name (required)
                  Text(
                    'আইটেমের নাম (বাংলা) *',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: আলু',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'আইটেমের নাম লিখুন';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // English name (optional)
                  Text(
                    'আইটেমের নাম (ইংরেজি)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _englishNameController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: Potato',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Category dropdown
                  Text(
                    'ক্যাটাগরি',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  categoriesAsync.when(
                    data: (categories) {
                      return DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(
                              category.nameBangla,
                              style: const TextStyle(),
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
                  SizedBox(height: 16.h),

                  // Quantity
                  Text(
                    'পরিমাণ',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'পরিমাণ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
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
                  SizedBox(height: 16.h),

                  // Unit chips
                  Text(
                    'একক',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: JhuriConstants.fixedUnits.map((unit) {
                      final isSelected = unit == _selectedUnit;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedUnit = unit;
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
                  SizedBox(height: 16.h),

                  // Price (optional)
                  Text(
                    'মূল্য (ঐচ্ছিক)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _priceController,
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'বাতিল',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Save button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveCustomItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  height: 20.h,
                                  width: 48.w,
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

          SizedBox(width: 48.w),
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
      // Save to database via repository
      final itemRepo = ref.read(itemTemplateRepositoryProvider);
      await itemRepo.createCustomItem(
        nameBangla: _nameController.text.trim(),
        nameEnglish: _englishNameController.text.trim().isEmpty
            ? _nameController.text.trim()
            : _englishNameController.text.trim(),
        phoneticName:
            _nameController.text.trim().toLowerCase().replaceAll(' ', ''),
        categoryId: _selectedCategoryId,
        defaultQuantity: double.tryParse(_quantityController.text) ?? 1.0,
        defaultUnit: _selectedUnit,
        emoji: '📦', // Default emoji for custom items
        sortOrder: 999, // Custom items appear last
      );

      // Invalidate the item picker provider to refresh the grid
      ref.invalidate(itemPickerViewModelProvider(_selectedCategoryId));

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
