import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_item_form_viewmodel.dart';

class CustomItemFormScreen extends ConsumerStatefulWidget {
  const CustomItemFormScreen({super.key});

  @override
  ConsumerState<CustomItemFormScreen> createState() =>
      _CustomItemFormScreenState();
}

class _CustomItemFormScreenState extends ConsumerState<CustomItemFormScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.read(customItemFormViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'নিজের আইটেম তৈরি',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
      ),
      body: _buildBody(viewModel, colorScheme),
    );
  }

  Widget _buildBody(
      CustomItemFormViewModel viewModel, ColorScheme colorScheme) {
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.hasError ? 'ত্রুটি হয়েছে' : 'একটি ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name
          Text(
            'আইটেমর নাম',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: (value) => viewModel.updateNameBangla(value),
            decoration: InputDecoration(
              hintText: 'আইটেমর নাম (যেমন)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),

          const SizedBox(height: 16),

          // English name
          TextField(
            onChanged: (value) => viewModel.updateNameEnglish(value),
            decoration: InputDecoration(
              hintText: 'আইটেমর নাম (English)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),

          const SizedBox(height: 24),

          // Category selection
          Text(
            'ক্যাটাগরি',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: viewModel.selectedCategoryId,
            decoration: InputDecoration(
              hintText: 'ক্যাটাগরি নির্বাচন',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
            items: const [
              DropdownMenuItem(value: '1', child: Text('শাকসবজি')),
              DropdownMenuItem(value: '2', child: Text('মাছ')),
              DropdownMenuItem(value: '3', child: Text('মাছ')),
              DropdownMenuItem(value: '4', child: Text('মাস')),
              DropdownMenuItem(value: '5', child: Text('ডিম')),
              DropdownMenuItem(value: '6', child: Text('ফল')),
              DropdownMenuItem(value: '7', child: Text('ফল')),
              DropdownMenuItem(value: '8', child: Text('বাদন')),
              DropdownMenuItem(value: '9', child: Text('অন্ন')),
              DropdownMenuItem(value: '10', child: Text('অন্যাল')),
              DropdownMenuItem(value: '11', child: Text('সবাজ')),
              DropdownMenuItem(value: '12', child: Text('ডিম')),
            ],
            onChanged: (value) => viewModel.updateCategoryId(value ?? ''),
          ),

          const SizedBox(height: 24),

          // Quantity and unit
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      viewModel.updateQuantity(double.tryParse(value) ?? 1.0),
                  decoration: InputDecoration(
                    hintText: 'পরিমাণ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: viewModel.selectedUnit,
                  decoration: InputDecoration(
                    hintText: 'একক',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                  items: viewModel.availableUnits.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) => viewModel.updateUnit(value ?? ''),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Icon selection
          Text(
            'আইকন',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: viewModel.availableIcons.map((icon) {
              final isSelected = viewModel.selectedIcon == icon;
              return GestureDetector(
                onTap: () => viewModel.updateIcon(icon),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _saveCustomItem(viewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: viewModel.isValid
                    ? colorScheme.primary
                    : colorScheme.surface,
                foregroundColor: viewModel.isValid
                    ? Colors.white
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'আইটেম যোগ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: viewModel.isValid
                      ? Colors.white
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCustomItem(CustomItemFormViewModel viewModel) async {
    if (!viewModel.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অন্তত একট দিন')),
      );
      return;
    }

    try {
      final context = this.context;
      await viewModel.saveCustomItem();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আইটেম যোগ হয়েছে')),
      );
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (e) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ত্রুটি হয়েছে: $e')),
      );
    }
  }
}
