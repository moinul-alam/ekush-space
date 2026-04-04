import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'shopping_mode_viewmodel.dart';
import '../../services/share_card_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_providers.dart';
import '../../config/jhuri_constants.dart';

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
    final viewState = ref.watch(shoppingModeViewModelProvider);
    final viewModel = ref.read(shoppingModeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.list?.title.isEmpty == true
              ? 'বাজারের ফর্দ'
              : viewModel.list?.title ?? 'বাজারের ফর্দ',
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
        actions: [
          IconButton(
            onPressed: () => _showShareOptions(context, viewModel),
            icon: const Icon(Icons.share, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: _buildBody(viewModel, viewState, colorScheme),
      bottomNavigationBar: const AppAdBannerBottom(),
    );
  }

  Widget _buildBody(ShoppingModeViewModel viewModel, ViewState viewState,
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'তালিকা লোড করতে সমস্যা হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.loadList(widget.listId),
              child: const Text('আবার চেষ্টা করুন'),
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
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_basket_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'কোন আইটেম নির্বাচিত হয়নি',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ফর্দে ফিরুন'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: LinearProgressIndicator(
              value: viewModel.completionPercentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 8),

          // Progress text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                viewModel.progressText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${viewModel.boughtItems}/${viewModel.totalItems}',
                style: TextStyle(
                  fontSize: 14,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => viewModel.toggleItemBought(item.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => viewModel.toggleItemBought(item.id),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: item.isBought
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
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

                const SizedBox(width: 12),

                // Item info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nameBangla,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          decoration:
                              item.isBought ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (item.nameEnglish != item.nameBangla) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.nameEnglish,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${item.quantity} ${item.unit}',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          if (item.price != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '৳${item.price!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
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
                    const PopupMenuItem(
                      value: 'quantity',
                      child: Text('পরিমাণ পরিবর্তন'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('মুছে ফেলুন'),
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
    if (viewModel.allItemsBought && viewModel.totalItems > 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _markAsCompleted(context, viewModel),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'কেনাকাটা সম্পন্ন করুন',
            style: TextStyle(
              fontSize: 16,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'পরিমাণ পরিবর্তন',
          style: TextStyle(
            fontSize: 18,
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
                fontSize: 16,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Minus button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (item.quantity > 0.1) {
                        viewModel.updateItem(item.id,
                            quantity: item.quantity - 0.1);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('-'),
                  ),
                ),

                const SizedBox(width: 12),

                // Quantity display
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    child: Center(
                      child: Text(
                        '${item.quantity.toStringAsFixed(1)} ${item.unit}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Plus button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      viewModel.updateItem(item.id,
                          quantity: item.quantity + 0.1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
            child: const Text('সম্পন্ন'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ListItem item,
      ShoppingModeViewModel viewModel, ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('মুছে ফেলার নিশ্চিততা'),
        content: Text('আপনি "${item.nameBangla}" মুছে ফেলার নিশ্চিততা?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteItem(item.id);
            },
            child: const Text('মুছুন', style: TextStyle(color: Colors.red)),
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
    await _showInterstitialAdIfNeeded();
  }

  void _markAsCompleted(
      BuildContext context, ShoppingModeViewModel viewModel) async {
    await viewModel.markListAsCompleted();
    if (context.mounted) context.pop();
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
