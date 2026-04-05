import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/jhuri_constants.dart';
import '../../providers/database_provider.dart';
import 'item_picker_viewmodel.dart';
import '../../shared/widgets/jhuri_app_header.dart';
import '../../l10n/jhuri_localizations.dart';

class CreateCustomItemScreen extends ConsumerStatefulWidget {
  const CreateCustomItemScreen({super.key});

  @override
  ConsumerState<CreateCustomItemScreen> createState() =>
      _CreateCustomItemScreenState();
}

class _CreateCustomItemScreenState
    extends ConsumerState<CreateCustomItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _banglaNameController = TextEditingController();
  final _englishNameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _priceController = TextEditingController();

  int _selectedCategoryId = 1;
  String _selectedUnit = JhuriConstants.defaultUnit;
  bool _isSaving = false;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _banglaNameController.dispose();
    _englishNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categoryRepo = ref.read(categoryRepositoryProvider);
      final categories = await categoryRepo.watchAllCategories().first;
      setState(() {
        _categories = categories;
        if (categories.isNotEmpty) {
          _selectedCategoryId = categories.first.id;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ত্রুটি: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const JhuriAppHeader(
        title: 'নতুন আইটেম তৈরি',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          top: 20.h,
          left: 20.w,
          right: 20.w,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bangla Name (required)
              Text(
                JhuriLocalizations.of(context).itemNameBangla,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _banglaNameController,
                decoration: InputDecoration(
                  hintText: JhuriLocalizations.of(context).itemNameBanglaHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return JhuriLocalizations.of(context).itemNameRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // English Name (optional)
              Text(
                JhuriLocalizations.of(context).itemNameEnglish,
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
                  hintText: JhuriLocalizations.of(context).itemNameEnglishHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Category (required)
              Text(
                JhuriLocalizations.of(context).itemCategory,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value == -1) {
                    return JhuriLocalizations.of(context).selectItemCategory;
                  }
                  return null;
                },
                items: [
                  ..._categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Row(
                        children: [
                          Text(
                            category.iconIdentifier,
                            style: const TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 8.w),
                          Text(category.nameBangla),
                        ],
                      ),
                    );
                  }),
                  // Add new category option
                  DropdownMenuItem<int>(
                    value: -1,
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8.w),
                        Text(JhuriLocalizations.of(context).createNewCategory),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == -1) {
                    _showCreateCategoryDialog();
                  } else if (value != null) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                  }
                },
              ),
              SizedBox(height: 16.h),

              // Quantity
              Text(
                JhuriLocalizations.of(context).itemQuantity,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: JhuriLocalizations.of(context).quantityHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return JhuriLocalizations.of(context).enterQuantity;
                  }
                  final quantity = double.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return JhuriLocalizations.of(context).validQuantity;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // Unit
              Text(
                JhuriLocalizations.of(context).itemUnit,
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
                  final isSelected = _selectedUnit == unit;
                  return FilterChip(
                    label: Text(unit),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedUnit = unit;
                      });
                    },
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    selectedColor: colorScheme.primary.withValues(alpha: 0.2),
                    checkmarkColor: colorScheme.primary,
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),

              // Price (optional)
              Text(
                JhuriLocalizations.of(context).price,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: JhuriLocalizations.of(context).priceHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  prefixText: JhuriConstants.defaultCurrencySymbol,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return JhuriLocalizations.of(context).validPrice;
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          JhuriLocalizations.of(context).addCustomItem,
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
      ),
    );
  }

  void _showCreateCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(JhuriLocalizations.of(context).createNewCategory),
        content: Text(JhuriLocalizations.of(context).featureComingSoonCategory),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(JhuriLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategoryId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(JhuriLocalizations.of(context).selectItemCategory)),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final itemRepo = ref.read(itemTemplateRepositoryProvider);

      await itemRepo.createCustomItem(
        nameBangla: _banglaNameController.text.trim(),
        nameEnglish: _englishNameController.text.trim().isEmpty
            ? _banglaNameController.text.trim()
            : _englishNameController.text.trim(),
        phoneticName:
            _banglaNameController.text.trim().toLowerCase().replaceAll(' ', ''),
        categoryId: _selectedCategoryId,
        defaultQuantity: double.parse(_quantityController.text.trim()),
        defaultUnit: _selectedUnit,
        emoji: '📦', // Default emoji for custom items
        sortOrder: 999, // Custom items appear last
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(JhuriLocalizations.of(context).customItemAddedSuccess)),
        );
        // Invalidate the item picker provider for the saved category
        ref.invalidate(itemPickerViewModelProvider(_selectedCategoryId));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${JhuriLocalizations.of(context).errorWithSuffix}$e')),
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
