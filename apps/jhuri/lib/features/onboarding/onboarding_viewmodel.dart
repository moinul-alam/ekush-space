// lib/features/onboarding/onboarding_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/onboarding_repository.dart';
import 'data/onboarding_repository_provider.dart';

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
  late final OnboardingRepository _repository;

  @override
  OnboardingState build() {
    _repository = ref.read(onboardingRepositoryProvider);
    return const OnboardingState();
  }

  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  /// Persists all choices and marks onboarding complete.
  /// Called when the user taps "Get Started" or completes onboarding.
  Future<bool> complete() async {
    state = state.copyWith(isCompleting: true);

    try {
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
