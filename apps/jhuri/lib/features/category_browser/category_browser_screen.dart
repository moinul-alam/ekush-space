import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../core/providers/jhuri_providers.dart';
import '../../shared/widgets/jhuri_app_bar.dart';
import '../../shared/widgets/jhuri_drawer.dart';
import 'category_browser_viewmodel.dart';

class CategoryBrowserScreen extends BaseScreen {
  const CategoryBrowserScreen({super.key});

  @override
  BaseScreenState<CategoryBrowserScreen> createState() =>
      _CategoryBrowserScreenState();
}

class _CategoryBrowserScreenState
    extends BaseScreenState<CategoryBrowserScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  NotifierProvider<CategoryBrowserViewModel, ViewState> get viewModelProvider =>
      categoryBrowserViewModelProvider;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context, WidgetRef ref) {
    return const JhuriAppBar(
      title: 'কী কিনবেন?',
    );
  }

  @override
  Widget? buildDrawer(BuildContext context, WidgetRef ref) {
    return const JhuriDrawer();
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
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ক্যাটাগরি খুঁজুন...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (query) {
              viewModel.filterCategories(query);
            },
          ),
        ),

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
    final isFrequent = category.id == kFrequentlyUsedCategoryId;

    return Card(
      elevation: isFrequent ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFrequent
            ? BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.5),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          context.push('/categories/${category.id}/items',
              extra: category.nameBangla);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isFrequent
                  ? [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surfaceContainer,
                    ]
                  : [
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                      Theme.of(context).colorScheme.surfaceContainer,
                    ],
            ),
          ),
          child: Stack(
            children: [
              // Icon or placeholder
              Center(
                child: Icon(
                  isFrequent ? Icons.star : Icons.category_outlined,
                  size: 32,
                  color: isFrequent
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                ),
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
                    color: isFrequent
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.8)
                        : Colors.black.withValues(alpha: 0.6),
                  ),
                  child: Text(
                    category.nameBangla,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
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
    final viewModel = ref.read(categoryBrowserViewModelProvider.notifier);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showAddCategoryDialog(context, viewModel),
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
              const SizedBox(height: 4),
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

  void _showAddCategoryDialog(
      BuildContext context, CategoryBrowserViewModel viewModel) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('নতুন ক্যাটাগরি'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'ক্যাটাগরির নাম লিখুন',
            labelText: 'নাম',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await viewModel.addCategory(name);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('যোগ করুন'),
          ),
        ],
      ),
    );
  }
}
