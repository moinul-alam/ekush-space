// lib/features/shopping_list/widgets/no_list_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../l10n/jhuri_localizations.dart';

class NoListWidget extends StatelessWidget {
  final VoidCallback onCreateList;

  const NoListWidget({
    super.key,
    required this.onCreateList,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = JhuriLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Illustration placeholder
              Icon(
                Icons.shopping_basket_outlined,
                size: 80,
                color: colorScheme.primary.withValues(alpha: 0.4),
              ),

              SizedBox(height: 24.h),

              // 2. Title text
              Text(
                l10n.noListYetTitle,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              // 3. Subtitle text
              Text(
                l10n.noListYetSubtitle,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              // 4. ElevatedButton with leading + icon
              ElevatedButton.icon(
                onPressed: onCreateList,
                icon: const Icon(Icons.add),
                label: Text(l10n.createList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // 5. How-to section title
              Text(
                l10n.howToUseTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),

              // 6. Three bullet points
              Column(
                children: [
                  _buildBulletPoint(
                    context,
                    text: l10n.howToStep1,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: 8.h),
                  _buildBulletPoint(
                    context,
                    text: l10n.howToStep2,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: 8.h),
                  _buildBulletPoint(
                    context,
                    text: l10n.howToStep3,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(
    BuildContext context, {
    required String text,
    required ColorScheme colorScheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
