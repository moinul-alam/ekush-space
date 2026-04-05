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
import '../shopping_list/widgets/home_greeter_widget.dart';
import '../shopping_list/widgets/home_list_card_widget.dart';
import '../shopping_list/widgets/no_list_widget.dart';
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

    return SingleChildScrollView(
      child: Column(
        children: [
          // Always show greeter widget
          const HomeGreeterWidget(),

          // Show either empty state or lists
          if (!homeListsData.hasAnyLists)
            NoListWidget(onCreateList: () => context.push('/categories'))
          else
            _buildListsView(homeListsData, colorScheme, l10n),
        ],
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
      return const SizedBox.shrink();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180, // Fixed height for cards
      ),
      itemCount: lists.length,
      itemBuilder: (context, index) {
        final list = lists[index];
        return HomeListCardWidget(
          list: list,
          onTap: () => context.push('/list/${list.id}'),
          onLongPress: () => _showListOptions(context, list, l10n),
        );
      },
    );
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
