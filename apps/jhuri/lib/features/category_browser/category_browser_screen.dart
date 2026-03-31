import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'category_browser_viewmodel.dart';
import '../item_picker/item_picker_screen.dart';

class CategoryBrowserScreen extends BaseScreen {
  const CategoryBrowserScreen({super.key});

  @override
  BaseScreenState<CategoryBrowserScreen> createState() =>
      _CategoryBrowserScreenState();
}

class _CategoryBrowserScreenState
    extends BaseScreenState<CategoryBrowserScreen> {
  @override
  NotifierProvider<CategoryBrowserViewModel, ViewState> get viewModelProvider =>
      categoryBrowserViewModelProvider;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('কী কিনবেন?'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(categoryBrowserViewModelProvider);

    if (viewState is ViewStateLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewState is ViewStateError) {
      return buildErrorWidget(viewState);
    }

    if (viewState is ViewStateEmpty) {
      return Center(
        child: Text(
          viewState.message ?? 'কোনো ক্যাটাগরি পাওয়া যায়নি',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final viewModel = ref.watch(categoryBrowserViewModelProvider.notifier);
    final categories = viewModel.categories;

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: categories.length + 1, // +1 for custom category
            itemBuilder: (context, index) {
              if (index == categories.length) {
                // Custom category card
                return _buildCustomCategoryCard(context);
              }

              final category = categories[index];
              return _buildCategoryCard(context, category);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('সম্পন্ন'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemPickerScreen(
                categoryId: category.id,
                categoryName: category.nameBangla,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surfaceContainerHighest,
                Theme.of(context).colorScheme.surfaceContainer,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Grey placeholder for image
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              // Category name overlay at bottom
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
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Text(
                    category.nameBangla,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCategoryCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('শীঘ্রই আসছে')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 32,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 4),
              Text(
                '➕ কাস্টম',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
