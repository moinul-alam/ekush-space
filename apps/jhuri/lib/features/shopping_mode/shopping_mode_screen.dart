import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_share/ekush_share.dart';
import '../../../config/jhuri_constants.dart';
import '../../../core/utils/bangla_date_formatter.dart';
import 'shopping_mode_viewmodel.dart';
import '../../shared/widgets/jhuri_app_bar.dart';
import '../home/widgets/ad_banner_widget.dart';

class ShoppingModeScreen extends ConsumerStatefulWidget {
  final int listId;

  const ShoppingModeScreen({super.key, required this.listId});

  @override
  ConsumerState<ShoppingModeScreen> createState() => _ShoppingModeScreenState();
}

class _ShoppingModeScreenState extends ConsumerState<ShoppingModeScreen> {
  bool _showCompletionOverlay = false;

  @override
  void initState() {
    super.initState();
    // Initialize viewmodel with list ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(shoppingModeViewModelProvider.notifier)
          .initialize(widget.listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(shoppingModeViewModelProvider);
    final viewModel = ref.watch(shoppingModeViewModelProvider.notifier);

    if (viewState is ViewStateError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64),
              const SizedBox(height: 16),
              Text(
                viewState.message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(shoppingModeViewModelProvider.notifier).refresh(),
                child: const Text('আবার চেষ্টা করুন'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewState is ViewStateLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'লোড হচ্ছে...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (viewState is ViewStateEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'এই ফর্দে কোনো আইটেম নেই',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: Text('ফিরে যান'),
              ),
            ],
          ),
        ),
      );
    }

    final data = viewModel.successData!;
    final list = data.list;
    final totalPrice = viewModel.totalPrice;

    // Watch for completion trigger
    if (viewModel.completionTriggered && !_showCompletionOverlay) {
      _showCompletionOverlay = true;
      _hideCompletionOverlayAfterDelay();
    }

    if (_showCompletionOverlay) {
      return buildCompletionOverlay();
    }

    return Scaffold(
      appBar: buildAppBar(context, list, viewModel),
      body: Column(
        children: [
          // Progress indicator
          buildProgressIndicator(viewModel),

          // Items list
          Expanded(
            child:
                buildItemsList(context, viewModel.itemsByCategory, viewModel),
          ),

          // Total price row
          if (totalPrice != null) buildTotalPriceRow(totalPrice),
        ],
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context, ShoppingList? list,
      ShoppingModeViewModel viewModel) {
    return JhuriAppBar(
      title: list?.title ?? 'বাজারের ফর্দ',
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareList(context, list, viewModel),
        ),
      ],
    );
  }

  Widget buildProgressIndicator(ShoppingModeViewModel viewModel) {
    final progress = viewModel.totalCount > 0
        ? viewModel.boughtCount / viewModel.totalCount
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatBanglaNumber(viewModel.boughtCount.toString())}/${_formatBanglaNumber(viewModel.totalCount.toString())} কেনা হয়েছে',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget buildItemsList(
      BuildContext context,
      Map<int, List<ListItem>> itemsByCategory,
      ShoppingModeViewModel viewModel) {
    if (itemsByCategory.isEmpty) {
      return const Center(
        child: Text('এই ফর্দে কোনো আইটেম নেই'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemsByCategory.keys.length,
      itemBuilder: (context, index) {
        final categoryId = itemsByCategory.keys.elementAt(index);
        final categoryItems = itemsByCategory[categoryId]!;

        return buildCategorySection(
            context, categoryId, categoryItems, viewModel);
      },
    );
  }

  Widget buildCategorySection(BuildContext context, int categoryId,
      List<ListItem> items, ShoppingModeViewModel viewModel) {
    // Find category name
    final categoryName = viewModel.getCategoryName(categoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...items.map((item) => buildItemRow(context, item, viewModel)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildItemRow(
      BuildContext context, ListItem item, ShoppingModeViewModel viewModel) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: item.isBought
            ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.6)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: buildItemIcon(item),
        title: Text(
          item.nameBangla,
          style: TextStyle(
            decoration: item.isBought ? TextDecoration.lineThrough : null,
            color: item.isBought
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
        subtitle: Text(
            '${_formatBanglaNumber(item.quantity.toStringAsFixed(1))} ${item.unit}'),
        trailing: item.price != null && item.price! > 0
            ? Text(
                '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(item.price!.toStringAsFixed(0))}')
            : null,
        onTap: () => viewModel.toggleItem(item.id, item.isBought),
      ),
    );
  }

  Widget buildItemIcon(ListItem item) {
    // Try to load icon from assets, fallback to generic icon
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.shopping_basket,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget buildTotalPriceRow(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'মোট আনুমানিক',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(totalPrice.toStringAsFixed(0))}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget buildCompletionOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'সব কেনা হয়েছে! 🎉',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('ঠিক করুন'),
            ),
          ],
        ),
      ),
    );
  }

  void _hideCompletionOverlayAfterDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showCompletionOverlay = false;
        });
        // Navigate back to home
        context.pop();
      }
    });
  }

  Future<void> _shareList(BuildContext context, ShoppingList? list,
      ShoppingModeViewModel viewModel) async {
    if (list == null) return;

    // Capture context-dependent objects before any async operations
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Generate share image using ekush_share
      await ShareService.shareWidget(
        widget: buildShareCard(
            context, list, viewModel.items, viewModel.totalPrice),
        fileBaseName: 'shopping_card',
        text: 'কেনাকাটির ফর্দ: ${list.title}',
      );

      if (!mounted) return;
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text('শেয়ার করতে ব্যর্থ হয়েছে: $e')),
      );
    }
  }

  Widget buildShareCard(BuildContext context, ShoppingList list,
      List<ListItem> items, double? totalPrice) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.shopping_basket,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      BanglaDateFormatter.formatDate(list.buyDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Items summary
          Text(
            'কেনাকাটির আইটেম:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...items.take(5).map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '• ${item.nameBangla}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    if (item.price != null && item.price! > 0)
                      Text(
                        '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(item.price!.toStringAsFixed(0))}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              )),
          if (items.length > 5) Text('... আরও ${items.length - 5}টি আইটেম'),
          const SizedBox(height: 16),

          // Total price
          if (totalPrice != null && totalPrice > 0) ...[
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'মোট আনুমানিক:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${JhuriConstants.defaultCurrencySymbol} ${_formatBanglaNumber(totalPrice.toStringAsFixed(0))}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),

          // Footer branding
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'ঝুড়ি - আপনার স্মার্ট কেনাকাটার সঙ্গী',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
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

    return number
        .split('')
        .map((char) => englishToBangla[char] ?? char)
        .join('');
  }
}
