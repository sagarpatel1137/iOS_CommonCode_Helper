# iOS : CommonCode-Helper

# Requirements
`iOS_CommonCode_Helper` works on iOS 13.0+.

# Adding iOS_CommonCode_Helper to your project

## Cocoapods
CocoaPods is the recommended way to add iOS_CommonCode_Helper to your project.

1. Add a pod entry for iOS_CommonCode_Helper to your Podfile `pod 'iOS_CommonCode_Helper'`
2. Install the pod(s) by running `pod install`.
3. Include iOS_CommonCode_Helper wherever you need it with `import iOS_CommonCode_Helper`.

## Swift Packages



# Usage
## GDPR Consent
1. Add into `AppDelegate.swift` file
```groovy
GoogleMobileAdsConsent_Manager.funGDPRConsent { consentError in
    <#code#>
}
```

## ATTracking Request
1. Add into `Info.plist`
```groovy
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
2. Add Below Code in `AppDelegate.swift` file, after `GDPRConsent Completion` Called
```groovy
ATTracking_Manager.funRequestTracking {
    <#code#>
}
```

## Force Update
1. Implementation
```groovy
ForceUpdate_Manager.configure(withAppID: YOUR_APP_ID)
```
2. If you want to custom text implement below method
```groovy
ForceUpdate_Manager.configureForceUpdateAlert(title: "Update Required".localized(),
                                                      message: "We've noticed that you've been using the deprecated application version for a long time. Please update to the latest version and enjoy the app.".localized(),
                                                      actionBtn: "Update".localized(),
                                                      cancelBtn: "Cancel".localized())
```
NOTE - Do not forgot to add application in backend side

## Facebook
1. Add into `Info.plist`
```groovy
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fb`FACEBOOK_ID`</string>
        </array>
    </dict>
</array>
<key>FacebookAdvertiserIDCollectionEnabled</key>
<true/>
<key>FacebookAppID</key>
<string>`FACEBOOK_ID`</string>
<key>FacebookAutoLogAppEventsEnabled</key>
<true/>
<key>FacebookClientToken</key>
<string>`FACEBOOK_CLIENT_TOKEN`</string>
<key>FacebookDisplayName</key>
<string>`APPNAME`</string>
```
2. Add into `AppDelegate.swift` file
```groovy
Facebook_Manager.initialize(application, launchOptions)
```

## AppMetrica
1. Add into `AppDelegate.swift` file
```groovy
AppMetrica_Manager.initialize(withID: APPMETRICA_ID)
```

## OneSignal
1. Add into `AppDelegate.swift` file
```groovy
OneSignal_Manager.shared.initialize(oneSignalId: ONESIGNAL_ID, launchOptions: launchOptions)
```

## TikTok
1. Add into `AppDelegate.swift` file
```groovy
TikTok_Manager.initialize(withAppId: YOUR_APP_ID, TikTokId: TIKTOK_ID)
```
2. For Debug Mode
```groovy
TikTok_Manager.initialize(withAppId: YOUR_APP_ID, TikTokId: TIKTOK_ID, isDebug: true)
```
3. For TikTok Event
```groovy
TikTok_Events.tikTokPurchaseSuccessEvent(plan: PlanInfo)
```   

## AppFlyer
1. Add into `AppDelegate.swift` file
```groovy
AppFlyer_Manager.shared.initialize(withAppID: YOUR_APP_ID, appsFlyerKey: APPFLYER_ID)
```
2. Add Endpoint into `AppStoreConnect -> Application -> App Information -> App Store Server Notifications`


## RevenueCat
1. Initialise : Add into `AppDelegate.swift` file
```groovy
RevenueCat_Manager.shared.initialiseRevenueCat(APIKey: REVENUECAT_ID, productIds: nil)
```
2. If you want which offer you get from revenucat need to pass product Ids while initilise
```groovy
let ids = SubscriptionProductIds(offer1_oneWeek: "com.subscription.week",
                                 offer1_oneMonth: "com.subscription.month",
                                 offer1_oneYear: "com.subscription.year",
                                 offer1_oneMonth_Discount: "com.subscription.discount.month",
                                 offer1_lifeTime: "com.subscription.lifetime",
                                 offer2_oneWeek: "com.subscription.week.exp",
                                 offer2_oneMonth: "com.subscription.month.experiment",
                                 offer2_oneYear: "com.subscription.year.experiment",
                                 offer2_oneMonth_Discount: "com.subscription.discount.month.exp",
                                 offer2_lifeTime: "com.subscription.lifetime.exp",
                                 offer3_oneWeek: "com.subscription.offering3.week",
                                 offer3_oneMonth: "com.subscription.offering3.month",
                                 offer3_oneYear: "com.subscription.offering3.year",
                                 offer3_oneMonth_Discount: "com.subscription.offering3.discount.month",
                                 offer3_lifeTime: "com.subscription.offering3.lifetime")

