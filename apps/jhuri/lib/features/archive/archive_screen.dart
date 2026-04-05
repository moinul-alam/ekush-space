import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ekush_core/ekush_core.dart';
import '../../l10n/jhuri_localizations.dart';
import 'archive_viewmodel.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class ArchiveScreen extends ConsumerStatefulWidget {
  const ArchiveScreen({super.key});

  @override
  ConsumerState<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends ConsumerState<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = JhuriLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final viewState = ref.watch(archiveViewModelProvider);
    final viewModel = ref.read(archiveViewModelProvider.notifier);

    return Scaffold(
      appBar: JhuriAppHeader(
        title: l10n.archive,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(archiveViewModelProvider.notifier)
              .refresh(loadingArchives: l10n.loadingArchives);
        },
        child: _buildBody(viewState, viewModel, colorScheme),
      ),
    );
  }

  Widget _buildBody(ViewState viewState, ArchiveViewModel viewModel,
      ColorScheme colorScheme) {
    final l10n = JhuriLocalizations.of(context);

    if (viewState is ViewStateLoading && !viewModel.hasData) {
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
                fontFamily: 'HindSiliguri',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              viewState.message,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: 'HindSiliguri',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final archivedLists = viewModel.archivedLists;

    if (archivedLists.isEmpty) {
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
              l10n.noArchivedLists,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontFamily: 'HindSiliguri',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.noArchivedListsDescription,
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
      child: _buildListsGrid(context, archivedLists, colorScheme),
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
    final l10n = JhuriLocalizations.of(context);
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
                  list.title.isEmpty ? l10n.shoppingListDefault : list.title,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    l10n.completedStatus,
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
    final l10n = JhuriLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final listDate = DateTime(date.year, date.month, date.day);

    if (listDate == today) {
      return l10n.today;
    } else if (listDate == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
