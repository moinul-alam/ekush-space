import 'package:flutter/material.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/utils/bangla_date_formatter.dart';

class SimpleListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;

  const SimpleListCard({
    super.key,
    required this.list,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDuplicate,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                list.title.isEmpty ? 'বাজারের ফর্দ' : list.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration:
                          list.isCompleted ? TextDecoration.lineThrough : null,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                BanglaDateFormatter.getRelativeDateLabel(list.buyDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
