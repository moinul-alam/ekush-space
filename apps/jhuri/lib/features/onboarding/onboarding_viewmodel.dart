// lib/features/onboarding/onboarding_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_notifications/ekush_notifications.dart';
import '../../core/providers/jhuri_providers.dart';

// ── State ────────────────────────────────────────────────────

class OnboardingState {
  final String selectedLanguage; // 'bangla' | 'english'
  final bool isCompleting;

  const OnboardingState({
    this.selectedLanguage = 'bangla',
    this.isCompleting = false,
  });

  OnboardingState copyWith({
    String? selectedLanguage,
    bool? isCompleting,
  }) {
    return OnboardingState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void selectLanguage(String code) {
    state = state.copyWith(selectedLanguage: code);
  }

  /// Persists all choices and marks onboarding complete.
  /// Called when the user taps "Get Started".
  Future<void> complete(WidgetRef ref, BuildContext context) async {
    state = state.copyWith(isCompleting: true);

    final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    final seedService = ref.read(seedServiceProvider);

    await appSettingsRepository.setOnboardingComplete();
    await seedService.seedIfNeeded();

    state = state.copyWith(isCompleting: false);

    if (context.mounted) {
      context.go('/');
    }
  }

  /// Request notification permission (optional for onboarding completion)
  Future<bool> requestNotificationPermission() async {
    try {
      await NotificationPermissionService.ensurePermission();
      return true;
    } catch (e) {
      // Handle permission request error gracefully
      return false;
    }
  }
}

// ── Provider ─────────────────────────────────────────────────

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
