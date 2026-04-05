import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_providers.dart';

class JhuriAppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final bool isHomeScreen;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const JhuriAppHeader({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.onLeadingPressed,
    this.isHomeScreen = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = isHomeScreen
        ? backgroundColor
        : (backgroundColor ?? colorScheme.primary);
    final effectiveForegroundColor =
        isHomeScreen ? foregroundColor : (foregroundColor ?? Colors.white);

    if (isHomeScreen) {
      // Watch locale provider for reactive language changes
      final localeAsync = ref.watch(localeProvider);

      return AppBar(
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(leadingIcon ?? Icons.menu),
            onPressed:
                onLeadingPressed ?? () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: localeAsync.when(
          data: (locale) => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 32.h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                locale.languageCode == 'bn'
                    ? 'assets/images/app_title_bn.png'
                    : 'assets/images/app_title_en.png',
                height: 28.h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ],
          ),
          loading: () => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 32.h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 120.w,
                height: 28.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: effectiveForegroundColor?.withValues(alpha: 0.1) ??
                        Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          error: (_, __) => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 32.h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              SizedBox(width: 8.w),
              Text(
                'ঝুড়ি',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'HindSiliguri',
                  color: effectiveForegroundColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: effectiveForegroundColor),
            onPressed: () => context.push('/settings'),
          ),
        ],
      );
    }

    return AppBar(
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(leadingIcon ?? Icons.arrow_back),
        onPressed: onLeadingPressed ?? () => context.pop(),
      ),
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'HindSiliguri',
                color: effectiveForegroundColor,
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
