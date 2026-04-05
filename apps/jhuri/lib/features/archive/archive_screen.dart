import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shopping_list/home_providers.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final archivedListsAsync = ref.watch(archivedListsProvider);

    return Scaffold(
      appBar: const JhuriAppHeader(
        title: 'আর্কাইভ',
      ),
      body: archivedListsAsync.when(
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
                  fontFamily: 'HindSiliguri',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'আর্কাইভ তালিকা লোড করতে সমস্যা হয়েছে',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'HindSiliguri',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (lists) {
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 64,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'কোনো আর্কাইভ তালিকা নেই',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'সম্পন্ন হওয়া তালিকাগুলো এখানে দেখাবে',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: _buildListsGrid(context, lists, colorScheme),
          );
        },
      ),
    );
  }

  Widget _buildListsGrid(
      BuildContext context, List<ShoppingList> lists, ColorScheme colorScheme) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 180.h, // Fixed height for cards
      ),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        return _buildListCard(context, lists[index], colorScheme);
      },
    );
  }

  Widget _buildListCard(
      BuildContext context, ShoppingList list, ColorScheme colorScheme) {
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
          onTap: () => GoRouter.of(context).push('/list/${list.id}'),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  list.title.isEmpty ? 'বাজারের ফর্দ' : list.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'HindSiliguri',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // Date
                Text(
                  _formatDate(list.buyDate),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontFamily: 'HindSiliguri',
                  ),
                ),

                const Spacer(),

                // Completed badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'সম্পন্ন',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final listDate = DateTime(date.year, date.month, date.day);

    if (listDate == today) {
      return 'আজ';
    } else if (listDate == today.subtract(const Duration(days: 1))) {
      return 'গতকাল';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
