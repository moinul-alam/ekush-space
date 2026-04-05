import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_item_form_viewmodel.dart';
import '../../shared/widgets/jhuri_app_header.dart';

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
      appBar: const JhuriAppHeader(
        title: 'নিজের আইটেম তৈরি',
        leadingIcon: Icons.close,
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
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: Colors.red,
            ),
            SizedBox(height: 16.h),
            Text(
              'ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              viewModel.hasError ? 'ত্রুটি হয়েছে' : 'একটি ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name
          Text(
            'আইটেমর নাম',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            onChanged: (value) => viewModel.updateNameBangla(value),
            decoration: InputDecoration(
              hintText: 'আইটেমর নাম (যেমন)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),

          SizedBox(height: 16.h),

          // English name
          TextField(
            onChanged: (value) => viewModel.updateNameEnglish(value),
            decoration: InputDecoration(
              hintText: 'আইটেমর নাম (English)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.3)),
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          ),

          SizedBox(height: 24.h),

          // Category selection
          Text(
            'ক্যাটাগরি',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            initialValue: viewModel.selectedCategoryId,
            decoration: InputDecoration(
              hintText: 'ক্যাটাগরি নির্বাচন',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
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

          SizedBox(height: 24.h),

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
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: viewModel.selectedUnit,
                  decoration: InputDecoration(
                    hintText: 'একক',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
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

          SizedBox(height: 24.h),

          // Icon selection
          Text(
            'আইকন',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: viewModel.availableIcons.map((icon) {
              final isSelected = viewModel.selectedIcon == icon;
              return GestureDetector(
                onTap: () => viewModel.updateIcon(icon),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? colorScheme.primary : colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.r),
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
                        fontSize: 20.sp,
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

          SizedBox(height: 32.h),

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
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'আইটেম যোগ',
                style: TextStyle(
                  fontSize: 16.sp,
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
