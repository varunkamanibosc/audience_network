/// Facebook Audience Network plugin for Flutter applications.
///
/// This library uses native API of [Facebook Audience Network](https://developers.facebook.com/docs/audience-network)
/// to provide functionality for Flutter applications.
///
/// Currently only Android platform is supported.
library audience_network;

import 'package:flutter/services.dart';

import 'ad/ad_interstitial.dart';
import 'constants.dart';

export 'ad/ad_banner.dart';
export 'ad/ad_interstitial.dart';
export 'ad/ad_native.dart';
export 'ad/rewarded_ad.dart';

/// All non-widget functions such as initialization, loading interstitial,
/// in-stream and reward video ads are enclosed in this class.
///
/// Initialize the Facebook Audience Network by calling the static [init]
/// function.
class AudienceNetwork {
  static const _channel = const MethodChannel(MAIN_CHANNEL);

  /// Initializes the Facebook Audience Network. [testingId] can be used to
  /// obtain test Ads. [testMode] can be used to obtain test Ads as well,
  /// it is more useful on iOS where testingId keeps changing.
  ///
  /// [testingId] can be obtained by running the app once without the testingId.
  /// Check the log to obtain the [testingId] for your device.
  static Future<bool?> init({
    String? testingId,
    bool testMode = false,
    bool iOSAdvertiserTrackingEnabled = false,
  }) async {
    Map<String, dynamic> initValues = {
      "testingId": testingId,
      "iOSAdvertiserTrackingEnabled": iOSAdvertiserTrackingEnabled,
      "testMode": testMode,
    };

    try {
      final result = await _channel.invokeMethod(INIT_METHOD, initValues);
      return result;
    } on PlatformException {
      return false;
    }
  }

  /// Loads an Interstitial Ad in background. Replace the default [placementId]
  /// with the one which you obtain by signing-up for Facebook Audience Network.
  ///
  /// [listener] passes [InterstitialAdResult] and information associated with
  /// the result to the implemented callback.
  ///
  /// Information will generally be of type Map with details such as:
  ///
  /// ```dart
  /// {
  ///   'placement_id': "YOUR_PLACEMENT_ID",
  ///   'invalidated': false,
  ///   'error_code': 2,
  ///   'error_message': "No internet connection",
  /// }
  /// ```
  static Future<bool?> loadInterstitialAd({
    String placementId = "YOUR_PLACEMENT_ID",
    Function(InterstitialAdResult, dynamic)? listener,
  }) async {
    return await FacebookInterstitialAd.loadInterstitialAd(
      placementId: placementId,
      listener: listener,
    );
  }

  /// Shows an Interstitial Ad after it has been loaded. (This needs to be called
  /// only after calling [loadInterstitialAd] function). [delay] is in
  /// milliseconds.
  ///
  /// Example:
  ///
  /// ```dart
  /// AudienceNetwork.loadInterstitialAd(
  ///   listener: (result, value) {
  ///     if (result == InterstitialAdResult.LOADED)
  ///       AudienceNetwork.showInterstitialAd(delay: 5000);
  ///   },
  /// );
  /// ```
  static Future<bool?> showInterstitialAd({int? delay}) async {
    return await FacebookInterstitialAd.showInterstitialAd(delay: delay);
  }

  /// Removes the Ad.
  static Future<bool?> destroyInterstitialAd() async {
    return await FacebookInterstitialAd.destroyInterstitialAd();
  }
}
