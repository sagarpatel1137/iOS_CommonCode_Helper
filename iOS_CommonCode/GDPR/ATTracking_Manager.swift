//
//  ATTracking_Manager.swift
//  iOS_CommonCode
//
//  Created by IOS on 06/09/24.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import RevenueCat
import FBSDKCoreKit
import AppsFlyerLib
import Firebase
import FirebaseAuth

public class ATTracking_Manager: NSObject {

    public class func funRequestTracking(complition: @escaping () -> Void)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    switch status {
                    case .authorized:
                        print("Vasundhara 🏢 - ATTracking \(status.rawValue) 🟢🟢🟢")
                        break
                    case .notDetermined, .denied, .restricted :
                        print("Vasundhara 🏢 - ATTracking \(status.rawValue) 🔴🔴🔴")
                        break
                    @unknown default:
                        break
                    }
                    
                    funRevenueCatToolsInitialize()
                    
                    complition()
                })
            } else {
                print("Vasundhara 🏢 - Deployement Target Below iOS 14.0 ⚠️⚠️⚠️")
                
                funRevenueCatToolsInitialize()
                
                complition()
            }
        }
    }
    
    private class func funRevenueCatToolsInitialize() {
        
        Purchases.shared.attribution.collectDeviceIdentifiers()
        
        //Apple Ad Services
        if #available(iOS 14.3, *) {
            Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
        }
        
        //AppFlyer
        Purchases.shared.attribution.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
        
        //Facebook Ads
        Purchases.shared.attribution.setFBAnonymousID(FBSDKCoreKit.AppEvents.shared.anonymousID)
        FBSDKCoreKit.Settings.shared.isAutoLogAppEventsEnabled = false
        FBSDKCoreKit.AppEvents.shared.activateApp()
        
        //Firebase
        // Add state change listener for Firebase Authentication
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let uid = user?.uid {
                // identify Purchases SDK with new Firebase user
                Purchases.shared.logIn(uid, completion: { (info, created, error) in
                    if let error {
                        print("Sign in error: \(error.localizedDescription)")
                    } else {
                        print("User \(uid) signed in")
                    }
                })
            }
        }
        
        // Set the reserved $firebaseAppInstanceId attribute from Firebase Analytics
        let instanceID = Analytics.appInstanceID()
        if let unwrapped = instanceID {
            //print("Instance ID -> " + unwrapped)
            //print("Setting Attributes")
            Purchases.shared.attribution.setFirebaseAppInstanceID(unwrapped)
        } else {
            //print("Instance ID -> NOT FOUND!")
        }
    }
    
}
