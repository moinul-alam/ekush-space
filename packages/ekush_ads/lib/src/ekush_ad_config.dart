class EkushAdConfig {
  const EkushAdConfig({
    required this.bannerAdUnitId,
    required this.interstitialAdUnitId,
    required this.nativeAdUnitId,
    this.enableBannerAds = true,
    this.enableInterstitialAds = true,
    this.enableNativeAds = true,
    this.nativeRetryOnNoFill = true,
    this.nativeNoFillMaxRetries = 4,
    this.nativeNoFillRetrySeconds = 45,
    this.nativeCardBaseHeightAndroid = 236.0,
    this.nativeSectionBaseHeightAndroid = 228.0,
    this.nativeMinHeightAndroid = 212.0,
    this.nativeMaxHeightAndroid = 236.0,
    this.nativeCompactReductionAndroid = 8.0,
    this.nativeVeryCompactReductionAndroid = 16.0,
    this.nativeCompactHeightThreshold = 700.0,
    this.nativeCompactShortestSideThreshold = 360.0,
    this.nativeVeryCompactHeightThreshold = 620.0,
    this.nativeVeryCompactShortestSideThreshold = 330.0,
    this.nativeCardHeightDefault = 132.0,
    this.nativeSectionHeightDefault = 120.0,
  });

  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String nativeAdUnitId;
  final bool enableBannerAds;
  final bool enableInterstitialAds;
  final bool enableNativeAds;
  final bool nativeRetryOnNoFill;
  final int nativeNoFillMaxRetries;
  final int nativeNoFillRetrySeconds;
  final double nativeCardBaseHeightAndroid;
  final double nativeSectionBaseHeightAndroid;
  final double nativeMinHeightAndroid;
  final double nativeMaxHeightAndroid;
  final double nativeCompactReductionAndroid;
  final double nativeVeryCompactReductionAndroid;
  final double nativeCompactHeightThreshold;
  final double nativeCompactShortestSideThreshold;
  final double nativeVeryCompactHeightThreshold;
  final double nativeVeryCompactShortestSideThreshold;
  final double nativeCardHeightDefault;
  final double nativeSectionHeightDefault;
}
