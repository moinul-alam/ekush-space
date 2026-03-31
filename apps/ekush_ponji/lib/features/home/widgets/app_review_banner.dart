// lib/features/home/widgets/app_review_banner.dart
//
// Soft fallback "Rate us" banner shown at the bottom of the home scroll
// when the native in-app review dialog was suppressed by Google Play.
// Unobtrusive, dismissible, bilingual.

import 'package:flutter/material.dart';
import 'package:ekush_core/ekush_core.dart';

class AppReviewBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const AppReviewBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final isBn = l10n.languageCode == 'bn';

    return Container(
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // ── Star icon ───────────────────────────────
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              color: cs.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // ── Text ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBn ? 'অ্যাপটি ব্যবহার করে উপকৃত হলে রেটিং দিয়ে উৎসাহিত করুন' : 'If you enjoy using Ekush Ponji, please consider leaving us a rating!',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Rate button ─────────────────────────────
          TextButton(
            onPressed: () async {
              await AppReviewService.openStoreListing();
              onDismiss();
            },
            style: TextButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              isBn ? 'রেটিং দিন' : 'Rate',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onPrimary,
              ),
            ),
          ),

          const SizedBox(width: 4),

          // ── Dismiss ─────────────────────────────────
          IconButton(
            onPressed: () async {
              await AppReviewService.dismissFallbackBanner();
              onDismiss();
            },
            icon: Icon(
              Icons.close_rounded,
              size: 18,
              color: cs.onPrimaryContainer.withValues(alpha: 0.6),
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: l10n.close,
          ),
        ],
      ),
    );
  }
}


