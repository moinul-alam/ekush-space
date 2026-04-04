// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../config/jhuri_constants.dart';
import '../shopping_list/home_providers.dart';
import '../../providers/database_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final homeListsAsync = ref.watch(homeListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // App Name
            Text(
              JhuriConstants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'HindSiliguri',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings will be implemented in Phase 4
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _buildBody(homeListsAsync, colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/categories'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(HomeListsData homeListsData, ColorScheme colorScheme) {
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
              'একটি ত্রুটি হয়েছে',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'NotoSansBengali',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (!homeListsData.hasAnyLists) {
      return _buildEmptyState(colorScheme);
    }

    return _buildListsView(homeListsData, colorScheme);
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Empty State Icon ──────────────────────
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Empty State Title ────────────────────
              Text(
                'বাজারের কোনো ফর্দ নেই',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontFamily: 'NotoSansBengali',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ── Empty State Message ──────────────────
              Text(
                '"+", বাটন চেপে নতুন ফর্দ তৈরি করুন',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontFamily: 'NotoSansBengali',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // ── Quick Start Tips ────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'দ্রুত শুরু করুন',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                        fontFamily: 'NotoSansBengali',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTipItem(
                      context,
                      icon: Icons.add_circle_outline,
                      title: 'নতুন ফর্দ তৈরি করুন',
                      description: '+ বাটনে ক্লিক করে নতুন ফর্দ শুরু করুন',
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      context,
                      icon: Icons.category_outlined,
                      title: 'বিভাগ নির্বাচন',
                      description: 'প্রয়োজনীয় আইটেমের বিভাগ বেছে নিন',
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem(
                      context,
                      icon: Icons.shopping_cart_outlined,
                      title: 'আইটেম যোগ করুন',
                      description: 'সহজেই আপনার বাজারের তালিকা তৈরি করুন',
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

  Widget _buildListsView(HomeListsData homeListsData, ColorScheme colorScheme) {
    // Combine all lists for the grid
    final allLists = [
      ...homeListsData.todayLists,
      ...homeListsData.upcomingLists,
      ...homeListsData.pastIncompleteLists,
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _buildListsGrid(allLists, colorScheme),
    );
  }

  Widget _buildListsGrid(List<ShoppingList> lists, ColorScheme colorScheme) {
    if (lists.isEmpty) {
      return _buildEmptyState(colorScheme);
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
        return _buildListCard(lists[index], colorScheme);
      },
    );
  }

  Widget _buildListCard(ShoppingList list, ColorScheme colorScheme) {
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
          onLongPress: () => _showListOptions(context, list),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  list.title.isEmpty ? 'বাজারের ফর্দ' : list.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'NotoSansBengali',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Items preview (mock data for now - will be implemented with actual items)
                Expanded(
                  child: _buildItemsPreview(list.id, colorScheme),
                ),

                const SizedBox(height: 8),

                // Footer with date and completion
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Text(
                      _formatDateForDisplay(list.buyDate),
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'NotoSansBengali',
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

  Widget _buildItemsPreview(int listId, ColorScheme colorScheme) {
    final itemsAsync = ref.watch(listItemsProvider(listId));

    return itemsAsync.when(
      loading: () => const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => Text(
        'ত্রুটি',
        style: TextStyle(
          fontSize: 10,
          color: colorScheme.error,
          fontFamily: 'NotoSansBengali',
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Text(
            'কোনো আইটেম নেই',
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontFamily: 'NotoSansBengali',
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
                      fontSize: 11,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                )),
            if (hasMore)
              Text(
                '+${items.length - 3}টি আরও আইটেম',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontFamily: 'NotoSansBengali',
                ),
              ),
          ],
        );
      },
    );
  }

  String _formatDateForDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return 'আজ';
    } else if (checkDate.isAtSameMomentAs(tomorrow)) {
      return 'আগামীকাল';
    } else {
      // Format in Bangla date format
      final months = [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  void _showListOptions(BuildContext context, ShoppingList list) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('সম্পাদনা'),
              onTap: () {
                Navigator.pop(context);
                context.push('/list/${list.id}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('নকল করুন'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final shoppingListRepo =
                      ref.read(shoppingListRepositoryProvider);
                  final listItemRepo = ref.read(listItemRepositoryProvider);

                  // Create new list with copy suffix
                  final newTitle = '${list.title} (কপি)';
                  final newListId = await shoppingListRepo.duplicateList(
                    list.id,
                    newTitle,
                    DateTime.now(),
                  );

                  // Duplicate all items
                  await listItemRepo.duplicateItems(list.id, newListId);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('নকল করা হয়েছে')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ত্রুটি: $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('আর্কাইভ'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  final shoppingListRepo =
                      ref.read(shoppingListRepositoryProvider);
                  await shoppingListRepo.archive(list.id);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('তালিকা আর্কাইভ করা হয়েছে')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ত্রুটি: $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('মুছুন', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, list);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ShoppingList list) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('তালিকা মুছে ফেলার নিশ্চিত্তা করুন'),
        content: Text(
            'আপনি কি "${list.title.isEmpty ? 'বাজারের ফর্দ' : list.title}" মুছতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final shoppingListRepo =
                    ref.read(shoppingListRepositoryProvider);
                final listItemRepo = ref.read(listItemRepositoryProvider);

                // Delete all items first, then the list
                await listItemRepo.deleteByListId(list.id);
                await shoppingListRepo.permanentDelete(list.id);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('তালিকা মুছে ফেলা হয়েছে')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ত্রুটি: $e')),
                  );
                }
              }
            },
            child: const Text('মুছুন', style: TextStyle(color: Colors.red)),
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
        const SizedBox(width: 12),
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
}
