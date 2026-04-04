// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../config/jhuri_constants.dart';
import '../shopping_list/home_viewmodel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final viewModelAsync = ref.watch(homeViewModelProvider);

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
      body: _buildBody(viewModelAsync, colorScheme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/categories'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ViewState viewModelAsync, ColorScheme colorScheme) {
    final viewModel = ref.read(homeViewModelProvider.notifier);

    if (viewModelAsync is ViewStateLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModelAsync is ViewStateError) {
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              child: const Text('আবার চেষ্টা করুন'),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasAnyLists) {
      return _buildEmptyState(colorScheme);
    }

    return _buildListsView(viewModel, colorScheme);
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
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
    );
  }

  Widget _buildListsView(HomeViewModel viewModel, ColorScheme colorScheme) {
    return RefreshIndicator(
      onRefresh: () async => await viewModel.refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Lists
            if (viewModel.todayLists.isNotEmpty) ...[
              _buildSectionHeader('আজ', colorScheme),
              ...viewModel.todayLists
                  .map((list) => _buildListCard(list, viewModel, colorScheme)),
              const SizedBox(height: 24),
            ],

            // Upcoming Lists
            if (viewModel.upcomingLists.isNotEmpty) ...[
              _buildSectionHeader('আসন্নিক', colorScheme),
              ...viewModel.upcomingLists
                  .map((list) => _buildListCard(list, viewModel, colorScheme)),
              const SizedBox(height: 24),
            ],

            // Past Incomplete Lists
            if (viewModel.pastIncompleteLists.isNotEmpty) ...[
              _buildSectionHeader('অসম্পূর্ণ', colorScheme),
              ...viewModel.pastIncompleteLists
                  .map((list) => _buildListCard(list, viewModel, colorScheme)),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
          fontFamily: 'NotoSansBengali',
        ),
      ),
    );
  }

  Widget _buildListCard(
      ShoppingList list, HomeViewModel viewModel, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          onLongPress: () {
            _showListOptions(context, list, viewModel);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // List Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // List Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.title.isEmpty ? 'বাজারের ফর্দ' : list.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        viewModel.formatDateForDisplay(list.buyDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontFamily: 'NotoSansBengali',
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showListOptions(
      BuildContext context, ShoppingList list, HomeViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('সম্পাদনা করুন'),
              onTap: () {
                Navigator.pop(context);
                context.push('/list/edit/${list.id}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('কপি করুন'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await viewModel.duplicateList(list.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ফর্দ কপি করা হয়েছে')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ত্রুটি: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('আর্কাইভ করুন'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await viewModel.archiveList(list.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ফর্দ আর্কাইভ করা হয়েছে')),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ত্রুটি: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('মুছুন', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, list, viewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, ShoppingList list, HomeViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ফর্দ মুছে ফেলার নিশ্চিত্তা করুন'),
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
                await viewModel.deleteList(list.id);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ফর্দ মুছে ফেলা হয়েছে')),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ত্রুটি: $e')),
                );
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
