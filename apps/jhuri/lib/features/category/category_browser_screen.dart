import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'category_browser_viewmodel.dart';
import '../../providers/item_selection_provider.dart';
import 'custom_category_form_bottom_sheet.dart';
import '../../shared/widgets/jhuri_app_header.dart';

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
      appBar: const JhuriAppHeader(
        title: 'কী কিনবেন?',
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
            SizedBox(height: 16.h),
            Text(
              'ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
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
              SizedBox(height: 16.h),
              _buildCategoryGrid(categories, viewModel, colorScheme),
              SizedBox(height: 24.h),
              _buildBottomButton(context, colorScheme),
              SizedBox(height: 100.h), // Space for navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(List<Category> categories,
      CategoryBrowserViewModel viewModel, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ক্যাটাগরি নির্বাচন করুন',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
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
                        BorderRadius.vertical(top: Radius.circular(12.r)),
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
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12.r)),
                          color: colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            category.iconIdentifier,
                            style: TextStyle(
                              fontSize: 48.sp,
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
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12.r)),
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
          padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Name
                      Flexible(
                        child: Text(
                          category.nameBangla,
                          style: TextStyle(
                            fontSize: 12.sp,
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
          borderRadius: BorderRadius.circular(12.r),
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
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              // Open custom category creation bottom sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CustomCategoryFormBottomSheet(),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: Text(
                      'নতুন ক্যাটাগরি',
                      style: TextStyle(
                        fontSize: 14.sp,
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
      padding: EdgeInsets.all(16.w),
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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          selectedCount > 0 ? 'সম্পন্ন ($selectedCountটি আইটেম)' : 'সম্পন্ন',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
