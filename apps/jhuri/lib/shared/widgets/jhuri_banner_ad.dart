import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class JhuriBannerAd extends ConsumerWidget {
  const JhuriBannerAd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerLoaded = ref.watch(bannerLoadedProvider);
    final adService = ref.read(adServiceProvider);

    if (bannerLoaded && adService.bannerAd != null) {
      final banner = adService.bannerAd!;
      return SizedBox(
        width: double.infinity,
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      );
    }

    // Return empty container if ad fails to load - no blank space
    return const SizedBox.shrink();
  }
}

/// Banner ad wrapper that reserves space even when ad is not loaded
/// Use this when you need to maintain layout consistency
class JhuriBannerAdWithPlaceholder extends ConsumerWidget {
  const JhuriBannerAdWithPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerLoaded = ref.watch(bannerLoadedProvider);
    final adService = ref.read(adServiceProvider);

    if (bannerLoaded && adService.bannerAd != null) {
      final banner = adService.bannerAd!;
      return SizedBox(
        width: double.infinity,
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      );
    }

    // Placeholder - reserves 50dp so layout never jumps
    return Container(
      height: 50,
      width: double.infinity,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.4),
    );
  }
}
