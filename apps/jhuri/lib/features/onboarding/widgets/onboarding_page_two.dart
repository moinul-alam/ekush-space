// lib/features/onboarding/widgets/onboarding_page_two.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../onboarding_viewmodel.dart';

class OnboardingPageTwo extends ConsumerStatefulWidget {
  final bool isBn;
  final OnboardingState state;
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const OnboardingPageTwo({
    super.key,
    required this.isBn,
    required this.state,
    required this.onBack,
    required this.onComplete,
  });

  @override
  ConsumerState<OnboardingPageTwo> createState() => _OnboardingPageTwoState();
}

class _OnboardingPageTwoState extends ConsumerState<OnboardingPageTwo> {
  bool _notifEnabled = false;
  bool _notifRequested = false;

  // ── Notification handler ───────────────────────────────────

  Future<void> _handleEnableNotification() async {
    if (_notifRequested) return;
    setState(() => _notifRequested = true);

    final notifier = ref.read(onboardingProvider.notifier);
    final granted = await notifier.requestNotificationPermission();

    if (granted) {
      setState(() => _notifEnabled = true);
    } else {
      setState(() {
        _notifEnabled = false;
        _notifRequested = false;
      });
    }
  }

  // ── Get Started handler ────────────────────────────────────

  Future<void> _handleGetStarted() async {
    final notifier = ref.read(onboardingProvider.notifier);
    await notifier.complete(ref, context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleting = ref.watch(onboardingProvider).isCompleting;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // ── Icon ───────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE9A23B).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 64,
              color: const Color(0xFFE9A23B),
            ),
          ),

          const SizedBox(height: 20),

          // ── Title ──────────────────────────────────
          Text(
            'বিজ্ঞপ্তি চালু করুন',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // ── Subtitle ───────────────────────────
          Text(
            'বাজারের সময় মনে করিয়ে দিতে অনুমতি দিন',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          // ── Notification card ──────────────────────
          _TransparencyCard(
            icon: Icons.notifications_outlined,
            iconColor: const Color(0xFFE9A23B),
            iconBg: const Color(0xFFE9A23B).withValues(alpha: 0.1),
            title: 'নোটিফিকেশন',
            body: Text(
              'কেনাকাটার তালিকা রিমাইন্ডার, অফার ও ছাড়ের আপডেট, আর বাজার দরের তথ্য পেতে নোটিফিকেশন চালু রাখুন।',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
                fontSize: 15,
              ),
            ),
            action: _notifEnabled
                ? _EnabledBadge()
                : _EnableButton(
                    onTap: _handleEnableNotification,
                  ),
          ),

          const Spacer(),

          // ── Back + Get Started ─────────────────────
          Row(
            children: [
              OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  'পিছনে',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D6A4F),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: isCompleting ? null : _handleGetStarted,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6A4F),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isCompleting
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'শুরু করুন',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Transparency Card ─────────────────────────────────────────

class _TransparencyCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final Widget body;
  final Widget? action;

  const _TransparencyCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Body Text Styling ──────────────────────
          DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
              fontSize: 15,
            ),
            child: body,
          ),

          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

// ── Components ────────────────────────────────────────────────

class _EnableButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EnableButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFE9A23B).withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_outlined,
                size: 20, color: const Color(0xFFE9A23B)),
            const SizedBox(width: 8),
            Text(
              'নোটিফিকেশন চালু করুন',
              style: TextStyle(
                color: const Color(0xFFE9A23B),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnabledBadge extends StatelessWidget {
  const _EnabledBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, color: const Color(0xFF2D6A4F), size: 20),
        const SizedBox(width: 8),
        Text(
          'নোটিফিকেশন চালু আছে',
          style: TextStyle(
            color: const Color(0xFF2D6A4F),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
