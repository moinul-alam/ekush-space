import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../item_picker/item_picker_screen.dart';
import '../../../core/providers/jhuri_providers.dart';

class ItemPickerBottomSheet extends ConsumerWidget {
  const ItemPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'আইটেম বাছাই করুন',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Categories content
              Expanded(
                child: CategoryBrowserContent(
                  onCategorySelected: (categoryId, categoryName) {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ItemPickerModalSheet(
                        categoryId: categoryId,
                        categoryName: categoryName,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryBrowserContent extends ConsumerWidget {
  final Function(int categoryId, String categoryName) onCategorySelected;

  const CategoryBrowserContent({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    if (categoriesAsync is AsyncLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoriesAsync is AsyncError) {
      return Center(
        child: Text(
          'ক্যাটাগরি লোড করতে ব্যর্থ হয়েছে',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final categories = categoriesAsync.value ?? [];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onCategorySelected(category.id, category.nameBangla),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category.iconIdentifier),
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                category.nameBangla,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? iconIdentifier) {
    switch (iconIdentifier) {
      case 'star':
        return Icons.star;
      case 'vegetables':
        return Icons.eco;
      case 'fruits':
        return Icons.shopping_basket;
      case 'dairy':
        return Icons.egg;
      case 'meat':
        return Icons.lunch_dining;
      case 'fish':
        return Icons.set_meal;
      case 'bakery':
        return Icons.bakery_dining;
      case 'grains':
        return Icons.grain;
      case 'spices':
        return Icons.local_fire_department;
      case 'beverages':
        return Icons.local_cafe;
      case 'snacks':
        return Icons.cookie;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'personal':
        return Icons.person;
      case 'baby':
        return Icons.child_care;
      case 'pet':
        return Icons.pets;
      case 'other':
        return Icons.category;
      default:
        return Icons.category;
    }
  }
}

class ItemPickerModalSheet extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ItemPickerModalSheet({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ItemPickerScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        );
      },
    );
  }
}
