import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A wrapper around AdService that completely disables interstitial ads
/// This prevents any interstitial ads from loading or showing
class BannerOnlyAdService implements AdService {
  final AdService _originalService;

  BannerOnlyAdService(Ref ref, EkushAdConfig config)
      : _originalService = AdService(ref, config) {
    debugPrint('🚫 BannerOnlyAdService: Interstitial ads completely disabled');
  }

  // Banner functionality - delegate to original service
  @override
  BannerAd? get bannerAd => _originalService.bannerAd;

  // Interstitial functionality - completely disabled
  @override
  void showInterstitialIfAvailable({VoidCallback? onClosed}) {
    debugPrint('🚫 BannerOnlyAdService: Interstitial ad blocked');
    onClosed?.call(); // Immediately call the callback to prevent hanging
  }

  @override
  void dispose() {
    _originalService.dispose();
  }
}
