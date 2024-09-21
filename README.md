# iOS : CommonCode-Helper

# Requirements
`iOS_CommonCode_Helper` works on iOS 13.0+.

# Adding MBProgressHUD to your project

## Cocoapods
CocoaPods is the recommended way to add iOS_CommonCode_Helper to your project.

1. Add a pod entry for iOS_CommonCode_Helper to your Podfile `pod 'iOS_CommonCode_Helper'`
2. Install the pod(s) by running `pod install`.
3. Include iOS_CommonCode_Helper wherever you need it with `import iOS_CommonCode_Helper`.

## Swift Packages



# Usage
## GDPR Consent
1. Add Below Code in `AppDelegate.swift` file
```groovy
GoogleMobileAdsConsent_Manager.funGDPRConsent { consentError in
    <#code#>
}
```

## ATTracking Request
1. Add Below Code in `Info.plist`
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
1. Add Below Code in `AppDelegate.swift` file
```groovy
Facebook_Manager.initialize(application, launchOptions)
```

## AppMetrica
1. Add Below Code in `AppDelegate.swift` file
```groovy
AppMetrica_Manager.initialize(withID: APPMETRICA_ID)
```

## OneSignal
1. Add Below Code in `AppDelegate.swift` file
```groovy
OneSignal_Manager.shared.initialize(oneSignalId: ONESIGNAL_ID, launchOptions: launchOptions)
```

## TikTok
1. Add Below Code in `AppDelegate.swift` file
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
1. Add Below Code in `AppDelegate.swift` file
```groovy
AppFlyer_Manager.shared.initialize(withAppID: YOUR_APP_ID, appsFlyerKey: APPFLYER_ID)
```
2. Add Endpoint into `AppStoreConnect -> Application -> App Information -> App Store Server Notifications`


## RevenueCat
1. Initialise in `AppDelegate.swift` file
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
