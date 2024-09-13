//
//  AppDelegate.swift
//  Vasundhara_CommonCode_Demo
//
//  Created by IOS on 06/09/24.
//

import UIKit
import FirebaseCore
import iOS_CommonCode_Helper

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //ForceUpdate
        ForceUpdate_Manager.configure(withAppID: 1659583821)
        ForceUpdate_Manager.configureForceUpdateAlert(title: "Update Required".localized(),
                                                      message: "We've noticed that you've been using the deprecated application version for a long time. Please update to the latest version and enjoy the app.".localized(),
                                                      actionBtn: "Update".localized(),
                                                      cancelBtn: "Cancel".localized())
        
        FirebaseApp.configure()
        FirebaseRemote.shared.startRemoteConfig()
        
        
        
        //GDPR
        GoogleMobileAdsConsent_Manager.funGDPRConsent { consentError in
            
            //ATTracking
            ATTracking_Manager.funRequestTracking {
    
                //AppMetrica
                AppMetrica_Manager.initialize(withID: "522d7aeb-f838-43b4-99f9-5afffd17fa3f")
                
                //Facebook
                Facebook_Manager.initialize(application, launchOptions)
                
                //OneSignal
                OneSignal_Manager.shared.initialize(oneSignalId: "f9257067-699d-4e7f-a6de-a6af981198ae", launchOptions: launchOptions)
                
                //TikTok
                TikTok_Manager.initialize(withAppId: "1659583821", TikTokId: "7398586953823813639", isDebug: true)
            }
        }
        
        //RevenueCat
        let ids = SubscriptionProductIds(offer1_oneWeek: "com.voiceeffectchanger.subscription.week",
                                         offer1_oneMonth: "com.voiceeffectchanger.subscription.month",
                                         offer1_oneYear: "com.voiceeffectchanger.subscription.year",
                                         offer1_oneMonth_Discount: "com.voiceeffectchanger.subscription.discount.month",
                                         offer1_lifeTime: "com.voiceeffectchanger.subscription.lifetime",
                                         offer2_oneWeek: "com.voiceeffectchanger.subscription.week.exp",
                                         offer2_oneMonth: "com.voiceeffectchanger.subscription.month.experiment",
                                         offer2_oneYear: "com.voiceeffectchanger.subscription.year.experiment",
                                         offer2_oneMonth_Discount: "com.voiceeffectchanger.subscription.discount.month.exp",
                                         offer2_lifeTime: "com.voiceeffectchanger.subscription.lifetime.exp",
                                         offer3_oneWeek: "com.voiceeffectchanger.subscription.offering3.week",
                                         offer3_oneMonth: "com.voiceeffectchanger.subscription.offering3.month",
                                         offer3_oneYear: "com.voiceeffectchanger.subscription.offering3.year",
                                         offer3_oneMonth_Discount: "com.voiceeffectchanger.subscription.offering3.discount.month",
                                         offer3_lifeTime: "com.voiceeffectchanger.subscription.offering3.lifetime")
        
        RevenueCat_Manager.shared.initialiseRevenueCat(APIKey: "appl_TGKguPfDQefQBwTwefUcfkjUYZw", productIds: ids)

        //Google Ad
        GoogleAd_Manager.shared.initialiseGoogleAds(collapsibleBannerAd: "ca-app-pub-3940256099942544/8388050270",
                                                    bannerAd: "ca-app-pub-3940256099942544/2435281174",
                                                    intAd: "ca-app-pub-3940256099942544/4411468910",
                                                    nativeAd: "ca-app-pub-3940256099942544/3986624511",
                                                    rewardAd: "ca-app-pub-3940256099942544/1712485313",
                                                    rewardIntAd: "ca-app-pub-3940256099942544/6978759866",
                                                    appOpenAd: "ca-app-pub-3940256099942544/5575463023")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
