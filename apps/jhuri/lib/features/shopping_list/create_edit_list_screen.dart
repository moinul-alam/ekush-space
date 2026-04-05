import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/item_selection_provider.dart';
import '../shopping_list/home_viewmodel.dart';
import 'create_edit_list_viewmodel.dart';
import '../category/category_browser_screen.dart';
import '../item_template/item_picker_screen.dart';
import '../../shared/widgets/jhuri_app_header.dart';
import '../../l10n/jhuri_localizations.dart';

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
      final l10n = JhuriLocalizations.of(context);
      if (widget.listId != null) {
        ref
            .read(createEditListViewModelProvider.notifier)
            .initializeForEdit(widget.listId!, l10n.listNotFound);
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
        title: viewModel.isEditMode
            ? JhuriLocalizations.of(context).editList
            : JhuriLocalizations.of(context).createList,
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
                JhuriLocalizations.of(context).save,
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
              JhuriLocalizations.of(context).errorOccurred,
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
                final l10n = JhuriLocalizations.of(context);
                if (viewModel.isEditMode) {
                  viewModel.initializeForEdit(
                      widget.listId!, l10n.listNotFound);
                } else {
                  viewModel.initializeForCreate();
                }
              },
              child: Text(JhuriLocalizations.of(context).retry),
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
            JhuriLocalizations.of(context).listInfo,
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
              labelText: JhuriLocalizations.of(context).listTitleOptional,
              hintText: JhuriLocalizations.of(context).listTitleHint,
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
              JhuriLocalizations.of(context).buyDate,
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
              JhuriLocalizations.of(context).reminder,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              viewModel.isReminderOn
                  ? '${JhuriLocalizations.of(context).timePrefix} ${viewModel.formatTime(viewModel.reminderTime)}'
                  : JhuriLocalizations.of(context).turnOff,
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
                  JhuriLocalizations.of(context).reminderTime,
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
                '${JhuriLocalizations.of(context).itemsHeader} (${viewModel.itemCount})',
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
                  JhuriLocalizations.of(context).addItem,
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
                    JhuriLocalizations.of(context).noItems,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    JhuriLocalizations.of(context).clickToAddItems,
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
    final l10n = JhuriLocalizations.of(context);
    try {
      final listId = await viewModel.saveList(l10n.atLeastOneItem);
      if (listId != -1) {
        ref.read(itemSelectionProvider.notifier).clearSelections();
        ref.invalidate(homeViewModelProvider);
        await viewModel.triggerPostSaveAd();
        if (!mounted) return;
        router.go('/home');
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
            SnackBar(content: Text('${l10n.errorWithMessage} $e')));
      }
    }
  }
}
