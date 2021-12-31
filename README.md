# audience_network
![Pub](https://img.shields.io/pub/v/audience_network.svg) ![GitHub](https://img.shields.io/github/license/dreamsoftin/facebook_audience_network.svg)

Forked from https://pub.dev/packages/facebook_audience_network
- Added support for multiple Interstitial and Rewarded Ads
- Added support for Rewarded Ads on iOS

---

[Facebook Audience Network](https://developers.facebook.com/docs/audience-network) plugin for Flutter applications (Android & iOS).

| Banner Ad | Native Banner Ad | Native Ad |
| - | - | - |
| ![Banner Ad](https://raw.githubusercontent.com/dreamsoftin/facebook_audience_network/master/example/gifs/banner.gif "Banner Ad") | ![Native Banner Ad](https://raw.githubusercontent.com/dreamsoftin/facebook_audience_network/master/example/gifs/native_banner.gif "Native Banner Ad") | ![Native Ad](https://raw.githubusercontent.com/dreamsoftin/facebook_audience_network/master/example/gifs/native.gif "Native Ad") |

| Interstitial Ad | Rewarded Video Ad |
| - | - |
| ![Interstitial Ad](https://raw.githubusercontent.com/dreamsoftin/facebook_audience_network/master/example/gifs/interstitial.gif "Interstitial Ad") | ![Rewarded Ad](https://raw.githubusercontent.com/dreamsoftin/facebook_audience_network/master/example/gifs/rewarded.gif "Rewarded Video Ad") |

---
## Getting Started

### 1. Initialization:

For testing purposes you need to obtain the hashed ID of your testing device. To obtain the hashed ID: 

1. Call `AudienceNetwork.init()` during app initialization.
2. Place the `BannerAd` widget in your app.
3. Run the app.

The hased id will be in printed to the logcat. Paste that onto the `testingId` parameter.

```dart
AudienceNetwork.init(
  testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
  testMode: true, // optional
  iOSAdvertiserTrackingEnabled: true, //default false
);
```
##### IOS Setup
In Pod file, set the IOS deployment target version to 9.0

---
### 2. Show Banner Ad:

```dart
Container(
  alignment: Alignment(0.5, 1),
  child: BannerAd(
    placementId: Platform.isAndroid
        ? "YOUR_ANDROID_PLACEMENT_ID"
        : "YOUR_IOS_PLACEMENT_ID",
    bannerSize: BannerSize.STANDARD,
    listener: BannerAdListener(
      onError: (code, message) => print('error'),
      onLoaded: () => print('loaded'),
      onClicked: () => print('clicked'),
      onLoggingImpression: () => print('logging impression'),
    ),
  ),
)
```
---
### 3. Show Interstitial Ad:

```dart
final interstitialAd = InterstitialAd(InterstitialAd.testPlacementId);
interstitialAd.listener = InterstitialAdListener(
  onLoaded: () {
    interstitialAd.show();
  },
  onDismissed: () {
    interstitialAd.destroy();
    print('Interstitial dismissed');
  },
);
interstitialAd.load();
```
---
### 4. Show Rewarded Video Ad:

```dart
final rewardedAd = RewardedAd(
  RewardedAd.testPlacementId,
  userId: 'some_user_id', // optional for server side verification
);
rewardedAd.listener = RewardedAdListener(
  onLoaded: () {
    rewardedAd.show();
  },
  onVideoComplete: () {
    rewardedAd.destroy();
    print('Video completed');
  },
);
rewardedAd.load();
```
---
### 5. Show Native Ad:
- NativeAdType NATIVE_AD_HORIZONTAL & NATIVE_AD_VERTICAL ad types are supported only in iOS. In Android use NATIVE_AD.
```dart
NativeAd(
  placementId: NativeAd.testPlacementId,
  adType: NativeAdType.NATIVE_AD,
  width: double.infinity,
  height: 300,
  backgroundColor: Colors.blue,
  titleColor: Colors.white,
  descriptionColor: Colors.white,
  buttonColor: Colors.deepPurple,
  buttonTitleColor: Colors.white,
  buttonBorderColor: Colors.white,
  //set true if you do not want adview to refresh on widget rebuild
  keepAlive: true,
  // set false if you want to collapse the native ad view when the ad is loading
  keepExpandedWhileLoading: false, 
  //in milliseconds. Expands the adview with animation when ad is loaded
  expandAnimationDuraion: 300, 
  listener: NativeAdListener(
    onError: (code, message) => print('error'),
    onLoaded: () => print('loaded'),
    onClicked: () => print('clicked'),
    onLoggingImpression: () => print('logging impression'),
    onMediaDownloaded: () => print('media downloaded'),
  ),
)
```
---
### 6. Show Native Banner Ad:
Use `NativeBannerAdSize` to choose the height for Native banner ads. `height` property is ignored for native banner ads.

```dart
NativeAd(
  placementId: NativeAd.testPlacementId,
  adType: NativeAdType.NATIVE_BANNER_AD,
  bannerAdSize: NativeBannerAdSize.HEIGHT_100,
  width: double.infinity,
  backgroundColor: Colors.blue,
  titleColor: Colors.white,
  descriptionColor: Colors.white,
  buttonColor: Colors.deepPurple,
  buttonTitleColor: Colors.white,
  buttonBorderColor: Colors.white,
  listener: NativeAdListener(
    onError: (code, message) => print('error'),
    onLoaded: () => print('loaded'),
    onClicked: () => print('clicked'),
    onLoggingImpression: () => print('logging impression'),
    onMediaDownloaded: () => print('media downloaded'),
  ),
)
```
---
**Check out the [example](https://github.com/lslv1243/facebook_audience_network/tree/master/example) for complete implementation.**

iOS wrapper code contribution by **lolqplay team from birdgang**

### Note: Instream video ad has been removed by Facebook. Read more [here](https://www.facebook.com/business/help/645132129564436?id=211412110064838)


