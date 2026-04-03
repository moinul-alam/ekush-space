// lib/features/onboarding/onboarding_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/jhuri_constants.dart';

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

  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  /// Persists all choices and marks onboarding complete.
  /// Called when the user taps "Get Started" or completes onboarding.
  Future<bool> complete() async {
    state = state.copyWith(isCompleting: true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Save language preference
      await prefs.setString(
          JhuriConstants.storageKeyLanguage, state.selectedLanguage);

      // Mark onboarding done — splash will never show this again
      await prefs.setBool(JhuriConstants.storageKeyOnboardingComplete, true);

      state = state.copyWith(isCompleting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isCompleting: false);
      return false;
    }
  }

  /// Returns true if onboarding has already been completed.
  static Future<bool> isOnboardingDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(JhuriConstants.storageKeyOnboardingComplete) ??
          false;
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
