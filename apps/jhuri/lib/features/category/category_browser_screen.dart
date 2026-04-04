import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import 'category_browser_viewmodel.dart';
import '../../providers/item_selection_provider.dart';
import 'custom_category_form_bottom_sheet.dart';

class CategoryBrowserScreen extends ConsumerStatefulWidget {
  final int? listId;

  const CategoryBrowserScreen({super.key, this.listId});

  @override
  ConsumerState<CategoryBrowserScreen> createState() =>
      _CategoryBrowserScreenState();
}

class _CategoryBrowserScreenState extends ConsumerState<CategoryBrowserScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(categoryBrowserViewModelProvider);
    final viewModel = ref.read(categoryBrowserViewModelProvider.notifier);

    // Eagerly initialize item selection provider to ensure first tap works
    ref.watch(itemSelectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'কী কিনবেন?',
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
      ),
      body: _buildBody(categoriesAsync, viewModel, colorScheme),
    );
  }

  Widget _buildBody(AsyncValue<List<Category>> categoriesAsync,
      CategoryBrowserViewModel viewModel, ColorScheme colorScheme) {
    return categoriesAsync.when(
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      ),
      data: (categories) => RefreshIndicator(
        onRefresh: () async => await viewModel.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildCategoryGrid(categories, viewModel, colorScheme),
              const SizedBox(height: 24),
              _buildBottomButton(context, colorScheme),
              const SizedBox(height: 100), // Space for navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(List<Category> categories,
      CategoryBrowserViewModel viewModel, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ক্যাটাগরি নির্বাচন করুন',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: categories.length + 1, // +1 for custom item
            itemBuilder: (context, index) {
              if (index == categories.length) {
                // Custom item card
                return _buildCustomItemCard(colorScheme);
              } else {
                final category = categories[index];
                return AspectRatio(
                  aspectRatio: 1.0,
                  child: _buildCategoryCard(category, colorScheme),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category, ColorScheme colorScheme) {
    return Container(
      height: double.infinity,
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
          onTap: () {
            // Navigate to item picker using new route
            context.push('/categories/${category.id}/items',
                extra: category.nameBangla);
          },
          child: Column(
            children: [
              // Category Image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: colorScheme.surface,
                  ),
                  child: Image.asset(
                    'assets/images/categories/${category.imageIdentifier}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to emoji icon
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          color: colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            category.iconIdentifier,
                            style: TextStyle(
                              fontSize: 48,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Category Name Overlay
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.0),
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Name
                      Flexible(
                        child: Text(
                          category.nameBangla,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomItemCard(ColorScheme colorScheme) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        height: double.infinity,
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
            onTap: () {
              // Open custom category creation bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CustomCategoryFormBottomSheet(),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.add,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Text(
                      'নতুন ক্যাটাগরি',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, ColorScheme colorScheme) {
    final itemSelection = ref.watch(itemSelectionProvider);
    final selectedCount = itemSelection.selectedCount;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: selectedCount > 0
            ? () {
                if (widget.listId == null) {
                  // New list flow - navigate to create list with selections
                  context.push('/list/new');
                } else {
                  // Existing list flow - go back with selections
                  context.pop();
                }
              }
            : null, // Disable when no items selected
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedCount > 0 ? colorScheme.primary : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          selectedCount > 0 ? 'সম্পন্ন ($selectedCountটি আইটেম)' : 'সম্পন্ন',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