RevenueCat_Manager.shared.initialiseRevenueCat(APIKey: REVENUECAT_ID, productIds: ids)
```
3. Add Below code in `Splash Screen`, to get purchase details and offerings
```groovy
RevenueCat_Manager.shared.funCheckForPurchase {
    <#code#>
}
```   
4. Purchase
```groovy
RevenueCat_Manager.shared.purchaseProduct(ProductID: plan_Id) { (state, info, error, isCancel) in
    <#code#>
}
```   
- With PromotionalOffer
```groovy
RevenueCat_Manager.shared.purchaseProductWithPromo(ProductID: plan_Id, promoOffers: promoOffer) { (state, info, error, isCancel) in
    <#code#>
}
```
5. Restore
```groovy
RevenueCat_Manager.shared.restoreProduct { (state, info, error) in
    <#code#>
}
```
6. Variables
- IsPurchase or Not - `Purchase_Flag`
- IsPriceGet or Not - `SubscriptionConst.isGet`
- Active Plans - `SubscriptionConst.ActivePlans`
- Payment Type - `SubscriptionConst.PaymentType`
- Discount Type - `SubscriptionConst.DiscountType`
- Subscription Type - `SubscriptionConst.SubscriptionType`
- Offering from RevenueCat `RevenueCat_Manager.shared.isOfferType`

## Google Ads
1. Add Into `Info.plist`
```groovy
        <key>GADApplicationIdentifier</key>
	<string>ca-app-pub-3940256099942544~1458002511</string>
	<key>GADNativeAdValidatorEnabled</key>
	<false/>
	<key>ITSAppUsesNonExemptEncryption</key>
	<false/>
	<key>SKAdNetworkItems</key>
	<array>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>cstr6suwn9.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>4fzdc2evr5.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>2fnua5tdw4.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>ydx93a7ass.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>p78axxw29g.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>v72qych5uu.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>ludvb6z3bs.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>cp8zw746q7.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3sh42y64q3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>c6k4g5qg8m.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>s39g8k73mm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3qy4746246.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>hs6bdukanm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>mlmmfzh3r3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>v4nxqhlyqp.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>wzmmz9fp6w.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>su67r6k2v3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>yclnxrl5pm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>7ug5zh24hu.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>gta9lk7p23.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>vutu7akeur.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>y5ghdn5j9k.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>v9wttpbfk9.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>n38lu8286q.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>47vhws6wlr.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>kbd757ywx3.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>9t245vhmpl.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>a2p9lx4jpn.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>22mmun2rn5.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>4468km3ulz.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>2u9pt9hc89.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>8s468mfl3y.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>ppxm28t8ap.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>uw77j35x4d.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>pwa73g5rt2.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>578prtvx9j.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>4dzt52r2t5.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>Tl55sbb4fm.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>e5fvkxwrpn.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>8c4e2ghe7u.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3rd42ekr43.skadnetwork</string>
		</dict>
		<dict>
			<key>SKAdNetworkIdentifier</key>
			<string>3qcr597p9d.skadnetwork</string>
		</dict>
	</array>
```

2. Initialise : Add Into `AppDelegate.swift` after `GDPRConsent` and `ATTtracking Completion` called
```groovy
GoogleAd_Manager.shared.initialiseGoogleAds(bannerAd: "ca-app-pub-3940256099942544/2435281174",
                                            intAd: "ca-app-pub-3940256099942544/4411468910",
                                            nativeAd: "ca-app-pub-3940256099942544/3986624511",
                                            rewardAd: "ca-app-pub-3940256099942544/1712485313",
                                            rewardIntAd: "ca-app-pub-3940256099942544/6978759866",
                                            appOpenAd: "ca-app-pub-3940256099942544/5575463023")
```
- If you dont want to load particular Ads then, no need to pass their ad is


3. Banner Ad
```groovy
GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBanner)
```
- BannerAd With `Ads By Developer` Custom Text Color
```groovy
GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBanner, loaderType: .AdsByDeveloper, adByDeveloperTextColor: .red)
```
- BannerAd With `Shimmer` Loading Animation
```groovy
GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBanner, loaderType: .Shimmer)
```
- BannerAd With `Custom` Loading
```groovy
GoogleAd_Manager.shared.funShowBannerAd(parentView: viewBanner, loaderType: .Custom, customLoader: `CUSTOM_VIEW`)
```


4. Native Ad
```groovy
GoogleAd_Manager.shared.funShowNativeAd(adType: .full_Native, parentView: viewNative) { isAdPresent in
    print("Google NativeAd Present : \(isAdPresent)")
} isClick: {
    print("Google NativeAd Click")
} isNewLoad: {
    print("Google NativeAd Reload")
}
```


5. Interstitial Ad
```groovy
GoogleAd_Manager.shared.funShowInterstitialAd(rootVC: self) { isAdPresent in
    print("Google InterstitialAd Present : \(isAdPresent)")
} adDidDismiss: {
    print("Google InterstitialAd Dismiss")
} didFailToPresent: { error in
    print("Google InterstitialAd Failed : \(error)")
}
```


6. AppOpen Ad
```groovy
GoogleAd_Manager.shared.funShowAppOpenAd(rootVC: self) { isAdPresent in
    print("Google AppOpenAd Present : \(isAdPresent)")
} adDidDismiss: {
    print("Google AppOpenAd Dismiss")
} didFailToPresent: { error in
    print("Google AppOpenAd Failed : \(error)")
}
```


7. Rewarded Ad
```groovy
GoogleAd_Manager.shared.funShowRewardedAd(rootVC: self) { isAdPresent in
    print("Google RewardedAd Present : \(isAdPresent)")
} adDidDismiss: {
    print("Google RewardedAd Dismiss")
} adRewarded: {
    print("Google RewardedAd Reward Granted")
} didFailToPresent: { error in
    print("Google RewardedAd Failed : \(error)")
}
```


8. RewardedInt Ad
```groovy
GoogleAd_Manager.shared.funShowRewardedIntAd(rootVC: self) { isAdPresent in
    print("Google RewardedIntAd Present : \(isAdPresent)")
} adDidDismiss: {
    print("Google RewardedIntAd Dismiss")
} adRewarded: {
    print("Google RewardedIntAd Reward Granted")
} didFailToPresent: { error in
    print("Google RewardedIntAd Failed : \(error)")
}
```
