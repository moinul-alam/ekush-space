// lib/features/onboarding/widgets/onboarding_page_one.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_viewmodel.dart';

class OnboardingPageOne extends ConsumerWidget {
  final bool isBn;
  final OnboardingState state;
  final VoidCallback onNext;

  const OnboardingPageOne({
    super.key,
    required this.isBn,
    required this.state,
    required this.onNext,
  });

  static const double _logoSize = 120;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // ── App Icon ───────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: _logoSize,
                          height: _logoSize,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: _logoSize,
                            height: _logoSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D6A4F).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.shopping_basket_rounded,
                              size: 60,
                              color: const Color(0xFF2D6A4F),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── App Name ───────────────────────────
                      Text(
                        'ঝুড়ি',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D6A4F),
                          fontSize: 48,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // ── Tagline ─────────────────────────────
                      Text(
                        'বাজারের ঝুড়ি, হাতের মুঠোয়',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // ── Feature highlights ─────────────────────
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: 'স্মার্ট কেনাকাটার তালিকা',
                        color: const Color(0xFF2D6A4F),
                      ),
                      const SizedBox(height: 12),
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: 'ক্যাটাগরি ভিত্তিক আইটেম',
                        color: const Color(0xFFE9A23B),
                      ),
                      const SizedBox(height: 12),
                      _FeatureItem(
                        icon: Icons.check_circle_rounded,
                        text: 'বাজেট ট্র্যাকিং',
                        color: const Color(0xFF2D6A4F),
                      ),

                      const SizedBox(height: 32),

                      // ── Language label ─────────────────────
                      Text(
                        'আপনার ভাষা নির্বাচন করুন',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Language cards ─────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _LanguageCard(
                              label: 'বাংলা',
                              sublabel: 'Bangla',
                              flag: '🇧🇩',
                              isSelected: state.selectedLanguage == 'bangla',
                              onTap: () => notifier.selectLanguage('bangla'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _LanguageCard(
                              label: 'English',
                              sublabel: 'ইংরেজি',
                              flag: '🇺🇸',
                              isSelected: state.selectedLanguage == 'english',
                              onTap: () => notifier.selectLanguage('english'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A4F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'পরবর্তী',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Feature Item ─────────────────────────────────────────────

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Language Card ─────────────────────────────────────────────

class _LanguageCard extends StatelessWidget {
  final String label;
  final String sublabel;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.label,
    required this.sublabel,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2D6A4F).withValues(alpha: 0.1)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2D6A4F)
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(flag, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF2D6A4F)
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? const Color(0xFF2D6A4F).withValues(alpha: 0.7)
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
