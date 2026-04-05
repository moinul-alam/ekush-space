// lib/features/custom_items/custom_items_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/database_provider.dart';
import '../../l10n/jhuri_localizations.dart';
import '../../shared/widgets/jhuri_app_header.dart';

class CustomItemsScreen extends ConsumerStatefulWidget {
  const CustomItemsScreen({super.key});

  @override
  ConsumerState<CustomItemsScreen> createState() => _CustomItemsScreenState();
}

class _CustomItemsScreenState extends ConsumerState<CustomItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final customItemsAsync = ref.watch(customItemsProvider);
    final l10n = JhuriLocalizations.of(context);

    return Scaffold(
      appBar: JhuriAppHeader(
        title: l10n.manageCustomItems,
      ),
      body: customItemsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error loading custom items: $error',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'কোনো কাস্টম আইটেম নেই',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'আপনি এখনো কোনো কাস্টম আইটেম তৈরি করেননি',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item, l10n);
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(ItemTemplate item, JhuriLocalizations l10n) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.w),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            item.iconIdentifier ?? '📦',
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        title: Text(item.nameBangla),
        subtitle: Text(item.nameEnglish),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              _showDeleteConfirmation(item);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8.w),
                  Text('মুছুন', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ItemTemplate item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('কাস্টম আইটেম মুছে ফেলুন'),
        content: Text('আপনি কি "${item.nameBangla}" মুছতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(this.context);
              try {
                final repository = ref.read(itemTemplateRepositoryProvider);
                await repository.delete(item.id);
                messenger.showSnackBar(
                  const SnackBar(
                      content: Text('কাস্টম আইটেম মুছে ফেলা হয়েছে')),
                );
              } catch (e) {
                messenger.showSnackBar(
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
}

// Provider for custom items
final customItemsProvider = FutureProvider<List<ItemTemplate>>((ref) async {
  final repository = ref.read(itemTemplateRepositoryProvider);
  return await repository.getCustomItems();
});
