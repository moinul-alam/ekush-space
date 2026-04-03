// lib/features/onboarding/widgets/onboarding_page_three.dart

import 'package:flutter/material.dart';
import '../../../config/jhuri_constants.dart';

class OnboardingPageThree extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onComplete;
  final bool isCompleting;

  const OnboardingPageThree({
    super.key,
    required this.onBack,
    required this.onComplete,
    required this.isCompleting,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Icon ──────────────────────────────
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 60,
              color: colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // ── Title ──────────────────────────────
          Text(
            'বিজ্ঞপ্তি',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'HindSiliguri',
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // ── Message ───────────────────────────
          Text(
            'বাজারের জন্য রিমাইন্ডার পেতে বিজ্ঞপ্তি অনুমতি দিন',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // ── Permission Benefits ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildBenefitItem(
                  context,
                  icon: Icons.alarm,
                  title: 'সময়মতো রিমাইন্ডার',
                  description: 'বাজারের সময় হলে বিজ্ঞপ্তি পান',
                ),
                const SizedBox(height: 12),
                _buildBenefitItem(
                  context,
                  icon: Icons.check_circle_outline,
                  title: 'ভুলে যাবেন না',
                  description: 'কখনো বাজার ভুলে যাবেন না',
                ),
                const SizedBox(height: 12),
                _buildBenefitItem(
                  context,
                  icon: Icons.smartphone,
                  title: 'সহজ ব্যবস্থাপনা',
                  description: 'সব তালিকা একসাথে দেখুন',
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // ── Navigation Buttons ─────────────────
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'এখন না',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Allow button
              Expanded(
                child: ElevatedButton(
                  onPressed: isCompleting ? null : onComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isCompleting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'অনুমতি দিন',
                          style: TextStyle(
                            fontSize: 16,
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

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
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
