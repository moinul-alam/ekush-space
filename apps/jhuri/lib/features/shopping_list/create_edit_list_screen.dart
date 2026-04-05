import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_ads/ekush_ads.dart';
import '../../providers/item_selection_provider.dart';
import '../shopping_list/home_viewmodel.dart';
import 'create_edit_list_viewmodel.dart';
import '../category/category_browser_screen.dart';
import '../item_template/item_picker_screen.dart';
import '../../providers/settings_providers.dart';
import '../../config/jhuri_constants.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class CreateEditListScreen extends ConsumerStatefulWidget {
  final int? listId;

  const CreateEditListScreen({super.key, this.listId});

  @override
  ConsumerState<CreateEditListScreen> createState() =>
      _CreateEditListScreenState();
}

class _CreateEditListScreenState extends ConsumerState<CreateEditListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.listId != null) {
        ref
            .read(createEditListViewModelProvider.notifier)
            .initializeForEdit(widget.listId!);
      } else {
        ref
            .read(createEditListViewModelProvider.notifier)
            .initializeForCreate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewState = ref.watch(createEditListViewModelProvider);
    final viewModel = ref.read(createEditListViewModelProvider.notifier);

    return Scaffold(
      appBar: JhuriAppHeader(
        title: viewModel.isEditMode ? 'ফর্দ সম্পাদনা' : 'নতুন ফর্দ',
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: _buildBody(viewModel, viewState, colorScheme),
      floatingActionButton: viewModel.isValid
          ? FloatingActionButton.extended(
              onPressed: () => _saveList(viewModel),
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.save),
              label: Text(
                'সংরক্ষণ করুন',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody(CreateEditListViewModel viewModel, ViewState viewState,
      ColorScheme colorScheme) {
    if (viewState is ViewStateLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewState is ViewStateError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
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
              viewState.error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                if (viewModel.isEditMode) {
                  viewModel.initializeForEdit(widget.listId!);
                } else {
                  viewModel.initializeForCreate();
                }
              },
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
          // List Info Section
          _buildListInfoSection(viewModel, colorScheme),
          SizedBox(height: 24.h),

          // Items Section
          _buildItemsSection(viewModel, colorScheme),
          SizedBox(height: 100.h), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildListInfoSection(
      CreateEditListViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ফর্দের তথ্য',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),

          // Title field
          TextField(
            onChanged: (value) => viewModel.updateTitle(value),
            decoration: InputDecoration(
              labelText: 'ফর্দের নাম (ঐচ্ছিক)',
              hintText: 'উদাহরণ: সাপ্তাহিক বাজার',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            style: const TextStyle(),
          ),
          SizedBox(height: 16.h),

          // Date picker
          ListTile(
            leading: Icon(Icons.calendar_today, color: colorScheme.primary),
            title: Text(
              'কেনার তারিখ',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              viewModel.formatDateForDisplay(viewModel.buyDate),
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            onTap: () => _selectDate(viewModel),
          ),

          // Reminder toggle
          SwitchListTile(
            value: viewModel.isReminderOn,
            onChanged: (value) => viewModel.updateReminder(value),
            title: Text(
              'রিমাইন্ডার',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              viewModel.isReminderOn
                  ? 'সময়: ${viewModel.formatTime(viewModel.reminderTime)}'
                  : 'বন্ধ',
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            secondary: Icon(Icons.notifications, color: colorScheme.primary),
          ),
          if (viewModel.isReminderOn) ...[
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: ListTile(
                leading: Icon(Icons.access_time, color: colorScheme.primary),
                title: Text(
                  'রিমাইন্ডার সময়',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  viewModel.formatTime(viewModel.reminderTime),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                onTap: () => _selectTime(viewModel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection(
      CreateEditListViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'আইটেম (${viewModel.itemCount})',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToCategoryBrowser(viewModel),
                icon: const Icon(Icons.add),
                label: Text(
                  'আইটেম যোগ করুন',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (viewModel.items.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 48,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'কোন আইটেম যোগ করা হয়নি',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'আইটেম যোগ করতে উপরের বাটনে ক্লিক করুন',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...viewModel.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildItemCard(item, index, viewModel, colorScheme);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildItemCard(ListItem item, int index,
      CreateEditListViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        leading: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          item.nameBangla,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${item.quantity} ${item.unit}',
          style: TextStyle(
            fontSize: 14.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => viewModel.removeItem(index),
        ),
      ),
    );
  }

  Future<void> _selectDate(CreateEditListViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.buyDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      viewModel.updateBuyDate(picked);
    }
  }

  Future<void> _selectTime(CreateEditListViewModel viewModel) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: viewModel.reminderTime,
    );
    if (picked != null) {
      viewModel.updateReminderTime(picked);
    }
  }

  Future<void> _navigateToCategoryBrowser(
      CreateEditListViewModel viewModel) async {
    // For new lists, navigate to category browser with temporary selections
    // For existing lists, use the old flow
    if (widget.listId == null) {
      // New list flow - navigate to category browser with listId=0
      context.push('/categories');

      // Refresh the items from temporary selection state when returning
      if (mounted) {
        ref
            .read(createEditListViewModelProvider.notifier)
            .refreshFromSelectionState();
      }
    } else {
      // Existing list flow - use the old navigation
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryBrowserScreen(listId: widget.listId!),
        ),
      );

      if (result != null && result is Category) {
        // Navigate to item picker
        final context = this.context;
        if (!context.mounted) return;
        final items = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemPickerScreen(
              categoryId: result.id,
              categoryName: result.nameBangla,
            ),
          ),
        );

        if (items != null && items is List<ListItem>) {
          if (!context.mounted) return;
          for (final item in items) {
            viewModel.addItem(item);
          }
        }
      }
    }
  }

  Future<void> _saveList(CreateEditListViewModel viewModel) async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final listId = await viewModel.saveList();
      if (listId != -1) {
        ref.read(itemSelectionProvider.notifier).clearSelections();
        ref.invalidate(homeViewModelProvider);
        await _showInterstitialAdIfNeeded();
        if (!mounted) return;
        router.go('/home');
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('ত্রুটি: $e')));
    }
  }

  Future<void> _showInterstitialAdIfNeeded() async {
    try {
      final adService = ref.read(adServiceProvider);
      final lastShownNotifier =
          ref.read(lastInterstitialShownNotifierProvider.notifier);
      final lastShown = ref.read(lastInterstitialShownProvider);

      // Check if enough time has passed since last interstitial
      final now = DateTime.now();
      final minInterval =
          Duration(minutes: JhuriConstants.interstitialMinIntervalMinutes);

      bool shouldShowAd = true;
      if (lastShown != null) {
        final lastShownTime = DateTime.parse(lastShown);
        final timeSinceLastAd = now.difference(lastShownTime);
        if (timeSinceLastAd < minInterval) {
          shouldShowAd = false;
        }
      }

      if (shouldShowAd) {
        adService.showInterstitialIfAvailable();
        // Update last interstitial shown time
        await lastShownNotifier.setLastInterstitialShown(now.toIso8601String());
      }
    } catch (e) {
      // Silently fail ad display - don't block user flow
      debugPrint('Failed to show interstitial ad: $e');
    }
  }
}
