// lib/services/share_card_service.dart

import 'package:flutter/material.dart';
import 'package:ekush_share/ekush_share.dart';
import 'package:ekush_models/ekush_models.dart';
import '../features/list_item/data/list_item_repository.dart';
import '../features/category/data/category_repository.dart';

/// Service for generating and sharing shopping list cards
class ShareCardService {
  /// Generate and share a shopping list as an image card
  static Future<void> shareShoppingListCard({
    required int listId,
    required String listTitle,
    required DateTime buyDate,
    required ListItemRepository itemRepository,
    required CategoryRepository categoryRepository,
    required BuildContext context,
  }) async {
    try {
      // Capture scaffold messenger and theme before await to avoid context usage across async gaps
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final theme = Theme.of(context);

      // Get all items for the list
      final items = await itemRepository.getByListId(listId);

      if (items.isEmpty) {
        _showErrorToast(scaffoldMessenger);
        return;
      }

      // Group items by category
      final Map<int, List<ListItem>> itemsByCategory = {};
      for (final item in items) {
        final categoryId = item.templateId ?? 0;
        itemsByCategory.putIfAbsent(categoryId, () => []).add(item);
      }

      // Get category names
      final categoryNames = <int, String>{
        0: 'অন্যান্য',
      };
      for (final categoryId in itemsByCategory.keys) {
        if (categoryId == 0) continue;
        final category = await categoryRepository.getById(categoryId);
        categoryNames[categoryId] = category?.nameBangla ?? 'অন্যান্য';
      }

      // Build the share card widget
      final cardWidget = _buildShareCard(
        listTitle: listTitle,
        buyDate: buyDate,
        itemsByCategory: itemsByCategory,
        categoryNames: categoryNames,
        theme: theme,
      );

      // Share the widget as image
      await ShareService.shareWidget(
        widget: cardWidget,
        fileBaseName:
            'jhuri_shopping_list_${DateTime.now().millisecondsSinceEpoch}',
      );
    } catch (e) {
      debugPrint('❌ Failed to share shopping list card: $e');
      // Need to capture scaffold messenger in catch block too
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      _showErrorToast(scaffoldMessenger);
    }
  }

  /// Build the share card widget
  static Widget _buildShareCard({
    required String listTitle,
    required DateTime buyDate,
    required Map<int, List<ListItem>> itemsByCategory,
    required Map<int, String> categoryNames,
    required ThemeData theme,
  }) {
    // Use captured theme instead of accessing context
    // final theme = Theme.of(context);

    // Calculate totals
    int totalItems = 0;
    double totalPrice = 0.0;
    for (final items in itemsByCategory.values) {
      totalItems += items.length;
      for (final item in items) {
        if (item.price != null) {
          totalPrice += item.price! * item.quantity;
        }
      }
    }

    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Warm cream background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8D6E63), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ঝুড়ি',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'স্মার্ট গ্রোসারি লিস্ট',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF558B2F),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatBanglaDate(buyDate),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF33691E),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'তারিখ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF689F38),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // List title
          if (listTitle.isNotEmpty) ...[
            Text(
              listTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B5E20),
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Items grouped by category
          ...itemsByCategory.entries.map((entry) {
            final categoryId = entry.key;
            final items = entry.value;
            final categoryName = categoryNames[categoryId] ?? 'অন্যান্য';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category header
                Text(
                  '$categoryName (${items.length})',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                    fontFamily: 'HindSiliguri',
                  ),
                ),
                const SizedBox(height: 8),

                // Items in this category
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '• ${item.nameBangla}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF33691E),
                                fontFamily: 'HindSiliguri',
                              ),
                            ),
                          ),
                          if (item.price != null)
                            Text(
                              '৳${(item.price! * item.quantity).toStringAsFixed(0)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF558B2F),
                                fontFamily: 'HindSiliguri',
                              ),
                            ),
                        ],
                      ),
                    )),

                const SizedBox(height: 12),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Footer with totals and watermark
          Column(
            children: [
              // Divider
              Container(
                height: 1,
                color: const Color(0xFF8D6E63),
              ),
              const SizedBox(height: 12),

              // Totals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'মোট আইটেম: $totalItems টি',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                      fontFamily: 'HindSiliguri',
                    ),
                  ),
                  if (totalPrice > 0)
                    Text(
                      'মোট মূল্য: ৳${totalPrice.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B5E20),
                        fontFamily: 'HindSiliguri',
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Watermark
              Center(
                child: Text(
                  'Jhuri দিয়ে তৈরি 🛒',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF8D6E63),
                    fontFamily: 'HindSiliguri',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Format date in Bangla
  static String _formatBanglaDate(DateTime date) {
    final banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

    String convertToBangla(String number) {
      return number.split('').map((char) {
        if (char.contains(RegExp(r'[0-9]'))) {
          return banglaDigits[int.parse(char)];
        }
        return char;
      }).join('');
    }

    final day = convertToBangla(date.day.toString());
    final month = convertToBangla(date.month.toString());
    final year = convertToBangla(date.year.toString());

    return '$day/$month/$year';
  }

  /// Show error toast
  static void _showErrorToast(ScaffoldMessengerState scaffoldMessenger) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text('শেয়ার করতে সমস্যা হয়েছে। আবার চেষ্টা করুন'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
