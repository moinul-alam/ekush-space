// lib/features/onboarding/data/onboarding_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/jhuri_constants.dart';

/// Repository for onboarding-specific SharedPreferences operations
/// Wraps only the onboarding-specific keys: onboardingComplete and language
class OnboardingRepository {
  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  /// Save language preference
  Future<bool> setLanguage(String language) async {
    return await _prefs.setString(JhuriConstants.storageKeyLanguage, language);
  }

  /// Get language preference
  String getLanguage() {
    return _prefs.getString(JhuriConstants.storageKeyLanguage) ?? 
        JhuriConstants.defaultLanguage;
  }

  /// Mark onboarding as complete
  Future<bool> setOnboardingComplete(bool complete) async {
    return await _prefs.setBool(JhuriConstants.storageKeyOnboardingComplete, complete);
  }

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _prefs.getBool(JhuriConstants.storageKeyOnboardingComplete) ?? false;
  }

  /// Complete onboarding - saves language and marks as complete
  Future<bool> completeOnboarding(String language) async {
    final languageSaved = await setLanguage(language);
    final onboardingSaved = await setOnboardingComplete(true);
    return languageSaved && onboardingSaved;
  }
}
