import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'create_edit_list_viewmodel.dart';
import '../category/category_browser_screen.dart';
import '../item_template/item_picker_screen.dart';

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
      appBar: AppBar(
        title: Text(
          viewModel.isEditMode ? 'ফর্দ সম্পাদনা' : 'নতুন ফর্দ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansBengali',
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansBengali',
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
            const SizedBox(height: 16),
            Text(
              'ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewState.error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List Info Section
          _buildListInfoSection(viewModel, colorScheme),
          const SizedBox(height: 24),

          // Items Section
          _buildItemsSection(viewModel, colorScheme),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildListInfoSection(
      CreateEditListViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ফর্দের তথ্য',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 16),

          // Title field
          TextField(
            onChanged: (value) => viewModel.updateTitle(value),
            decoration: InputDecoration(
              labelText: 'ফর্দের নাম (ঐচ্ছিক)',
              hintText: 'উদাহরণ: সাপ্তাহিক বাজার',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            style: const TextStyle(
              fontFamily: 'NotoSansBengali',
            ),
          ),
          const SizedBox(height: 16),

          // Date picker
          ListTile(
            leading: Icon(Icons.calendar_today, color: colorScheme.primary),
            title: Text(
              'কেনার তারিখ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            subtitle: Text(
              viewModel.formatDateForDisplay(viewModel.buyDate),
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontFamily: 'NotoSansBengali',
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
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            subtitle: Text(
              viewModel.isReminderOn
                  ? 'সময়: ${viewModel.formatTime(viewModel.reminderTime)}'
                  : 'বন্ধ',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontFamily: 'NotoSansBengali',
              ),
            ),
            secondary: Icon(Icons.notifications, color: colorScheme.primary),
          ),
          if (viewModel.isReminderOn) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ListTile(
                leading: Icon(Icons.access_time, color: colorScheme.primary),
                title: Text(
                  'রিমাইন্ডার সময়',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
                subtitle: Text(
                  viewModel.formatTime(viewModel.reminderTime),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    fontFamily: 'NotoSansBengali',
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
              TextButton.icon(
                onPressed: () => _navigateToCategoryBrowser(viewModel),
                icon: const Icon(Icons.add),
                label: Text(
                  'আইটেম যোগ করুন',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansBengali',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (viewModel.items.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 48,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'কোন আইটেম যোগ করা হয়নি',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'আইটেম যোগ করতে উপরের বাটনে ক্লিক করুন',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontFamily: 'NotoSansBengali',
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            fontFamily: 'NotoSansBengali',
          ),
        ),
        subtitle: Text(
          '${item.quantity} ${item.unit}',
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontFamily: 'NotoSansBengali',
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
    // For now, we'll navigate to category browser
    // In a real implementation, we'd need to handle the listId properly
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryBrowserScreen(listId: widget.listId ?? 0),
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
            listId: widget.listId ?? 0,
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

  Future<void> _saveList(CreateEditListViewModel viewModel) async {
    try {
      final listId = await viewModel.saveList();
      if (listId != -1) {
        final context = this.context;
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              viewModel.isEditMode ? 'ফর্দ আপডেট হয়েছে' : 'ফর্দ তৈরি হয়েছে',
              style: const TextStyle(fontFamily: 'NotoSansBengali'),
            ),
          ),
        );
        if (!context.mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ত্রুটি: $e',
            style: const TextStyle(fontFamily: 'NotoSansBengali'),
          ),
        ),
      );
    }
  }
}
