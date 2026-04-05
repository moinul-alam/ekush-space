// lib/features/onboarding/widgets/onboarding_page_one.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/jhuri_constants.dart';
import '../../../l10n/jhuri_localizations.dart';

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
      padding: EdgeInsets.all(24.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Logo ──────────────────────────────
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // ── App Name ───────────────────────────
          Text(
            JhuriConstants.appName,
            style: TextStyle(
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'HindSiliguri',
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          // ── Tagline ─────────────────────────────
          Text(
            JhuriLocalizations.of(context).onboardingTagline,
            style: TextStyle(
              fontSize: 20.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16.h),

          // ── Description ─────────────────────────
          Text(
            JhuriLocalizations.of(context).appDescription,
            style: TextStyle(
              fontSize: 16.sp,
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
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Text(
                JhuriLocalizations.of(context).onboardingGetStarted,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
