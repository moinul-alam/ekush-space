import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../config/jhuri_constants.dart';
import '../../../core/utils/bangla_date_formatter.dart';
import 'list_create_viewmodel.dart';
import '../item_picker/item_picker_viewmodel.dart';
import 'item_picker_bottom_sheet.dart';
import '../../../shared/widgets/jhuri_app_bar.dart';

class ListCreateScreen extends ConsumerStatefulWidget {
  final ShoppingList? list;
  final ShoppingList? duplicateFrom;

  const ListCreateScreen({
    super.key,
    this.list,
    this.duplicateFrom,
  });

  @override
  ConsumerState<ListCreateScreen> createState() => _ListCreateScreenState();
}

class _ListCreateScreenState extends ConsumerState<ListCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final viewModel = ref.read(createListViewModelProvider.notifier);

    // Check for route parameters
    final extra = widget.list;
    if (extra != null) {
      viewModel.initializeForEdit(extra);
      _titleController.text = extra.title;
    } else {
      // Check if we're in duplicate mode via route extra
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final routeExtra = GoRouterState.of(context).extra;
        if (routeExtra is Map && routeExtra['duplicate'] != null) {
          final duplicateList = routeExtra['duplicate'] as ShoppingList;
          viewModel.initializeForDuplicate(duplicateList);
          _titleController.text = viewModel.title;
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createListViewModelProvider.notifier);
    final viewState = ref.watch(createListViewModelProvider);

    return Scaffold(
      appBar: JhuriAppBar(
        title: viewModel.isEditMode
            ? 'ফর্দ এডিট করুন'
            : viewModel.isDuplicateMode
                ? 'ফর্দ ডুপ্লিকেট করুন'
                : 'নতুন ফর্দ তৈরি করুন',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed:
                viewState is ViewStateLoading ? null : () => _save(viewModel),
            child: viewState is ViewStateLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('সংরক্ষণ করুন'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: const InputDecoration(
                  labelText: 'শিরোনাম',
                  hintText: 'যেমন: সাপ্তাহিক বাজার',
                ),
                onChanged: (value) {
                  viewModel.setTitle(value);
                },
              ),

              const SizedBox(height: 16),

              // Date picker
              InkWell(
                onTap: () => _selectDate(context, viewModel),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'কেনার তারিখ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              BanglaDateFormatter.formatDate(viewModel.buyDate),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Reminder toggle
              SwitchListTile(
                title: const Text('রিমাইন্ডার'),
                subtitle: const Text('নির্দিষ্ট সময়ে রিমাইন্ডার পাঠানো হবে'),
                value: viewModel.isReminderOn,
                onChanged: (value) {
                  viewModel.setReminderOn(value);
                },
              ),

              // Time picker (only when reminder is on)
              if (viewModel.isReminderOn) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context, viewModel),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'রিমাইন্ডারের সময়',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                BanglaDateFormatter.formatTime(
                                    viewModel.reminderTime),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Items section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showItemPicker(context),
                      icon: const Icon(Icons.add),
                      label: const Text('আইটেম যোগ করুন'),
                    ),
                    const SizedBox(height: 16),
                    // Display added items
                    Consumer(
                      builder: (context, ref, child) {
                        final items = viewModel.items;

                        if (items.isEmpty) {
                          return Text(
                            'কোনো আইটেম যোগ করা হয়নি',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 14,
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildItemRow(
                                context, viewModel, item, index);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, CreateListViewModel viewModel) async {
    final date = await showDatePicker(
      context: context,
      initialDate: viewModel.buyDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      viewModel.setBuyDate(date);
    }
  }

  Future<void> _selectTime(
      BuildContext context, CreateListViewModel viewModel) async {
    final time = await showTimePicker(
      context: context,
      initialTime: viewModel.reminderTime,
    );

    if (time != null) {
      viewModel.setReminderTime(time);
    }
  }

  Future<void> _save(CreateListViewModel viewModel) async {
    if (_formKey.currentState?.validate() ?? false) {
      viewModel.setTitle(_titleController.text);

      final success = await viewModel.save();
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _showItemPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const ItemPickerBottomSheet(),
    );
  }

  Widget _buildItemRow(BuildContext context, CreateListViewModel viewModel,
      SelectedItem item, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => _showItemEditDialog(context, viewModel, item, index),
      onLongPress: () => _showItemRemoveDialog(context, viewModel, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            // Serial number
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _formatBanglaNumber((index + 1).toString()),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Item name
            Expanded(
              flex: 3,
              child: Text(
                item.nameBangla,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Amount
            Expanded(
              flex: 2,
              child: Text(
                '${_formatBanglaNumber(item.quantity.toStringAsFixed(1))} ${item.unit}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            // Price (hide if 0)
            if (item.price != null && item.price! > 0) ...[
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Text(
                  '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(item.price!.toStringAsFixed(0))}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  void _showItemEditDialog(BuildContext context, CreateListViewModel viewModel,
      SelectedItem item, int index) {
    final quantityController =
        TextEditingController(text: item.quantity.toString());
    final priceController =
        TextEditingController(text: item.price?.toString() ?? '');
    String selectedUnit = item.unit;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('আইটেম এডিট করুন: ${item.nameBangla}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'পরিমাণ',
                hintText: 'যেমন: 1.5',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedUnit,
              decoration: const InputDecoration(labelText: 'একক'),
              items: JhuriConstants.availableUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) selectedUnit = value;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'মূল্য (ঐচ্ছিক)',
                hintText: 'যেমন: 120',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity =
                  double.tryParse(quantityController.text) ?? item.quantity;
              final price = priceController.text.isNotEmpty
                  ? double.tryParse(priceController.text)
                  : null;

              viewModel.updateItem(index, quantity, selectedUnit, price);
              Navigator.pop(context);
            },
            child: const Text('সংরক্ষণ করুন'),
          ),
        ],
      ),
    );
  }

  void _showItemRemoveDialog(
      BuildContext context, CreateListViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('আইটেম মুছুন'),
        content: const Text('আপনি কি এই আইটেমটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.removeItem(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('মুছুন'),
          ),
        ],
      ),
    );
  }

  String _formatBanglaNumber(String number) {
    const englishToBangla = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    return number.split('').map((char) {
      return englishToBangla[char] ?? char;
    }).join('');
  }
}
