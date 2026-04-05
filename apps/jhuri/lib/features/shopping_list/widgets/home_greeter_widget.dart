// lib/features/shopping_list/widgets/home_greeter_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/jhuri_localizations.dart';

class HomeGreeterWidget extends ConsumerWidget {
  const HomeGreeterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = JhuriLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Get current hour for greeting logic
    final hour = DateTime.now().hour;
    String greeting;
    if (hour >= 0 && hour <= 11) {
      greeting = l10n.goodMorning;
    } else if (hour >= 12 && hour <= 16) {
      greeting = l10n.goodAfternoon;
    } else if (hour >= 17 && hour <= 20) {
      greeting = l10n.goodEvening;
    } else {
      greeting = l10n.goodNight;
    }

    // Format today's date in Bangla
    final now = DateTime.now();
    final weekdayName = l10n.getDayName(now.weekday);
    final monthName = l10n.getMonthName(now.month);
    final banglaDate = '$weekdayName, ${now.day} $monthName ${now.year}';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Optional: Add navigation or action when tapped
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Left side: Greeting and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        banglaDate,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right side: App logo
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 40.h,
                  width: 40.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.shopping_basket,
                    size: 40.h,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
