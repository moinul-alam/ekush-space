// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_ads/ekush_ads.dart';
import '../../../l10n/jhuri_localizations.dart';
import '../shopping_list/home_providers.dart';
import '../shopping_list/home_viewmodel.dart';
import '../category/custom_category_form_bottom_sheet.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = JhuriLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final homeListsAsync = ref.watch(homeListsProvider);

    return Scaffold(
      appBar: const JhuriAppHeader(
        isHomeScreen: true,
      ),
      drawer: _buildDrawer(context, colorScheme, l10n),
      body: _buildBody(homeListsAsync, colorScheme, l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/categories'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppAdBannerBottom(),
    );
  }

  Widget _buildBody(HomeListsData homeListsData, ColorScheme colorScheme,
      JhuriLocalizations l10n) {
    if (homeListsData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (homeListsData.error != null) {
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
              l10n.errorOccurred,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.anErrorOccurred,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!homeListsData.hasAnyLists) {
      return _buildEmptyState(colorScheme, l10n);
    }

    return _buildListsView(homeListsData, colorScheme, l10n);
  }

  Widget _buildEmptyState(ColorScheme colorScheme, JhuriLocalizations l10n) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Empty State Icon ──────────────────────
              // Container(
              //   width: 120,
              //   height: 120,
              //   decoration: BoxDecoration(
              //     color: colorScheme.surfaceContainerHighest,
              //     borderRadius: BorderRadius.circular(24),
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(24),
              //     child: Image.asset(
              //       'assets/images/app_logo.png',
              //       width: 120,
              //       height: 120,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),

              SizedBox(height: 32.h),

              // ── Empty State Title ────────────────────
              Text(
                l10n.homeEmptyTitle,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ── Empty State Message ──────────────────
              Text(
                l10n.homeEmptyMessage,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48.h),

              // ── Quick Start Tips ────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.quickStart,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildTipItem(
                      context,
                      icon: Icons.add_circle_outline,
                      title: l10n.newList,
                      description: l10n.clickButtonToCreateList,
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      context,
                      icon: Icons.category_outlined,
                      title: l10n.categories,
                      description: l10n.selectCategoryDescription,
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      context,
                      icon: Icons.shopping_cart_outlined,
                      title: l10n.addItem,
                      description: l10n.createListDescription,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListsView(HomeListsData homeListsData, ColorScheme colorScheme,
      JhuriLocalizations l10n) {
    // Combine all lists for grid
    final allLists = [
      ...homeListsData.todayLists,
      ...homeListsData.upcomingLists,
      ...homeListsData.pastIncompleteLists,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildListsGrid(allLists, colorScheme, l10n),
    );
  }

  Widget _buildListsGrid(List<ShoppingList> lists, ColorScheme colorScheme,
      JhuriLocalizations l10n) {
    if (lists.isEmpty) {
      return _buildEmptyState(colorScheme, l10n);
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180, // Fixed height for cards
      ),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        return _buildListCard(lists[index], colorScheme, l10n);
      },
    );
  }

  Widget _buildListCard(
      ShoppingList list, ColorScheme colorScheme, JhuriLocalizations l10n) {
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
          onTap: () => context.push('/list/${list.id}'),
          onLongPress: () => _showListOptions(context, list, l10n),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  list.title.isEmpty ? l10n.shoppingList : list.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Items preview (mock data for now - will be implemented with actual items)
                Expanded(
                  child: _buildItemsPreview(list.id, colorScheme, l10n),
                ),

                const SizedBox(height: 8),

                // Footer with date and completion
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Text(
                      _formatDateForDisplay(list.buyDate, l10n),
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),

                    // Completion indicator
                    _buildCompletionIndicator(list.id, colorScheme),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionIndicator(int listId, ColorScheme colorScheme) {
    final itemsAsync = ref.watch(listItemsProvider(listId));

    return itemsAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '...',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.error,
          ),
        ),
      ),
      data: (items) {
        final boughtCount = items.where((item) => item.isBought).length;
        final totalCount = items.length;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$boughtCount/$totalCount',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsPreview(
      int listId, ColorScheme colorScheme, JhuriLocalizations l10n) {
    final itemsAsync = ref.watch(listItemsProvider(listId));

    return itemsAsync.when(
      loading: () => Center(
        child: SizedBox(
          width: 16.w,
          height: 16.h,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => Text(
        l10n.error,
        style: TextStyle(
          fontSize: 10,
          color: colorScheme.error,
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Text(
            l10n.noItems,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          );
        }

        final displayItems = items.take(3).toList();
        final hasMore = items.length > 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...displayItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '• ${item.nameBangla}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                )),
            if (hasMore)
              Text(l10n.moreItems.replaceAll('${0}', '${items.length - 3}')),
          ],
        );
      },
    );
  }

  String _formatDateForDisplay(DateTime date, JhuriLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return l10n.today;
    } else if (checkDate.isAtSameMomentAs(tomorrow)) {
      return l10n.tomorrow;
    } else {
      return '${date.day} ${l10n.getMonthName(date.month)} ${date.year}';
    }
  }

  void _showListOptions(
      BuildContext context, ShoppingList list, JhuriLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.edit),
              onTap: () {
                Navigator.pop(context);
                context.push('/list/${list.id}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.duplicateList),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(this.context);
                try {
                  await ref.read(homeViewModelProvider.notifier).duplicateList(
                        list.id,
                        listCopy: l10n.listCopy,
                        listWithCopy: l10n.listWithCopy,
                      );

                  // Show success message
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.listDuplicated)),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                        content: Text(l10n.errorWithMessage
                            .replaceAll('ত্রুটি: ', 'ত্রুটি: $e'))),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text(l10n.archive),
              onTap: () async {
                Navigator.pop(context);
                final messenger = ScaffoldMessenger.of(this.context);
                try {
                  await ref
                      .read(homeViewModelProvider.notifier)
                      .archiveListFromHome(list.id);

                  // Show success message
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.listArchived)),
                  );
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                        content: Text(l10n.errorWithMessage
                            .replaceAll('ত্রুটি: ', 'ত্রুটি: $e'))),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(l10n.delete, style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, list, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, ShoppingList list, JhuriLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteList),
        content: Text(l10n.deleteListQuestion.replaceAll(
            '${0}', list.title.isEmpty ? l10n.shoppingList : list.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(this.context);
              try {
                debugPrint(
                    '🔄 Starting deletion for list ${list.id}: "${list.title}"');

                await ref
                    .read(homeViewModelProvider.notifier)
                    .deleteListPermanently(list.id);

                // Show success message
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.listDeleted)),
                );
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(
                      content: Text(l10n.errorWithMessage
                          .replaceAll('ত্রুটি: ', 'ত্রুটি: $e'))),
                );
              }
            },
            child: Text(l10n.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(
      BuildContext context, ColorScheme colorScheme, JhuriLocalizations l10n) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.secondaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App logo
                Image.asset(
                  'assets/images/app_logo.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.shopping_basket,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                // App name
                Text(
                  l10n.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                    fontFamily: 'HindSiliguri',
                  ),
                ),
                const SizedBox(height: 4),
                // Tagline
                Text(
                  l10n.appTagline,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    fontFamily: 'HindSiliguri',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Menu items
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(l10n.navHome),
            onTap: () {
              Navigator.pop(context);
              // Already on home, no navigation needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: Text(l10n.createNewCategory),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CustomCategoryFormBottomSheet(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: Text(l10n.createNewItem),
            onTap: () {
              Navigator.pop(context);
              context.push('/items/create');
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: Text(l10n.archive),
            onTap: () {
              Navigator.pop(context);
              context.push('/archive');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            },
          ),

          const Divider(),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ekush Labs',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                FutureBuilder(
                  future: _getAppVersion(),
                  builder: (context, snapshot) {
                    return Text(
                      'Version ${snapshot.data ?? '1.0.0'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      debugPrint('Error getting app version: $e');
      return '1.0.0';
    }
  }
}
