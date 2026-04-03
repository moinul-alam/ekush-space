import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import 'category_browser_viewmodel.dart';

class CategoryBrowserScreen extends ConsumerStatefulWidget {
  final int listId;

  const CategoryBrowserScreen({super.key, required this.listId});

  @override
  ConsumerState<CategoryBrowserScreen> createState() =>
      _CategoryBrowserScreenState();
}

class _CategoryBrowserScreenState extends ConsumerState<CategoryBrowserScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = ref.read(categoryBrowserViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'কী কিনবেন?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSansBengali',
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(viewModel, colorScheme),
    );
  }

  Widget _buildBody(
      CategoryBrowserViewModel viewModel, ColorScheme colorScheme) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.hasError) {
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
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.hasError ? 'ত্রুটি হয়েছে' : 'একটি ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansBengali',
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
      );
    }

    return RefreshIndicator(
      onRefresh: () async => await viewModel.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildCategoryGrid(viewModel, colorScheme),
            const SizedBox(height: 24),
            _buildBottomButton(context, colorScheme),
            const SizedBox(height: 100), // Space for navigation
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(
      CategoryBrowserViewModel viewModel, ColorScheme colorScheme) {
    final categories = viewModel.categories;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'বিভাগ নির্বাচন করুন',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              fontFamily: 'NotoSansBengali',
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
                return _buildCategoryCard(category, colorScheme);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category category, ColorScheme colorScheme) {
    return Container(
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
            // Navigate to item picker
            context
                .push('/list/${widget.listId}/category/${category.id}/items');
          },
          child: Column(
            children: [
              // Category Image
              Expanded(
                flex: 2,
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/categories/${category.imageIdentifier}.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Category Name Overlay
              Expanded(
                flex: 1,
                child: Container(
                  height: 110,
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.iconIdentifier.isEmpty
                              ? Icons.category
                              : IconData(int.parse(category.iconIdentifier)),
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Category Name
                      Text(
                        category.nameBangla,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'NotoSansBengali',
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
    return Container(
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
            // Navigate to custom item form
            Navigator.pop(context, 'custom');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'কাস্টম আইটেম',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'নিজের আইটেম তৈরি করুন',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'সম্পন্ন',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotoSansBengali',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
