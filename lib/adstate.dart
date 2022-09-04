

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';


class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId =>
      //Platform.isAndroid ? "ca-app-pub-6645065920201981/9424925658" : "ca-app-pub-3940256099942544/2934735716";
       Platform.isAndroid ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-3940256099942544/6300978111";//TEST

//test
  //test	ca-app-pub-3940256099942544/2934735716

  AdListener get adListener => _adListener;
  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) => print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name, data) => print('App event: ${ad.adUnitId}, $name, $data'),
    onApplicationExit: (ad) => print('App Exit: ${ad.adUnitId}.'),
    onNativeAdClicked: (nativeAd) => print('Native ad clicked: ${nativeAd.adUnitId}'),
    onNativeAdImpression: (nativeAd) => print('Native ad impression: ${nativeAd.adUnitId}'),
    onRewardedAdUserEarnedReward: (ad, reward) =>
        print('User rewarded: ${ad.adUnitId}, ${reward.amount} ${reward.type}.'),
  );
}
