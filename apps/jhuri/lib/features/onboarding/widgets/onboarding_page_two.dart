// lib/features/onboarding/widgets/onboarding_page_two.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/jhuri_constants.dart';
import '../onboarding_viewmodel.dart';

class OnboardingPageTwo extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const OnboardingPageTwo({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(24.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Title ──────────────────────────────
          Text(
            'ভাষা নির্বাচন',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontFamily: 'HindSiliguri',
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16.h),

          // ── Subtitle ───────────────────────────
          Text(
            'আপনার পছন্দের ভাষা নির্বাচন করুন',
            style: TextStyle(
              fontSize: 16.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 48.h),

          // ── Language Options ───────────────────
          ...JhuriConstants.languageDisplay.entries.map((entry) {
            final languageCode = entry.key;
            final displayText = entry.value;
            final isSelected = state.selectedLanguage == languageCode;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: InkWell(
                onTap: () {
                  ref
                      .read(onboardingProvider.notifier)
                      .selectLanguage(languageCode);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          isSelected ? colorScheme.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Radio button
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      SizedBox(width: 16.w),

                      // Language text
                      Expanded(
                        child: Text(
                          displayText,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // ── Navigation Buttons ─────────────────
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'পিছনে',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Next/Start button
              Expanded(
                child: ElevatedButton(
                  onPressed: state.isCompleting ? null : onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: state.isCompleting
                      ? SizedBox(
                      height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'শুরু করুন',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
