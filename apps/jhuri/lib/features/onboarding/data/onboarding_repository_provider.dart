// lib/features/onboarding/data/onboarding_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/settings_providers.dart';
import 'onboarding_repository.dart';

/// Provider for OnboardingRepository
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return OnboardingRepository(prefs);
});
