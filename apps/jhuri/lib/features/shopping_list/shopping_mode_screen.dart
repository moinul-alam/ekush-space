import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_ads/ekush_ads.dart';
import '../../providers/database_provider.dart';
import '../../services/share_card_service.dart';
import 'shopping_mode_viewmodel.dart';
import '../../shared/widgets/jhuri_app_header.dart';
import '../../l10n/jhuri_localizations.dart';

class ShoppingModeScreen extends ConsumerStatefulWidget {
  final int listId;

  const ShoppingModeScreen({super.key, required this.listId});

  @override
  ConsumerState<ShoppingModeScreen> createState() => _ShoppingModeScreenState();
}

class _ShoppingModeScreenState extends ConsumerState<ShoppingModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shoppingModeViewModelProvider.notifier).loadList(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = JhuriLocalizations.of(context);
    final viewState = ref.watch(shoppingModeViewModelProvider);
    final viewModel = ref.read(shoppingModeViewModelProvider.notifier);

    return Scaffold(
      appBar: JhuriAppHeader(
        title: viewModel.list?.title.isEmpty == true
            ? l10n.shoppingListDefault
            : viewModel.list?.title ?? l10n.shoppingListDefault,
        actions: [
          IconButton(
            onPressed: () => _showShareOptions(context, viewModel),
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: _buildBody(viewModel, viewState, colorScheme),
      bottomNavigationBar: const AppAdBannerBottom(),
    );
  }

  Widget _buildBody(ShoppingModeViewModel viewModel, ViewState viewState,
      ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

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
              l10n.errorOccurred,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.failedToLoadList,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => viewModel.loadList(widget.listId,
                  listNotFoundText: l10n.listNotFound),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    if (viewModel.list == null) {
      return _buildEmptyState(colorScheme);
    }

    return Column(
      children: [
        // Progress header
        _buildProgressHeader(viewModel, colorScheme),

        // Items list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await viewModel.loadList(widget.listId),
            child: ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return _buildItemCard(item, viewModel, colorScheme);
              },
            ),
          ),
        ),

        // Bottom actions
        _buildBottomActions(context, viewModel, colorScheme),

        // Ad placeholder
        SizedBox(height: 50.h),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_basket_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.noItemsSelected,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.returnToList),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 8.h,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: LinearProgressIndicator(
              value: viewModel.completionPercentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          SizedBox(height: 8.h),

          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 8.w),
              Text(
                viewModel.getProgressText(
                  l10n.noItems,
                  l10n.itemsBoughtCount(
                      viewModel.boughtItems, viewModel.totalItems),
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${viewModel.boughtItems}/${viewModel.totalItems}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      ListItem item, ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => viewModel.toggleItemBought(item.id),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => viewModel.toggleItemBought(item.id),
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: item.isBought
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: item.isBought
                            ? colorScheme.primary
                            : Colors.grey.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: item.isBought
                        ? Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ),

                SizedBox(width: 12.w),

                // Item info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nameBangla,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          decoration:
                              item.isBought ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (item.nameEnglish != item.nameBangla) ...[
                        SizedBox(height: 2.h),
                        Text(
                          item.nameEnglish,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            '${item.quantity} ${item.unit}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          if (item.price != null) ...[
                            SizedBox(width: 8.w),
                            Text(
                              '৳${item.price!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Options button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'quantity':
                        _showQuantityDialog(
                            context, item, viewModel, colorScheme);
                        break;
                      case 'delete':
                        _showDeleteConfirmation(
                            context, item, viewModel, colorScheme);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'quantity',
                      child: Text(l10n.changeQuantity),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(l10n.deleteItemText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context,
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    if (viewModel.allItemsBought && viewModel.totalItems > 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton(
          onPressed: () => _markAsCompleted(context, viewModel),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            l10n.markShoppingComplete,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _showQuantityDialog(BuildContext context, ListItem item,
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.changeQuantity,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.nameBangla,
              style: TextStyle(
                fontSize: 16.sp,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                // Minus button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (item.quantity > 0.1) {
                        viewModel.updateItem(item.id,
                            quantity: item.quantity - 0.1,
                            defaultUnit: l10n.defaultUnitKg);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('-'),
                  ),
                ),

                SizedBox(width: 12.w),

                // Quantity display
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity.toStringAsFixed(1)} ${item.unit}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Plus button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      viewModel.updateItem(item.id,
                          quantity: item.quantity + 0.1,
                          defaultUnit: l10n.defaultUnitKg);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('+'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ListItem item,
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmation),
        content: Text(l10n.confirmDeleteItem(item.nameBangla)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteItem(item.id);
            },
            child: Text(l10n.deleteItemText,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(
      BuildContext context, ShoppingModeViewModel viewModel) async {
    final list = viewModel.list;
    if (list == null) return;

    await ShareCardService.shareShoppingListCard(
      listId: list.id,
      listTitle: list.title,
      buyDate: list.buyDate,
      itemRepository: ref.read(listItemRepositoryProvider),
      categoryRepository: ref.read(categoryRepositoryProvider),
      context: context,
    );

    // Show interstitial ad after share image generation
    await viewModel.triggerPostShareAd();
  }

  void _markAsCompleted(
      BuildContext context, ShoppingModeViewModel viewModel) async {
    await viewModel.markListAsCompleted();
    if (context.mounted) Navigator.pop(context);
  }
}
