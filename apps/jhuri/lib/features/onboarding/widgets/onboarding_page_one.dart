// lib/features/onboarding/widgets/onboarding_page_one.dart

import 'package:flutter/material.dart';
import '../../../config/jhuri_constants.dart';

class OnboardingPageOne extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPageOne({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Logo ──────────────────────────────
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
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

          const SizedBox(height: 40),

          // ── App Name ───────────────────────────
          Text(
            JhuriConstants.appName,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'HindSiliguri',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // ── Tagline ─────────────────────────────
          Text(
            'বাজারের ফর্দ, হাতের মুঠোয়',
            style: TextStyle(
              fontSize: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // ── Description ─────────────────────────
          Text(
            'স্মার্ট গ্রোসারি লিস্ট\nপ্ল্যান বেটার, শপ ইজিয়ার',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // ── Start Button ───────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'শুরু করুন',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
