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
  //Code
}
```

## ATTracking Request
1. Add Below Code in `Info.plist`
```groovy
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```
2. Add Below Code in `AppDelegate.swift` file
```groovy
ATTracking_Manager.funRequestTracking {
  //Code
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

## RevenueCat

## Google Ads
