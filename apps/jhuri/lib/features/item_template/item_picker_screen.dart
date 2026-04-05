import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/item_selection_provider.dart';
import '../../config/jhuri_constants.dart';
import 'item_picker_viewmodel.dart';
import 'item_quantity_bottom_sheet.dart';
import 'custom_item_form_bottom_sheet.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class ItemPickerScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;

  const ItemPickerScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<ItemPickerScreen> createState() => _ItemPickerScreenState();
}

class _ItemPickerScreenState extends ConsumerState<ItemPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    // Check if search should be visible based on category item count
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSearchVisibility();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _checkSearchVisibility() {
    final itemsAsync = ref.read(itemPickerViewModelProvider(widget.categoryId));
    itemsAsync.whenData((items) {
      setState(() {
        _isSearchVisible =
            items.length >= JhuriConstants.searchVisibleThreshold;
      });
    });
  }

  void _onSearchChanged(String query) {
    final viewModel =
        ref.read(itemPickerViewModelProvider(widget.categoryId).notifier);
    viewModel.searchItems(query);
  }

  void _clearSearch() {
    _searchController.clear();
    final viewModel =
        ref.read(itemPickerViewModelProvider(widget.categoryId).notifier);
    viewModel.searchItems('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final itemsAsync =
        ref.watch(itemPickerViewModelProvider(widget.categoryId));
    final itemSelection = ref.watch(itemSelectionProvider);

    return Scaffold(
      appBar: JhuriAppHeader(
        title: widget.categoryName,
      ),
      body: Column(
        children: [
          // Search bar - always visible since all categories have 25-40 items
          if (_isSearchVisible)
            Padding(
              padding: EdgeInsets.all(12.0.w),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'আইটেম খুঁজুন...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          // Items grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(_isSearchVisible ? 0 : 12.0.w),
              child: _buildItemsGrid(itemsAsync, itemSelection, colorScheme),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCustomItemForm(context),
        icon: const Icon(Icons.add),
        label: const Text('নতুন আইটেম'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildItemsGrid(AsyncValue<List<ItemTemplate>> itemsAsync,
      ItemSelectionState itemSelection, ColorScheme colorScheme) {
    return itemsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
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
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      data: (items) {
        // Check if search is active and no results found
        final isSearchActive = _searchController.text.isNotEmpty;
        if (isSearchActive && items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 16),
                Text(
                  'কোনো আইটেম পাওয়া যায়নি',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'অন্য কিওয়ার্ড দিয়ে চেষ্টা করুন',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = itemSelection.selectedItemIds.contains(item.id);

            return InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ItemQuantityBottomSheet(item: item),
                );
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: isSelected
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          item.iconIdentifier ?? item.emoji,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            item.nameBangla,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Checkmark badge for selected items
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCustomItemForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CustomItemFormBottomSheet(
        preselectedCategoryId: widget.categoryId,
      ),
    );
  }
}
