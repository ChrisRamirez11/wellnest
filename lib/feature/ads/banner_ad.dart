import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:wellnest/core/helper/ad_helper.dart';
import 'package:wellnest/core/utils/is_premium_user_provider.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  final Color? cardColor;

  const BannerAdWidget({
    super.key,
    this.cardColor,
  });

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumUser).isPremium ?? true;

    return (_isAdLoaded && !isPremium)
        ? Card(
          color: widget.cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(10),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: _bannerAd!.size.height.toDouble(), maxHeight: 110),
              child: Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: AdWidget(ad: _bannerAd!)),
            ),
          )
        : SizedBox(
            height: 20,
          );
  }
}
