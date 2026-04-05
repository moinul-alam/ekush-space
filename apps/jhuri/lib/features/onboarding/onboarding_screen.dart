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
  bool _phase1Complete = false;
  bool _contentVisible = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Start phase 2 after 2000ms delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _phase1Complete = true;
        });
        _animationController.forward();
      }
    });

    // Show content after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _contentVisible = true;
        });
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

  Widget _buildLanguageOption(
      String languageCode, String displayText, String flag) {
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
                  color:
                      isSelected ? colorScheme.primary : colorScheme.onSurface,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine which title image to show based on locale
    final titleImagePath = locale.value?.languageCode == 'en'
        ? 'assets/images/app_title_en.png'
        : 'assets/images/app_title_bn.png';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Phase 1: Centered logo and title
            if (!_phase1Complete)
              Positioned.fill(
                  child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset('assets/images/app_logo.png', height: 100.h),
                SizedBox(height: 12.h),
                Image.asset(titleImagePath, height: 36.h),
              ]))),

            // Phase 2: Animated positioned elements
            if (_phase1Complete) ...[
              // Logo
              AnimatedPositioned(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  top: _phase1Complete ? 16.h : (screenHeight / 2 - 62.h),
                  left: _phase1Complete ? 20.w : (screenWidth / 2 - 50.w),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    height: _phase1Complete ? 40.h : 100.h,
                    width: _phase1Complete ? 40.w : 100.w,
                  )),

              // Title image
              AnimatedPositioned(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  top: _phase1Complete ? 24.h : (screenHeight / 2 + 62.h),
                  left: _phase1Complete ? 68.w : (screenWidth / 2 - 80.w),
                  child: AnimatedOpacity(
                      duration: Duration(milliseconds: 600),
                      opacity: _phase1Complete ? 1.0 : 0.0,
                      child: Image.asset(titleImagePath,
                          height: _phase1Complete ? 28.h : 36.h))),
            ],

            // Content section (fades in after animation)
            Positioned(
              top: 88.h,
              left: 24.w,
              right: 24.w,
              bottom: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: _contentVisible ? 1.0 : 0.0,
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
                        onPressed:
                            state.isCompleting ? null : _completeOnboarding,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
    );
  }
}
