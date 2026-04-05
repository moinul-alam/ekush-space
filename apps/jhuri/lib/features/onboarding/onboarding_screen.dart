// lib/features/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'onboarding_viewmodel.dart';
import '../../providers/settings_providers.dart';
import '../../l10n/jhuri_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo animation: slide from center to top-left and scale down
    _logoSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.35, -0.35),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.33, // 120.h -> 40.h is approximately 1/3
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Title fade animation
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Content fade animation (starts after logo animation)
    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    // Start animation after 800ms delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final success = await ref.read(onboardingProvider.notifier).complete();
    if (success && mounted) {
      context.go('/home');
    }
  }

  Widget _buildLanguageOption(String languageCode, String displayText, String flag) {
    final state = ref.watch(onboardingProvider);
    final isSelected = state.selectedLanguage == languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(onboardingProvider.notifier).selectLanguage(languageCode);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flag,
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(ThemeMode mode, String text) {
    final state = ref.watch(onboardingProvider);
    final isSelected = state.selectedTheme == mode;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(onboardingProvider.notifier).selectTheme(mode);
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final locale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = JhuriLocalizations.of(context);

    // Determine which title image to show based on locale
    final titleImagePath = locale.value?.languageCode == 'en' 
        ? 'assets/images/app_title_en.png' 
        : 'assets/images/app_title_bn.png';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // ── Header with animated logo and title ──────────────────────
              SizedBox(
                height: 100.h,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Logo
                        Positioned(
                          left: _logoSlideAnimation.value.dx * MediaQuery.of(context).size.width / 2,
                          top: _logoSlideAnimation.value.dy * 100.h + 20.h,
                          child: Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Container(
                              width: 40.h,
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  width: 40.h,
                                  height: 40.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Title image
                        Positioned(
                          left: 80.w,
                          top: 30.h,
                          child: FadeTransition(
                            opacity: _titleFadeAnimation,
                            child: Image.asset(
                              titleImagePath,
                              height: 28.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  l10n.appName,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    fontFamily: 'HindSiliguri',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // ── Content (fades in after animation) ───────────────────────
              Expanded(
                child: FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Welcome text
                      Text(
                        l10n.onboardingWelcomeTitle,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                          fontFamily: 'HindSiliguri',
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 12.h),

                      // Subtitle text
                      Text(
                        l10n.onboardingWelcomeSubtitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 48.h),

                      // Language selection
                      Text(
                        l10n.onboardingLanguageTitle,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          _buildLanguageOption('bangla', 'বাংলা', '🇧🇩'),
                          SizedBox(width: 12.w),
                          _buildLanguageOption('english', 'English', '🇬🇧'),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // Theme selection
                      Text(
                        l10n.onboardingThemeTitle,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        children: [
                          _buildThemeOption(ThemeMode.system, l10n.themeSystem),
                          SizedBox(width: 8.w),
                          _buildThemeOption(ThemeMode.light, l10n.themeLight),
                          SizedBox(width: 8.w),
                          _buildThemeOption(ThemeMode.dark, l10n.themeDark),
                        ],
                      ),

                      const Spacer(),

                      // Start button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isCompleting ? null : _completeOnboarding,
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
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  l10n.onboardingGetStarted,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
