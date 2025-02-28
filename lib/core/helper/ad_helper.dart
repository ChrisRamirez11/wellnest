import 'dart:io';

import 'package:wellnest/core/consts/ads_consts.dart';

class AdHelper {
  static String get bannerAdUnitId {
    return Platform.isAndroid ? AdsConsts.bannerAd : AdsConsts.iosBannerAd;
  }

  static String get openAppAdUnitId {
    return Platform.isAndroid ? AdsConsts.appOpenAd : AdsConsts.iosAppOpenAd;
  }
}
