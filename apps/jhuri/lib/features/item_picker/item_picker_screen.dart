import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../config/jhuri_constants.dart';
import 'item_picker_viewmodel.dart';

class ItemPickerScreen extends BaseScreen {
  final int categoryId;
  final String categoryName;

  const ItemPickerScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  BaseScreenState<ItemPickerScreen> createState() => _ItemPickerScreenState();
}

class _ItemPickerScreenState extends BaseScreenState<ItemPickerScreen> {
  final _searchController = TextEditingController();
  bool _searchVisible = false;

  @override
  NotifierProvider<ItemPickerViewModel, ViewState> get viewModelProvider =>
      itemPickerViewModelProvider;

  @override
  void initState() {
    super.initState();
    // Initialize the view model with the category ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(itemPickerViewModelProvider.notifier)
          .loadItems(widget.categoryId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(widget.categoryName),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(itemPickerViewModelProvider);

    if (viewState is ViewStateLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewState is ViewStateError) {
      return buildErrorWidget(viewState);
    }

    if (viewState is ViewStateEmpty) {
      return Center(
        child: Text(
          viewState.message ?? 'কোনো আইটেম পাওয়া যায়নি',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final viewModel = ref.watch(itemPickerViewModelProvider.notifier);
    final items = viewModel.items;
    final selectedItems = viewModel.selectedItems;

    // Show search bar if there are enough items
    if (items.length >= JhuriConstants.searchVisibleThreshold &&
        !_searchVisible) {
      _searchVisible = true;
    }

    return Column(
      children: [
        // Search bar (conditionally visible)
        if (_searchVisible) ...[
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'আইটেম খুঁজুন...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                viewModel.filterItems(query);
              },
            ),
          ),
        ],
        // Items grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = selectedItems
                  .any((selected) => selected.templateId == item.id);

              return _buildItemCard(context, item, isSelected, viewModel);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, ItemTemplate item,
      bool isSelected, ItemPickerViewModel viewModel) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showQuantityBottomSheet(context, item, viewModel),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Stack(
            children: [
              // Grey placeholder for image
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              // Item name at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Text(
                    item.nameBangla,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // Checkmark overlay if selected
              if (isSelected)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuantityBottomSheet(
      BuildContext context, ItemTemplate item, ItemPickerViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _QuantityBottomSheet(
        item: item,
        onAdd: (quantity, unit, price) {
          viewModel.addItem(item, quantity, unit, price);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _QuantityBottomSheet extends StatefulWidget {
  final ItemTemplate item;
  final Function(double quantity, String unit, double? price) onAdd;

  const _QuantityBottomSheet({
    required this.item,
    required this.onAdd,
  });

  @override
  State<_QuantityBottomSheet> createState() => _QuantityBottomSheetState();
}

class _QuantityBottomSheetState extends State<_QuantityBottomSheet> {
  double _quantity = 1.0;
  String _selectedUnit = 'কেজি';
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.defaultQuantity;
    _selectedUnit = widget.item.defaultUnit;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Item name
              Text(
                widget.item.nameBangla,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),

              const SizedBox(height: 24),

              // Quantity stepper
              Text(
                'পরিমাণ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity =
                            (_quantity - 0.5).clamp(0.5, double.infinity);
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: Text(
                      _quantity.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity += 0.5;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Unit selector
              Text(
                'একক',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: JhuriConstants.availableUnits.length,
                  itemBuilder: (context, index) {
                    final unit = JhuriConstants.availableUnits[index];
                    final isSelected = unit == _selectedUnit;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(unit),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedUnit = unit;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Price field (optional)
              Text(
                'মূল্য (ঐচ্ছিক)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'মূল্য লিখুন',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              // Add button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final price = _priceController.text.isNotEmpty
                        ? double.tryParse(_priceController.text)
                        : null;
                    widget.onAdd(_quantity, _selectedUnit, price);
                  },
                  child: const Text('যোগ করুন'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
