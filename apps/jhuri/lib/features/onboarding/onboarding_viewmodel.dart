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
    try {
      state = state.copyWith(isCompleting: true);

      final appSettingsRepository = ref.read(appSettingsRepositoryProvider);
      final seedService = ref.read(seedServiceProvider);

      // 1. Mark as complete in database
      await appSettingsRepository.setOnboardingComplete();
      
      // 2. Ensure seed data is present
      await seedService.seedIfNeeded();

      state = state.copyWith(isCompleting: false);

      // The router will automatically refresh and redirect to / 
      // because we're now watching appSettingsProvider as a Stream.
      // But we still call go('/') to be explicit.
      if (context.mounted) {
        context.go('/');
      }
    } catch (e, st) {
      debugPrint('🔥 Error completing onboarding: $e');
      debugPrintStack(stackTrace: st);
      state = state.copyWith(isCompleting: false);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('অ্যাপ শুরু করতে সমস্যা হয়েছে: $e')),
        );
      }
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
