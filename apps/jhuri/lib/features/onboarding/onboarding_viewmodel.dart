// lib/features/onboarding/onboarding_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/onboarding_repository.dart';
import 'data/onboarding_repository_provider.dart';
import '../../providers/settings_providers.dart';

// ── State ────────────────────────────────────────────────────

class OnboardingState {
  final String selectedLanguage; // 'bangla' | 'english'
  final ThemeMode selectedTheme;
  final bool isCompleting;

  const OnboardingState({
    this.selectedLanguage = 'bangla',
    this.selectedTheme = ThemeMode.system,
    this.isCompleting = false,
  });

  OnboardingState copyWith({
    String? selectedLanguage,
    ThemeMode? selectedTheme,
    bool? isCompleting,
  }) {
    return OnboardingState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      isCompleting: isCompleting ?? this.isCompleting,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────

class OnboardingNotifier extends Notifier<OnboardingState> {
  late final OnboardingRepository _repository;

  @override
  OnboardingState build() {
    _repository = ref.read(onboardingRepositoryProvider);
    return const OnboardingState();
  }

  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void selectTheme(ThemeMode mode) {
    state = state.copyWith(selectedTheme: mode);
    // Update theme immediately for live preview
    ref.read(themeModeProvider.notifier).setThemeMode(mode);
  }

  /// Persists all choices and marks onboarding complete.
  /// Called when the user taps "Get Started" or completes onboarding.
  Future<bool> complete() async {
    state = state.copyWith(isCompleting: true);

    try {
      // Persist selected theme first
      await ref
          .read(themeModeProvider.notifier)
          .setThemeMode(state.selectedTheme);

      // Then complete onboarding with language
      final success =
          await _repository.completeOnboarding(state.selectedLanguage);
      state = state.copyWith(isCompleting: false);
      return success;
    } catch (e) {
      state = state.copyWith(isCompleting: false);
      return false;
    }
  }

  /// Returns true if onboarding has already been completed.
  static Future<bool> isOnboardingDone(OnboardingRepository repository) async {
    try {
      return repository.isOnboardingComplete();
    } catch (_) {
      return false;
    }
  }
}

// ── Provider ─────────────────────────────────────────────────

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
