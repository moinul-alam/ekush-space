import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../config/jhuri_constants.dart';
import '../../../core/utils/bangla_date_formatter.dart';
import 'list_create_viewmodel.dart';
import '../item_picker/item_picker_viewmodel.dart';

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

    if (widget.list != null) {
      viewModel.initializeForEdit(widget.list!);
      _titleController.text = widget.list!.title;
    } else if (widget.duplicateFrom != null) {
      viewModel.initializeForDuplicate(widget.duplicateFrom!);
      _titleController.text = viewModel.title;
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

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      viewModel.isEditMode
                          ? 'ফর্দ এডিট করুন'
                          : viewModel.isDuplicateMode
                              ? 'ফর্দ ডুপ্লিকেট করুন'
                              : 'নতুন ফর্দ তৈরি করুন',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title field
                        TextFormField(
                          controller: _titleController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'কেনার তারিখ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        BanglaDateFormatter.formatDate(
                                            viewModel.buyDate),
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
                          subtitle: const Text(
                              'নির্দিষ্ট সময়ে রিমাইন্ডার পাঠানো হবে'),
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
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'রিমাইন্ডারের সময়',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
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
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () =>
                                    GoRouter.of(context).push('/categories'),
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

                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        items.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return _buildItemChip(
                                          context, viewModel, item, index);
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: viewState is ViewStateLoading
                                ? null
                                : () => _save(viewModel),
                            child: viewState is ViewStateLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('সংরক্ষণ করুন'),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  Widget _buildItemChip(BuildContext context, CreateListViewModel viewModel,
      SelectedItem item, int index) {
    return GestureDetector(
      onTap: () => _showItemEditDialog(context, viewModel, item, index),
      onLongPress: () => _showItemRemoveDialog(context, viewModel, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon placeholder
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shopping_basket, size: 12),
            ),
            const SizedBox(width: 8),
            // Item info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.nameBangla,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.price != null && item.price! > 0)
                  Text(
                    '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(item.price!.toStringAsFixed(0))}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            // Quantity and unit
            Text(
              '${_formatBanglaNumber(item.quantity.toStringAsFixed(1))} ${item.unit}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
