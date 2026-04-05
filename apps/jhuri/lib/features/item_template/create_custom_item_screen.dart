import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../config/jhuri_constants.dart';
import '../../providers/database_provider.dart';
import 'item_picker_viewmodel.dart';
import '../../shared/widgets/jhuri_app_header.dart';

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
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bangla Name (required)
              Text(
                'আইটেমের নাম *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _banglaNameController,
                decoration: InputDecoration(
                  hintText: 'যেমন: টমেটো',
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

              // English Name (optional)
              Text(
                'ইংরেজি নাম',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _englishNameController,
                decoration: InputDecoration(
                  hintText: 'যেমন: Tomato',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category (required)
              Text(
                'ক্যাটাগরি *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value == -1) {
                    return 'ক্যাটাগরি বেছে নিন';
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
                          const SizedBox(width: 8),
                          Text(category.nameBangla),
                        ],
                      ),
                    );
                  }),
                  // Add new category option
                  const DropdownMenuItem<int>(
                    value: -1,
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text('নতুন ক্যাটাগরি তৈরি'),
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
              const SizedBox(height: 16),

              // Quantity
              Text(
                'পরিমাণ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: 'যেমন: 1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
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

              // Unit
              Text(
                'একক',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
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
              const SizedBox(height: 16),

              // Price (optional)
              Text(
                'মূল্য',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'যেমন: 50',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: JhuriConstants.defaultCurrencySymbol,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'বৈধ মূল্য লিখুন';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
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
        ),
      ),
    );
  }

  void _showCreateCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নতুন ক্যাটাগরি তৈরি'),
        content: const Text(
            'এই ফিচারটি শীঘ্রই আসছে। অনুগ্রহ করে ক্যাটাগরি ব্রাউজার থেকে নতুন ক্যাটাগরি তৈরি করুন।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
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
        const SnackBar(content: Text('ক্যাটাগরি বেছে নিন')),
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
          const SnackBar(content: Text('আইটেম সংরক্ষণ হয়েছে')),
        );
        // Invalidate the item picker provider for the saved category
        ref.invalidate(itemPickerViewModelProvider(_selectedCategoryId));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ত্রুটি: $e')),
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
